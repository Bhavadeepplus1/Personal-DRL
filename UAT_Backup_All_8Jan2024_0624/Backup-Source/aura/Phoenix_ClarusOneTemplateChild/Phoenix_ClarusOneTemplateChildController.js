({    
    doInit: function(component, event, helper) {
        
        console.log('childdonint');
        console.log('approved person--'+component.get("v.isContractsApprovePerson"));
        console.log('aprovalstatus==='+component.get("v.BidAprrovalStatus")); 
        console.log('cnt--approvaer==='+component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name"));
        console.log('v.singleRec.Phoenix_Marketing_Final_Approval__c==='+component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
        var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
        var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
        var WMTDirDeadnet = component.get("v.singleRec.Phoenix_WMT_Direct_Dead_Net_Proposed__c") != null ? component.get("v.singleRec.Phoenix_WMT_Direct_Dead_Net_Proposed__c") : 0;
        var WMTInDirDeadnet = component.get("v.singleRec.Phoenix_Current_Retail_Indirect_Price__c") != null ? component.get("v.singleRec.Phoenix_Current_Retail_Indirect_Price__c") : 0;
        var MckOSDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
        var productDirector = component.get("v.singleRec.Phoenix_Product_Director__c");
        var delegatedUser = component.get("v.deligatedUserName");
        WMTDirDeadnet = (Math.round(WMTDirDeadnet * 100) / 100).toFixed(2);
        WMTInDirDeadnet = (Math.round(WMTInDirDeadnet * 100) / 100).toFixed(2);
        MckOSDeadnet = (Math.round(MckOSDeadnet * 100) / 100).toFixed(2);
        component.set("v.WMTDirDeadnet",WMTDirDeadnet);
        component.set("v.WMTInDirDeadnet",WMTInDirDeadnet);
        component.set("v.MckOSDeadnet",MckOSDeadnet);
        console.log('isBala--->'+productDirector+"-->"+component.get("v.deligatedUserName").includes(productDirector));
        var wacOsRadPercent;
        var currentOsRadContractPrice;
        var wacdirectPercent;
        var currentdirectContractPrice;
        var wacIndirectPercent;
        var currentIndirectContractPrice;
        if(component.get("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c") > 0 && component.get("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c") != null && component.get("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c") != '' && component.get("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c") != undefined){
            
             wacOsRadPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c")*100).toFixed(2);
             currentOsRadContractPrice = (component.get("v.singleRec.Phoenix_OS_RAD_NCP__c")/component.get("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c")*100).toFixed(2);
        }
        else{
            wacOsRadPercent = 'NA'; 
            currentOsRadContractPrice = 'NA';
            
        }
           if(component.get("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c") > 0 && component.get("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c") != null && component.get("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c") != '' && component.get("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c") != undefined){
            
             wacdirectPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c")*100).toFixed(2);
             currentdirectContractPrice = (component.get("v.singleRec.Phoenix_WMT_Direct_NCP__c")/component.get("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c")*100).toFixed(2);
        }
        else{
            wacdirectPercent = 'NA'; 
            currentdirectContractPrice = 'NA';
            
        }
            if(component.get("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c") > 0 && component.get("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c") != null && component.get("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c") != '' && component.get("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c") != undefined){
            
             wacIndirectPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c")*100).toFixed(2);
             currentIndirectContractPrice = (component.get("v.singleRec.Phoenix_WMT_Indirect_NCP__c")/component.get("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c")*100).toFixed(2);
        }
        else{
            wacIndirectPercent = 'NA'; 
            currentIndirectContractPrice = 'NA';
            
        }
        
        component.set("v.singleRec.wacOsRadPercent",wacOsRadPercent);
        component.set("v.singleRec.currentOsRadContractPrice",currentOsRadContractPrice);
        component.set("v.singleRec.wacdirectPercent",wacdirectPercent);
        component.set("v.singleRec.currentdirectContractPrice",currentdirectContractPrice);
        component.set("v.singleRec.wacIndirectPercent",wacIndirectPercent);
        component.set("v.singleRec.currentIndirectContractPrice",currentIndirectContractPrice);
        
        if(productDirector != null && delegatedUser != null && delegatedUser.includes(productDirector) && component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c") == false){
           component.set("v.isdeligationApprover",true) 
        }
        if(latestEstimate > 0){
            var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < WMTDirDeadnet ? true : false;
            var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < WMTDirDeadnet ? true : false;
            var isAccpetable1= ((latestEstimate/100)*10 + latestEstimate) < WMTInDirDeadnet ? true : false;
            var isNotAccpetable1= (latestEstimate - (latestEstimate/100)*10) < WMTInDirDeadnet ? true : false;
            var isAccpetable2= ((latestEstimate/100)*10 + latestEstimate) < MckOSDeadnet ? true : false;
            var isNotAccpetable2= (latestEstimate - (latestEstimate/100)*10) < MckOSDeadnet ? true : false;
            component.set("v.isAccpetable",isAccpetable);
            component.set("v.isNotAccpetable",isNotAccpetable);
            component.set("v.isAccpetableWMTIndir",isAccpetable1);
            component.set("v.isNotAccpetableWMTIndir",isNotAccpetable1);
            component.set("v.isAccpetableMakOs",isAccpetable2);
            component.set("v.isNotAccpetableMakOs",isNotAccpetable2);
        }
        else if(BudgetedASP > 0){
            var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < WMTDirDeadnet ? true : false;
            var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < WMTDirDeadnet ? true : false;
            var isAccpetable1= ((BudgetedASP/100)*10 + BudgetedASP) < WMTInDirDeadnet ? true : false;
            var isNotAccpetable1= (BudgetedASP - (BudgetedASP/100)*10) < WMTInDirDeadnet ? true : false;
            var isAccpetable2= ((BudgetedASP/100)*10 + BudgetedASP) < MckOSDeadnet ? true : false;
            var isNotAccpetable2= (BudgetedASP - (BudgetedASP/100)*10) < MckOSDeadnet ? true : false;
            component.set("v.isAccpetable",isAccpetable);
            component.set("v.isNotAccpetable",isNotAccpetable);
            component.set("v.isAccpetableWMTIndir",isAccpetable1);
            component.set("v.isNotAccpetableWMTIndir",isNotAccpetable1);
            component.set("v.isAccpetableMakOs",isAccpetable2);
            component.set("v.isNotAccpetableMakOs",isNotAccpetable2);
        }else{
            console.log('else condition--->')
            component.set("v.isAccpetable",false);
            component.set("v.isNotAccpetable",false);
            component.set("v.isAccpetableWMTIndir",false);
            component.set("v.isNotAccpetableWMTIndir",false);
            component.set("v.isAccpetableMakOs",false);
            component.set("v.isNotAccpetableMakOs",false);
        }
        
        //helper.fetchPickListVal(component, 'Phoenix_Initial_Order_Discount_Type__c', 'ratingPicklistOpts');
        if(component.get("v.singleRec.Vision_CVS_Indirect_Analysis_Vol__c") != null && component.get("v.singleRec.Vision_CVS_Indirect_Analysis_Vol__c") != undefined)
            component.set("v.analysisCvsIndirVol",component.get("v.singleRec.Vision_CVS_Indirect_Analysis_Vol__c").toLocaleString('en-US'));//for analysis
        if(component.get("v.singleRec.Vision_Cardnial_Analysis_Vol__c") != null && component.get("v.singleRec.Vision_Cardnial_Analysis_Vol__c") != undefined)
            component.set("v.analysisCardinalVol",component.get("v.singleRec.Vision_Cardnial_Analysis_Vol__c").toLocaleString('en-US'));//for analysis
        if(component.get("v.singleRec.Vision_Major_Analysis_Vol__c") != null && component.get("v.singleRec.Vision_Major_Analysis_Vol__c") != undefined)
            component.set("v.analysisMajorVol",component.get("v.singleRec.Vision_Major_Analysis_Vol__c").toLocaleString('en-US'));//for analysis
    },
    
    inlineEditCISUnit : function(component,event,helper){  
        component.set("v.CISUEditMode", true);
        setTimeout(function(){
            component.find("inputCISUId").focus();
        }, 100);
    },
    inlineEditNewOptybid : function(component,event,helper){  
        component.set("v.NewOptybidEditMode", true);
        setTimeout(function(){
            component.find("NewOptybid").focus();
        }, 100);
    },
    inlineEditPropOSUnits: function(component,event,helper){  
        component.set("v.PropOSUnitsEditMode", true);
        setTimeout(function(){
            component.find("PropOSUnits").focus();
        }, 100);
    },
    inlineEditPropRADUnits: function(component,event,helper){  
        component.set("v.PropRADUnitsEditMode", true);
        setTimeout(function(){
            component.find("PropRADUnits").focus();
        }, 100);
    },
    inlineEditOverrideOSUnits: function(component,event,helper){  
        component.set("v.OverrideOSUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverrideOSUnits").focus();
        }, 100);
    },
    inlineEditPropWMTUnits: function(component,event,helper){  
        component.set("v.PropWMTUnitsEditMode", true);
        setTimeout(function(){
            component.find("PropWMTUnits").focus();
        }, 100);
    },
    inlineEditoverrideWMTUnits:function(component,event,helper){  
        component.set("v.overRideWMTUnitsEditMode", true);
        setTimeout(function(){
            component.find("overRideWMTUnits").focus();
        }, 100);
    },
    inlineEditoverRideRADUnits: function(component,event,helper){  
        component.set("v.overRideRADUnitsEditMode", true);
        setTimeout(function(){
            component.find("overRideRADUnits").focus();
        }, 100);
    },
    inlineEditPropWMTDirNCP:  function(component,event,helper){  
        component.set("v.PropWMTDirNCPEditMode", true);
        setTimeout(function(){
            component.find("PropWMTDirNCP").focus();
        }, 100);
    }, 
    inlineEditPropSalesMacRADNCP:  function(component,event,helper){  
        component.set("v.PropSalesMacRADNCPEditMode", true);
        setTimeout(function(){
            component.find("PropSalesMacRADNCP").focus();
        }, 100);
    },
   inlineEditPropSalesMacOSRADNCP:  function(component,event,helper){  
        component.set("v.PropSalesMacOSRADNCPEditMode", true);
        setTimeout(function(){
            component.find("PropSalesMacOSRADNCP").focus();
        }, 100);
    },
    inlineEditPropWMTIndirNCP:  function(component,event,helper){  
        component.set("v.PropWMTIndirNCPEditMode", true);
        setTimeout(function(){
            component.find("PropWMTIndirNCP").focus();
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
    inlineEditEstDays: function (component, event, helper) {
        component.set("v.EstDaysEditMode", true);
        setTimeout(function () {
            component.find("inputEstDaysId").focus();
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
    inlineContSDF: function (component, event, helper) {
        component.set("v.ContSDFEditMode", true);
        setTimeout(function () {
            component.find("CSDFId").focus();
        }, 100);
    },
    /*---- New Product Launch ---*/
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
    inlineWMTOpeningOrder: function (component, event, helper) {
        component.set("v.OpeningWMTOrderEditMode", true);
        setTimeout(function () {
            component.find("WMTOpeningOrderId").focus();
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
    inlineWMTCurrentSupplier: function (component, event, helper) {
        component.set("v.WMTCSUPEditMode", true);
        setTimeout(function () {
            component.find("inputWMTCSUPId").focus();
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
     closeGoalseekPopup : function(component,event,helper){
        component.set("v.isGoalseekModalOpen",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
     closeGoalseekPopup1 : function(component,event,helper){
        component.set("v.isGoalseekModalOpen1",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    openGoalseek :  function(component,event,helper){
        component.set("v.isGoalseekModalOpen",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    openGoalseek1 :  function(component,event,helper){
        component.set("v.isGoalseekModalOpen1",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    calcGoalSeek : function(component,event,helper){
        var bidRecord=component.get("v.bidRecordParent");  
       
        console.log('inital required price-->'+component.get("v.MckRequiredPrice"))
        let expectedMckRADDeadNet=parseFloat(component.get("v.expectDdeadnet"));        
        //let MckRADDeadNet=parseFloat(component.get("v.singleRec.Phoenix_Direct_Dead_Net__c"));
        let CashTerms = parseFloat(bidRecord.Phoenix_Customer__r.Phoenix_Cash_Discount__c)/100;
        CashTerms = Number.isFinite(CashTerms)?CashTerms:0;
        let rdccheck = component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c");
        let RDC = rdccheck != null ? parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c"))/100 : 0;
        RDC = Number.isFinite(RDC)?RDC:0;
        let WAC = parseFloat(component.get("v.singleRec.Phoenix_WAC__c"));
        let globalRebate = parseFloat(bidRecord.Phoenix_Mck_RAD_Rebate__c)/100;
        globalRebate = Number.isFinite(globalRebate)? globalRebate:0;
        let adminFee = parseFloat(bidRecord.Phoenix_Customer__r.Phoenix_Fee__c)/100;
        adminFee = Number.isFinite(adminFee) ? adminFee:0;
        let dataFeeCheck = bidRecord.Phoenix_Customer__r.Phoenix_ABS__c;
        let dataFee = dataFeeCheck != null ? parseFloat(bidRecord.Phoenix_Customer__r.Phoenix_ABS__c)/100 : 0;
        console.log('dataFee==>'+dataFee)
        let requireMackRaddPrice;
        //dataFee = Number.isInteger(dataFee) ? dataFee:0;
        //adminFee = Number.isInteger(adminFee) ? adminFee:0;
        //globalRebate = Number.isInteger(globalRebate) ? globalRebate:0;
        //RDC = Number.isInteger(RDC) ? RDC:0;
        console.log('expectedMckRADDeadNet-->'+expectedMckRADDeadNet)
        console.log('CashTerms-->'+CashTerms)
        console.log('RDC-->'+RDC)
        console.log('WAC-->'+WAC)
        console.log('globalRebate-->'+globalRebate)
        console.log('adminFee-->'+adminFee)
        console.log('dataFee-->'+Number.isInteger(dataFee))
        requireMackRaddPrice = ((expectedMckRADDeadNet + ((CashTerms+ RDC) *WAC)) / (1-globalRebate-adminFee-dataFee)); 
        console.log('requireMackRaddPrice-->'+(expectedMckRADDeadNet + ((CashTerms/100)) + ((RDC/100))*WAC))
        
        if(WAC != 0 && WAC != undefined && WAC<requireMackRaddPrice){
            //onCISUChange(component, event,helper);
            component.set("v.MckerrMsg","Mck and RAD Price can not be greater than WAC");
            component.set("v.Mckerr",true);
            component.set("v.ShowSaveButton",false);
        }
        else{
            component.set("v.Mckerr",false);
            component.set("v.ShowSaveButton",true);
        }
        
        component.set("v.MckRequiredPrice",requireMackRaddPrice);
        
        component.set("v.expectCustmerDdeadnet",null);
        component.set("v.RequiredPrice",null);
        component.set("v.err",false);
             
    },
    calcCustDeadNetGoalSeek:  function(component,event,helper){
        let expectedDirWMTDeadNet=parseFloat(component.get("v.expectCustmerDdeadnet"));
        var bidRecord=component.get("v.bidRecordParent");     
        let WAC = parseFloat(component.get("v.singleRec.Phoenix_WAC__c"));
        let CashTerms = parseFloat(bidRecord.Phoenix_Customer__r.Phoenix_Cash_Discount__c )/100;
        CashTerms = Number.isFinite(CashTerms) ? CashTerms:0;
        let globalRebate = parseFloat(bidRecord.Phoenix_WMT_Direct_Rebate__c)/100;
        globalRebate = Number.isFinite(globalRebate) ? globalRebate:0;
        let adminFee = parseFloat(bidRecord.Phoenix_Customer__r.Phoenix_Fee__c)/100;
        adminFee = Number.isFinite(adminFee) ?  adminFee:0;
        let requireWMTDirectPrice;
        requireWMTDirectPrice = (expectedDirWMTDeadNet  / (1-globalRebate-CashTerms-adminFee)); 
        if(WAC != 0 && WAC != undefined && WAC<requireWMTDirectPrice){
            component.set("v.errMsg","WMT Direct Price can not be greater than WAC");
            component.set("v.err",true);
            component.set("v.ShowSaveButton",false);
        }
        else{
            component.set("v.err",false);
            component.set("v.ShowSaveButton",true);
        }
        
        component.set("v.RequiredPrice",requireWMTDirectPrice);
        component.set("v.MckRequiredPrice",null);
        component.set("v.expectDdeadnet",null);
        component.set("v.Mckerr",false);
    },
    onCISUChange : function(component,event,helper){       
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var currentValue, fieldName;
        var isGuidancePrice = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice'? true:false;
        var isSalesMckPrice = event.getSource().get('v.class') == 'slds-input inputWidth MckSalesPrice'? true:false;
        var isWMTSalesPrice = event.getSource().get('v.class') == 'slds-input inputWidth SalesPrice'? true:false;
        var isWMTDirectPrice = event.getSource().get('v.class') == 'slds-input inputWidth WMTDirectPrice'? true:false;
        var isWMTindirectPrice = event.getSource().get('v.class') == 'slds-input inputWidth WMTIndirectPrice'? true:false;
        var isMacRADOSPrice = event.getSource().get('v.class') == 'slds-input inputWidth MckOSRadPrice'? true:false;
        console.log('nameofEditfield---'+nameofEditfield+'--isGuidancePrice--'+isGuidancePrice);
        if(nameofEditfield == 'OpportunityBidding'){
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
                }else if(nameofEditfield == 'EstmatedDays'){
                    currentValue = val;
                    fieldName = nameofEditfield;
                }
                    else{
                        currentValue = 'No Change';
                        fieldName = '';
                    }
        var goalseek = component.get("v.isGoalseekModalOpen");
        console.log("goalseek value--->"+goalseek);
        if( goalseek == true){
            var copyText=component.get("v.MckRequiredPrice");
            console.log("required pirce-->"+copyText);
            component.set("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c",copyText);
        }
        var goalseek1 = component.get("v.isGoalseekModalOpen1");
        console.log("goalseek value--->"+goalseek);
        var isGoalseekFired = false;
        if( goalseek1 == true){
            var copyText=component.get("v.RequiredPrice");
            var IndirectPrice = component.get("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c");	
            console.log("required pirce-->"+copyText);
            if(copyText>IndirectPrice){
                component.set("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c",null);
                isGoalseekFired = true;
            }else{
                component.set("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c",copyText);
            }
                
            
        }

        component.set("v.isGoalseekModalOpen",false);
        component.set("v.isGoalseekModalOpen1",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        
        
        helper.getCalculations(component,event,helper, currentValue, fieldName,isGuidancePrice,isSalesMckPrice,isWMTSalesPrice,isWMTDirectPrice,isWMTindirectPrice,isMacRADOSPrice,isGoalseekFired);

        //component.set("v.showSaveCancelBtn",true);
        //
        
        
        //helper.getCalculations(component,event,helper);
    },
    
    //Analytic component methods start
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
    closeEstDaysBox: function (component, event, helper) {
        component.set("v.EstDaysEditMode", false);
        
    },
    closeOverrideUnits: function (component, event, helper) {       
        component.set("v.OverrideUnitsEditMode", false);        
    },
    closeOverrideDirectUnits:function (component, event, helper) {       
        component.set("v.OverrideDirEditMode", false);        
    },
    closeNewOptybid :function (component, event, helper) {       
        component.set("v.NewOptybidEditMode", false);        
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
    closeOpeningOrder: function (component, event, helper) {
        component.set("v.ContSDFEditMode", false);
    },
    closeWMTOpeningOrder:function (component, event, helper) {
        component.set("v.OpeningWMTOrderEditMode", false);
    },
    closeCURSUP: function (component, event, helper) {
        component.set("v.CSUPEditMode", false);
    },
    closeWMTCURSUP: function (component, event, helper) {
        component.set("v.WMTCSUPEditMode", false);
    },
    closeWac: function (component, event, helper) {
        component.set("v.WacEditMode", false);
    },
     closeBrandWac: function (component, event, helper) {
        component.set("v.CSPEditMode", false);
    },
        
    closePropOSUnits : function (component, event, helper) {
        component.set("v.PropOSUnitsEditMode ", false);
    },
    closeOverrideOSUnits : function (component, event, helper) {
        component.set("v.OverrideOSUnitsEditMode ", false);
    },
    closePropRADUnits : function (component, event, helper) {
        component.set("v.PropRADUnitsEditMode", false);
    },
    closeoverRideRADUnits: function (component, event, helper) {
        component.set("v.overRideRADUnitsEditMode", false);
    },
    closePropWMTUnits : function (component, event, helper) {
        component.set("v.PropWMTUnitsEditMode", false);
    },
    closeoverRideWMTUnits: function (component, event, helper) {
        component.set("v.overRideWMTUnitsEditMode", false);
    },
    closePropWMTDirNCP : function (component, event, helper) {
        component.set("v.PropWMTDirNCPEditMode", false);
    },
    closePropSalesMacRADNCP : function (component, event, helper) {
        component.set("v.PropSalesMacRADNCPEditMode", false);
    },
    closePropSalesMacOSRADNCP : function (component, event, helper) {
        component.set("v.PropSalesMacOSRADNCPEditMode", false);
    },
    closePropWMTIndirNCP : function (component, event, helper) {
        component.set("v.PropWMTIndirNCPEditMode", false);
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
     inlineEditPositions: function (component, event, helper) {
        component.set("v.isPositionsModalOpen", true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
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
     
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.getPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.LinepositionsList", null);
        }
    },
    inlineMCKEditPositions: function (component, event, helper) {
        component.set("v.MCKisPositionsModalOpen", true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        /*component.set("v.PositionsEditMode", true);
        setTimeout(function(){
            component.find("positions").focus();
        }, 100);*/
        component.set('v.MCKLinepositionColumns', [{
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
            helper.getMCKPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.MCKLinepositionsList", null);
        }
    },
    closePositionsPopup: function (component, event, helper) {
        component.set("v.isPositionsModalOpen", false);
        component.set("v.MCKisPositionsModalOpen", false);
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
    saveMCKPositions: function (component, event, helper) {
        var selectPos = component.find('MCKPoslineLevelTable').getSelectedRows();
        var selectedPositions = []; //=component.get("v.LineselectedPosistions;
        for (var i = 0; i < selectPos.length; i++) {
            selectedPositions.push(selectPos[i].Name);
        }
        component.set("v.LineselectedPosistions", selectedPositions);
        console.log('selectedPositions--' + selectedPositions);
        component.set("v.singleRec.Phoenix_Current_Position__c", selectedPositions.toString());
        helper.getCalculations(component, event, helper, 'No Change', '', false, false, false);
        component.set("v.MCKisPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    }
    /*Product Positions logic End*/
})