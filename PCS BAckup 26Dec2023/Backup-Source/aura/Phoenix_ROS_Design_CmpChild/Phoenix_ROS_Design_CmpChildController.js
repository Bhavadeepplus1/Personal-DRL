({    
    doInit: function(component, event, helper) {
        var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
        var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
        var dirDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
        var indDeadNet = component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") : 0 ;
        var cardDeadNet = component.get("v.singleRec.Phoenix_Customer_Dead_Net1__c") != null ? component.get("v.singleRec.Phoenix_Customer_Dead_Net1__c") : 0 ;
        var childRec = component.get("v.singleRec.BidLineItemsExtn__r[0]");
        component.set("v.childRec",childRec);
        dirDeadnet = (Math.round(dirDeadnet * 100) / 100).toFixed(2);
        indDeadNet = (Math.round(indDeadNet * 100) / 100).toFixed(2);
        cardDeadNet = (Math.round(cardDeadNet * 100) / 100).toFixed(2);
        component.set("v.dirDeadnet",dirDeadnet);
        component.set("v.indDeadNet",indDeadNet);
        component.set("v.cardDeadNet",cardDeadNet);
        
        var productDirector = component.get("v.singleRec.Phoenix_Product_Director__c");
        var delegatedUser = component.get("v.deligatedUserName");
        console.log("Deligation user-->"+delegatedUser);
        console.log("productDirector user-->"+productDirector);
        console.log('isBala--->'+productDirector+"-->"+delegatedUser.includes(productDirector))
        if(productDirector != null && delegatedUser != null && delegatedUser.includes(productDirector) && component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c") == false){
            component.set("v.isdeligationApprover",true) 
            
        }
        //get the Extn child LineItem record..
        /* var action = component.get("c.getChildExtnRecord");
        action.setParams({
            'bliId' : component.get("v.singleRec.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state FROM getChildExtnRecord--->'+state);
            if(state==='SUCCESS'){
                component.set("v.childRec",response.getReturnValue()); */
        var majorDeadNet = component.get("v.childRec.Phoenix_Internal_Major_Dead_Net__c") != null ? component.get("v.childRec.Phoenix_Internal_Major_Dead_Net__c") : 0 ;
        majorDeadNet = (Math.round(majorDeadNet * 100) / 100).toFixed(2);
        component.set("v.majorDeadNet",majorDeadNet);
        var waccardinalPercent;
        var currentcardinalContractPrice;
        var wacmajorPercent;
        var currentmajorContractPrice;
        var wacdirectPercent;
        var currentdirectContractPrice;
        var wacIndirectPercent;
        var currentIndirectContractPrice;
        if(component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") > 0 && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != null && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != '' && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != undefined){
            waccardinalPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")*100).toFixed(2) + '%';
            currentcardinalContractPrice = (component.get("v.singleRec.Phoenix_Current_Wholesaler_Price__c")/component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")*100).toFixed(2) + '%';
            
        }
        else{
            waccardinalPercent = 'NA'; 
            currentcardinalContractPrice = 'NA';
            
        }
        if(childRec.Phoenix_Proposed_CvsDirectContractPrice__c > 0 && childRec.Phoenix_Proposed_CvsDirectContractPrice__c != null && childRec.Phoenix_Proposed_CvsDirectContractPrice__c != '' && childRec.Phoenix_Proposed_CvsDirectContractPrice__c != undefined){
            
            
            wacdirectPercent = (component.get("v.singleRec.Phoenix_WAC__c")/childRec.Phoenix_Proposed_CvsDirectContractPrice__c*100).toFixed(2);
            currentdirectContractPrice = (component.get("v.singleRec.Phoenix_Current_Direct_Price__c")/childRec.Phoenix_Proposed_CvsDirectContractPrice__c*100).toFixed(2);
        }
        else{
            wacdirectPercent = 'NA'; 
            currentdirectContractPrice = 'NA';
            
        }
        if(component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") > 0 && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != null && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != '' && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != undefined){
            
            wacIndirectPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2);
            currentIndirectContractPrice = (component.get("v.singleRec.Phoenix_Current_Indirect_Price__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2);
        }
        else{
            wacIndirectPercent = 'NA'; 
            currentIndirectContractPrice = 'NA';
            
        }
        if(childRec.Phoenix_Proposed_Major_Contract_Price__c > 0 && childRec.Phoenix_Proposed_Major_Contract_Price__c != null && childRec.Phoenix_Proposed_Major_Contract_Price__c != '' && childRec.Phoenix_Proposed_Major_Contract_Price__c != undefined){
            
            wacmajorPercent = (component.get("v.singleRec.Phoenix_WAC__c")/childRec.Phoenix_Proposed_Major_Contract_Price__c*100).toFixed(2);
            currentmajorContractPrice = (childRec.Phoenix_Current_Major_Contract_Price__c/childRec.Phoenix_Proposed_Major_Contract_Price__c*100).toFixed(2);
        }
        else{
            wacmajorPercent = 'NA'; 
            currentmajorContractPrice = 'NA';
            
        }
        component.set("v.singleRec.wacmajorPercent",wacmajorPercent);
        component.set("v.singleRec.currentmajorContractPrice",currentmajorContractPrice);
        component.set("v.singleRec.waccardinalPercent",waccardinalPercent);
        component.set("v.singleRec.currentcardinalContractPrice",currentcardinalContractPrice);
        component.set("v.singleRec.wacdirectPercent",wacdirectPercent);
        component.set("v.singleRec.currentdirectContractPrice",currentdirectContractPrice);
        component.set("v.singleRec.wacIndirectPercent",wacIndirectPercent);
        component.set("v.singleRec.currentIndirectContractPrice",currentIndirectContractPrice);
        
        //checking for highlights...
        if(latestEstimate > 0){
            var lePlus = (latestEstimate/100)*10 + latestEstimate;
            var leMinus = latestEstimate - (latestEstimate/100)*10;
            var isAccpetable= lePlus < dirDeadnet ? true : false;
            var isNotAccpetable= leMinus < dirDeadnet ? true : false;
            var isAccpetable1= lePlus < indDeadNet ? true : false;
            var isNotAccpetable1= leMinus < indDeadNet ? true : false;
            var isAccpetable2= lePlus < cardDeadNet ? true : false;
            var isNotAccpetable2= leMinus < cardDeadNet ? true : false;
            var isAccpetable3= lePlus < majorDeadNet ? true : false;
            var isNotAccpetable3= leMinus < majorDeadNet ? true : false;
            component.set("v.isAccpetable",isAccpetable);
            component.set("v.isNotAccpetable",isNotAccpetable);
            component.set("v.isAccpetable1",isAccpetable1);
            component.set("v.isNotAccpetable1",isNotAccpetable1);
            component.set("v.isAccpetable2",isAccpetable2);
            component.set("v.isNotAccpetable2",isNotAccpetable2);
            component.set("v.isAccpetable3",isAccpetable3);
            component.set("v.isNotAccpetable3",isNotAccpetable3);
        }
        else if(BudgetedASP > 0){
            var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < dirDeadnet ? true : false;
            var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < dirDeadnet ? true : false;
            var isAccpetable1= ((BudgetedASP/100)*10 + BudgetedASP) < indDeadNet ? true : false;
            var isNotAccpetable1= (BudgetedASP - (BudgetedASP/100)*10) < indDeadNet ? true : false;
            var isAccpetable2= ((BudgetedASP/100)*10 + BudgetedASP) < cardDeadNet ? true : false;
            var isNotAccpetable2= (BudgetedASP - (BudgetedASP/100)*10) < cardDeadNet ? true : false;
            var isAccpetable3= ((BudgetedASP/100)*10 + BudgetedASP) < majorDeadNet ? true : false;
            var isNotAccpetable3= (BudgetedASP - (BudgetedASP/100)*10) < majorDeadNet ? true : false;
            component.set("v.isAccpetable",isAccpetable);
            component.set("v.isNotAccpetable",isNotAccpetable);
            component.set("v.isAccpetable1",isAccpetable1);
            component.set("v.isNotAccpetable1",isNotAccpetable1);
            component.set("v.isAccpetable2",isAccpetable2);
            component.set("v.isNotAccpetable2",isNotAccpetable2);
            component.set("v.isAccpetable3",isAccpetable3);
            component.set("v.isNotAccpetable3",isNotAccpetable3);
        }else{
            console.log('else condition--->')
            component.set("v.isAccpetable",false);
            component.set("v.isNotAccpetable",false);
            component.set("v.isAccpetable1",false);
            component.set("v.isNotAccpetable1",false);
            component.set("v.isAccpetable2",false);
            component.set("v.isNotAccpetable2",false);
            component.set("v.isAccpetable3",false);
            component.set("v.isNotAccpetable3",false);
        }
        /*  }
            if(state==='ERROR'){
                var errorMsg = action.getError()[0].message;
                console.log('ERROR FROM getChildExtnRecord  --  '+errorMsg);
            }
        });
        $A.enqueueAction(action); */
        //helper.fetchPickListVal(component, 'Phoenix_Initial_Order_Discount_Type__c', 'ratingPicklistOpts');
    },
    closeGoalseekPopup : function(component,event,helper){
        component.set("v.isGoalseekModalOpen",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    openGoalseek :  function(component,event,helper){
        component.set("v.isGoalseekModalOpen",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    inlineContSDF: function (component, event, helper) {
        component.set("v.ContSDFEditMode", true);
        setTimeout(function () {
            component.find("CSDFId").focus();
        }, 100);
    },
    /*--
    /*New ProductLaunch*/
    inlineWac: function (component, event, helper) {
        component.set("v.WacEditMode", true);
        setTimeout(function () {
            component.find("inputwacId").focus();
        }, 100);
    },
    inlineBrandWac: function (component, event, helper) {
        component.set("v.CSPEditMode", true);
        setTimeout(function () {
            component.find("inputCSPId").focus();
        }, 100);
    },
    inlineOpeningOrder: function (component, event, helper) {
        component.set("v.OpeningOrderEditMode", true);
        setTimeout(function () {
            component.find("OpeningOrderId").focus();
        }, 100);
    },
    inlineOpeningOrderCVS: function (component, event, helper) {
        component.set("v.OpeningOrderCVSEditMode", true);
        setTimeout(function () {
            component.find("OpeningOrderCVSId").focus();
        }, 100);
    },
    inlineOpeningMajorOrder: function (component, event, helper) {
        component.set("v.OpeningMajorOrderEditMode", true);
        setTimeout(function () {
            component.find("OpeningMajorOrderId").focus();
        }, 100);
    },
    inlineCurrentSupplier: function (component, event, helper) {
        component.set("v.CSUPEditMode", true);
        setTimeout(function () {
            component.find("inputCSUPId").focus();
        }, 100);
    },
    inlineMajorSupplier: function (component, event, helper) {
        component.set("v.CMajorEditMode", true);
        setTimeout(function () {
            component.find("inputMajorId").focus();
        }, 100);
    },
    inlineEditEstDays: function(component,event,helper){  
        component.set("v.EstDaysEditMode", true);
        setTimeout(function(){
            component.find("inputEstDaysId").focus();
        }, 100);
    },
    /* End New Product Launch*/
    /* New Product Launch*/
    closeOpeningOrder: function (component, event, helper) {
        component.set("v.OpeningOrderEditMode", false);
    },
    
    closeOpeningOrderCVS: function (component, event, helper) {
        component.set("v.OpeningOrderCVSEditMode", false);
    },
    closeMajorOrder: function (component, event, helper) {
        component.set("v.OpeningMajorOrderEditMode", false);
    },
    closeCURSUP: function (component, event, helper) {
        component.set("v.CSUPEditMode", false);
    },
    closeCuMajUP: function (component, event, helper) {
        component.set("v.CMajorEditMode", false);
    },
    closeWac: function (component, event, helper) {
        component.set("v.WacEditMode", false);
    },
    closeBrandWac: function (component, event, helper) {
        component.set("v.CSPEditMode", false);
    },
    /*END New Product Launch*/
    
    inlineEditCISUnit : function(component,event,helper){  
        component.set("v.CISUEditMode", true);
        setTimeout(function(){
            component.find("inputCISUId").focus();
        }, 100);
    },
    inlineEditOverrideCVSDirectUnits : function(component,event,helper){  
        component.set("v.OverrideCVSDirectUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverridecvsdirectUnits").focus();
        }, 100);
    },
    inlineEditOverrideCVSInDirectUnits : function(component,event,helper){  
        component.set("v.OverrideCVSInDirectUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverridecvsindirectUnits").focus();
        }, 100);
    },
    inlineEditOverrideCardinalUnits : function(component,event,helper){  
        component.set("v.OverrideCardinaltUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverridecardinalUnits").focus();
        }, 100);
    },
    inlineEditOverrideMajorUnits : function(component,event,helper){  
        component.set("v.OverrideMajorUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverridemajorUnits").focus();
        }, 100);
    },
    inlineEditProposedCVSDirectUnits : function(component,event,helper){  
        component.set("v.ProposedCVSDirectUnitsEditMode", true);
        setTimeout(function(){
            component.find("proposedcvsdirectUnits").focus();
        }, 100);
    },
    inlineEditProposedCVSInDirectUnits : function(component,event,helper){  
        component.set("v.ProposedCVSInDirectUnitsEditMode", true);
        setTimeout(function(){
            component.find("proposedcvsindirectUnits").focus();
        }, 100);
    },
    inlineEditProposedCardinalUnits : function(component,event,helper){  
        component.set("v.ProposedCardinalUnitsEditMode", true);
        setTimeout(function(){
            component.find("proposedcardinalUnits").focus();
        }, 100);
    },
    inlineEditProposedMajorUnits : function(component,event,helper){  
        component.set("v.ProposedMajorUnitsEditMode", true);
        setTimeout(function(){
            component.find("proposedmajorUnits").focus();
        }, 100);
    },
    inlineEditOverrideUnits : function(component,event,helper){  
        component.set("v.OverrideUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverrideUnits").focus();
        }, 100);
    },
    inlineEditOverrideDirectUnits: function(component,event,helper){  
        component.set("v.OverrideDirEditMode", true);
        setTimeout(function(){
            component.find("OverrideDirectUnits").focus();
        }, 100);
    },
    inlineEditDirESI:  function(component,event,helper){  
        component.set("v.DirectESIEditMode", true);
        setTimeout(function(){
            component.find("inputDirectESI").focus();
        }, 100);
    },
    inlineEditInDirESI:  function(component,event,helper){  
        component.set("v.IndirectESIEditMode", true);
        setTimeout(function(){
            component.find("inputInDirectESI").focus();
        }, 100);
    }, 
    inlineEditDirectKroger:  function(component,event,helper){  
        component.set("v.DirectKrogerEditMode", true);
        setTimeout(function(){
            component.find("DirectKroger").focus();
        }, 100);
    }, 
    inlineEditInDirectKroger:  function(component,event,helper){  
        component.set("v.IndirectKrogerEditMode", true);
        setTimeout(function(){
            component.find("InDirectKroger").focus();
        }, 100);
    },
    inlineEditDirectRxOutReach:  function(component,event,helper){  
        component.set("v.DirectRxOutReachEditMode", true);
        setTimeout(function(){
            component.find("DirectRxOutReach").focus();
        }, 100);
    },
    inlineEditInDirectRxOutReach:  function(component,event,helper){  
        component.set("v.IndirectRxOutReachEditMode", true);
        setTimeout(function(){
            component.find("InDirectRxOutReach").focus();
        }, 100);
    },
    inlineEditDirSuperValEditMode:  function(component,event,helper){  
        component.set("v.DirectSuperValuEditMode", true);
        setTimeout(function(){
            component.find("DirSuperVal").focus();
        }, 100);
    },
    inlineEditInDirSuperValEditMode:  function(component,event,helper){  
        component.set("v.IndirectSuperValuEditMode", true);
        setTimeout(function(){
            component.find("InDirSuperVal").focus();
        }, 100);
    },
    inlineEditDirectCignaEditMode:  function(component,event,helper){  
        component.set("v.DirectCignaEditMode", true);
        setTimeout(function(){
            component.find("DirectCigna").focus();
        }, 100);
    },
    inlineEditInDirCignaEditMode:  function(component,event,helper){  
        component.set("v.IndirectCignaEditMode", true);
        setTimeout(function(){
            component.find("InDirectCigna").focus();
        }, 100);
    },
    inlineEditDirectCordant:  function(component,event,helper){  
        component.set("v.DirectCordantEditMode", true);
        setTimeout(function(){
            component.find("DirectCordant").focus();
        }, 100);
    },
    inlineEditInDirectCordant:  function(component,event,helper){  
        component.set("v.IndirectCordantEditMode", true);
        setTimeout(function(){
            component.find("InDirectCordant").focus();
        }, 100);
    },
    inlineEditDirectAccordo:  function(component,event,helper){  
        component.set("v.DirectAccordoEditMode", true);
        setTimeout(function(){
            component.find("DirectAccordo").focus();
        }, 100);
    },
    inlineEditInDirectAccordo:  function(component,event,helper){  
        component.set("v.IndirectAccordoEditMode", true);
        setTimeout(function(){
            component.find("InDirectAccordo").focus();
        }, 100);
    },
    inlineEditOthersIndirect:  function(component,event,helper){  
        component.set("v.OthersIndirectEditMode", true);
        setTimeout(function(){
            component.find("OthersIndirect").focus();
        }, 100);
    },
    inlineEditOthersDirect:  function(component,event,helper){  
        component.set("v.OthersDirectEditMode", true);
        setTimeout(function(){
            component.find("OthersDirect").focus();
        }, 100);
    },
    inlineEditMarketingApproval : function(component,event,helper){  
        component.set("v.MarketApprovalEditMode", true);
        setTimeout(function(){
            component.find("inputMarketApprovalId").focus();
        }, 100);
    },
    inlineEditContractApproval : function(component,event,helper){  
        component.set("v.ContractApprovalEditMode", true);
        setTimeout(function(){
            component.find("inputContractApprovalId").focus();
        }, 100);
    },
    inlineEditContractComments : function(component,event,helper){  
        component.set("v.ContractCommentsEditMode", true);
        setTimeout(function(){
            component.find("inputContractCommentsId").focus();
        }, 100);
    },
    inlineEditCDSUnit: function(component,event,helper){  
        component.set("v.CDSUEditMode", true);
        setTimeout(function(){
            component.find("inputCDSUId").focus();
        }, 100);
    },
    inlineEditFeeType : function(component,event,helper){  
        component.set("v.feeTypeEdit", true);
        setTimeout(function(){
            component.find("inputFeeTypeId").focus();
        }, 100);
    }, 
    
    inlineEditRebateType : function(component,event,helper){  
        component.set("v.rebateTypeEdit", true);
        setTimeout(function(){
            component.find("inputRebateTypeId").focus();
        }, 100);
    },
    inlineEditPISUnit: function(component,event,helper){  
        component.set("v.PISUditMode", true);
        setTimeout(function(){
            component.find("inputPISUnitId").focus();
        }, 100);
    },
    inlineEditPDSUnit: function(component,event,helper){  
        component.set("v.PDSUEditMode", true);
        setTimeout(function(){
            component.find("inputPDSUId").focus();
        }, 100);
    },
    inlineEditWholeDiffPriInd : function(component,event,helper){  
        component.set("v.WDPIEditMode", true);
        setTimeout(function(){
            component.find("inputWDPIId").focus();
        }, 100);
    },
    inlineEditGuidancePrice: function(component,event,helper){  
        component.set("v.GDPEditMode", true);
        setTimeout(function(){
            component.find("inputGDPId").focus();
        }, 100);
    },
    inlineEditPCBPS : function(component,event,helper){  
        component.set("v.PCBPSEditMode", true);
        setTimeout(function(){
            component.find("inputPCBPSId").focus();
        }, 100);
    },
    inlineEditProposedCardinalSalesPrice : function(component,event,helper){  
        component.set("v.ProposedCardinalSalesPriceEditMode", true);
        setTimeout(function(){
            component.find("inputProposedCardinalSalesPrice").focus();
        }, 100);
    },
    inlineEditProposedMajorSalesPrice : function(component,event,helper){  
        component.set("v.ProposedMajorSalesPriceEditMode", true);
        setTimeout(function(){
            component.find("inputProposedMajorSalesPrice").focus();
        }, 100);
    },
    inlineEditFAPC : function(component,event,helper){  
        component.set("v.FAPCEditMode", true);
        setTimeout(function(){
            component.find("inputFAPCId").focus();
        }, 100);
    },
    inlineEditProCurRebate:  function(component,event,helper){  
        component.set("v.PCREditMode", true);
        setTimeout(function(){
            component.find("inputPCRId").focus();
        }, 100);
    },
    inlineEditPreferredMjrRebatePer:  function(component,event,helper){  
        component.set("v.PreferredMjrRebatePerEditMode", true);
        setTimeout(function(){
            component.find("inputPreferredMjrRebatePer").focus();
        }, 100);
    },
    inlineEditProPerUnitRebate : function(component,event,helper){  
        component.set("v.PPUREditMode", true);
        setTimeout(function(){
            component.find("inputPPURId").focus();
        }, 100);
    },
    inlineEditBudASP: function(component,event,helper){  
        component.set("v.BudASPEditMode", true);
        setTimeout(function(){
            component.find("inputBudgAspId").focus();
        }, 100);
    },
    inlineEditISOV: function(component,event,helper){  
        component.set("v.ISOVEditMode", true);
        setTimeout(function(){
            component.find("inputISOVId").focus();
        }, 100);
    },
    inlineEditISOC: function(component,event,helper){  
        component.set("v.ISOCEditMode", true);
        setTimeout(function(){
            component.find("inputISOCId").focus();
        }, 100);
    },
    
    inlineEditSalesNotes : function(component,event,helper){  
        component.set("v.SalesNotesEditMode", true);
        setTimeout(function(){
            component.find("inputSalesNoteId").focus();
        }, 100);
    },
    inlineEditSCMNotes: function(component,event,helper){  
        component.set("v.SCMNotesEditMode", true);
        setTimeout(function(){
            component.find("inputSCMNotesId").focus();
        }, 100);
    },
    inlineEditPricingNotes: function(component,event,helper){  
        component.set("v.PriNotesEditMode", true);
        setTimeout(function(){
            component.find("inputPriceNotesId").focus();
        }, 100);
    },
    inlineEditMarketingNotes:  function(component,event,helper){  
        component.set("v.MarkNotesEditMode", true);
        setTimeout(function(){
            component.find("inputMarketNotesId").focus();
        }, 100);
    },
    inlineEditPCBP : function(component,event,helper){  
        component.set("v.PCBPEditMode", true);
        setTimeout(function(){
            component.find("inputPCBPId").focus();
        }, 100);
    },
    inlineEditPCVSIndCtcPrice : function(component,event,helper){  
        component.set("v.PCVSIndCtcPriceEditMode", true);
        setTimeout(function(){
            component.find("inputPCVSIndCtcPrice").focus();
        }, 100);
    },
    inlineEditPMkngCVSCardinalAcqunCosts : function(component,event,helper){  
        component.set("v.PMkngCVSCardinalAcqunCostsEditMode", true);
        setTimeout(function(){
            component.find("inputPMkngCVS/CardinalAcqunCosts").focus();
        }, 100);
    },
    handleMouseHover: function(component, event, helper) {     
        if(component.get("v.togglehover")==false){         
            component.set("v.togglehover",true);
        }        
    },
    handleMouseOut: function(component, event, helper) {      
        component.set("v.togglehover",false);
    },
    showSelectedproducts:function(component,event,helper){
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---'+LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.isModalOpen",true);
        
        var action = component.get("c.getReBidLineInfo");
        action.setParams({
            'productId' : component.get("v.singleRec.Phoenix_Product__r.Id"),
            'bidId':component.get("v.singleRec.Phoenix_Bid__c")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('state--->'+state);
            var responseData =  response.getReturnValue();
            component.set("v.ReBidListAll",responseData);
            
        });
        $A.enqueueAction(action);
        
    },
    closePopup:function(component,event,helper){
        component.set("v.isModalOpen",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    
    calcGoalSeek : function(component,event,helper){
        component.set("v.expectCardDdeadnet", '');
        component.set("v.expectMajorDdeadnet", '');
        var bidRecord=component.get("v.bidRecordParent"); 
        let deadnetPrice=parseFloat(component.get("v.expectDdeadnet"));
        console.log('deadnetPrice--'+deadnetPrice);
        
        //let cvsDirDeadNet = parseFloat(component.get("v.singleRec.Phoenix_Customer_Dead_net__c"));
        let currCD = parseFloat(component.get("v.bidRecordParent.Phoenix_Current_CD__c"))/100;
        let serviceFee = parseFloat(component.get("v.bidRecordParent.Phoenix_Proposed_Value_Admin_Fee__c"))/100;
        
        let proposedCP = deadnetPrice / (1-currCD-serviceFee);
        let acqiCosst = proposedCP*(1-currCD-serviceFee);
        
        component.set("v.RequiredPrice",proposedCP);
        component.set("v.acQuiCost",acqiCosst);
    },
    calcCardDeadNetGoalSeek:  function(component,event,helper){
        component.set("v.expectDdeadnet", '');
        component.set("v.expectMajorDdeadnet", '');
        var bidRecord=component.get("v.bidRecordParent");  
        
        let cardDeadNetPrice=parseFloat(component.get("v.expectCardDdeadnet"));
        console.log('customer dead net--->'+cardDeadNetPrice);
        
        let currCD = parseFloat(bidRecord.Phoenix_Current_CD__c/100);
        console.log('currCD :: '+currCD);
        let additionalRebatePer = parseFloat(bidRecord.Phoenix_AdditionalRebateCardinalMajor__c != null ? bidRecord.Phoenix_AdditionalRebateCardinalMajor__c/100 : 0);//parseFloat(1/100);//
        console.log('additionalRebatePer :: '+additionalRebatePer);
        let wac = parseFloat(component.get("v.singleRec.Phoenix_WAC__c"));
        console.log('wac :: '+wac);
        let cardinalRebate = component.get("v.childRec.Phoenix_Preferred_Cardinal_Rebate_per__c") != null ? component.get("v.childRec.Phoenix_Preferred_Cardinal_Rebate_per__c") : 0;
        let cardRebatePercent = parseFloat(cardinalRebate/100);
        console.log('cardRebatePercent :: '+cardRebatePercent);
        let cashDisOnWac = parseFloat(component.get("v.singleRec.Phoenix_INDIRECT_CD__c"));
        let nlc = component.get("v.singleRec.Phoenix_NLC__c") != null ? component.get("v.singleRec.Phoenix_NLC__c") : 0;
        let bidFeeMasterFeeNLC = parseFloat(nlc);
        console.log('bidFeeMasterFeeNLC ::--> '+bidFeeMasterFeeNLC);
        let belowCalc = 1 - cardRebatePercent - additionalRebatePer ;
        console.log('belowCalc ::--> '+belowCalc);
        let aboveCalc = cardDeadNetPrice + (currCD*wac) + (bidFeeMasterFeeNLC);
        console.log('aboveCalc ::--> '+aboveCalc);
        //let proposedCp = (cardDeadNetPrice + (wac*currCD) + (wac*bidFeeMasterFeeNLC)) / (1 - cardRebatePercent - serviceFee); 
        let proposedCp = aboveCalc/belowCalc;
        console.log('proposedCp :: '+proposedCp);
        let acqiCosst = proposedCp * (1 - cardRebatePercent) - cashDisOnWac;
        
        component.set("v.RequiredPrice",proposedCp);
        component.set("v.acQuiCost",acqiCosst);
    },
    calcMajorDeadNetGoalSeek:  function(component,event,helper){
        component.set("v.expectDdeadnet", '');
        component.set("v.expectCardDdeadnet", '');
        var bidRecord=component.get("v.bidRecordParent");  
        
        let majorDeadNetPrice=parseFloat(component.get("v.expectMajorDdeadnet"));
        console.log('customer dead net--->'+majorDeadNetPrice);
        
        let currCD = parseFloat(bidRecord.Phoenix_Current_CD__c/100);
        console.log('currCD :: '+currCD);
        let additionalRebatePer = parseFloat(bidRecord.Phoenix_AdditionalRebateCardinalMajor__c != null ? bidRecord.Phoenix_AdditionalRebateCardinalMajor__c/100 : 0);//parseFloat(1/100);//
        console.log('additionalRebatePer :: '+additionalRebatePer);
        let wac = parseFloat(component.get("v.singleRec.Phoenix_WAC__c"));
        console.log('wac :: '+wac);
        let majorRebate = component.get("v.childRec.Phoenix_Major_Rebate_per__c") != null ? component.get("v.childRec.Phoenix_Major_Rebate_per__c") : 0;
        let majorRebatePercent = parseFloat(majorRebate/100);
        console.log('majorRebatePercent :: '+majorRebatePercent);
        let cashDisOnWac = parseFloat(component.get("v.singleRec.Phoenix_INDIRECT_CD__c"));
        //let currentRebate = component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c") != null ? component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c") : 0;
        //let bidFeeMasterFeeNLC = parseFloat(currentRebate/100);
        //console.log('bidFeeMasterFeeNLC ::--> '+bidFeeMasterFeeNLC);
        let belowCalc = 1 - majorRebatePercent - additionalRebatePer ;
        console.log('belowCalc ::--> '+belowCalc);  
        let aboveCalc = majorDeadNetPrice + (currCD*wac);//majorDeadNetPrice + (currCD + bidFeeMasterFeeNLC)*wac;
        console.log('aboveCalc ::--> '+aboveCalc);
        
        let proposedCp = aboveCalc/belowCalc;
        console.log('proposedCp :: '+proposedCp);
        let acqiCosst = proposedCp * (1 - majorRebatePercent) - cashDisOnWac;
        
        component.set("v.RequiredPrice",proposedCp);
        component.set("v.acQuiCost",acqiCosst);
    },
    
    onCISUChange : function(component,event,helper){   
        component.set("v.isSpinner",true);
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var currentValue, fieldName;
        var isGuidancePrice = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice'? true:false;
        var isMarketingPrice = event.getSource().get('v.class') == 'slds-input inputWidth MarketingPrice'? true:false;
        var isSalesPrice = event.getSource().get('v.class') == 'slds-input inputWidth SalesPrice'? true:false;
        console.log('nameofEditfield---'+nameofEditfield+'--isGuidancePrice--'+isGuidancePrice);
        
        if(nameofEditfield == 'rebateType'){
            currentValue = val;
            console.log('currentValue=======>'+currentValue)
            console.log('nameofEditfield=======>'+nameofEditfield)
            fieldName = nameofEditfield;
        }
        else if(nameofEditfield == 'feeType'){
            currentValue = val;
            fieldName = nameofEditfield;
        }
            else if(nameofEditfield == 'ContractApproval'){
                currentValue = val;
                fieldName = nameofEditfield;
            }
                else if(nameofEditfield == 'MarketApproval'){
                    currentValue = val;
                    fieldName = nameofEditfield;
                }
                    else if (nameofEditfield == 'EstmatedDays') {
                        currentValue = val;
                        fieldName = nameofEditfield;
                    }
                        else{
                            currentValue = 'No Change';
                            fieldName = '';
                        }
        helper.getCalculations(component,event,helper, currentValue, fieldName,isGuidancePrice,isMarketingPrice,isSalesPrice);
        
    },
    
    onChildInputChange : function(component,event,helper){
        component.set("v.isSpinner",true);
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var goalseek = component.get("v.isGoalseekModalOpen");
        var isMarketingPrice = event.getSource().get('v.class') == 'slds-input inputWidth MarketingPrice'? true:false;
        
        console.log("goalseek value--->"+goalseek);
        if( goalseek == true){
            var copyText= component.get("v.acQuiCost");
            console.log("required pirce-->"+copyText);
            component.set("v.childRec.Phoenix_PropMarktCvsCardinalAcquisitCost__c",copyText);
            component.set("v.isGoalseekModalOpen",false);
            var LineItemtable = component.get("v.tableRef");
            $A.util.addClass(LineItemtable, "maintable");
        }
        helper.updateChild(component,event,helper, val);
    },
    
    onCDSUChange : function(component,event,helper){
        if(event.getSource().get("v.value").trim() != ''){
            component.set("v.showSaveCancelBtn",true);
        }
    },
    closeMarketApprovalBox : function (component, event, helper) {
        component.set("v.MarketApprovalEditMode", false);
    },
    closeContractApprovalBox : function (component, event, helper) {
        component.set("v.ContractApprovalEditMode", false);
    },
    closeContractCommentslBox : function (component, event, helper) {
        component.set("v.ContractCommentsEditMode", false);
    },
    closeFeeTypeBox : function (component, event, helper) {
        component.set("v.feeTypeEdit", false);
        
    },
    closeRebateTypeBox : function (component, event, helper) {
        component.set("v.rebateTypeEdit", false);
    },
    onRatingChange : function(component,event,helper){
        component.set("v.showSaveCancelBtn",true);
    },    
    
    closeCISUBox : function (component, event, helper) {
        component.set("v.CISUEditMode", false);
        
    },
    closeCDSUBox: function (component, event, helper) {
        component.set("v.CDSUEditMode", false);
        
    },
    closePISUBox: function (component, event, helper) {
        component.set("v.PISUditMode", false);
        
    },
    closePDSUBox :  function (component, event, helper) {
        component.set("v.PDSUEditMode", false);
        
    },
    closeWDPIBox : function (component, event, helper) {       
        component.set("v.WDPIEditMode", false);        
    },
    closeGDPBox : function (component, event, helper) {       
        component.set("v.GDPEditMode", false);        
    },
    closePCBPSBox: function (component, event, helper) {       
        component.set("v.PCBPSEditMode", false);        
    },
    closePCVSIndCtcPrice: function (component, event, helper) {       
        component.set("v.PCVSIndCtcPriceEditMode", false);        
    },
    closePMkngCVSCardinalAcqunCosts: function (component, event, helper) {       
        component.set("v.PMkngCVSCardinalAcqunCostsEditMode", false);        
    },
    closeProposedCardinalSalesPrice: function (component, event, helper) {       
        component.set("v.ProposedCardinalSalesPriceEditMode", false);        
    },
    closeProposedMajorSalesPrice: function (component, event, helper) {       
        component.set("v.ProposedMajorSalesPriceEditMode", false);        
    },
    closeOverridecvsdirectUnits: function (component, event, helper) {       
        component.set("v.OverrideCVSDirectUnitsEditMode", false);        
    },
    closeOverridecvsindirectUnits: function (component, event, helper) {       
        component.set("v.OverrideCVSInDirectUnitsEditMode", false);        
    },
    closeOverridecardinalUnits: function (component, event, helper) {       
        component.set("v.OverrideCardinaltUnitsEditMode", false);        
    },
    closeOverrideMajorUnits: function (component, event, helper) {       
        component.set("v.OverrideMajorUnitsEditMode", false);        
    },
    closeProposedCVSDirectUnits: function (component, event, helper) {       
        component.set("v.ProposedCVSDirectUnitsEditMode", false);        
    },
    closeProposedCVSInDirectUnits: function (component, event, helper) {       
        component.set("v.ProposedCVSInDirectUnitsEditMode", false);        
    },
    closeProposedCardinalUnits: function (component, event, helper) {       
        component.set("v.ProposedCardinalUnitsEditMode", false);        
    },
    closeProposedMajorUnits: function (component, event, helper) {       
        component.set("v.ProposedMajorUnitsEditMode", false);        
    },
    closeOverrideUnits: function (component, event, helper) {       
        component.set("v.OverrideUnitsEditMode", false);        
    },
    closeOverrideDirectUnits:function (component, event, helper) {       
        component.set("v.OverrideDirEditMode", false);        
    },
    closeFAPCBox :function (component, event, helper) {       
        component.set("v.FAPCEditMode", false);        
    },
    closeProCurRebateBox: function (component, event, helper) {       
        component.set("v.PCREditMode", false);        
    },
    closePreferredMjrRebatePer: function (component, event, helper) {       
        component.set("v.PreferredMjrRebatePerEditMode", false);        
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
    closeSalesNotesBox:function (component, event, helper) {       
        component.set("v.SalesNotesEditMode", false);        
    },
    closeSCMNotesBox : function (component, event, helper) {
        component.set("v.SCMNotesEditMode", false);
    },
    closePriceNotesBox : function (component, event, helper) {
        component.set("v.PriNotesEditMode", false);
    },
    closeMarketNotesBox:  function (component, event, helper) {
        component.set("v.MarkNotesEditMode", false);
    },
    closePCBPBox : function (component, event, helper) {
        component.set("v.PCBPEditMode", false);
    },
    closeCSDF: function (component, event, helper) {
        component.set("v.ContSDFEditMode", false);
    },
    //----
    closeDirESIBox : function (component, event, helper) {
        component.set("v.DirectESIEditMode", false);
    },
    closeInDirESIUBox : function (component, event, helper) {
        component.set("v.IndirectESIEditMode", false);
    },
    closeDirectKrogerBox : function (component, event, helper) {
        component.set("v.DirectKrogerEditMode", false);
    },
    closeInDirectKrogerUBox : function (component, event, helper) {
        component.set("v.IndirectKrogerEditMode", false);
    },
    closeDirectRxOutReachUBox : function (component, event, helper) {
        component.set("v.DirectRxOutReachEditMode", false);
    },
    closeInDirectReachUBox : function (component, event, helper) {
        component.set("v.IndirectRxOutReachEditMode", false);
    },
    closeDirSuperValBox : function (component, event, helper) {
        component.set("v.DirectSuperValuEditMode", false);
    },closeInDirSuperVal : function (component, event, helper) {
        component.set("v.IndirectSuperValuEditMode", false);
    },
    closeDirectCigna : function (component, event, helper) {
        component.set("v.DirectCignaEditMode", false);
    },
    closeInDirectCigna : function (component, event, helper) {
        component.set("v.IndirectCignaEditMode", false);
    },
    closDirectCordant : function (component, event, helper) {
        component.set("v.DirectCordantEditMode", false);
    },
    closeInDirectCordant : function (component, event, helper) {
        component.set("v.IndirectCordantEditMode", false);
    },
    closeDirectAccordo : function (component, event, helper) {
        component.set("v.DirectAccordoEditMode", false);
    },
    closeInDirectAccordo : function (component, event, helper) {
        component.set("v.IndirectAccordoEditMode", false);
    },
    closeOthersDirect : function (component, event, helper) {
        component.set("v.OthersDirectEditMode", false);
    },
    closeOthersIndirect : function (component, event, helper) {
        component.set("v.OthersIndirectEditMode", false);
    },
    closeEstDaysBox: function (component, event, helper) {
        component.set("v.EstDaysEditMode", false);   
    },
    //----->
    deleteLineItem : function(component, event, helper){
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('rowIndex--->'+rowIndex);
        console.log('rowIndex-num-->'+component.get("v.sNo"));
        console.log('rowIndex--lenth->'+component.get("v.ItemsLength"));
        var action = component.get("c.deleteLineItems");
        action.setParams({
            'LineItemId' : rowIndex
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--->'+state);
            component.set("v.ItemsLength",component.get("v.ItemsLength")-1);
            
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send" );
        event.fire();
        
    },
    /*Product Positions logic Start*/
    inlineEditPositions: function (component, event, helper) {
        component.set("v.isPositionsModalOpen", true);
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
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.getPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.LinepositionsList", null);
            component.set("v.isSpinner",false);
        }
    },
    
    inlineEditCardinalPositions: function (component, event, helper) {
        component.set("v.isCardinalPositionsModalOpen", true);
        component.set("v.isSpinner",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set('v.LineCardinalpositionColumns', [
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
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.getCardinalPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.LineCardinalpositionsList", null);
            component.set("v.isSpinner",false);
        }
    },
    
    inlineEditMajorPositions: function (component, event, helper) {
        component.set("v.isMajorPositionsModalOpen", true);
        component.set("v.isSpinner",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set('v.LineMajorpositionColumns', [
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
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.getMajorPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.LineMajorpositionsList", null);
            component.set("v.isSpinner",false);
        }
    },
    
    closeCardinalPositionsPopup: function (component, event, helper) {
        component.set("v.isCardinalPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
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
    saveCardinalPositions: function (component, event, helper) {
        var selectPos = component.find('PosCardinallineLevelTable').getSelectedRows();
        var selectedPositions = []; //=component.get("v.LineselectedPosistions;
        for (var i = 0; i < selectPos.length; i++) {
            selectedPositions.push(selectPos[i].Name);
        }
        component.set("v.LineselectedCardinalPosistions", selectedPositions);
        console.log('selectedPositions--' + selectedPositions);
        component.set("v.childRec.Phoenix_Proposed_Cardinal_Position__c", selectedPositions.toString());
        helper.getCalculations(component, event, helper, 'No Change', '', false, false, false);
        component.set("v.isCardinalPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    saveMajorPositions: function (component, event, helper) {
        var selectPos = component.find('PosMajorlineLevelTable').getSelectedRows();
        var selectedPositions = []; //=component.get("v.LineselectedPosistions;
        for (var i = 0; i < selectPos.length; i++) {
            selectedPositions.push(selectPos[i].Name);
        }
        component.set("v.LineselectedMajorPosistions", selectedPositions);
        console.log('selectedPositions--' + selectedPositions);
        component.set("v.childRec.Phoenix_Proposed_Major_Position__c", selectedPositions.toString());
        helper.getCalculations(component, event, helper, 'No Change', '', false, false, false);
        component.set("v.isMajorPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    /*Product Positions logic End*/
    closeMajorPositionsPopup: function (component, event, helper) {
        component.set("v.isMajorPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    
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
    //--END
    // This method is for Future NPR--START
    displayFutureNPR :function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        var rowIndex = component.get("v.lineItemId");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.productId",component.get("v.singleRec.Phoenix_Product__r.Id"));
        component.set("v.bidLineItemId",rowIndex);
        component.set("v.displayFutureDisplay",true);
    }
    //--END
    
})