({
	doCalcs : function(component, event, helper) {
        var totalUnits = 0;
        if(component.get("v.templateType") == 'OTC Customer'){
            var propTotalUnits = component.get("v.singleRec.ProposedTotalUnits") != undefined ? component.get("v.singleRec.ProposedTotalUnits") : 0;
            var percentVal = component.get("v.singleRec.ProposedsharePer") != undefined ? component.get("v.singleRec.ProposedsharePer") : 0;
            totalUnits = parseInt(propTotalUnits * (percentVal/100));
        }
        else{
            var indirectUnits = component.get("v.proposedUnitsVal") != undefined ? component.get("v.proposedUnitsVal") : 0;
            var directUnits = component.get("v.proposedDirectUnits") != undefined ? component.get("v.proposedDirectUnits") : 0;
            
            var ProposedDirectEsiUnits = component.get("v.singleRec.ProposedDirectEsiUnits") != undefined ? component.get("v.singleRec.ProposedDirectEsiUnits") : 0;
            var ProposedIndirectEsiUnits = component.get("v.singleRec.ProposedIndirectEsiUnits") != undefined ? component.get("v.singleRec.ProposedIndirectEsiUnits") : 0;
            var ProposedDirectKrogerUnits = component.get("v.singleRec.ProposedDirectKrogerUnits") != undefined ? component.get("v.singleRec.ProposedDirectKrogerUnits") : 0;
            var ProposedIndirectKrogerUnits = component.get("v.singleRec.ProposedIndirectKrogerUnits") != undefined ? component.get("v.singleRec.ProposedIndirectKrogerUnits") : 0;
            var ProposedDirectRxOutreachUnits = component.get("v.singleRec.ProposedDirectRxOutreachUnits") != undefined ? component.get("v.singleRec.ProposedDirectRxOutreachUnits") : 0;
            var ProposedIndirectRxOutreachUnits = component.get("v.singleRec.ProposedIndirectRxOutreachUnits") != undefined ? component.get("v.singleRec.ProposedIndirectRxOutreachUnits") : 0;
            var ProposedDirectSupervaluUnits = component.get("v.singleRec.ProposedDirectSupervaluUnits") != undefined ? component.get("v.singleRec.ProposedDirectSupervaluUnits") : 0;
            var ProposedIndirectSupervaluUnits = component.get("v.singleRec.ProposedIndirectSupervaluUnits") != undefined ? component.get("v.singleRec.ProposedIndirectSupervaluUnits") : 0;
            var ProposedDirectCordantUnits = component.get("v.singleRec.ProposedDirectCordantUnits") != undefined ? component.get("v.singleRec.ProposedDirectCordantUnits") : 0;
            var ProposedIndirectCordantUnits = component.get("v.singleRec.ProposedIndirectCordantUnits") != undefined ? component.get("v.singleRec.ProposedIndirectCordantUnits") : 0;
            var ProposedDirectAccerodoUnits = component.get("v.singleRec.ProposedDirectAccerodoUnits") != undefined ? component.get("v.singleRec.ProposedDirectAccerodoUnits") : 0;
            var ProposedIndirectAccerodoUnits = component.get("v.singleRec.ProposedIndirectAccerodoUnits") != undefined ? component.get("v.singleRec.ProposedIndirectAccerodoUnits") : 0;
            var ProposedIndirectUnits = component.get("v.singleRec.ProposedIndirectUnits") != undefined ? component.get("v.singleRec.ProposedIndirectUnits") : 0;
            var ProposedSmithDrugUnits = component.get("v.singleRec.ProposedSmithDrugUnits") != undefined ? component.get("v.singleRec.ProposedSmithDrugUnits") : 0;
            var ProposedAndaUnits = component.get("v.singleRec.ProposedAndaUnits") != undefined ? component.get("v.singleRec.ProposedAndaUnits") : 0;
            var ProposedDirectAholdDelhaizeUnits = component.get("v.singleRec.ProposedDirectAholdDelhaizeUnits") != undefined ? component.get("v.singleRec.ProposedDirectAholdDelhaizeUnits") : 0;
            var ProposedDirectGaintEagleUnits = component.get("v.singleRec.ProposedDirectGaintEagleUnits") != undefined ? component.get("v.singleRec.ProposedDirectGaintEagleUnits") : 0;
            var ProposedTotalRetailIndirectUnits = component.get("v.singleRec.ProposedTotalRetailIndirectUnits") != undefined ? component.get("v.singleRec.ProposedTotalRetailIndirectUnits") : 0;
            var ProposedBaseUnits = component.get("v.singleRec.ProposedBaseUnits") != undefined ? component.get("v.singleRec.ProposedBaseUnits") : 0;
            var ProposedDshUnits = component.get("v.singleRec.ProposedDshUnits") != undefined ? component.get("v.singleRec.ProposedDshUnits") : 0;
            var ProposedAutosubUnits = component.get("v.singleRec.ProposedAutosubUnits") != undefined ? component.get("v.singleRec.ProposedAutosubUnits") : 0;
            var ProposedOSUnits = component.get("v.singleRec.ProposedOSUnits") != undefined ? component.get("v.singleRec.ProposedOSUnits") : 0;
            var ProposedRadUnits = component.get("v.singleRec.ProposedRadUnits") != undefined ? component.get("v.singleRec.ProposedRadUnits") : 0;
            var ProposedWmtUnits = component.get("v.singleRec.ProposedWmtUnits") != undefined ? component.get("v.singleRec.ProposedWmtUnits") : 0;
            var ProposedCVSDirectUnits = component.get("v.singleRec.ProposedCVSDirectUnits") != undefined ? component.get("v.singleRec.ProposedCVSDirectUnits") : 0;
            var ProposedCVSIndirectUnits = component.get("v.singleRec.ProposedCVSIndirectUnits") != undefined ? component.get("v.singleRec.ProposedCVSIndirectUnits") : 0;
            var ProposedCardinalUnits = component.get("v.singleRec.ProposedCardinalUnits") != undefined ? component.get("v.singleRec.ProposedCardinalUnits") : 0;
            var ProposedMajorUnits = component.get("v.singleRec.ProposedMajorUnits") != undefined ? component.get("v.singleRec.ProposedMajorUnits") : 0;
            totalUnits = parseInt(indirectUnits) + parseInt(directUnits) + parseInt(ProposedDirectEsiUnits)+parseInt(ProposedIndirectEsiUnits)+parseInt(ProposedDirectKrogerUnits)+parseInt(ProposedIndirectKrogerUnits)
            +parseInt(ProposedDirectRxOutreachUnits)+parseInt(ProposedIndirectRxOutreachUnits)+parseInt(ProposedDirectSupervaluUnits)+parseInt(ProposedIndirectSupervaluUnits)
            +parseInt(ProposedDirectCordantUnits)+parseInt(ProposedIndirectCordantUnits)+parseInt(ProposedDirectAccerodoUnits)+parseInt(ProposedIndirectAccerodoUnits)
            +parseInt(ProposedIndirectUnits)+parseInt(ProposedSmithDrugUnits)+parseInt(ProposedAndaUnits)+parseInt(ProposedDirectAholdDelhaizeUnits)+parseInt(ProposedDirectGaintEagleUnits)
            +parseInt(ProposedTotalRetailIndirectUnits)+parseInt(ProposedBaseUnits)+parseInt(ProposedDshUnits)+parseInt(ProposedAutosubUnits)+parseInt(ProposedOSUnits)
            +parseInt(ProposedRadUnits)+parseInt(ProposedWmtUnits)+parseInt(ProposedCVSDirectUnits)+parseInt(ProposedCVSIndirectUnits)+parseInt(ProposedCardinalUnits)+parseInt(ProposedMajorUnits);
        }
        
        
        var guidancePrice = component.get("v.guidancePriceVal") != undefined ? component.get("v.guidancePriceVal") :0;
        
        
        var finImpact = 0;
        var currentDirUnits = component.get("v.singleRec.currentDirectUnits") != undefined ? component.get("v.singleRec.currentDirectUnits") :0;
        var currentIndirUnits = component.get("v.singleRec.currentIndirectUnits") != undefined ? component.get("v.singleRec.currentIndirectUnits") :0;
        var totalCurrentUnits = currentDirUnits + currentIndirUnits;
        var currentDirPrice = component.get("v.singleRec.currentDirectPrice") != undefined ? component.get("v.singleRec.currentDirectPrice") :0;
        var currentIndirPrice = component.get("v.singleRec.currentIndirectPrice") != undefined ? component.get("v.singleRec.currentIndirectPrice") :0;
        var currentPrice = currentDirPrice +  currentIndirPrice;
        
        var useUnits = totalUnits != 0 ? totalUnits : totalCurrentUnits;
                
        if(guidancePrice > 0){
            component.set("v.singleRec.opportunityVal", useUnits * guidancePrice);
        }
        else if(currentPrice > 0){
            component.set("v.singleRec.opportunityVal", useUnits * currentPrice);
        }
            else{
                component.set("v.singleRec.opportunityVal", useUnits * component.get("v.lowestPriceVal"));
            }
        
        if(component.get("v.bidType") == 'Price Change'){
            finImpact = totalCurrentUnits * (guidancePrice - currentPrice);
        }
        else{
            finImpact = currentPrice * (totalUnits - totalCurrentUnits);
        }
        component.set("v.singleRec.financialImpact",finImpact);
	}
})