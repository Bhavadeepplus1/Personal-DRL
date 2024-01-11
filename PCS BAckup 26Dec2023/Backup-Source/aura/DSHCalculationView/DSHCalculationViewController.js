/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 29-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   29-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({
    doInit: function (component, event, helper) {
         /*Positions Logix*/
        var alreadySelctdPositions = component.get("v.singleRec.Phoenix_Proposed_Position__c");
        if (alreadySelctdPositions != null) {
            component.set("v.LineselectedPosistions", alreadySelctdPositions.split(','));
        }
        /*end Positions Logix*/
        var productDirector = component.get("v.singleRec.Phoenix_Product_Director__c");
        var delegatedUser = component.get("v.deligatedUserName");
        console.log("Deligation user-->"+delegatedUser);
        console.log("productDirector user-->"+productDirector);
        console.log('isBala--->'+productDirector+"-->"+component.get("v.deligatedUserName").includes(productDirector))
        if(productDirector != null && delegatedUser != null && delegatedUser.includes(productDirector) && component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c") == false){
           component.set("v.isdeligationApprover",true) 
            
        }
     console.log('autoSubFlag--in child---'+component.get("v.autoSubFlag"));
        console.log('childdonint');
        console.log('approved person--' + component.get("v.isContractsApprovePerson"));
        console.log('aprovalstatus===' + component.get("v.BidAprrovalStatus"));
        console.log('cnt--approvaer===' + component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name"));
        console.log('v.singleRec.Phoenix_Marketing_Final_Approval__c===' + component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
        var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
        var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
        var Deadnet = component.get("v.singleRec.Phoenix_Wholesaler_DRL_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Wholesaler_DRL_Net_Price__c") : 0;
        var WHLSDRLPrice = component.get("v.singleRec.Phoenix_Anda_DRL_Net_price__c") != null ? component.get("v.singleRec.Phoenix_Anda_DRL_Net_price__c") : 0;
        var AndaDRLPrice = component.get("v.singleRec.Phoenix_Wholesaler_DRL_TPT__c") != null ? component.get("v.singleRec.Phoenix_Wholesaler_DRL_TPT__c") : 0;
        console.log('Deadnet----' + Deadnet);
        console.log('latestEstimate----' + ((latestEstimate / 100) * 10 + latestEstimate));
        if (latestEstimate > 0) {
            var isAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < Deadnet ? true : false;
            var isNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < Deadnet ? true : false;
            component.set("v.isAccpetable", isAccpetable);
            component.set("v.isNotAccpetable", isNotAccpetable)

            var isAccpetable1 = ((latestEstimate / 100) * 10 + latestEstimate) < WHLSDRLPrice ? true : false;
            var isNotAccpetable1 = (latestEstimate - (latestEstimate / 100) * 10) < WHLSDRLPrice ? true : false;
            component.set("v.isAccpetable1", isAccpetable1);
            component.set("v.isNotAccpetable1", isNotAccpetable1)

            var isAccpetable2 = ((latestEstimate / 100) * 10 + latestEstimate) < AndaDRLPrice ? true : false;
            var isNotAccpetable2 = (latestEstimate - (latestEstimate / 100) * 10) < AndaDRLPrice ? true : false;
            component.set("v.isAccpetable2", isAccpetable2);
            component.set("v.isNotAccpetable2", isNotAccpetable2)

        } else if (BudgetedASP > 0) {
            var isAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
            var isNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
            component.set("v.isAccpetable", isAccpetable);
            component.set("v.isNotAccpetable", isNotAccpetable)

            var isAccpetable1 = ((BudgetedASP / 100) * 10 + BudgetedASP) < WHLSDRLPrice ? true : false;
            var isNotAccpetable1 = (BudgetedASP - (BudgetedASP / 100) * 10) < WHLSDRLPrice ? true : false;
            component.set("v.isAccpetable1", isAccpetable1);
            component.set("v.isNotAccpetable1", isNotAccpetable1)

            var isAccpetable2 = ((BudgetedASP / 100) * 10 + BudgetedASP) < AndaDRLPrice ? true : false;
            var isNotAccpetable2 = (BudgetedASP - (BudgetedASP / 100) * 10) < AndaDRLPrice ? true : false;
            component.set("v.isAccpetable2", isAccpetable2);
            component.set("v.isNotAccpetable2", isNotAccpetable2)

        } else {
            console.log('else condition--->')
            component.set("v.isAccpetable", false);
            component.set("v.isNotAccpetable", false);
            component.set("v.isAccpetable1", false);
            component.set("v.isNotAccpetable1", false);
            component.set("v.isAccpetable2", false);
            component.set("v.isNotAccpetable2", false);
        }

        console.log('isAccpetable----' + isAccpetable);
        console.log('isNotAccpetable----' + isNotAccpetable);
        console.log('isAccpetable1----' + isAccpetable1);
        console.log('isNotAccpetable1----' + isNotAccpetable1);
        console.log('isAccpetable2----' + isAccpetable2);
        console.log('isNotAccpetable2----' + isNotAccpetable2);
        //helper.fetchPickListVal(component, 'Phoenix_Initial_Order_Discount_Type__c', 'ratingPicklistOpts');
    },
    closeGoalseekPopup: function (component, event, helper) {
        component.set("v.isGoalseekModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    openGoalseek: function (component, event, helper) {
        component.set("v.isGoalseekModalOpen", true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    calcGoalSeek: function (component, event, helper) {
        var bidRecord = component.get("v.bidRecord");
        let deadnetPrice = component.get("v.expectDdeadnet");
        let vipperunit = parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c") / 100);
        console.log('VIP PER UNIT $--->' + vipperunit);
        let currentcashterms = bidRecord.Phoenix_Current_CD__c;
        if (currentcashterms != null) {
            currentcashterms = parseFloat(currentcashterms / 100);
        }
        console.log('CD PER UNIT $--->' + currentcashterms)
        let propadminfee = bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
        console.log('ADMIN FEE %' + propadminfee)
        if (propadminfee != null) {
            propadminfee = parseFloat(propadminfee / 100);
        }
        console.log('ADMIN FEE %' + propadminfee)
        let proposedrebatepercentage = parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c") / 100);
        console.log(' proposedrebatepercentage-->' + proposedrebatepercentage);
        //oenix_Current_Rebate__c
        let requiredPriceNumer = deadnetPrice;
        let requiredPricedeNumer;
        requiredPricedeNumer = 1 - currentcashterms - propadminfee - (vipperunit - (propadminfee * vipperunit));
        console.log('requiredPricedeNumer next--->' + requiredPricedeNumer);
        component.set("v.RequiredPrice", requiredPriceNumer / requiredPricedeNumer);
        //component.set("v.expectCustmerDdeadnet",null); 
        var copyText = component.get("v.RequiredPrice");
        console.log("required pirce-->" + copyText);
        var WAC = component.get("v.singleRec.Phoenix_WAC__c");
        var proposedPriceMarketing = component.get("v.RequiredPrice");
        if (WAC < proposedPriceMarketing) {
            //onCISUChange(component, event,helper);
            component.set("v.errMsg", "Retail Direct Marketing Price can not be greater than WAC");
            component.set("v.err", true);
            component.set("v.ShowSaveButton", false);
        } else {
            component.set("v.err", false);
            component.set("v.ShowSaveButton", true);
        }

    },


    calcCustDeadNetGoalSeek: function (component, event, helper) {
        var bidRecord = component.get("v.bidRecord");
        console.log('bidRecord--->' + bidRecord)
        let deadnetPrice = component.get("v.expectCustmerDdeadnet");
        console.log('deadnetPrice--->' + component.get("v.expectCustmerDdeadnet"))
        //t customerdeadnet=component.get("v.singleRec.Phoenix_Customer_Dead_net__c");

        let vipperunit = parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c") / 100);
        console.log('vipperunit--->' + vipperunit)
        let cdperunit = parseFloat(component.get("v.singleRec.Phoenix_Direct_CD_Per_Unit__c") / 100);
        console.log('cdperunit--->' + cdperunit)
        //let currenadminfee= bidRecord.Phoenix_Current_Admin_Fee__c;
        //console.log('currenadminfee--->'+currenadminfee)
        let currentcashterms = bidRecord.Phoenix_Current_CD__c;
        if (currentcashterms != null) {
            currentcashterms = parseFloat(currentcashterms / 100);
        }
        console.log('currentcashterms--->' + currentcashterms)
        let propadminfee = bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
        console.log('propadminfee--->' + propadminfee)
        if (propadminfee != null) {
            propadminfee = parseFloat(propadminfee / 100);
        }
        let requiredPriceNumer = deadnetPrice;
        let requiredPricedeNumer;
        requiredPricedeNumer = 1 - (vipperunit - (currentcashterms + propadminfee) * vipperunit);
        console.log('requiredPricedeNumer next--->' + requiredPricedeNumer);
        component.set("v.RequiredPrice", requiredPriceNumer / requiredPricedeNumer);
        console.log("valueee-->", requiredPriceNumer / requiredPricedeNumer)
        component.set("v.expectDdeadnet", null);

        var WAC = component.get("v.singleRec.Phoenix_WAC__c");
        var proposedPriceMarketing = component.get("v.RequiredPrice");
        if (WAC < proposedPriceMarketing) {
            //onCISUChange(component, event,helper);
            component.set("v.errMsg", "Marketing Price can not be greater than WAC");
            component.set("v.err", true);
            component.set("v.ShowSaveButton", false);
        } else {
            component.set("v.err", false);
            component.set("v.ShowSaveButton", true);
            console.log("test price value--" + component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c"))
        }
    },

    inlineEditCISUnit: function (component, event, helper) {
        component.set("v.CISUEditMode", true);
        setTimeout(function () {
            component.find("inputCISUId").focus();
        }, 100);
    },
    inlineEditOverrideUnits: function (component, event, helper) {
        component.set("v.OverrideUnitsEditMode", true);
        setTimeout(function () {
            component.find("OverrideUnits").focus();
        }, 100);
    },
    inlineEditOverrideDirectUnits: function (component, event, helper) {
        component.set("v.OverrideDirEditMode", true);
        setTimeout(function () {
            component.find("OverrideDirectUnits").focus();
        }, 100);
    },
    inlineEditDirESI: function (component, event, helper) {
        component.set("v.DirectESIEditMode", true);
        setTimeout(function () {
            component.find("inputDirectESI").focus();
        }, 100);
    },
    inlineEditInDirESI: function (component, event, helper) {
        component.set("v.IndirectESIEditMode", true);
        setTimeout(function () {
            component.find("inputInDirectESI").focus();
        }, 100);
    },
    inlineEditDirectKroger: function (component, event, helper) {
        component.set("v.DirectKrogerEditMode", true);
        setTimeout(function () {
            component.find("DirectKroger").focus();
        }, 100);
    },
    inlineEditInDirectKroger: function (component, event, helper) {
        component.set("v.IndirectKrogerEditMode", true);
        setTimeout(function () {
            component.find("InDirectKroger").focus();
        }, 100);
    },
    inlineEditDirectRxOutReach: function (component, event, helper) {
        component.set("v.DirectRxOutReachEditMode", true);
        setTimeout(function () {
            component.find("DirectRxOutReach").focus();
        }, 100);
    },
    inlineEditInDirectRxOutReach: function (component, event, helper) {
        component.set("v.IndirectRxOutReachEditMode", true);
        setTimeout(function () {
            component.find("InDirectRxOutReach").focus();
        }, 100);
    },
    inlineEditDirSuperValEditMode: function (component, event, helper) {
        component.set("v.DirectSuperValuEditMode", true);
        setTimeout(function () {
            component.find("DirSuperVal").focus();
        }, 100);
    },
      inlineEditSCMLeadTime : function(component,event,helper){  
        component.set("v.scmLeadTimeEditMode", true);
        setTimeout(function(){
            component.find("scmLeadTime").focus();
        }, 100);
    },
    inlineEditInDirSuperValEditMode: function (component, event, helper) {
        component.set("v.IndirectSuperValuEditMode", true);
        setTimeout(function () {
            component.find("InDirSuperVal").focus();
        }, 100);
    },
    inlineEditDirectCignaEditMode: function (component, event, helper) {
        component.set("v.DirectCignaEditMode", true);
        setTimeout(function () {
            component.find("DirectCigna").focus();
        }, 100);
    },
    inlineEditInDirCignaEditMode: function (component, event, helper) {
        component.set("v.IndirectCignaEditMode", true);
        setTimeout(function () {
            component.find("InDirectCigna").focus();
        }, 100);
    },
    inlineEditDirectCordant: function (component, event, helper) {
        component.set("v.DirectCordantEditMode", true);
        setTimeout(function () {
            component.find("DirectCordant").focus();
        }, 100);
    },
    inlineEditInDirectCordant: function (component, event, helper) {
        component.set("v.IndirectCordantEditMode", true);
        setTimeout(function () {
            component.find("InDirectCordant").focus();
        }, 100);
    },
    inlineEditDirectAccordo: function (component, event, helper) {
        component.set("v.DirectAccordoEditMode", true);
        setTimeout(function () {
            component.find("DirectAccordo").focus();
        }, 100);
    },
    inlineEditInDirectAccordo: function (component, event, helper) {
        component.set("v.IndirectAccordoEditMode", true);
        setTimeout(function () {
            component.find("InDirectAccordo").focus();
        }, 100);
    },
    inlineEditOthersIndirect: function (component, event, helper) {
        component.set("v.OthersIndirectEditMode", true);
        setTimeout(function () {
            component.find("OthersIndirect").focus();
        }, 100);
    },
    inlineEditOthersDirect: function (component, event, helper) {
        component.set("v.OthersDirectEditMode", true);
        setTimeout(function () {
            component.find("OthersDirect").focus();
        }, 100);
    },
    inlineEditMarketingApproval: function (component, event, helper) {
        component.set("v.MarketApprovalEditMode", true);
        setTimeout(function () {
            component.find("inputMarketApprovalId").focus();
        }, 100);
    },
    inlineEditContractApproval: function (component, event, helper) {
        component.set("v.ContractApprovalEditMode", true);
        setTimeout(function () {
            component.find("inputContractApprovalId").focus();
        }, 100);
    },
    inlineEditContractComments: function (component, event, helper) {
        component.set("v.ContractCommentsEditMode", true);
        setTimeout(function () {
            component.find("inputContractCommentsId").focus();
        }, 100);
    },
    inlineEditCDSUnit: function (component, event, helper) {
        component.set("v.CDSUEditMode", true);
        setTimeout(function () {
            component.find("inputCDSUId").focus();
        }, 100);
    },
    inlineEditFeeType: function (component, event, helper) {
        component.set("v.feeTypeEdit", true);
        setTimeout(function () {
            component.find("inputFeeTypeId").focus();
        }, 100);
    },

    inlineEditRebateType: function (component, event, helper) {
        component.set("v.rebateTypeEdit", true);
        setTimeout(function () {
            component.find("inputRebateTypeId").focus();
        }, 100);
    },
    inlineEditPISUnit: function (component, event, helper) {
        component.set("v.PISUditMode", true);
        setTimeout(function () {
            component.find("inputPISUnitId").focus();
        }, 100);
    },
    inlineEditPDSUnit: function (component, event, helper) {
        component.set("v.PDSUEditMode", true);
        setTimeout(function () {
            component.find("inputPDSUId").focus();
        }, 100);
    },
    inlineEditWholeDiffPriInd: function (component, event, helper) {
        component.set("v.WDPIEditMode", true);
        setTimeout(function () {
            component.find("inputWDPIId").focus();
        }, 100);
    },
    inlineEditGuidancePrice: function (component, event, helper) {
        component.set("v.GDPEditMode", true);
        setTimeout(function () {
            component.find("inputGDPId").focus();
        }, 100);
    },
    inlineEditPCBPS: function (component, event, helper) {
        component.set("v.PCBPSEditMode", true);
        setTimeout(function () {
            component.find("inputPCBPSId").focus();
        }, 100);
    },
    inlineEditFAPC: function (component, event, helper) {
        component.set("v.FAPCEditMode", true);
        setTimeout(function () {
            component.find("inputFAPCId").focus();
        }, 100);
    },
    inlineEditProCurRebate: function (component, event, helper) {
        component.set("v.PCREditMode", true);
        setTimeout(function () {
            component.find("inputPCRId").focus();
        }, 100);
    },
    inlineEditProPerUnitRebate: function (component, event, helper) {
        component.set("v.PPUREditMode", true);
        setTimeout(function () {
            component.find("inputPPURId").focus();
        }, 100);
    },
    inlineEditBudASP: function (component, event, helper) {
        component.set("v.BudASPEditMode", true);
        setTimeout(function () {
            component.find("inputBudgAspId").focus();
        }, 100);
    },
    inlineEditISOV: function (component, event, helper) {
        component.set("v.ISOVEditMode", true);
        setTimeout(function () {
            component.find("inputISOVId").focus();
        }, 100);
    },
    inlineEditISOC: function (component, event, helper) {
        component.set("v.ISOCEditMode", true);
        setTimeout(function () {
            component.find("inputISOCId").focus();
        }, 100);
    },

    inlineEditSalesNotes: function (component, event, helper) {
        component.set("v.SalesNotesEditMode", true);
        setTimeout(function () {
            component.find("inputSalesNoteId").focus();
        }, 100);
    },
    inlineEditSCMNotes: function (component, event, helper) {
        component.set("v.SCMNotesEditMode", true);
        setTimeout(function () {
            component.find("inputSCMNotesId").focus();
        }, 100);
    },
    inlineEditPricingNotes: function (component, event, helper) {
        component.set("v.PriNotesEditMode", true);
        setTimeout(function () {
            component.find("inputPriceNotesId").focus();
        }, 100);
    },
    inlineEditMarketingNotes: function (component, event, helper) {
        component.set("v.MarkNotesEditMode", true);
        setTimeout(function () {
            component.find("inputMarketNotesId").focus();
        }, 100);
    },
    inlineEditPCBP: function (component, event, helper) {
        component.set("v.PCBPEditMode", true);
        setTimeout(function () {
            component.find("inputPCBPId").focus();
        }, 100);
    },
    inlineEditProposedAndaUsage: function (component, event, helper) {
        component.set("v.ProposedAndaUsageEditMode", true);
        setTimeout(function () {
            component.find("ProposedAndaUsage").focus();
        }, 100);
    },
    inlineEditProposedSmithDrugUsage: function (component, event, helper) {
        component.set("v.ProposedSmithDrugUsageEditMode", true);
        setTimeout(function () {
            component.find("ProposedSmithDrugUsage").focus();
        }, 100);
    },
    inlineEditProposedDirectAholdDelhaizeUnits: function (component, event, helper) {
        component.set("v.ProposedDirectAholdDelhaizeUnitsEditMode", true);
        setTimeout(function () {
            component.find("ProposedDirectAholdDelhaizeUnits").focus();
        }, 100);
    },
    inlineEditProposedDirectGaintEagleUnits: function (component, event, helper) {
        component.set("v.ProposedDirectGaintEagleUnitsEditMode", true);
        setTimeout(function () {
            component.find("ProposedDirectGaintEagleUnits").focus();
        }, 100);
    },
    inlineEditProposedIndirectAholdDelhaizeUnits: function (component, event, helper) {
        component.set("v.ProposedIndirectAholdDelhaizeUnitEditMode", true);
        setTimeout(function () {
            component.find("ProposedIndirectAholdDelhaizeUnits").focus();
        }, 100);
    },
    inlineEditProposedIndirectGaintEagleUnits: function (component, event, helper) {
        component.set("v.ProposedIndirectGaintEagleUnitsEditMode", true);
        setTimeout(function () {
            component.find("ProposedIndirectGaintEagleUnits").focus();
        }, 100);
    },
    inlineEditOthersDirect: function (component, event, helper) {
        component.set("v.OthersDirectEditMode", true);
        setTimeout(function () {
            component.find("OthersDirect").focus();
        }, 100);
    },
    inlineEditOthersIndirect: function (component, event, helper) {
        component.set("v.OthersIndirectEditMode", true);
        setTimeout(function () {
            component.find("OthersIndirect").focus();
        }, 100);
    },
    inlineEditRetailDirectGuidancePrice: function (component, event, helper) {
        component.set("v.RetailDirectGuidancePriceEditMode", true);
        setTimeout(function () {
            component.find("RetailDirectGuidancePrice").focus();
        }, 100);
    },
    inlineEditWholesalerGuidancePrice: function (component, event, helper) {
        component.set("v.WholesalerGuidancePriceEditMode", true);
        setTimeout(function () {
            component.find("WholesalerGuidancePrice").focus();
        }, 100);
    },
    inlineEditRetailDirectSalesPrice: function (component, event, helper) {
        component.set("v.RetailDirectSalesPricePEditMode", true);
        setTimeout(function () {
            component.find("RetailDirectSalesPrice").focus();
        }, 100);
    },
    inlineEditWholesalerSalesPrice: function (component, event, helper) {
        component.set("v.WholesalerSalesPriceEditMode", true);
        setTimeout(function () {
            component.find("WholesalerSalesPrice").focus();
        }, 100);
    },
    inlineEditRetailDirectPrice: function (component, event, helper) {
        component.set("v.RetailDirectPriceEditMode", true);
        setTimeout(function () {
            component.find("RetailDirectPrice").focus();
        }, 100);
    },
    inlineEditRetailIndirectPrice: function (component, event, helper) {
        component.set("v.RetailIndirectPriceEditMode", true);
        setTimeout(function () {
            component.find("RetailIndirectPrice").focus();
        }, 100);
    },
    inlineEditReduction: function (component, event, helper) {
        component.set("v.ReductionEditMode", true);
        setTimeout(function () {
            component.find("Reduction").focus();
        }, 100);
    },
    inlineEditOverrideIndirectUnits: function (component, event, helper) {
        component.set("v.OverrideIndirectUnitsEditMode", true);
        setTimeout(function () {
            component.find("OverrideIndirectUnits").focus();
        }, 100);
    },

    inlineEditOverrideDirectUnits: function (component, event, helper) {
        component.set("v.OverrideDirectUnitsEditMode", true);
        setTimeout(function () {
            component.find("OverrideDirectUnits").focus();
        }, 100);
    },
    inlineEditOverrideCurrentUnits: function (component, event, helper) {
        component.set("v.OverrideCurrentUnitsEditMode", true);
        setTimeout(function () {
            component.find("OverrideCurrentUnits").focus();
        }, 100);
    },
     inlineEditBASEMarketingPrice: function (component, event, helper) {
        component.set("v.BASEMarketingPriceEditMode", true);
        setTimeout(function () {
            component.find("BASEMarketingPrice").focus();
        }, 100);
    },
      inlineEditDSHSalesPrice: function (component, event, helper) {
        component.set("v.DSHSalesPricePEditMode", true);
        setTimeout(function () {
            component.find("DSHSalesPrice").focus();
        }, 100);
    },
    
     inlineEditWholesalerFee: function (component, event, helper) {
        component.set("v.WholesalerFeeEditMode", true);
        setTimeout(function () {
            component.find("WholesalerFee").focus();
        }, 100);
    },
    
      inlineEditCurrentAdminFee: function (component, event, helper) {
        component.set("v.currentAdminFeeEditMode", true);
        setTimeout(function () {
            component.find("CurrentAdminFee").focus();
        }, 100);
    },
    
          inlineEditRebate: function (component, event, helper) {
        component.set("v.rebateEditMode", true);
        setTimeout(function () {
            component.find("rebate").focus();
        }, 100);
    },
    
      inlineEditVIP: function (component, event, helper) {
        component.set("v.VIPEditMode", true);
        setTimeout(function () {
            component.find("VIP").focus();
        }, 100);
    },
    inlineEditCD: function (component, event, helper) {
        component.set("v.CDEditMode", true);
        setTimeout(function () {
            component.find("CD").focus();
        }, 100);
    },
      inlineEditBrandWAC  : function(component,event,helper){  
        component.set("v.BrandWACEditMode", true);
        setTimeout(function(){
            component.find("BrandWAC").focus();
        }, 100);
    },
     inlineEditOpeningOrder  : function(component,event,helper){  
        component.set("v.OpeningOrderEditMode", true);
        setTimeout(function(){
            component.find("OpeningOrder").focus();
        }, 100);
    },
     inlineEditCurrentSupplier  : function(component,event,helper){  
        component.set("v.CurrentSupplierEditMode", true);
        setTimeout(function(){
            component.find("CurrentSupplier").focus();
        }, 100);
    },
     inlineEditWAC  : function(component,event,helper){  
        component.set("v.WACEditMode", true);
        setTimeout(function(){
            component.find("WAC").focus();
        }, 100);
    },
    handleMouseHover: function (component, event, helper) {
        if (component.get("v.togglehover") == false) {
            component.set("v.togglehover", true);
        }
    },
    handleMouseOut: function (component, event, helper) {
        component.set("v.togglehover", false);
    },
    showSelectedproducts: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.isModalOpen", true);

        var action = component.get("c.getReBidLineInfo");
        action.setParams({
            'productId': component.get("v.singleRec.Phoenix_Product__r.Id"),
            'bidId': component.get("v.singleRec.Phoenix_Bid__c")
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            console.log('state--->' + state);
            var responseData = response.getReturnValue();
            component.set("v.ReBidListAll", responseData);

        });
        $A.enqueueAction(action);

    },
    closePopup: function (component, event, helper) {
        component.set("v.isModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },

    onCISUChange: function (component, event, helper) {
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var currentValue, fieldName;
        var isGuidancePrice1 = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice1' ? true : false;
        //var isGuidancePrice2 = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice2'? true:false;
        var isMarketingPrice1 = event.getSource().get('v.class') == 'slds-input inputWidth MarketingPrice1' ? true : false;
        var isMarketingPrice2 = event.getSource().get('v.class') == 'slds-input inputWidth MarketingPrice2' ? true : false;
           var MarketingDSHPrice = event.getSource().get('v.class') == 'slds-input inputWidth MarketingDSHPrice' ? true : false;
        var isSalesPrice1 = event.getSource().get('v.class') == 'slds-input inputWidth SalesPrice1' ? true : false;
        var isSalesPrice2 = event.getSource().get('v.class') == 'slds-input inputWidth SalesPrice2'? true:false;
          var DSHSalesPrice = event.getSource().get('v.class') == 'slds-input inputWidth DSHSalesPrice'? true:false;
        //console.log('nameofEditfield---'+nameofEditfield+'--isGuidancePrice1--'+isGuidancePrice1);
        if (nameofEditfield == 'rebateType') {
            currentValue = val;
            console.log('currentValue=======>' + currentValue)
            console.log('nameofEditfield=======>' + nameofEditfield)
            fieldName = nameofEditfield;
        } else if (nameofEditfield == 'feeType') {
            currentValue = val;
            fieldName = nameofEditfield;
        } else if (nameofEditfield == 'ContractApproval') {
            currentValue = val;
            fieldName = nameofEditfield;
        } else if (nameofEditfield == 'MarketApproval') {
            currentValue = val;
            fieldName = nameofEditfield;
        } else {
            currentValue = 'No Change';
            fieldName = '';
        }
        console.log('nameofEditfield---' + fieldName + '--currentValue--' + currentValue);
        console.log('isGuidancePrice1---' + isGuidancePrice1);
        console.log('isSalesPrice1---' + isSalesPrice1);
        console.log('isMarketingPrice1---' + isMarketingPrice1 + '--isMarketingPrice2--' + isMarketingPrice2);
        var copyText = component.get("v.RequiredPrice");
        console.log("required pirce-->" + copyText);
        if (component.get("v.isGoalseekModalOpen") == true) {
            component.set("v.singleRec.Phoenix_Retail_Direct_Price__c", copyText);

            component.set("v.isGoalseekModalOpen", false);
            var LineItemtable = component.get("v.tableRef");
            $A.util.addClass(LineItemtable, "maintable");
        }

        helper.getCalculations(component, event, helper, currentValue, fieldName, isGuidancePrice1, isMarketingPrice1, isMarketingPrice2, isSalesPrice1,isSalesPrice2,MarketingDSHPrice,DSHSalesPrice);

        //component.set("v.showSaveCancelBtn",true);
        //


        //helper.getCalculations(component,event,helper);
    },

    onCDSUChange: function (component, event, helper) {
        if (event.getSource().get("v.value").trim() != '') {
            component.set("v.showSaveCancelBtn", true);
        }
    },
    closeMarketApprovalBox: function (component, event, helper) {
        component.set("v.MarketApprovalEditMode", false);
    },
    closeContractApprovalBox: function (component, event, helper) {
        component.set("v.ContractApprovalEditMode", false);
    },
    closeContractCommentslBox: function (component, event, helper) {
        component.set("v.ContractCommentsEditMode", false);
    },
    closeFeeTypeBox: function (component, event, helper) {
        component.set("v.feeTypeEdit", false);

    },
    closeRebateTypeBox: function (component, event, helper) {
        component.set("v.rebateTypeEdit", false);
    },
    onRatingChange: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
    },

    closeCISUBox: function (component, event, helper) {
        component.set("v.CISUEditMode", false);

    },
    closeCDSUBox: function (component, event, helper) {
        component.set("v.CDSUEditMode", false);

    },
    closePISUBox: function (component, event, helper) {
        component.set("v.PISUditMode", false);

    },
    closePDSUBox: function (component, event, helper) {
        component.set("v.PDSUEditMode", false);

    },
    closeWDPIBox: function (component, event, helper) {
        component.set("v.WDPIEditMode", false);
    },
    closeGDPBox: function (component, event, helper) {
        component.set("v.GDPEditMode", false);
    },
    closePCBPSBox: function (component, event, helper) {
        component.set("v.PCBPSEditMode", false);
    },
    closeOverrideUnits: function (component, event, helper) {
        component.set("v.OverrideUnitsEditMode", false);
    },
    closeOverrideDirectUnits: function (component, event, helper) {
        component.set("v.OverrideDirEditMode", false);
    },
    closeFAPCBox: function (component, event, helper) {
        component.set("v.FAPCEditMode", false);
    },
    closeProCurRebateBox: function (component, event, helper) {
        component.set("v.PCREditMode", false);
    },
    closePPURBox: function (component, event, helper) {
        component.set("v.PPUREditMode", false);
    },
    closeBudgAspBox: function (component, event, helper) {
        component.set("v.BudASPEditMode", false);
    },
    closeISOVBox: function (component, event, helper) {
        component.set("v.ISOVEditMode", false);
    },
    closeISOCBox: function (component, event, helper) {
        component.set("v.ISOCEditMode", false);
    },
    closeSalesNotesBox: function (component, event, helper) {
        component.set("v.SalesNotesEditMode", false);
    },
    closeSCMNotesBox: function (component, event, helper) {
        component.set("v.SCMNotesEditMode", false);
    },
    closePriceNotesBox: function (component, event, helper) {
        component.set("v.PriNotesEditMode", false);
    },
     closeEstimatedLeadBox : function (component, event, helper) {
        component.set("v.scmLeadTimeEditMode", false);
    },
    closeMarketNotesBox: function (component, event, helper) {
        component.set("v.MarkNotesEditMode", false);
    },
    closePCBPBox: function (component, event, helper) {
        component.set("v.PCBPEditMode", false);
    },

    closeDirESIBox: function (component, event, helper) {
        component.set("v.DirectESIEditMode", false);
    },
    closeInDirESIUBox: function (component, event, helper) {
        component.set("v.IndirectESIEditMode", false);
    },
    closeDirectKrogerBox: function (component, event, helper) {
        component.set("v.DirectKrogerEditMode", false);
    },
    closeInDirectKrogerUBox: function (component, event, helper) {
        component.set("v.IndirectKrogerEditMode", false);
    },
    closeDirectRxOutReachUBox: function (component, event, helper) {
        component.set("v.DirectRxOutReachEditMode", false);
    },
    closeInDirectReachUBox: function (component, event, helper) {
        component.set("v.IndirectRxOutReachEditMode", false);
    },
    closeDirSuperValBox: function (component, event, helper) {
        component.set("v.DirectSuperValuEditMode", false);
    },
    closeInDirSuperVal: function (component, event, helper) {
        component.set("v.IndirectSuperValuEditMode", false);
    },
    closeDirectCigna: function (component, event, helper) {
        component.set("v.DirectCignaEditMode", false);
    },
    closeInDirectCigna: function (component, event, helper) {
        component.set("v.IndirectCignaEditMode", false);
    },
    closDirectCordant: function (component, event, helper) {
        component.set("v.DirectCordantEditMode", false);
    },
    closeInDirectCordant: function (component, event, helper) {
        component.set("v.IndirectCordantEditMode", false);
    },
    closeDirectAccordo: function (component, event, helper) {
        component.set("v.DirectAccordoEditMode", false);
    },
    closeInDirectAccordo: function (component, event, helper) {
        component.set("v.IndirectAccordoEditMode", false);
    },
    closeOthersDirect: function (component, event, helper) {
        component.set("v.OthersDirectEditMode", false);
    },
    closeOthersIndirect: function (component, event, helper) {
        component.set("v.OthersIndirectEditMode", false);
    },
    closeProposedAndaUsage: function (component, event, helper) {
        component.set("v.ProposedAndaUsageEditMode", false);
    },
    closeProposedSmithDrugUsage: function (component, event, helper) {
        component.set("v.ProposedSmithDrugUsageEditMode", false);
    },
    closeProposedDirectAholdDelhaizeUnits: function (component, event, helper) {
        component.set("v.ProposedDirectAholdDelhaizeUnitsEditMode", false);
    },
    closeProposedDirectGaintEagleUnits: function (component, event, helper) {
        component.set("v.ProposedDirectGaintEagleUnitsEditMode", false);
    },
    closeProposedIndirectAholdDelhaizeUnits: function (component, event, helper) {
        component.set("v.ProposedIndirectAholdDelhaizeUnitEditMode", false);
    },
    closeProposedIndirectGaintEagleUnits: function (component, event, helper) {
        component.set("v.ProposedIndirectGaintEagleUnitsEditMode", false);
    },
    closeOthersDirect: function (component, event, helper) {
        component.set("v.OthersDirectEditMode", false);
    },
    closeOthersIndirect: function (component, event, helper) {
        component.set("v.OthersIndirectEditMode", false);
    },
    closeRetailDirectGuidancePrice: function (component, event, helper) {
        component.set("v.RetailDirectGuidancePriceEditMode", false);
    },
    closeWholesalerGuidancePrice: function (component, event, helper) {
        component.set("v.WholesalerGuidancePriceEditMode", false);
    },
    closeRetailDirectSalesPrice: function (component, event, helper) {
        component.set("v.RetailDirectSalesPricePEditMode", false);
    },
    closeWholesalerSalesPrice: function (component, event, helper) {
        component.set("v.WholesalerSalesPriceEditMode", false);
    },
    closeRetailDirectPrice: function (component, event, helper) {
        component.set("v.RetailDirectPriceEditMode", false);
    },
    closeRetailIndirectPrice: function (component, event, helper) {
        component.set("v.RetailIndirectPriceEditMode", false);
    },
    closeReductionBox: function (component, event, helper) {
        component.set("v.ReductionEditMode", false);
    },

    closeOverrideIndirectUnits: function (component, event, helper) {
        component.set("v.OverrideIndirectUnitsEditMode", false);
    },
    closeOverrideDirectUnits: function (component, event, helper) {
        component.set("v.OverrideDirectUnitsEditMode", false);
    },
    closeOverrideCurrentUnits: function (component, event, helper) {
        component.set("v.OverrideCurrentUnitsEditMode", false);
    },
      closeBASEMarketingPrice: function (component, event, helper) {
        component.set("v.BASEMarketingPriceEditMode", false);
    },
    
     closeDSHSalesPrice: function (component, event, helper) {
        component.set("v.DSHSalesPricePEditMode", false);
    },
    
     closeWholesalerFee : function (component, event, helper) {
        component.set("v.WholesalerFeeEditMode", false);
    },
     closeCurrentAdminFee : function (component, event, helper) {
        component.set("v.currentAdminFeeEditMode", false);
    },
    closeRebate : function (component, event, helper) {
        component.set("v.rebateEditMode", false);
    },
    closeVIP : function (component, event, helper) {
        component.set("v.VIPEditMode", false);
    },
    closeCD : function (component, event, helper) {
        component.set("v.CDEditMode", false);
    },
     closeBrandWAC  : function (component, event, helper) {
        component.set("v.BrandWACEditMode", false);
    },
    closeOpeningOrder  : function (component, event, helper) {
        component.set("v.OpeningOrderEditMode", false);
    },
     closeCurrentSupplier  : function (component, event, helper) {
        component.set("v.CurrentSupplierEditMode", false);
    },
     closeWAC  : function (component, event, helper) {
        component.set("v.WACEditMode", false);
    },

    //----->
    
    deleteLineItem: function (component, event, helper) {
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('rowIndex--->' + rowIndex);
        console.log('rowIndex-num-->' + component.get("v.sNo"));
        console.log('rowIndex--lenth->' + component.get("v.ItemsLength"));
        var action = component.get("c.deleteLineItems");
        action.setParams({
            'LineItemId': rowIndex
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state--->' + state);
            component.set("v.ItemsLength", component.get("v.ItemsLength") - 1);

        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send");
        event.fire();

    },
     /*Product Positions logic Start*/
    inlineEditPositions: function (component, event, helper) {
        component.set("v.isPositionsModalOpen", true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        /*component.set("v.PositionsEditMode", true);
        setTimeout(function(){
            component.find("positions").focus();
        }, 100);*/
        component.set('v.LinepositionColumns', [{
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
        // var searchInput=component.find("cntInput").get("v.value");
        // console.log('--searchInput--'+searchInput);
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.getPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.LinepositionsList", null);
        }
    },
    closePositionsPopup: function (component, event, helper) {
        component.set("v.isPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    savePositions: function (component, event, helper) {
        var selectPos = component.find('PoslineLevelTable').getSelectedRows();
        var selectedPositions = []; //=component.get("v.LineselectedPosistions;
        for (var i = 0; i < selectPos.length; i++) {
            selectedPositions.push(selectPos[i].Name);
        }
        component.set("v.LineselectedPosistions", selectedPositions);
        console.log('selectedPositions--' + selectedPositions);
        component.set("v.singleRec.Phoenix_Proposed_Position__c", selectedPositions.toString());
        helper.getCalculations(component, event, helper, 'No Change', '', false, false, false);
        component.set("v.isPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    /*Product Positions logic End*/
    // This method is to collect the Bid Histroy--START
    
      displayBidHist:function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---'+LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId",rowIndex);
        component.set("v.displayBidHist",true);
        
    },
    
    //--END
    
    // This method is to collect the Prod NPR Histroy--START
    
    displayProdNPRHist:function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var selectedRec = event.getSource().get("v.name");
        component.set("v.bidLineItemId",selectedRec);
        component.set("v.displayProdNPRHist",true);
        
    },
    
    //--END
   
   // This method is to collect IMS Market Share--START
    
    displayIMSMarketShare:function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var selectedRec = event.getSource().get("v.name");
        component.set("v.bidLineItemId",selectedRec);
        component.set("v.displayIMS",true);
        
   
     },
        
        //--END
        
         // This method is to collect IMS Market Share--START
        
        displayHistoricalPricing:function (component, event, helper) {
            var LineItemtable = component.get("v.tableRef");
             var rowIndex = component.get("v.lineItemId");
            $A.util.removeClass(LineItemtable, "maintable");
            component.set("v.bidLineItemId",rowIndex);
            component.set("v.displayHistPricing",true);
            
        },
     displayFutureRecords: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        var rowIndex = component.get("v.lineItemId");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayFutureDisplay", true);
    },
        
        //--END
})