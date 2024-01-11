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
        var bidLine = component.get("v.singleRec");
        var bidRecord = component.get("v.bidRecordParent"); 
        console.log('bidRecord in child-->'+JSON.stringify(bidRecord));
        if(bidRecord != undefined && bidRecord != null)
        	component.set("v.latestVersion",bidRecord.Phoenix_OTC_Bid_Version__c)
        if(bidLine.Bid_Line_Item_Price_History__r != null && bidLine.Bid_Line_Item_Price_History__r != undefined){
            var lineItemPriceHistory = new Object();
            lineItemPriceHistory.Name = (bidRecord != undefined && bidRecord != null) ? bidRecord.Phoenix_OTC_Bid_Version__c:'';
            lineItemPriceHistory.Pheonix_DRL_Units__c = bidLine.Phoenix_Proposed_Direct_Selling_Unit__c;
            lineItemPriceHistory.Phoenix_Current_52wk__c = bidLine.Phoenix_Current_Retail_Direct_Units__c;
            lineItemPriceHistory.Phoenix_Brand_Retail_Price__c =bidLine.Phoenix_Current_Retail_Direct_Price__c;
            lineItemPriceHistory.Phoenix_Net_Sales__c = bidLine.Phoenix_Net_Sales_Internal__c;
            lineItemPriceHistory.Phoenix_Current_Monthly__c	=bidLine.Phoenix_12_Months_TotalSaleUnits__c;
            lineItemPriceHistory.Phoenix_Proposed_Share__c = bidLine.Phoenix_Date_Fee__c;
            lineItemPriceHistory.Phoenix_SB_Retail_Price__c = bidLine.Phoenix_Current_Retail_Indirect_Price__c;
            lineItemPriceHistory.Phoenix_Gross_Sales__c = bidLine.Phoenix_Net_Sales_External__c;
            lineItemPriceHistory.Phoenix_Current_Sell_Price__c =bidLine.Phoenix_Current_Direct_Price__c;
            lineItemPriceHistory.Phoenix_Proposed_52wk__c =bidLine.Phoenix_Proposed_Anda_Units__c;
            lineItemPriceHistory.Phoenix_Retail_Dollor__c = bidLine.Phoenix_Opening_Order_Net_sales__c;
            lineItemPriceHistory.Phoenix_Supply_Type__c = bidLine.Phoenix_Supply_Type__c;
            lineItemPriceHistory.Phoenix_Total_Units__c = bidLine.Phoenix_12_Months_IndirectSaleUnit__c;
            lineItemPriceHistory.Phoenix_Bid_Line_Item__c = bidLine.Id;
            lineItemPriceHistory.Phoenix_Sales_Price__c = bidLine.Phoenix_ProposedContract_Bid_Price_Sales__c;
            lineItemPriceHistory.Phoenix_Marketing_Price__c = bidLine.Phoenix_ProposedContractBidPriceMktng__c;
            lineItemPriceHistory.Phoenix_Proposed_Monthly__c = bidLine.Phoenix_Proposed_OS_Units__c;
            lineItemPriceHistory.Phoenix_Sell_Price_Change__c = bidLine.Phoenix_Reduc_in_NCP_McK_And_RAD__c;
            lineItemPriceHistory.Phoenix_Net_Price__c = bidLine.Phoenix_Internal_Dead_Net_Price__c;
            lineItemPriceHistory.Phoenix_Damages__c = bidLine.Phoenix_Reduction__c;
            lineItemPriceHistory.Phoenix_Damages_Dollor__c = bidLine.Phoenix_Current_Anda_CP_Price__c;
            lineItemPriceHistory.Phoenix_Direct_CD_Percent__c = bidLine.Phoenix_Cash_Terms__c;
            lineItemPriceHistory.Phoenix_Direct_CD_Dollor__c = bidLine.Phoenix_Cash_Terms_RxSS__c;
            lineItemPriceHistory.Phoenix_TPT_Dollor_per_pack__c = bidLine.Proposed_TPT_Direct__c;
            lineItemPriceHistory.Phoenix_TPT_per_pack__c = bidLine.Proposed_TPT_Per_Direct__c;
            lineItemPriceHistory.Phoenix_Total_TPT__c = bidLine.Phoenix_Th_Put_Margin__c;
            lineItemPriceHistory.Phoenix_Profit__c = bidLine.Phoenix_Current_Net_Indirect_Price__c;
            lineItemPriceHistory.Phoenix_Sell_Price_Per_Size__c = bidLine.Phoenix_Reduc_in_NCP_McK_And_RAD__c;
            lineItemPriceHistory.Phoenix_RM_Dollor__c = bidLine.Phoenix_Opening_Order_TPT__c;
            lineItemPriceHistory.Phoenix_RM_Percent__c = bidLine.Phoenix_Opening_Order_TPT_Per__c;
            lineItemPriceHistory.Phoenix_Sales_Notes__c = bidLine.Phoenix_Sales_Notes__c;
            lineItemPriceHistory.Phoenix_Customer_Approval__c = bidLine.Phoenix_Customer_Approval_OTC__c;
            lineItemPriceHistory.Phoenix_Customer_Comments__c = bidLine.Phoenix_Customer_Service_Comments__c;
            lineItemPriceHistory.Phoenix_Supply_Effective_Date__c = bidLine.Phoenix_Supply_Effective_Date__c;
            lineItemPriceHistory.Phoenix_Price_Effective_Date__c = bidLine.Phoenix_Price_Effective_Date__c;
           // lineItemPriceHistory.Created_Date__c = bidLine.Bid_Line_Item_Price_History__r[0].Created_Date__c;
            component.set("v.priceHistoryData",bidLine.Bid_Line_Item_Price_History__r);
            var priceHistoryList = component.get("v.priceHistoryData");
            priceHistoryList.unshift(lineItemPriceHistory);
           console.log('size-----'+priceHistoryList.length);
            //bidRecord.Phoenix_OTC_Bid_Version__c
            console.log('mkg price bidlineitem ==='+bidLine.Phoenix_ProposedContractBidPriceMktng__c);
            for(var i=0;i<(priceHistoryList.length-1);i++){
                var diff1;
                var diff2;
                if(component.get("v.latestVersion") == priceHistoryList[i].Name){
                    diff1 = bidLine.Phoenix_ProposedContractBidPriceMktng__c
                }
                else{
                    diff1 = priceHistoryList[i].Phoenix_Marketing_Price__c;
                 }
                if(component.get("v.latestVersion") == priceHistoryList[i+1].Name){
                    diff2 = bidLine.Phoenix_ProposedContractBidPriceMktng__c
                }
                else{
                    diff2 = priceHistoryList[i+1].Phoenix_Marketing_Price__c;
                 }
                console.log('latestVersion-----'+component.get("v.latestVersion"));
                console.log('name=='+priceHistoryList[i].Name);
                console.log('diff1=='+diff1);
                console.log('diff2=='+diff2);
                var DiffInSellPrice= diff2 - diff1;
                console.log('DiffInSellPrice----'+DiffInSellPrice);
               // var diffSellPrice = (priceHistoryList[i].Phoenix_Marketing_Price__c)/(priceHistoryList[i+1].Phoenix_Marketing_Price__c)
                    var currentPrice = (1-((priceHistoryList[i].Phoenix_Marketing_Price__c)/(priceHistoryList[i+1].Phoenix_Marketing_Price__c)))*100;    
                console.log('Name---->'+priceHistoryList[i].Name);
                //console.log('diffrence---->'+((priceHistoryList[i].Phoenix_Marketing_Price__c)/(priceHistoryList[i-1].Phoenix_Marketing_Price__c)));
                priceHistoryList[i].changePercent = currentPrice;
                 priceHistoryList[i].DiffInSellPrice = DiffInSellPrice;
                
            }
            component.set("v.priceHistoryData",priceHistoryList)
            
        }
        

        var productDirector = component.get("v.singleRec.Phoenix_Product_Director__c");
        var delegatedUser = component.get("v.deligatedUserName");
        console.log('isBala--->'+productDirector+"-->"+component.get("v.deligatedUserName").includes(productDirector))
        if(productDirector != null && delegatedUser != null && delegatedUser.includes(productDirector) && component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c") == false){
            component.set("v.isdeligationApprover",true) 
        }
        console.log('Phoenix_Current_Position__c===' + bidLine.Phoenix_Current_Position__c);
        if(bidLine.Phoenix_Current_Position__c != null && bidLine.Phoenix_Current_Position__c !=  undefined){
                    var positionList = bidLine.Phoenix_Current_Position__c.split(',');
        }
        var positions;
        if(positionList != null && positionList.length >0){
            positionList.forEach(function(str){
            if(str && str!='' && str!=' '){
                console.log('str====='+str);
               positions = positions != null?positions+','+Math.round(parseFloat(str)*100) +'%':Math.round(parseFloat(str)*100) +'%';
            }                      
        });  
        }
      
        console.log('Phoenix_Current_Position__c===' +positions);
component.set("v.singleRec.Phoenix_Current_Position__c",positions);
        console.log('cnt--approvaer===' + component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name"));
        console.log('v.singleRec.Phoenix_Marketing_Final_Approval__c===' +productDirector+ "-->" +component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
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
            console.log('else condition line first-->'+bidLine.Phoenix_Pkg_Size1__c)
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
            console.log('else if condition line-->'+bidLine.Phoenix_Pkg_Size1__c)
            component.set("v.isAccpetable", isAccpetable);
            component.set("v.isNotAccpetable", isNotAccpetable);
            component.set("v.isDirectAccpetable", isDirectAccpetable);
            component.set("v.isDirectNotAccpetable", isDirectNotAccpetable);
            component.set("v.isIndirectAccpetable", isIndirectAccpetable);
            component.set("v.isIndirectNotAccpetable", isIndirectNotAccpetable);
        } else {
            console.log('else condition line-->'+bidLine.Phoenix_Pkg_Size1__c)
            component.set("v.isAccpetable", false);
            component.set("v.isNotAccpetable", false);
            component.set("v.isDirectAccpetable", false);
            component.set("v.isDirectNotAccpetable", false);
            component.set("v.isIndirectAccpetable", false);
            component.set("v.isIndirectNotAccpetable", false);
        }
        console.log('isAccpetable--->'+component.get("v.isAccpetable"))
        console.log('isAccpetableNot--->'+component.get("v.isNotAccpetable"))
    },
    
    inlineEditCISUnit: function (component, event, helper) {
        component.set("v.CISUEditMode", true);
        setTimeout(function () {
            component.find("inputCISUId").focus();
        }, 100);
    },
    inlineEditProposedShare:function (component, event, helper) {
        component.set("v.PSEditMode", true);
        setTimeout(function () {
            component.find("inputPSId").focus();
        }, 100);
    },
    inlineEditMarketingApproval: function (component, event, helper) {
        component.set("v.MarketApprovalEditMode", true);
        setTimeout(function () {
            component.find("inputMarketApprovalId").focus();
        }, 100);
    },
    inlineEditMarketingLeadApproval: function (component, event, helper) {
        component.set("v.MarketLeadApprovalEditMode", true);
        setTimeout(function () {
            component.find("inputMarketLeadApprovalId").focus();
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
    inlineEditPORDSUnit: function (component, event, helper) {
        component.set("v.PORDSUEditMode", true);
        setTimeout(function () {
            component.find("inputPORDSUId").focus();
        }, 100);
    },
    
    inlineEditSupplyType: function (component, event, helper) {
        console.log('supplyTypeEditCalled')
        component.set("v.SupplyTypeEditMode", true);
        setTimeout(function () {
            component.find("inputSupplyType").focus();
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
    inlineRetailPrice: function (component, event, helper) {
        component.set("v.retailPriceEditMode", true);
        setTimeout(function () {
            component.find("retailPriceId").focus();
        }, 100);
    },
     editCashTerms: function (component, event, helper) {
        component.set("v.cdEditMode", true);
        setTimeout(function () {
            component.find("cashTermsId").focus();
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
    editVIP: function (component, event, helper) {
        component.set("v.vipEditMode", true);
        setTimeout(function () {
            component.find("vipId").focus();
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
    
     editSED: function(component,event,helper){  
      //  var showErrorClassSED = component.get('v.showErrorClassSED');
            component.set("v.SEDEditMode", true);
            setTimeout(function(){
                component.find("inputSEDId").focus();
            }, 100);
    },
    
    changeSEDDate: function(component,event,helper){ 
        component.set("v.SEDEditMode", false);
        var date = component.find("inputSEDId").get('v.value');
        console.warn("date is: ", date);
        var fValue = event.getSource().get("v.value");
        console.log('fValue changeSEDDate'+fValue);
        //var labelClass = component.find("inputSEDId").get("v.labelClass");
        //console.log('labelClass'+labelClass);
    },
    
    changePEDDate: function(component,event,helper){ 
        component.set("v.PEDEditMode", false);
        var fValue = event.getSource().get("v.value");
        console.log('fValue changePEDate'+fValue);
        var labelClass = component.find("inputPEDId").get("v.labelClass");
        console.log('labelClass'+labelClass);
    },
    
    editPED: function(component,event,helper){  
            component.set("v.PEDEditMode", true);
            setTimeout(function(){
                component.find("inputPEDId").focus();
            }, 100);
    },
  
    inlineEditSalesNotes: function (component, event, helper) {
        component.set("v.SalesNotesEditMode", true);
        setTimeout(function () {
            component.find("inputSalesNoteId").focus();
        }, 100);
    },
    editadminFee: function (component, event, helper) {
        component.set("v.adminFeeEditMode", true);
        setTimeout(function () {
            component.find("adminFeeId").focus();
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
    inlineEditDamage: function (component, event, helper) {
        component.set("v.damageEditMode", true);
        setTimeout(function () {
            component.find("inputDamageId").focus();
        }, 100);
    },
    
    inlineEditTPT :function (component, event, helper) {
        component.set("v.TPTEditMode", true);
        setTimeout(function () {
            component.find("inputTPT").focus();
        }, 100);
    },
    
    EditcustApproval  :function (component, event, helper) {
        component.set("v.custAppEditMode ", true);
        setTimeout(function () {
            component.find("inputCustApproval").focus();
        }, 100);
    },
    
    inlineEditCustComments   :function (component, event, helper) {
        component.set("v.custCommentsEditMode  ", true);
        setTimeout(function () {
            component.find("inputCustCommentsId").focus();
        }, 100);
    },
    
    
    inlineEditMarketingNotes: function (component, event, helper) {
        component.set("v.MarkNotesEditMode", true);
        setTimeout(function () {
            component.find("inputMarketNotesId").focus();
        }, 100);
    },
    inlineEditMarketingLeadNotes:function (component, event, helper) {
        component.set("v.MarkLeadNotesEditMode", true);
        setTimeout(function () {
            component.find("inputMarketLeadNotesId").focus();
        }, 100);
    },
    inlineEditPCBP: function (component, event, helper) {
        component.set("v.PCBPEditMode", true);
        setTimeout(function () {
            component.find("inputPCBPId").focus();
        }, 100);
    },
    
    onCISUChange: function (component, event, helper) {
        console.log('on CISU Change');
        component.set("v.SEDEditMode",false);
        component.set("v.PEDEditMode",false);
        var nameofEditfield = event.getSource().get('v.name');
        var templateType = component.get("v.templateType");
        var val = event.getSource().get('v.value');
        console.log('get date --->'+val)
        var isGuidancePrice = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice' ? true : false;
        var currentValue, fieldName;
        if (nameofEditfield == 'rebateType') {
            currentValue = val;
            console.log('currentValue=======>' + currentValue)
            console.log('nameofEditfield=======>' + nameofEditfield)
            fieldName = nameofEditfield;
        } 
        else if (nameofEditfield == 'feeType') {
            currentValue = val;
            fieldName = nameofEditfield;
        } 
        else if (nameofEditfield == 'supplyType') {
            currentValue = val;
            fieldName = nameofEditfield;
        }
        else if (nameofEditfield == 'custApproval') {
            currentValue = val;
            fieldName = nameofEditfield;
        }
      
        else if (nameofEditfield == 'MarketApproval') {
            currentValue = val;
            fieldName = nameofEditfield;
        }
        else if (nameofEditfield == 'MarketLeadApproval') {
            currentValue = val;
            fieldName = nameofEditfield;
        }
        else if (nameofEditfield == 'EstmatedDays') {
            currentValue = val;
            fieldName = nameofEditfield;
        } 
        else {
            currentValue = 'No Change';
            fieldName = '';
        }
        var goalseek = component.get("v.isGoalseekModalOpen");
        var goalseekIndirect = component.get("v.isIndirectGoalseekModalOpen");
        console.log("goalseek value--->" + goalseek);
        if (goalseek == true) {
            console.log("testing by satya")
            var copyText = component.get("v.RequiredPrice");
            console.log("required pirce-->" + copyText);
            component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c", copyText);
        }
        if (goalseekIndirect == true) {
            console.log("testing by satya")
            var copyText = component.get("v.RequiredindirectPrice");
            console.log("required pirce-->" + copyText);
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
        var bidType = component.get("v.bidType");
        var bidRecord=component.get("v.bidRecordParent"); 
        var singlerec = component.get("v.singleRec");
        //console.log('bidRecord-->'+JSON.stringify(bidRecord))
        console.log( 'single reci-->'+JSON.stringify(singlerec))
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
        let damagesPercent=parseFloat(component.get("v.singleRec.Phoenix_Reduction__c")/100);         
        let rebateABC=parseFloat(component.get("v.singleRec.Phoenix_Customer_Rebates__c")/100);        
        let gorupVipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Group_VIP__c")/100);      
        let orderAnlFeePerc=parseFloat(component.get("v.singleRec.Phoenix_Customer_Order_Analytics_Fee__c")/100);  
        let vipPerc=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Est_VIP__c")/100);
        let DirectCashTerns=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c")/100);
        let DirectCD=parseFloat(component.get("v.singleRec.Phoenix_Cash_Terms__c")/100);
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
        let finalRebate = (Number.isFinite(prprebateperc) && prprebateperc>0) ? prprebateperc : Number.isFinite(currentrebateperc) ? currentrebateperc : 0;
        let finalVIP = Number.isFinite(vipPerc) ? vipPerc : 0;
        let finalCd = Number.isFinite(DirectCD) ? DirectCD : 0;
        let finalDamage = Number.isFinite(damagesPercent) ? damagesPercent : 0;
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
        if(true){
            if(adminBasis=='Gross' && rebateBasis=='Gross'){
                let requirePrice = (((perUnitReabate+deadnetPrice))/(1-finalRebate-finalVIP-finalCd-finalAdminFee-finalDamage));
                component.set("v.RequiredPrice",requirePrice);
            }
            else if(adminBasis=='Net' && rebateBasis=='Net'){
                
                //let requirePrice = (((deadnetPrice)+(finalRebate*perUnitReabate+perUnitReabate*finalAdminFee)-(perUnitReabate-(perUnitReabate*finalAdminFee)-(finalAdminFee*finalRebate)))/(1-(finalRebate+finalVIP+finalCd+finalAdminFee)));
                //let requirePrice = ((deadnetPrice+(perUnitReabate-((perUnitReabate*finalAdminFee)+(finalVIP*perUnitReabate)+(perUnitReabate*finalRebate))))/(1-(finalRebate+finalVIP+finalCd+finalAdminFee+finalDamage)));
                let requirePrice =   (deadnetPrice-(perUnitReabate*(finalAdminFee+finalRebate-1)))/ (1-(finalRebate+finalVIP+finalCd+finalAdminFee+finalDamage));         //((deadnetPrice+(perUnitReabate-((perUnitReabate*finalAdminFee)+(finalVIP*perUnitReabate)+(perUnitReabate*finalRebate))))/));
                
                console.log('perUnitReabate--->'+perUnitReabate);
                console.log('deadnetPrice--->'+deadnetPrice);
                console.log('finalRebate--->'+finalRebate);
                console.log('finalAdminFee--->'+finalAdminFee);
                console.log('finalVIP--->'+finalVIP);
                console.log('vipPerc-->'+vipPerc)
                console.log('finalCd--->'+DirectCD);
                component.set("v.RequiredPrice",requirePrice);
                
            }
                else if(adminBasis=='Gross' && rebateBasis=='Net'){
                    let requirePrice =   (deadnetPrice-(perUnitReabate*(finalRebate-1)))/ (1-(finalRebate+finalVIP+finalCd+finalAdminFee+finalDamage));  
                    component.set("v.RequiredPrice",requirePrice);
                }
                    else if(adminBasis=='Net' && rebateBasis=='Gross'){ 
                        let requirePrice =   (deadnetPrice-(perUnitReabate*(finalAdminFee-1)))/ (1-(finalRebate+finalVIP+finalCd+finalAdminFee+finalDamage));      
                        
                        component.set("v.RequiredPrice",requirePrice);
                    } 
                        else if((rebateBasis== null || rebateBasis == 'undefined' || rebateBasis == undefined) && adminBasis=='Net'){ 
                            let requirePrice =   (deadnetPrice-(perUnitReabate*(finalAdminFee-1)))/ (1-(finalVIP+finalCd+finalAdminFee+finalDamage));      
                            component.set("v.RequiredPrice",requirePrice);
                        } 
                            else if((rebateBasis== null || rebateBasis == 'undefined' || rebateBasis == undefined) && adminBasis=='Gross'){ 
                                //let requirePrice = (((deadnetPrice)+(finalRebate*perUnitReabate+perUnitReabate*finalAdminFee)-(perUnitReabate-(perUnitReabate*finalAdminFee)))/(1-finalRebate-finalVIP-finalCd-finalAdminFee));
                                let requirePrice = (((deadnetPrice)+(perUnitReabate))/(1-(finalVIP+finalCd+finalAdminFee+finalDamage)));
                                
                                component.set("v.RequiredPrice",requirePrice);
                            }
                                else if((adminBasis== null || adminBasis == 'undefined' || adminBasis == undefined) && rebateBasis=='Net'){ 
                                    let requirePrice =   (deadnetPrice-(perUnitReabate*(finalRebate-1)))/ (1-(finalVIP+finalCd+finalRebate+finalDamage)); 
                                    component.set("v.RequiredPrice",requirePrice);
                                }
                                    else if((adminBasis== null || adminBasis == 'undefined' || adminBasis == undefined) && rebateBasis=='Gross'){ 
                                        let requirePrice =   (deadnetPrice-(perUnitReabate))/ (1-(finalVIP+finalCd+finalRebate+finalDamage)); 
                                        
                                        component.set("v.RequiredPrice",requirePrice);
                                    }
                                        else if((adminBasis== null || adminBasis == 'undefined' || adminBasis == undefined) && (rebateBasis== null || rebateBasis == 'undefined' || rebateBasis == undefined)){ 
                                            //let requirePrice = (((deadnetPrice)+(finalRebate*perUnitReabate+perUnitReabate*finalAdminFee)-(perUnitReabate-(perUnitReabate*finalAdminFee)))/(1-finalRebate-finalVIP-finalCd-finalAdminFee));
                                            let requirePrice = (((deadnetPrice)+(perUnitReabate))/(1-(finalVIP+finalCd+finalDamage)));
                                            
                                            component.set("v.RequiredPrice",requirePrice);
                                        }
        }
        
        
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
        component.set("v.err", false);
        component.set("v.ShowSaveButton", true);
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
    closeMarketLeadApprovalBox :function (component, event, helper) {
        component.set("v.MarketLeadApprovalEditMode", false);
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
    closeadminFee:function (component, event, helper) {
        component.set("v.adminFeeEditMode", false);
        
    },
    closeRebateTypeBox: function (component, event, helper) {
        component.set("v.rebateTypeEdit", false);
    },
    closePSBox: function (component, event, helper) {
        component.set("v.PSEditMode", false);
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
     closeTPTBox: function (component, event, helper) {
        component.set("v.TPTEditMode", false);
        
    },
    closeEstDaysBox: function (component, event, helper) {
        component.set("v.EstDaysEditMode", false);
        
    },
    closePISUBox: function (component, event, helper) {
        component.set("v.PISUditMode", false);
        
    },
    closeDamageBox: function (component, event, helper) {
        component.set("v.damageEditMode", false);
        
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
    closeCashTerms:function (component, event, helper) {
        component.set("v.cdEditMode", false);
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
    closeRetailPrice: function (component, event, helper) {
        component.set("v.retailPriceEditMode", false);
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
    
    closeSupplyType: function (component, event, helper) {
        console.log('SupplyTypeCalled');
        component.set("v.SupplyTypeEditMode", false);
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
    
    
    closeCustApp : function (component, event, helper) {
        component.set("v.custAppEditMode ", false);
    },
    closeCustCommentslBox    : function (component, event, helper) {
        component.set("v.custCommentsEditMode ", false);
    },
    
    
    
    closeMarketNotesBox: function (component, event, helper) {
        component.set("v.MarkNotesEditMode", false);
    },
    closeMarketLeadNotesBox:function (component, event, helper) {
        component.set("v.MarkLeadNotesEditMode", false);
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
    showHistoryMethod:function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showHistory",true);
        var priceHistoryData = component.get("v.priceHistoryData");
       
    },
    showTotalsMethod:function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showTotals",true);
    },
    toggle: function(component, event, helper) {
        var items = component.get("v.priceHistoryData"), index = event.getSource().get("v.value");
        console.log('index-->'+index)
        items[index].expanded = !items[index].expanded;
        component.set("v.priceHistoryData", items);
    },
    closeHistPopup: function (component, event, helper) {
        component.set("v.showHistory", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    closeTotalPopup: function (component, event, helper) {
        component.set("v.showTotals", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
      closeSED: function (component, event, helper) {
        component.set("v.SEDEditMode", false);
    },
     closePED: function (component, event, helper) {
        component.set("v.PEDEditMode", false);
    },
    closeVIP: function (component, event, helper) {
        component.set("v.vipEditMode", false);
    },
    currentVersion:function (component, event, helper) {
        console.log('currentVersion---')
        component.get("v.isCurrentVersion",true);
        var indexNum = event.getSource().get('v.name');
        var LineItemtable = component.find("currentData");
        var LineItemtable1 = component.find("previousData");
		var items = component.get("v.priceHistoryData");
        items[indexNum].isCurrentVersion = false;
        component.set("v.priceHistoryData", items);        
        if($A.util.isArray(LineItemtable)){
            $A.util.addClass(LineItemtable[indexNum], "toggle-button-active");
            $A.util.removeClass(LineItemtable1[indexNum], "toggle-button-active");
        }else{
            $A.util.addClass(LineItemtable, "toggle-button-active");
            $A.util.removeClass(LineItemtable1, "toggle-button-active");
        }
        
    },
    previousVersion:function (component, event, helper) {
        console.log('previousVersion---')
        component.get("v.isCurrentVersion",false);
        var indexNum = event.getSource().get('v.name');
        var LineItemtable = component.find("previousData");
        var LineItemtable1 = component.find("currentData");
        var items = component.get("v.priceHistoryData");
        items[indexNum].isCurrentVersion = true;
        component.set("v.priceHistoryData", items);
        if($A.util.isArray(LineItemtable)){
            $A.util.addClass(LineItemtable[indexNum], "toggle-button-active");
            $A.util.removeClass(LineItemtable1[indexNum], "toggle-button-active");
        }else{
             $A.util.addClass(LineItemtable, "toggle-button-active");
            $A.util.removeClass(LineItemtable1, "toggle-button-active");
        }
    },
    displayBidHist:function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---'+LineItemtable);
                var rowIndex = component.get("v.lineItemId");

        
        $A.util.removeClass(LineItemtable, "maintable");
       // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId",rowIndex);
        component.set("v.displayBidHist",true);
        
    },
    onChange: function (component, evt, helper) {
        var templateType = component.get("v.templateType");
        var LineItem = component.get("v.singleRec");
        var LineItemId = LineItem.Id;
        var bidType = component.get("v.bidType");
        var shareValue = component.find('inputPSId').get('v.value');
        console.log('templateType ------- '+templateType);
        console.log('LineItem ------- '+JSON.stringify(LineItem));
        console.log('LineItemId ------- '+LineItemId);
        console.log('bidType ------- '+bidType);
        console.log('select-----'+component.find('inputPSId').get('v.value'));
         var action = component.get("c.saveProposedShare");
            action.setParams({
                LineItemId: LineItemId,
                shareValue: shareValue
            });
        action.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS') {
                 console.log('share response--' + JSON.stringify(response.getReturnValue()));
                var response = response.getReturnValue();
                if(response.Id == LineItemId){
                  LineItem.Phoenix_Date_Fee__c = response.Phoenix_Date_Fee__c;
                    LineItem.Phoenix_Proposed_Direct_Selling_Unit__c = response.Phoenix_Proposed_Direct_Selling_Unit__c;
                }
                //component.set('v.PSEditMode',true);
                component.set("v.singleRec",LineItem);
            }
            
        });
        $A.enqueueAction(action);
        
        
    }
})