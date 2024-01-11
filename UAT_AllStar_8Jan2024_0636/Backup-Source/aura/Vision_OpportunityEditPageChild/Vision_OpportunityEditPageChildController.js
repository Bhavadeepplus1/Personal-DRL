({
	doInit : function(component, event, helper) {
        console.log('---PRD---'+component.get('v.prd'));
        component.set('v.proposedDirectSellingUnits',component.get('v.prd.Proposed_Direct_Selling_Units__c'));
        component.set('v.proposedUnits',component.get('v.prd.Proposed_Indirect_Selling_Units__c'));
        component.set('v.proposedOSUnits',component.get('v.prd.Vision_Proposed_OS_Units__c'));
        component.set('v.proposedRADUnits',component.get('v.prd.Vision_Proposed_RAD_Units__c'));
        component.set('v.proposedWMTUnits',component.get('v.prd.Vision_Proposed_WMT_Units__c'));
        component.set('v.proposedBaseUnits',component.get('v.prd.Vision_Proposed_BASE_Units__c'));
        component.set('v.proposedDSHUnits',component.get('v.prd.Vision_Proposed_DSH_Units__c'));
        component.set('v.proposedAutoSubUnits',component.get('v.prd.Vision_Proposed_AutoSub_Units__c'));
        component.set('v.proposedSmithDrugUnits',component.get('v.prd.Vision_Proposed_Smith_Drug_Units__c'));
        component.set('v.proposedAndaUnits',component.get('v.prd.Vision_Proposed_Anda_Units__c'));
        component.set('v.proposedDirectAholdDelhaizeUnits',component.get('v.prd.Vision_Proposed_DirectAholdDelhaizeUnits__c'));
        component.set('v.proposedDirectGaintEagleUnits',component.get('v.prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c'));
        component.set('v.proposedTotalRetalIndirectUnits',component.get('v.prd.Vision_Proposed_TotalRetailIndirectUnits__c'));
        component.set('v.proposedInDirectSellingUnits',component.get('v.prd.Proposed_Indirect_Selling_Units__c'));
        component.set('v.proposedDirectESIUnits',component.get('v.prd.Vision_Proposed_Direct_ESI_Units__c'));
        component.set('v.proposedInDirectESIUnits',component.get('v.prd.Vision_Proposed_Indirect_ESI_Units__c'));
        component.set('v.proposedDirectKrogerUnits',component.get('v.prd.Vision_Proposed_Direct_Kroger_Units__c'));
        component.set('v.proposedInDirectKrogerUnits',component.get('v.prd.Vision_Proposed_Indirect_Kroger_Units__c'));
        component.set('v.proposedDirectRxOutReachUnits',component.get('v.prd.Vision_Proposed_Direct_Rx_Outreach_Units__c'));
        component.set('v.proposedInDirectRxOutReachUnits',component.get('v.prd.Vision_Proposed_IndirectRxOutreach_Units__c'));
        component.set('v.proposedDirectSuperValuUnits',component.get('v.prd.Vision_Proposed_Direct_Supervalu_Units__c'));
        component.set('v.proposedInDirectSuperValuUnits',component.get('v.prd.Vision_Proposed_Indirect_Supervalu_Units__c'));
        component.set('v.proposedDirectCordantUnits',component.get('v.prd.Vision_Proposed_Direct_Cordant_Units__c'));
        component.set('v.proposedInDirectCordantUnits',component.get('v.prd.Vision_Proposed_Indirect_Cordant_Units__c'));
        component.set('v.proposedDirectAccerodoUnits',component.get('v.prd.Vision_Proposed_Direct_Accerodo_Units__c'));
        component.set('v.proposedInDirectAccerodoUnits',component.get('v.prd.Vision_Proposed_Indirect_Accerodo_Units__c'));

	},
    onproposedDirectSellingUnits: function(component, event, helper){
        console.log('--onproposedDirectSellingUnits--');
        component.set('v.prd.Proposed_Direct_Selling_Units__c',component.get('v.proposedDirectSellingUnits'));
    },
    onproposedUnits: function(component, event, helper){
        console.log('--onproposedUnits--');
        component.set('v.prd.Vision_Proposed_Units__c',component.get('v.proposedUnits'));
    },
    onproposedOSUnits: function(component, event, helper){
        console.log('--onproposedOSUnits--');
        component.set('v.prd.Vision_Proposed_OS_Units__c',component.get('v.proposedOSUnits'));
    },
    onproposedRADUnits: function(component, event, helper){
        console.log('--onproposedRADUnits--');
        component.set('v.prd.Vision_Proposed_RAD_Units__c',component.get('v.proposedRADUnits'));
    },
    onproposedWMTUnits: function(component, event, helper){
        console.log('--onproposedWMTUnits--');
        component.set('v.prd.Vision_Proposed_WMT_Units__c',component.get('v.proposedWMTUnits'));
    },
    onproposedBaseUnits: function(component, event, helper){
        console.log('--onproposedBaseUnits--');
        component.set('v.prd.Vision_Proposed_BASE_Units__c',component.get('v.proposedBaseUnits'));
    },
    onproposedDSHUnits: function(component, event, helper){
        console.log('--onproposedDSHUnits--');
        component.set('v.prd.Vision_Proposed_DSH_Units__c',component.get('v.proposedDSHUnits'));
    },
    onproposedAutoSubUnits: function(component, event, helper){
        console.log('--onproposedAutoSubUnits--');
        component.set('v.prd.Vision_Proposed_AutoSub_Units__c',component.get('v.proposedAutoSubUnits'));
    },
    onproposedSmithDrugUnits: function(component, event, helper){
        console.log('--onproposedSmithDrugUnits--');
        component.set('v.prd.Vision_Proposed_Smith_Drug_Units__c',component.get('v.proposedSmithDrugUnits'));
    },
    onproposedAndaUnits: function(component, event, helper){
        console.log('--onproposedAndaUnits--');
        component.set('v.prd.Vision_Proposed_Anda_Units__c',component.get('v.proposedAndaUnits'));
    },
    onproposedDirectAholdDelhaizeUnits: function(component, event, helper){
        console.log('--onproposedDirectAholdDelhaizeUnits--');
        component.set('v.prd.Vision_Proposed_DirectAholdDelhaizeUnits__c',component.get('v.proposedDirectAholdDelhaizeUnits'));
    },
    onproposedDirectGaintEagleUnits: function(component, event, helper){
        console.log('--onproposedDirectGaintEagleUnits--');
        component.set('v.prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c',component.get('v.proposedDirectGaintEagleUnits'));
    },
    onproposedTotalRetalIndirectUnits: function(component, event, helper){
        console.log('--onproposedTotalRetalIndirectUnits--');
        component.set('v.prd.Vision_Proposed_TotalRetailIndirectUnits__c',component.get('v.proposedTotalRetalIndirectUnits'));
    },
    onproposedInDirectSellingUnits: function(component, event, helper){
        console.log('--onproposedInDirectSellingUnits--');
        component.set('v.prd.Proposed_Indirect_Selling_Units__c',component.get('v.proposedInDirectSellingUnits'));
    },
    onproposedDirectESIUnits: function(component, event, helper){
        console.log('--onproposedDirectESIUnits--');
        component.set('v.prd.Vision_Proposed_Direct_ESI_Units__c',component.get('v.proposedDirectESIUnits'));
    },
    onproposedInDirectESIUnits: function(component, event, helper){
        console.log('--onproposedInDirectESIUnits--');
        component.set('v.prd.Vision_Proposed_Indirect_ESI_Units__c',component.get('v.proposedInDirectESIUnits'));
    },
    onproposedDirectKrogerUnits: function(component, event, helper){
        console.log('--onproposedDirectKrogerUnits--');
        component.set('v.prd.Vision_Proposed_Direct_Kroger_Units__c',component.get('v.proposedDirectKrogerUnits'));
    },
    onproposedInDirectKrogerUnits: function(component, event, helper){
        console.log('--onproposedInDirectKrogerUnits--');
        component.set('v.prd.Vision_Proposed_Indirect_Kroger_Units__c',component.get('v.proposedInDirectKrogerUnits'));
    },
    onproposedDirectRxOutReachUnits: function(component, event, helper){
        console.log('--onproposedDirectRxOutReachUnits--');
        component.set('v.prd.Vision_Proposed_Direct_Rx_Outreach_Units__c',component.get('v.proposedDirectRxOutReachUnits'));
    },
    onproposedInDirectRxOutReachUnits: function(component, event, helper){
        console.log('--onproposedInDirectRxOutReachUnits--');
        component.set('v.prd.Vision_Proposed_IndirectRxOutreach_Units__c',component.get('v.proposedInDirectRxOutReachUnits'));
    },
    onproposedDirectSuperValuUnits: function(component, event, helper){
        console.log('--onproposedDirectSuperValuUnits--');
        component.set('v.prd.Vision_Proposed_Direct_Supervalu_Units__c',component.get('v.proposedDirectSuperValuUnits'));
    },
    onproposedInDirectSuperValuUnits: function(component, event, helper){
        console.log('--onproposedInDirectSuperValuUnits--');
        component.set('v.prd.Vision_Proposed_Indirect_Supervalu_Units__c',component.get('v.proposedInDirectSuperValuUnits'));
    },
    onproposedDirectCordantUnits: function(component, event, helper){
        console.log('--onproposedDirectCordantUnits--');
        component.set('v.prd.Vision_Proposed_Direct_Cordant_Units__c',component.get('v.proposedDirectCordantUnits'));
    },
    onproposedInDirectCordantUnits: function(component, event, helper){
        console.log('--onproposedInDirectCordantUnits--');
        component.set('v.prd.Vision_Proposed_Indirect_Cordant_Units__c',component.get('v.proposedInDirectCordantUnits'));
    },
    onproposedDirectAccerodoUnits: function(component, event, helper){
        console.log('--onproposedDirectAccerodoUnits--');
        component.set('v.prd.Vision_Proposed_Direct_Accerodo_Units__c',component.get('v.proposedDirectAccerodoUnits'));
    },
    onproposedInDirectAccerodoUnits: function(component, event, helper){
        console.log('--onproposedInDirectAccerodoUnits--');
        component.set('v.prd.Vision_Proposed_Indirect_Accerodo_Units__c',component.get('v.proposedInDirectAccerodoUnits'));
    }
})