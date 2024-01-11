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
        
        optyProdObj.Vision_Proposed_CVS_Direct_Units__c = (optyProdObj.Vision_Proposed_CVS_Direct_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Direct_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Direct_Units__c : 0;
        optyProdObj.Vision_Proposed_CVS_Indirect_Units__c = (optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Indirect_Units__c : 0;
        optyProdObj.Vision_Proposed_Cardinal_Units__c = (optyProdObj.Vision_Proposed_Cardinal_Units__c != '' && optyProdObj.Vision_Proposed_Cardinal_Units__c != undefined) ? optyProdObj.Vision_Proposed_Cardinal_Units__c : 0;
        optyProdObj.Vision_Proposed_Major_Units__c = (optyProdObj.Vision_Proposed_Major_Units__c != '' && optyProdObj.Vision_Proposed_Major_Units__c != undefined) ? optyProdObj.Vision_Proposed_Major_Units__c : 0;
        component.set("v.prodOptyObj",optyProdObj);
        var packSize = component.get("v.prodObj").Phoenix_Pkg_Size__c != undefined ? component.get("v.prodObj").Phoenix_Pkg_Size__c : 1;
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
       
    },
    getDupItems : function(component, event, helper, fieldItem){
        var optyObj = component.get("v.prodOptyObj");
        var action = component.get("c.getAlldupItems");
        action.setParams({oppId:optyObj.Opportunity__c,
                          prodId:optyObj.Product__r.Id});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from getAlldupItems --> '+state);
            
            if(state == 'SUCCESS'){
                var optyItemsList = response.getReturnValue();
                console.log('fieldItem in action --> '+fieldItem);
                console.log('optyObj.Proposed_Indirect_Selling_Units__c --> '+optyObj.Proposed_Indirect_Selling_Units__c);
                var packSize = optyObj.Product__r.Phoenix_Pkg_Size__c;
                var OptypackSize = optyObj.Vision_Disc_Pkg_Size__c;
                console.log('packSize --> '+packSize);
                console.log('OptypackSize --> '+OptypackSize);
                //optyObj = calculateItems(optyObj,OptypackSize,packSize);
                var totalCalcUnits = calculateItems(optyObj,OptypackSize,packSize,fieldItem);
                console.log('totalCalcUnits --> '+totalCalcUnits);
                
                
                var calcList = [];
                var calcObj = {};
                calcObj.isSelected = true;
                calcObj.unitsVal = totalCalcUnits;
                calcList.push(calcObj);
                console.log('optyItemsList size --> '+optyItemsList.length);
                optyItemsList.forEach(function(item){
                    if(item.Id != optyObj.Id){
                        item = validateUndefinedUnits(item);
                        packSize = item.Product__r.Phoenix_Pkg_Size__c;
                        OptypackSize = item.Vision_Disc_Pkg_Size__c;
                        var calcObj = {};
                        calcObj.unitsVal = calculateItems(item,OptypackSize,packSize,fieldItem);
                        calcObj.isSelected = false;
                        calcList.push(calcObj);
                    }
                });
                function validateUndefinedUnits(optyProdObj){
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
                    
                    optyProdObj.Vision_Proposed_CVS_Direct_Units__c = (optyProdObj.Vision_Proposed_CVS_Direct_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Direct_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Direct_Units__c : 0;
                    optyProdObj.Vision_Proposed_CVS_Indirect_Units__c = (optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Indirect_Units__c : 0;
                    optyProdObj.Vision_Proposed_Cardinal_Units__c = (optyProdObj.Vision_Proposed_Cardinal_Units__c != '' && optyProdObj.Vision_Proposed_Cardinal_Units__c != undefined) ? optyProdObj.Vision_Proposed_Cardinal_Units__c : 0;
                    optyProdObj.Vision_Proposed_Major_Units__c = (optyProdObj.Vision_Proposed_Major_Units__c != '' && optyProdObj.Vision_Proposed_Major_Units__c != undefined) ? optyProdObj.Vision_Proposed_Major_Units__c : 0;
                    return optyProdObj;
                }
                function calculateItems(optyProd,OptypackSize,packSize,fieldItem){
                    console.log('fieldItem in function calculateItems --> '+fieldItem);
                    if(fieldItem =='dirUnitsCalc')
                        return Math.round((optyProd.Proposed_Direct_Selling_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='inDirUnitsCalc'){
                        console.log('Math.round((optyProd.Proposed_Indirect_Selling_Units__c*OptypackSize)/packSize) --> '+Math.round((optyProd.Proposed_Indirect_Selling_Units__c*OptypackSize)/packSize));
                        return Math.round((optyProd.Proposed_Indirect_Selling_Units__c*OptypackSize)/packSize);
                    }
                    if(fieldItem =='osUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_OS_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='radUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_RAD_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='WmtUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_WMT_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='BasUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_BASE_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='DshUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_DSH_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='AutSubUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_AutoSub_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='smithUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Smith_Drug_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='andaUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Anda_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='dirAhoUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c*OptypackSize)/packSize);
                    if(fieldItem =='dirGEUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='retIndUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_TotalRetailIndirectUnits__c*OptypackSize)/packSize);
                    if(fieldItem =='dirEsiUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_ESI_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='IndEsiUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Indirect_ESI_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='dirKroUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_Kroger_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='indKroUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Indirect_Kroger_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='dirRxUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='indRxUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_IndirectRxOutreach_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='dirSupUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_Supervalu_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='indSupUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Indirect_Supervalu_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='dirCigUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_Cigna_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='indCigUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Indirect_Cigna_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='dirCorUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_Cordant_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='indCorUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Indirect_Cordant_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='dirAccUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Direct_Accerodo_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='indAccUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Indirect_Accerodo_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='cvsDirUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_CVS_Direct_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='cvsIndUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_CVS_Indirect_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='CarUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Cardinal_Units__c*OptypackSize)/packSize);
                    if(fieldItem =='majUnitsCalc')
                        return Math.round((optyProd.Vision_Proposed_Major_Units__c*OptypackSize)/packSize);
                }
                /*function getSelectedValue(optyProd){
                    if(fieldItem = 'inDirUnitsCalc')
                        return component.get("v.ProposedIndirectSellingUnits");
                    else if(fieldItem = 'dirUnitsCalc')
                        return component.get("v.ProposedDirectSellingUnits");
                        else if(fieldItem = 'osUnitsCalc')
                            return component.get("v.VisionProposedOSUnits");
                            else if(fieldItem = 'radUnitsCalc')
                                return component.get("v.VisionProposedRADUnits");
                                else if(fieldItem = 'WmtUnitsCalc')
                                    return component.get("v.VisionProposedWMTUnits");
                                    else if(fieldItem = 'BasUnitsCalc')
                                        return component.get("v.VisionProposedBASEUnits");
                                        else if(fieldItem = 'DshUnitsCalc')
                                            return component.get("v.VisionProposedDSHUnits");
                                            else if(fieldItem = 'AutSubUnitsCalc')
                                                return component.get("v.VisionProposedAutoSubUnits");
                                                else if(fieldItem = 'cvsDirUnitsCalc')
                                                    return component.get("v.VisionProposedCVSDirectUnits");
                                                    else if(fieldItem = 'cvsIndUnitsCalc')
                                                        return component.get("v.VisionProposedCVSIndirectUnits");
                                                        else if(fieldItem = 'CarUnitsCalc')
                                                            return component.get("v.VisionProposedCardinalUnits");
                                                            else if(fieldItem = 'majUnitsCalc')
                                                                return component.get("v.VisionProposedMajorUnits");
                                                                else if(fieldItem = 'smithUnitsCalc')
                                                                    return component.get("v.VisionProposedSmithDrugUnits");
                                                                    else if(fieldItem = 'andaUnitsCalc')
                                                                        return component.get("v.VisionProposedAndaUnits");
                                                                        else if(fieldItem = 'dirAhoUnitsCalc')
                                                                            return component.get("v.VisionProposedDirectAholdDelhaizeUnits");
                                                                            else if(fieldItem = 'dirGEUnitsCalc')
                                                                                return component.get("v.VisionProposedDirectGaintEagleUnits");
                                                                                else if(fieldItem = 'retIndUnitsCalc')
                                                                                    return component.get("v.VisionProposedTotalRetailIndirectUnits");
                                                                                    else if(fieldItem = 'dirEsiUnitsCalc')
                                                                                        return component.get("v.VisionProposedDirectESIUnits");
                                                                                        else if(fieldItem = 'IndEsiUnitsCalc')
                                                                                            return component.get("v.VisionProposedIndirectESIUnits");
                                                                                            else if(fieldItem = 'dirKroUnitsCalc')
                                                                                                return component.get("v.VisionProposedDirectKrogerUnits");
                                                                                                else if(fieldItem = 'indKroUnitsCalc')
                                                                                                    return component.get("v.VisionProposedIndirectKrogerUnits");
                                                                                                    else if(fieldItem = 'dirRxUnitsCalc')
                                                                                                        return component.get("v.VisionProposedDirectRxOutreachUnits");
                                                                                                        else if(fieldItem = 'indRxUnitsCalc')
                                                                                                            return component.get("v.VisionProposedIndirectRxOutreachUnits");
                                                                                                            else if(fieldItem = 'dirSupUnitsCalc')
                                                                                                                return component.get("v.VisionProposedDirectSupervaluUnits");
                                                                                                                else if(fieldItem = 'indSupUnitsCalc')
                                                                                                                    return component.get("v.VisionProposedIndirectSupervaluUnits");
                                                                                                                    else if(fieldItem = 'dirCigUnitsCalc')
                                                                                                                        return component.get("v.VisionProposedDirectCignaUnits");
                                                                                                                        else if(fieldItem = 'indCigUnitsCalc')
                                                                                                                            return component.get("v.VisionProposedIndirectCignaUnits");
                                                                                                                            else if(fieldItem = 'dirCorUnitsCalc')
                                                                                                                                return component.get("v.VisionProposedDirectCordantUnits");
                                                                                                                                else if(fieldItem = 'indCorUnitsCalc')
                                                                                                                                    return component.get("v.VisionProposedIndirectCordantUnits");
                                                                                                                                    else if(fieldItem = 'dirAccUnitsCalc')
                                                                                                                                        return component.get("v.VisionProposedDirectAccerodoUnits");
                                                                                                                                        else if(fieldItem = 'indAccUnitsCalc')
                                                                                                                                            return component.get("v.VisionProposedIndirectAccerodoUnits");
                }
                function getCalcSelectedVal(optyProd){
                    if(fieldItem=='dirUnitsCalc')
                        return optyProd.Proposed_Direct_Selling_Units__c;
                    else if(fieldItem=='inDirUnitsCalc')
                        return optyProd.Proposed_Indirect_Selling_Units__c;
                        else if(fieldItem=='osUnitsCalc')
                            return optyProd.Vision_Proposed_OS_Units__c;
                            else if(fieldItem=='radUnitsCalc')
                                return optyProd.Vision_Proposed_RAD_Units__c;
                                else if(fieldItem=='WmtUnitsCalc')
                                    return optyProd.Vision_Proposed_WMT_Units__c;
                                    else if(fieldItem=='BasUnitsCalc')
                                        return optyProd.Vision_Proposed_BASE_Units__c;
                                        else if(fieldItem=='DshUnitsCalc')
                                            return optyProd.Vision_Proposed_DSH_Units__c;
                                            else if(fieldItem=='AutSubUnitsCalc')
                                                return optyProd.Vision_Proposed_AutoSub_Units__c;
                                                else if(fieldItem=='smithUnitsCalc')
                                                    return optyProd.Vision_Proposed_Smith_Drug_Units__c;
                                                    else if(fieldItem=='andaUnitsCalc')
                                                        return optyProd.Vision_Proposed_Anda_Units__c;
                                                        else if(fieldItem=='dirAhoUnitsCalc')
                                                            return optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c;
                                                            else if(fieldItem=='dirGEUnitsCalc')
                                                                return optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c;
                                                                else if(fieldItem=='retIndUnitsCalc')
                                                                    return optyProd.Vision_Proposed_TotalRetailIndirectUnits__c;
                                                                    else if(fieldItem=='dirEsiUnitsCalc')
                                                                        return optyProd.Vision_Proposed_Direct_ESI_Units__c;
                                                                        else if(fieldItem=='IndEsiUnitsCalc')
                                                                            return optyProd.Vision_Proposed_Indirect_ESI_Units__c;
                                                                            else if(fieldItem=='dirKroUnitsCalc')
                                                                                return optyProd.Vision_Proposed_Direct_Kroger_Units__c;
                                                                                else if(fieldItem=='indKroUnitsCalc')
                                                                                    return optyProd.Vision_Proposed_Indirect_Kroger_Units__c;
                                                                                    else if(fieldItem=='dirRxUnitsCalc')
                                                                                        return optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c;
                                                                                        else if(fieldItem=='indRxUnitsCalc')
                                                                                            return optyProd.Vision_Proposed_IndirectRxOutreach_Units__c;
                                                                                            else if(fieldItem=='dirSupUnitsCalc')
                                                                                                return optyProd.Vision_Proposed_Direct_Supervalu_Units__c;
                                                                                                else if(fieldItem=='indSupUnitsCalc')
                                                                                                    return optyProd.Vision_Proposed_Indirect_Supervalu_Units__c;
                                                                                                    else if(fieldItem=='dirCigUnitsCalc')
                                                                                                        return optyProd.Vision_Proposed_Direct_Cigna_Units__c;
                                                                                                        else if(fieldItem=='indCigUnitsCalc')
                                                                                                            return optyProd.Vision_Proposed_Indirect_Cigna_Units__c;
                                                                                                            else if(fieldItem=='dirCorUnitsCalc')
                                                                                                                return optyProd.Vision_Proposed_Direct_Cordant_Units__c;
                                                                                                                else if(fieldItem=='dirAccUnitsCalc')
                                                                                                                    return optyProd.Vision_Proposed_Direct_Accerodo_Units__c;
                                                                                                                    else if(fieldItem=='indAccUnitsCalc')
                                                                                                                        return optyProd.Vision_Proposed_Indirect_Accerodo_Units__c;
                                                                                                                        else if(fieldItem=='indCorUnitsCalc')
                                                                                                                            return optyProd.Vision_Proposed_Indirect_Cordant_Units__c;
                                                                                                                            else if(fieldItem=='cvsDirUnitsCalc')
                                                                                                                                return optyProd.Vision_Proposed_CVS_Direct_Units__c;
                                                                                                                                else if(fieldItem=='cvsIndUnitsCalc')
                                                                                                                                    return optyProd.Vision_Proposed_CVS_Indirect_Units__c;
                                                                                                                                    else if(fieldItem=='CarUnitsCalc')
                                                                                                                                        return optyProd.Vision_Proposed_Cardinal_Units__c;
                                                                                                                                        else if(fieldItem=='majUnitsCalc')
                                                                                                                                            return optyProd.Vision_Proposed_Major_Units__c;
                }*/
                component.set("v.calcItems",calcList);
                component.set("v.totalCalcUnits",totalCalcUnits);
                console.log('fieldItem --> '+fieldItem);
                console.log('optyObj.Id --> '+optyObj.Id);
                document.getElementById(optyObj.Id+''+fieldItem).style.display="";
            }
            else
                console.log('Error in getAlldupItems--->'+JSON.stringify(response.getError()));
        });
        $A.enqueueAction(action);
    },
    
    searchHelperResults : function(component, event, helper){
        component.set("v.smallSpinnerWhileMatch",true);
        var action = component.get("c.getProductListSearch");
        action.setParams({
            searchKeyWord : component.get("v.searchItemName"),
            accId : component.get("v.accId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var respList = response.getReturnValue();
                var finalList  = [];
                var filterIds = component.get("v.existingProducts");
                respList.forEach(function(prd){
                    prd.isSelected = prd.Id == component.get("v.prodOptyObj.Product__c") ? true : false;
                    if(filterIds.length>0 && !filterIds.includes(prd.Id))
                        finalList.push(prd);
                });
                component.set("v.listOfSearchResults",respList);
            }else{
                console.log('Error--->'+JSON.stringify(response.getError()));
            }
            component.set("v.smallSpinnerWhileMatch",false);
        });
        $A.enqueueAction(action);
    }
    
})