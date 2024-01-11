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
        
        console.log('childdonint');
        console.log('approved person--' + component.get("v.isContractsApprovePerson"));
        console.log('aprovalstatus===' + component.get("v.BidAprrovalStatus"));
        console.log('cnt--approvaer===' + component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name"));
        console.log('v.singleRec.Phoenix_Marketing_Final_Approval__c===' + component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
        var productDirector = component.get("v.singleRec.Phoenix_Product_Director__c");
        var delegatedUser = component.get("v.deligatedUserName");
        console.log('isBala--->'+productDirector+"-->"+component.get("v.deligatedUserName").includes(productDirector))
        if(productDirector != null && delegatedUser != null && delegatedUser.includes(productDirector) && component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c") == false){
           component.set("v.isdeligationApprover",true) 
        }
        var wacPercent;
        var currentContractPrice;
        if(component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") > 0 && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != null && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != '' && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != undefined){
      /*  if(component.get("v.templateType") == 'Humana Indirect CII'){
            currentContractPrice = (component.get("v.singleRec.Phoenix_Current_Direct_Price__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2) + '%';
                  wacPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2) + '%';
  }
            else{*/
                    currentContractPrice = (component.get("v.singleRec.Phoenix_Current_Indirect_Price__c")/component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")*100).toFixed(2) + '%';        
                      wacPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")*100).toFixed(2) + '%';
 // }
        }
        else{
            wacPercent = 'NA'; 
            currentContractPrice = 'NA';
        }
        component.set("v.singleRec.wacPercent",wacPercent);
        component.set("v.singleRec.currentContractPrice",currentContractPrice);
        //helper.fetchPickListVal(component, 'Phoenix_Initial_Order_Discount_Type__c', 'ratingPicklistOpts');
        var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
        var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
        var Deadnet = component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") : 0;
        var DirectDeadNet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
        var IndirectDeadNet = component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") : 0;
        IndirectDeadNet = (Math.round(IndirectDeadNet * 100) / 100).toFixed(2);
        DirectDeadNet = (Math.round(DirectDeadNet * 100) / 100).toFixed(2);
        Deadnet = (Math.round(Deadnet * 100) / 100).toFixed(2);
        if(component.get("v.templateType") == 'Direct and Indirect'){
            Deadnet= DirectDeadNet;
        }
        //num = num.toFixed(2);
       // consoloe.log('number1-->'+num)
        component.set("v.Deadnet",Deadnet);
        if (latestEstimate > 0) {
            var isAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < Deadnet ? true : false;
            var isNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < Deadnet ? true : false;
            var isDirectAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < DirectDeadNet ? true : false;
            var isDirectNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < DirectDeadNet ? true : false;
            var isIndirectAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < IndirectDeadNet ? true : false;
            var isIndirectNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < IndirectDeadNet ? true : false;
            
            component.set("v.isAccpetable", isAccpetable);
            component.set("v.isNotAccpetable", isNotAccpetable);
            component.set("v.isDirectAccpetable", isDirectAccpetable);
            component.set("v.isDirectNotAccpetable", isDirectNotAccpetable);
            component.set("v.isIndirectAccpetable", isIndirectAccpetable);
            component.set("v.isIndirectNotAccpetable", isIndirectNotAccpetable);
        } else if (BudgetedASP > 0) {
            console.log('BudgetedASP-------->' + BudgetedASP)
            var isAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
            var isNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
            var isDirectAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
            var isDirectNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
            var isIndirectAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
            var isIndirectNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
            
            component.set("v.isAccpetable", isAccpetable);
            component.set("v.isNotAccpetable", isNotAccpetable);
            component.set("v.isDirectAccpetable", isDirectAccpetable);
            component.set("v.isDirectNotAccpetable", isDirectNotAccpetable);
            component.set("v.isIndirectAccpetable", isIndirectAccpetable);
            component.set("v.isIndirectNotAccpetable", isIndirectNotAccpetable);
        } else {
            console.log('else condition--->')
            component.set("v.isAccpetable", false);
            component.set("v.isNotAccpetable", false);
            component.set("v.isDirectAccpetable", false);
            component.set("v.isDirectNotAccpetable", false);
            component.set("v.isIndirectAccpetable", false);
            component.set("v.isIndirectNotAccpetable", false);
        }
    },
    
    inlineEditCISUnit: function (component, event, helper) {
        component.set("v.CISUEditMode", true);
        setTimeout(function () {
            component.find("inputCISUId").focus();
        }, 100);
    },
    inlineEditMarketingApproval: function (component, event, helper) {
        component.set("v.MarketApprovalEditMode", true);
        setTimeout(function () {
            component.find("inputMarketApprovalId").focus();
        }, 100);
    },
    inlineEditOvridePISUnit: function (component, event, helper) {
        component.set("v.PORISUditMode", true);
        setTimeout(function () {
            component.find("inputPORISUnitId").focus();
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
         inlineOpeningOrder: function (component, event, helper) {
        component.set("v.OpeningOrderEditMode", true);
        setTimeout(function () {
            component.find("OpeningOrderId").focus();
        }, 100);
    },
    inlineEditPORDSUnit: function (component, event, helper) {
        component.set("v.PORDSUEditMode", true);
        setTimeout(function () {
            component.find("inputPORDSUId").focus();
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
    /*--- New Product Launch ---*/
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
    inlineCurrentSupplier: function (component, event, helper) {
        component.set("v.CSUPEditMode", true);
        setTimeout(function () {
            component.find("inputCSUPId").focus();
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
    inlineContSDF: function (component, event, helper) {
        component.set("v.ContSDFEditMode", true);
        setTimeout(function () {
            component.find("CSDFId").focus();
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
       inlineEditCD: function (component, event, helper) {
        component.set("v.CDEditMode", true);
        setTimeout(function () {
            component.find("inputcdId").focus();
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
    inlineEditEstDays: function (component, event, helper) {
        component.set("v.EstDaysEditMode", true);
        setTimeout(function () {
            component.find("inputEstDaysId").focus();
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
        console.log('singleRec mkg====='+JSON.stringify(component.get("v.singleRec")));
        var singleRec = component.get("v.singleRec");
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        var rowIndex = component.get("v.lineItemId");
          $A.util.removeClass(LineItemtable, "maintable");
        if(singleRec.Latest_Line_Item__c != null && singleRec.Latest_Line_Item__c != '' && singleRec.Latest_Line_Item__c != undefined && singleRec.Latest_Line_Item__r.Phoenix_Bid__c != null){
            console.log('BidNameForPopup=====');
            component.set("v.BidNameForPopup",singleRec.Latest_Line_Item__r.Phoenix_Bid__r.Name);  
        }
       
        if(singleRec.Latest_Line_Item__c != null && singleRec.Latest_Line_Item__c !=null ){
            component.set("v.marketingPricePopUp", true); 
            
        }
        else{
            component.set("v.marketingPricePopUp", false); 
        }
        component.set("v.marketingPricePopUpVal", 'ValueExist');
        
      
        component.set("v.PCBPEditMode", true);
       
        setTimeout(function () {
            component.find("inputPCBPId").focus();
        }, 100);
        
    },
    
    onCISUChange: function (component, event, helper) {
        var nameofEditfield = event.getSource().get('v.name');
        var templateType = component.get("v.templateType");
        var val = event.getSource().get('v.value');
        console.log('singleRec mkg====='+JSON.stringify(component.get("v.singleRec")));
        var isGuidancePrice = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice' ? true : false;
        
        var currentValue, fieldName;
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
        }else if (nameofEditfield == 'EstmatedDays') {
            currentValue = val;
            fieldName = nameofEditfield;
        } else {
            currentValue = 'No Change';
            fieldName = '';
        }
        var goalseek = component.get("v.isGoalseekModalOpen");
        var goalseekIndirect = component.get("v.isIndirectGoalseekModalOpen");
        console.log("goalseek value--->" + goalseek);
        if (goalseek == true) {
           console.log("testing by satya")
            var copyText = component.get("v.RequiredPrice");
            console.log("required pirce iNDIRECT-->" + copyText);
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", copyText);
        }
        if (goalseekIndirect == true) {
            console.log("testing by satya")
            var copyText = component.get("v.RequiredindirectPrice");
            console.log("required pirce iNDIRECT-->" + copyText);
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", copyText);
        }
        component.set("v.isGoalseekModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        
        //var validTosave=helper.requiredValidation(component,event,helper);
        helper.getCalculations(component, event, helper, currentValue, fieldName, isGuidancePrice,templateType);
        //component.set("v.showSaveCancelBtn",true);
        //
        
        
        //helper.getCalculations(component,event,helper);
    },
    
    onCDSUChange: function (component, event, helper) {
        if (event.getSource().get("v.value").trim() != '') {
            component.set("v.showSaveCancelBtn", true);
        }
    },
    // This method is to collect the Bid Histroy--START
    
    displayBidHist: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        var rowIndex = component.get("v.lineItemId");
        
        
        $A.util.removeClass(LineItemtable, "maintable");
        // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayBidHist", true);
        
    },
    
    //--END
    
    // This method is to collect the Prod NPR Histroy--START
    
    displayProdNPRHist: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        var rowIndex = component.get("v.lineItemId");
        
        
        $A.util.removeClass(LineItemtable, "maintable");
        // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayProdNPRHist", true);
        
    },
    
    //--END
    
    // This method is to collect IMS Market Share--START
    
    displayIMSMarketShare: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        var rowIndex = component.get("v.lineItemId");
        
        
        $A.util.removeClass(LineItemtable, "maintable");
        // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayIMS", true);
        
    },
    
    //--END
    
    // This method is to collect IMS Market Share--START
    
    displayHistoricalPricing: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        var rowIndex = component.get("v.lineItemId");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayHistPricing", true);
        
    },
    displayFutureRecords: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        var rowIndex = component.get("v.lineItemId");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayFutureDisplay", true);
    },
    
    //--END
    
    /*-- Goalseek start -- */
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
    calcGoalSeek : function(component,event,helper){
        console.log('calc Goal seek called');
        var bidType = component.get("v.bidType");
        var bidRecord=component.get("v.bidRecordParent"); 
        var singlerec = component.get("v.singleRec");
        //console.log('bidRecord-->'+JSON.stringify(bidRecord))
        //console.log( 'single reci-->'+JSON.stringify(singlerec))
        var templateType = component.get("v.templateType");
        let deadnetPrice=parseFloat(component.get("v.expectDdeadnet"));        
        let perUnitReabates=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Per_Unit_Rebate__c"));
        let perUnitReabate= Number.isFinite(perUnitReabates) ? perUnitReabates : 0;
        let iodPerUnit;
       // let adminBasis = bidRecord.Phoenix_Proposed_Admin_Fee_Basis__c;
       let adminBasis = component.get("v.singleRec.Phoenix_Fee_G_N__c");
        let rebateBasis= component.get("v.singleRec.Phoenix_Rebate_G_N__c");
        let vipType = bidRecord.Phoenix_Value_Est_VIP_Type__c;
        console.log('adminBasis--->'+adminBasis)
        let WAC = parseFloat(component.get("v.singleRec.Phoenix_WAC1__c"));
        if(bidRecord.Phoenix_Initial_Order_Discount_Type__c=='Contract'){           
            iodPerUnit=parseFloat(bidRecord.Phoenix_Proposed_Initial_Order_Discount__c/100);//*bidRecord.Phoenix_Initial_Order_Discount_of_Days__c)/360);           
        }else{
            iodPerUnit= parseFloat(component.get("v.singleRec.Phoenix_IOD_Per_Unit_in__c"));
        }   
        let cmFeePerc=component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c");
        if(cmFeePerc!=null){cmFeePerc=parseFloat(cmFeePerc/100);}           
        let adminfee = parseFloat(component.get("v.singleRec.Phoenix_Current_Admin_Fee__c")/100);       
        let adminFeeAcc = parseFloat(component.get("v.singleRec.Phoenix_Current_Admin_Fee__c")/100);       
        let proposedrebate=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Admin_Fee__c")/100);
        let currentrebate=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);        
        
        let rebateABC=parseFloat(component.get("v.singleRec.Phoenix_Customer_Rebates__c")/100);        
        let gorupVipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Group_VIP__c")/100);      
        let orderAnlFeePerc=parseFloat(component.get("v.singleRec.Phoenix_Customer_Order_Analytics_Fee__c")/100);  
        let vipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100);
        let DirectCashTerns=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c")/100);
        let DirectCD=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Current_CD__c")/100);
        let RDCNLC = parseFloat(component.get("v.singleRec.Phoenix_RDC_NLC__c")/100);
        let IndirectCD = parseFloat(component.get("v.singleRec.Phoenix_Indirect_CD_Per__c")/100);
        let CMfee = parseFloat(component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c")/100);
        let otherloaclVIP=parseFloat(component.get("v.singleRec.Phoenix_Local_VIP__c")/100);
        let salesOutDays=bidRecord.Phoenix_Sales_Out_Promotion_of_Days__c;
        let salesOutPerc=bidRecord.Phoenix_Proposed_Sales_Out_Promotion__c;
        let REMSFee = (bidRecord.Phoenix_REMS_Program_Fee__c != null && bidRecord.Phoenix_REMS_Program_Fee__c != undefined && component.get("v.singleRec.Phoenix_OS_and_RAD_Date_Fee__c") > 0) ? (bidRecord.Phoenix_REMS_Program_Fee__c / 100): 0; 
        let salesperUnit=0;
        let prprebateperc = parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100); 
        let currentrebateperc = parseFloat(component.get("v.singleRec.Phoenix_Current_Rebate__c")/100);
        let finalRebate = Number.isFinite(prprebateperc) ? prprebateperc : Number.isFinite(currentrebateperc) ? currentrebateperc : 0;
        let finalVIP = Number.isFinite(vipPerc) ? vipPerc : 0;
        let finalCd = Number.isFinite(DirectCashTerns) ? DirectCashTerns : Number.isFinite(DirectCD) ? DirectCD : 0;
        let finalAdminFee = Number.isFinite(adminfee) ? adminfee : Number.isFinite(adminFeeAcc) ? adminFeeAcc : 0;
        let finalRDCNLC = Number.isFinite(RDCNLC) ? RDCNLC : 0;
        let finalIndirectCD = bidType == 'New Customer' ? (Number.isFinite(DirectCashTerns) ? DirectCashTerns:0) : Number.isFinite(IndirectCD) ? IndirectCD : 0;
        let finalCMfee = Number.isFinite(CMfee) ? CMfee : 0;
        console.log(' Template--->'+templateType);
        /*Added by satya for special HAndling charges*/
        let lineAllFee = component.get("v.singleRec.Controlled_Substance_Distribution_Co__c");
        console.log('lineAllFee-->'+lineAllFee)
        let consubPercCheck = bidRecord.Phoenix_Controlled_Substance__c;
        let reqcolStorgCheck = bidRecord.Phoenix_Required_Cold_Storage__c;
        let cntrlDistbnCheck = bidRecord.Phoenix_Controlled_Distribution__c;
        let consubPerc = consubPercCheck != null ? parseFloat(bidRecord.Phoenix_Controlled_Substance__c)/100 :0;
        console.log('consubPerc-->'+consubPerc)
        let reqcolStorg = reqcolStorgCheck != null ? parseFloat(bidRecord.Phoenix_Required_Cold_Storage__c)/100 : 0;
        let cntrlDistbn = cntrlDistbnCheck != null ? parseFloat(bidRecord.Phoenix_Controlled_Distribution__c)/100 :0;
        let isContSubst = component.get("v.singleRec.Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c");
        console.log('isControllledSubstance-->'+isContSubst);
        let isreqcoldStorage = component.get("v.singleRec.Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c");
        console.log('isreqcoldStorage-->'+isreqcoldStorage);
        let iscontrDistbtn = component.get("v.singleRec.Phoenix_Product__r.Phoenix_Limited_Distribution__c");
        //added by vandana
        let indirectCDDolor = component.get("v.singleRec.Phoenix_INDIRECT_CD__c");
        let indirectCDDollor = indirectCDDolor!= null ? indirectCDDolor:0;
        
        let allfeePerc;
        if(lineAllFee != 0 && lineAllFee != undefined && lineAllFee != null){
            if(isContSubst && !isreqcoldStorage){
                allfeePerc =  consubPercCheck != null ? parseFloat(bidRecord.Phoenix_Controlled_Substance__c)/100 : 0;
                console.log('ist if-->'+allfeePerc)
            }
           if(!isContSubst && isreqcoldStorage){
                allfeePerc =  reqcolStorgCheck != null ? parseFloat(bidRecord.Phoenix_Required_Cold_Storage__c)/100 : 0;
                console.log('2nd if-->'+allfeePerc)
            }
           if(isContSubst && isreqcoldStorage !=  0){
                let total  =  (consubPercCheck != null && reqcolStorgCheck != null) ? bidRecord.Phoenix_Controlled_Substance__c + bidRecord.Phoenix_Required_Cold_Storage__c : 0;
                allfeePerc = parseFloat(total/100);
                console.log('3r if-->'+allfeePerc)
            }
           if(iscontrDistbtn){
                allfeePerc = cntrlDistbnCheck != null ? parseFloat(bidRecord.Phoenix_Controlled_Distribution__c)/100 : 0;
                console.log('4th if-->'+allfeePerc)
            }
        }
        else{
          allfeePerc = 0 ;  
        }
        console.log('allfeePerc-->'+allfeePerc);
        /*End by satya*/
        
        //start by vandana
        if(templateType=='Humana Indirect retail'){
               console.log('calc Goal seek template called');
            if(indirectCDDollor!=null && finalCMfee!=null){
            let requirePrice = ((deadnetPrice+indirectCDDollor)/(1-finalCMfee));
            console.log('requirePrice'+requirePrice);
            console.log('deadnetPrice'+deadnetPrice);
            console.log('indirectCDDollor'+indirectCDDollor);
            component.set("v.RequiredPrice",requirePrice);
            }
        }
    // end.
        if(salesOutPerc!=null && salesOutDays!=null){
            salesperUnit=parseFloat(((salesOutPerc/100)*salesOutDays)/360);
        }     
        let propadminfee=bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
        if(propadminfee!=null){propadminfee=parseFloat(propadminfee/100);}
        let requiredPriceNumer;      
        let requiredPricedeNumer;
        
        
        component.set("v.expectCustmerDdeadnet",null);   
        var copyText = component.get("v.RequiredPrice");
       
        
        var proposedPriceMarketing = component.get("v.RequiredPrice");
        //if(templateType == 'Walgreens' || templateType == 'ABC Progen'){
        if (WAC != 0 && WAC != undefined && WAC < proposedPriceMarketing) {
            //onCISUChange(component, event,helper);
            component.set("v.errMsg", "Marketing Price can not be greater than WAC");
            component.set("v.err", true);
            component.set("v.ShowSaveButton", false);
        } else {
            component.set("v.err", false);
            component.set("v.ShowSaveButton", true);
        }
    },
    openIndirectGoalseek: function(component,event,helper){
        component.set("v.isIndirectGoalseekModalOpen",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
     closeIndirectGoalseekPopup : function(component,event,helper){
        component.set("v.isIndirectGoalseekModalOpen",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    calcIndirectGoalSeek : function(component,event,helper){
        var bidRecord=component.get("v.bidRecordParent"); 
        var templateType = component.get("v.templateType");
        let deadnetPrice=parseFloat(component.get("v.expectIndirectDdeadnet"));        
        let perUnitReabate=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Per_Unit_Rebate__c"));
        let iodPerUnit;
       // let adminBasis = bidRecord.Phoenix_Proposed_Admin_Fee_Basis__c;
       let adminBasis = component.get("v.singleRec.Phoenix_Fee_G_N__c");
        let rebateBasis= component.get("v.singleRec.Phoenix_Rebate_G_N__c");
        let vipType = bidRecord.Phoenix_Value_Est_VIP_Type__c;
        let WAC = parseFloat(component.get("v.singleRec.Phoenix_WAC1__c"));
        if(bidRecord.Phoenix_Initial_Order_Discount_Type__c=='Contract'){           
            iodPerUnit=parseFloat(bidRecord.Phoenix_Proposed_Initial_Order_Discount__c/100);//*bidRecord.Phoenix_Initial_Order_Discount_of_Days__c)/360);           
        }else{
            iodPerUnit= parseFloat(component.get("v.singleRec.Phoenix_IOD_Per_Unit_in__c"));
        }   
        let cmFeePerc=component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c");
        if(cmFeePerc!=null){cmFeePerc=parseFloat(cmFeePerc/100);}           
        let adminfee = parseFloat(component.get("v.singleRec.Phoenix_Current_Admin_Fee__c")/100);       
        let adminFeeAcc = parseFloat(component.get("v.singleRec.Phoenix_Current_Admin_Fee__c")/100);       
        let proposedrebate=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Admin_Fee__c")/100);
        let currentrebate=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);        
        
        let rebateABC=parseFloat(component.get("v.singleRec.Phoenix_Customer_Rebates__c")/100);        
        let gorupVipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Group_VIP__c")/100);      
        let orderAnlFeePerc=parseFloat(component.get("v.singleRec.Phoenix_Customer_Order_Analytics_Fee__c")/100);  
        let vipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100);
        let DirectCashTerns=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c")/100);
        let DirectCD=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Current_CD__c")/100);
        let RDCNLC = parseFloat(component.get("v.singleRec.Phoenix_RDC_NLC__c")/100);
        let IndirectCD = parseFloat(component.get("v.singleRec.Phoenix_Indirect_CD_Per__c")/100);
        let CMfee = parseFloat(component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c")/100);
        let otherloaclVIP=parseFloat(component.get("v.singleRec.Phoenix_Local_VIP__c")/100);
        let salesOutDays=bidRecord.Phoenix_Sales_Out_Promotion_of_Days__c;
        let salesOutPerc=bidRecord.Phoenix_Proposed_Sales_Out_Promotion__c;
        let salesperUnit=0;
        
        let finalRebate = Number.isFinite(proposedrebate) ? proposedrebate : Number.isFinite(currentrebate) ? currentrebate : 0;
        let finalVIP = Number.isFinite(vipPerc) ? vipPerc : 0;
        let finalCd = Number.isFinite(DirectCashTerns) ? DirectCashTerns : Number.isFinite(DirectCD) ? DirectCD : 0;
        let finalAdminFee = Number.isFinite(adminfee) ? adminfee : Number.isFinite(adminFeeAcc) ? adminFeeAcc : 0;
        let finalRDCNLC = Number.isFinite(RDCNLC) ? RDCNLC : 0;
        let finalIndirectCD = Number.isFinite(IndirectCD) ? IndirectCD : 0;
        let finalCMfee = Number.isFinite(CMfee) ? CMfee : 0;
        console.log(' Template--->'+templateType);
      
            if(adminBasis=='Gross' && rebateBasis=='Gross'){
                let requirePrice = ((deadnetPrice+finalRebate+(finalIndirectCD*WAC)+(WAC*finalRDCNLC))/(1-finalVIP-finalAdminFee-finalCMfee));
                component.set("v.RequiredIndirectPrice",requirePrice);
            }
            else if(adminBasis=='Net' && rebateBasis=='Net'){
                
                //let requirePrice = (((deadnetPrice)+(finalRebate*perUnitReabate+perUnitReabate*finalAdminFee)-(perUnitReabate-(perUnitReabate*finalAdminFee)-(finalAdminFee*finalRebate)))/(1-(finalRebate+finalVIP+finalCd+finalAdminFee)));
                 let requirePrice = ((deadnetPrice+(perUnitReabate-((perUnitReabate*finalAdminFee)+(perUnitReabate*finalRebate))))/(1-(finalRebate+finalVIP+finalCd+finalAdminFee)));

                console.log('perUnitReabate--->'+perUnitReabate);
                console.log('deadnetPrice--->'+deadnetPrice);
                console.log('finalRebate--->'+finalRebate);
                console.log('finalAdminFee--->'+finalAdminFee);
                console.log('finalVIP--->'+finalVIP);
                console.log('vipPerc-->'+vipPerc)
                console.log('finalCd--->'+DirectCD);
                component.set("v.RequiredIndirectPrice",requirePrice);
                
            }
            else if(adminBasis=='Gross' && rebateBasis=='Net'){
                   // let requirePrice = (((deadnetPrice)+(finalRebate*perUnitReabate+perUnitReabate*finalAdminFee)-(perUnitReabate-(finalAdminFee*finalRebate)))/(1-finalRebate-finalVIP-finalCd-finalAdminFee));
                   let requirePrice = (((deadnetPrice)+(perUnitReabate-(perUnitReabate*finalRebate)))/(1-(finalRebate+finalVIP+finalCd+finalAdminFee)));

                component.set("v.RequiredIndirectPrice",requirePrice);
            }
           else if(adminBasis=='Net' && rebateBasis=='Gross'){ 
                    //let requirePrice = (((deadnetPrice)+(finalRebate*perUnitReabate+perUnitReabate*finalAdminFee)-(perUnitReabate-(perUnitReabate*finalAdminFee)))/(1-finalRebate-finalVIP-finalCd-finalAdminFee));
                   let requirePrice = (((deadnetPrice)+(perUnitReabate-(perUnitReabate*finalAdminFee)))/(1-(finalRebate+finalVIP+finalCd+finalAdminFee)));
                    
               component.set("v.RequiredIndirectPrice",requirePrice);
                }        
            
      
        
       
        
       
        if(salesOutPerc!=null && salesOutDays!=null){
            salesperUnit=parseFloat(((salesOutPerc/100)*salesOutDays)/360);
        }     
        let propadminfee=bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
        if(propadminfee!=null){propadminfee=parseFloat(propadminfee/100);}
        let requiredPriceNumer;      
        let requiredPricedeNumer;
        
        
        component.set("v.expectCustmerDdeadnet",null);   
        var copyText = component.get("v.RequiredIndirectPrice");
       
        
        var proposedPriceMarketing = component.get("v.RequiredPrice");
        //if(templateType == 'Walgreens' || templateType == 'ABC Progen'){
        if (WAC != 0 && WAC != undefined && WAC < proposedPriceMarketing) {
            //onCISUChange(component, event,helper);
            component.set("v.errIndirectMsg", "Marketing Price can not be greater than WAC");
            component.set("v.errIndirect", true);
            component.set("v.ShowSaveButton", false);
        } else {
            component.set("v.errIndirect", false);
            component.set("v.ShowSaveButton", true);
        }
    },
    
    //Ended goalseak
    
    /*-- Rebid function --*/
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
     closeEstDaysBox: function (component, event, helper) {
        component.set("v.EstDaysEditMode", false);
        
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
    closeFAPCBox: function (component, event, helper) {
        component.set("v.FAPCEditMode", false);
    },
    closeProCurRebateBox: function (component, event, helper) {
        component.set("v.PCREditMode", false);
    },
    closePPURBox: function (component, event, helper) {
        component.set("v.PPUREditMode", false);
    },
    closeOpeningOrder: function (component, event, helper) {
        	component.set("v.OpeningOrderEditMode", false);
    	},
    	closeCURSUP: function (component, event, helper) {
        component.set("v.CSUPEditMode", false);
    },
    closeWac: function (component, event, helper) {
        component.set("v.WacEditMode", false);
    },
     closeBrandWac: function (component, event, helper) {
        component.set("v.CSPEditMode", false);
    },
    
    closePORISUBox: function (component, event, helper) {
        component.set("v.PORISUditMode", false);
    },
    closePORDSUBox: function (component, event, helper) {
        component.set("v.PORDSUEditMode", false);
    },
    closeBudgAspBox: function (component, event, helper) {
        component.set("v.BudASPEditMode", false);
    },
      closecdBox: function (component, event, helper) {
        component.set("v.CDEditMode", false);
    },
        closeOpeningOrder: function (component, event, helper) {
        component.set("v.OpeningOrderEditMode", false);
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
    closeMarketNotesBox: function (component, event, helper) {
        component.set("v.MarkNotesEditMode", false);
    },
    closePCBPBox: function (component, event, helper) {
        component.set("v.PCBPEditMode", false);
    },
    closeCSDF: function (component, event, helper) {
        component.set("v.ContSDFEditMode", false);
    },
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
    
    // This method is to collect the Bid Histroy--START
    
    displayBidHist: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        var rowIndex = component.get("v.lineItemId");
        
        
        $A.util.removeClass(LineItemtable, "maintable");
        // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayBidHist", true);
        
    },
    
    //--END
    
    // This method is to collect the Prod NPR Histroy--START
    
    displayProdNPRHist: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        var rowIndex = component.get("v.lineItemId");
        
        
        $A.util.removeClass(LineItemtable, "maintable");
        // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayProdNPRHist", true);
        
    },
    
    //--END
    
    // This method is to collect IMS Market Share--START
    
    displayIMSMarketShare: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---' + LineItemtable);
        var rowIndex = component.get("v.lineItemId");
        
        
        $A.util.removeClass(LineItemtable, "maintable");
        // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayIMS", true);
        
    },
    
    //--END
    
    // This method is to collect IMS Market Share--START
    
    displayHistoricalPricing: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        var rowIndex = component.get("v.lineItemId");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayHistPricing", true);
        
    },
    
    //--END
    
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
        helper.getCalculations(component, event, helper, 'No Change', '', false, component.get("v.templateType"));
        component.set("v.isPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    /*Product Positions logic End*/
     closeMktgPopup : function(component,event,helper){
        component.set("v.marketingPricePopUp",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
})