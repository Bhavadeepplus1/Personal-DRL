({    
    doInit: function(component, event, helper) {
        
        
        console.log('childdonint');
          /*Positions Logix*/
        var alreadySelctdPositions = component.get("v.singleRec.Phoenix_Proposed_Position__c");
        if (alreadySelctdPositions != null) {
            component.set("v.LineselectedPosistions", alreadySelctdPositions.split(','));
        }
        /*end Positions Logix*/
        if(component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") > 0 && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != null && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != '' && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != undefined){
            
            var wacPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2)+'%';
            var currentContractPrice = (component.get("v.singleRec.Phoenix_Current_Indirect_Price__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2)+'%';
        }
        else{
            wacPercent = 'NA'; 
            currentContractPrice = 'NA';
            
        }
        component.set("v.singleRec.wacPercent",wacPercent);
        component.set("v.singleRec.currentContractPrice",currentContractPrice);
        var netSalesInternal = component.get("v.singleRec.Phoenix_Net_Sales_Internal__c");
        if(netSalesInternal != null){
         	const formattedNetSalesInternal = netSalesInternal.toLocaleString('en-US', { style: 'currency', currency: 'USD',  minimumFractionDigits: 0, maximumFractionDigits: 1 });
            component.set("v.singleRec.formattedNetSalesInternal", formattedNetSalesInternal);
        }
        component.set("v.EstimatedLeadTime",component.get("v.singleRec.Phoenix_Estimated_Lead_Time_Days__c"));
        console.log('approved person--'+component.get("v.isContractsApprovePerson"));
        console.log('aprovalstatus==='+component.get("v.BidAprrovalStatus")); 
        console.log('cnt--approvaer==='+component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name"));
        console.log('v.singleRec.Phoenix_Marketing_Final_Approval__c==='+component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
        //helper.fetchPickListVal(component, 'Phoenix_Initial_Order_Discount_Type__c', 'ratingPicklistOpts');
        var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
        var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
        var Deadnet = component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") : 0;
        Deadnet = (Math.round(Deadnet * 100) / 100).toFixed(2);
        component.set("v.Deadnet",Deadnet);
        var productDirector = component.get("v.singleRec.Phoenix_Product_Director__c");
        var delegatedUser = component.get("v.deligatedUserName");
        console.log("Deligation user-->"+delegatedUser);
        console.log("productDirector user-->"+productDirector);
        console.log('isBala--->'+productDirector+"-->"+component.get("v.deligatedUserName").includes(productDirector))
        if(productDirector != null && delegatedUser != null && delegatedUser.includes(productDirector) && component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c") == false){
           component.set("v.isdeligationApprover",true) 
            
        }
       
        if(latestEstimate > 0){
            var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < Deadnet ? true : false;
            var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < Deadnet ? true : false;
            component.set("v.isAccpetable",isAccpetable);
            component.set("v.isNotAccpetable",isNotAccpetable)
        }
        else if(BudgetedASP > 0){
            console.log('BudgetedASP-------->'+BudgetedASP)
            var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < Deadnet ? true : false;
            var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < Deadnet ? true : false;
            component.set("v.isAccpetable",isAccpetable);
            component.set("v.isNotAccpetable",isNotAccpetable)
        }else{
            console.log('else condition--->')
            component.set("v.isAccpetable",false);
            component.set("v.isNotAccpetable",false);
        }
        if(component.get("v.singleRec.Vision_Analysis_Volume__c") != null && component.get("v.singleRec.Vision_Analysis_Volume__c") != undefined)
            component.set("v.analysisVol",component.get("v.singleRec.Vision_Analysis_Volume__c").toLocaleString('en-US'));//for analysis
    },
    
    inlineEditCISUnit : function(component,event,helper){  
        component.set("v.CISUEditMode", true);
        setTimeout(function(){
            component.find("inputCISUId").focus();
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
    inlineEditOverrideUnits : function(component,event,helper){  
        component.set("v.OverrideUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverrideUnits").focus();
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
     inlineEditEstDays: function(component,event,helper){  
        component.set("v.EstDaysEditMode", true);
        setTimeout(function(){
            component.find("inputEstDaysId").focus();
        }, 100);
    },
    /*--- New Product Launch ---*/
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
    handleMouseHover: function(component, event, helper) {
        //var my = event.srcElement.id;
        //component.set("v.reId",my);
        
        //helper.loadlineItems(component, event, helper)
        //component.set("v.hoverRow", parseInt(event.target.dataset.index));
        console.log('----------togglehover----'+component.get("v.togglehover"));
        if(component.get("v.togglehover")==false){
            
            component.set("v.togglehover",true);
        }
        
    },
    handleMouseOut: function(component, event, helper) {
        //component.set("v.hoverRow",-1);
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
    openGoalseek :  function(component,event,helper){
        component.set("v.isGoalseekModalOpen",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    calcGoalSeek : function(component,event,helper){
        var bidRecord=component.get("v.bidRecordParent");        
        let deadnetPrice=parseFloat(component.get("v.expectDdeadnet"));        
        let cashDsicount=parseFloat(component.get("v.singleRec.Phoenix_Customer_Cash_Discount1__c"));
        cashDsicount = Number.isFinite(cashDsicount) ? cashDsicount : 0;
        console.log('cashDsicount--'+cashDsicount);
        let iodPerUnit;
        if(bidRecord.Phoenix_Initial_Order_Discount_Type__c=='Contract'){           
            iodPerUnit=parseFloat(bidRecord.Phoenix_Proposed_Initial_Order_Discount__c/100);//*bidRecord.Phoenix_Initial_Order_Discount_of_Days__c)/360);           
            iodPerUnit = (iodPerUnit === undefined || iodPerUnit == null) ? 0:iodPerUnit;
        }else{
            iodPerUnit= parseFloat(component.get("v.singleRec.Phoenix_IOD_Per_Unit_in__c"));
            iodPerUnit = (iodPerUnit === undefined || iodPerUnit == null) ? 0:iodPerUnit;
        }   
        let cmFeePerc=component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c");
        cmFeePerc = Number.isFinite(cmFeePerc) ? cmFeePerc : 0;
        if(cmFeePerc!=null){cmFeePerc=parseFloat(cmFeePerc/100);}           
        let adminfee = parseFloat(component.get("v.singleRec.Phoenix_Customer_Fee__c")/100); 
        adminfee = Number.isFinite(adminfee) ? adminfee : 0;
        let rebate=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);
        let currebate=parseFloat(component.get("v.singleRec.Phoenix_Current_Rebate__c")/100);
        currebate = Number.isFinite(currebate) ? currebate : 0;
		rebate = Number.isFinite(rebate) ? rebate : 0;
        rebate = rebate > 0 ? rebate :currebate;
        let rebateABC=parseFloat(component.get("v.singleRec.Phoenix_Customer_Rebates__c")/100);   
        rebateABC = Number.isFinite(rebateABC) ? rebateABC : 0;
         let gorupVipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Group_VIP__c")/100);
      
        gorupVipPerc = Number.isFinite(gorupVipPerc) ? gorupVipPerc : 0;
        let orderAnlFeePerc=parseFloat(component.get("v.singleRec.Phoenix_Customer_Order_Analytics_Fee__c")/100);  
        orderAnlFeePerc = Number.isFinite(orderAnlFeePerc) ? orderAnlFeePerc : 0;
       // let vipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100);
         let vipPerc=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Est_VIP__c")/100);
        vipPerc = Number.isFinite(vipPerc) ? vipPerc : 0;
        let loaclVIP=parseFloat(component.get("v.singleRec.Phoenix_Local_VIP_Per_Unit__c")/100);
        loaclVIP = Number.isFinite(loaclVIP) ? loaclVIP : 0;
        let otherloaclVIP=parseFloat(component.get("v.singleRec.Phoenix_Local_VIP__c")/100);
        otherloaclVIP = Number.isFinite(otherloaclVIP) ? otherloaclVIP : 0;
        let salesOutDays=bidRecord.Phoenix_Sales_Out_Promotion_of_Days__c;
        let salesOutPerc=bidRecord.Phoenix_Proposed_Sales_Out_Promotion__c;
        let salesperUnit=0;
        console.log("adminfee--->"+adminfee);
         console.log("rebate--->"+rebate);
         console.log("rebateABC--->"+rebateABC);
         console.log("gorupVipPerc--->"+gorupVipPerc);
         console.log("orderAnlFeePerc--->"+orderAnlFeePerc);
        console.log("loaclVIP--->"+loaclVIP);
        console.log("otherloaclVIP--->"+otherloaclVIP);
        if(salesOutPerc!=null && salesOutDays!=null){
            salesperUnit=parseFloat(((salesOutPerc/100)*salesOutDays)/360);
        }     
        let propadminfee=bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
        if(propadminfee!=null){propadminfee=parseFloat(propadminfee/100);}
        var templateType =component.get('v.templateType');
        let requiredPriceNumer;      
        let requiredPricedeNumer;
        console.log("propadminfee--->"+propadminfee);
        console.log("salesperUnit--->"+salesperUnit);
        console.log("vipPerc--->"+vipPerc);
        if(templateType == 'Walgreens'){
            if(bidRecord.Phoenix_Initial_Order_Discount_Type__c=='Contract'){
                requiredPriceNumer=deadnetPrice+cashDsicount;
                requiredPricedeNumer=(1-cmFeePerc-rebate-salesperUnit-gorupVipPerc-orderAnlFeePerc-vipPerc);//-iodPerUnit
                console.log("requiredPricedeNumer-->"+requiredPricedeNumer);
            }else{
                requiredPriceNumer=deadnetPrice+cashDsicount;//+iodPerUnit
                requiredPricedeNumer=(1-cmFeePerc-rebate-salesperUnit-gorupVipPerc-orderAnlFeePerc-vipPerc);
                console.log("requiredPricedeNumer-->"+requiredPricedeNumer);
            }
            console.log('requiredPricedeNumer--'+requiredPricedeNumer);
        }
        else{
            if(bidRecord.Phoenix_Initial_Order_Discount_Type__c=='Contract'){
                requiredPriceNumer=deadnetPrice+cashDsicount;               
                requiredPricedeNumer=(1-propadminfee-salesperUnit-rebate-gorupVipPerc-vipPerc);//-iodPerUnit
                console.log("requiredPricedeNumer-->"+requiredPricedeNumer);
              
            }else{
                requiredPriceNumer=deadnetPrice+cashDsicount;//+iodPerUnit                
                requiredPricedeNumer=(1-propadminfee- salesperUnit- rebate-gorupVipPerc-vipPerc);
                console.log("requiredPricedeNumer-->"+requiredPricedeNumer);
            }
            console.log('requiredPricedeNumer--'+requiredPricedeNumer);
        }
        console.log('requiredPriceNumer--'+requiredPriceNumer);
        component.set("v.RequiredPrice",requiredPriceNumer/requiredPricedeNumer);
		component.set("v.expectCustmerDdeadnet",null);   
        var copyText = component.get("v.RequiredPrice");
        console.log("required pirce-->" + copyText);
        var WAC = component.get("v.singleRec.Phoenix_WAC__c");
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
    calcCustDeadNetGoalSeek:  function(component,event,helper){
        let deadnetPrice=parseFloat(component.get("v.expectCustmerDdeadnet"));
        console.log('customer dead net--->'+component.get("v.expectCustmerDdeadnet"))
        let cashDsicount=parseFloat(component.get("v.singleRec.Phoenix_Customer_Cash_Discount1__c"));
         cashDsicount= Number.isFinite(cashDsicount) ? cashDsicount : 0;
        console.log('cash discount--->'+component.get("v.singleRec.Phoenix_Customer_Cash_Discount1__c"))
        let iodPerUnit= parseFloat(component.get("v.singleRec.Phoenix_IOD_Per_Unit_in__c"));
        iodPerUnit= Number.isFinite(iodPerUnit) ? iodPerUnit : 0;
        let cmFeePerc=parseFloat(component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c")/100);
        cmFeePerc= Number.isFinite(cmFeePerc) ? cmFeePerc : 0;
        console.log('cmFeePerc--->'+cmFeePerc);
        let adminfee = parseFloat(component.get("v.singleRec.Phoenix_Customer_Fee__c")/100);
        adminfee= Number.isFinite(adminfee) ? adminfee : 0;
        console.log('cmFeePerc--->'+adminfee);
        let rebate=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);
        rebate= Number.isFinite(rebate) ? rebate : 0;
        //let rebateABC=parseFloat(component.get("v.singleRec.Phoenix_Customer_Rebates__c")/100);
        //console.log('rebateABC--->'+rebateABC);
        let gorupVipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Group_VIP__c")/100);
        gorupVipPerc= Number.isFinite(gorupVipPerc) ? gorupVipPerc : 0;
        let orderAnlFeePerc=parseFloat(component.get("v.singleRec.Phoenix_Customer_Order_Analytics_Fee__c")/100);
        orderAnlFeePerc= Number.isFinite(orderAnlFeePerc) ? orderAnlFeePerc : 0;
        //let vipPerc=parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100);
        let vipPerc=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Est_VIP__c")/100);
        vipPerc= Number.isFinite(vipPerc) ? vipPerc : 0;
        console.log('vipPerc--->'+vipPerc);
        let loaclVIP=parseFloat(component.get("v.singleRec.Phoenix_Local_VIP_Per_Unit__c")/100);
        loaclVIP= Number.isFinite(loaclVIP) ? loaclVIP : 0;
        let otherloaclVIP=parseFloat(component.get("v.singleRec.Phoenix_Local_VIP__c")/100);
        otherloaclVIP= Number.isFinite(otherloaclVIP) ? otherloaclVIP : 0;
        console.log('Other loaclVIP--->'+otherloaclVIP);
        var templateType =component.get('v.templateType')
        let requiredPriceNumer=(deadnetPrice+cashDsicount);
        console.log('requiredPriceNumer--->'+requiredPriceNumer);
        let requiredPricedeNumer;
        if(templateType == 'Walgreens'){
        requiredPricedeNumer=(1-cmFeePerc-vipPerc);
        console.log('requiredPricedeNumer next--->'+requiredPricedeNumer);
        }else{
         requiredPricedeNumer=(1-adminfee-otherloaclVIP);
        console.log('requiredPricedeNumer next--->'+requiredPricedeNumer);   
        }
        component.set("v.RequiredPrice",requiredPriceNumer/requiredPricedeNumer);
        component.set("v.expectDdeadnet",null);
          var WAC = component.get("v.singleRec.Phoenix_WAC__c");
        var proposedPriceMarketing = component.get("v.RequiredPrice");
        if (WAC !=0 && WAC != undefined && WAC < proposedPriceMarketing) {
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
    onCISUChange : function(component,event,helper){
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var currentValue, fieldName;
        var isGuidancePrice = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice'? true:false;
        var isMarketingPrice = event.getSource().get('v.class') == 'slds-input inputWidth MarketingPrice'? true:false;
        var isSalesPrice = event.getSource().get('v.class') == 'slds-input inputWidth SalesPrice'? true:false;
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
         var goalseek = component.get("v.isGoalseekModalOpen");
        console.log("goalseek value--->" + goalseek);
        if (goalseek == true) {
            console.log("testing by satya")
            var copyText = component.get("v.RequiredPrice");
            console.log("required pirce-->" + copyText);
            component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c", copyText);
        }
        component.set("v.isGoalseekModalOpen", false);
        helper.getCalculations(component,event,helper, currentValue, fieldName,isGuidancePrice,isMarketingPrice,isSalesPrice);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        //component.set("v.showSaveCancelBtn",true);
        //
        
        
        //helper.getCalculations(component,event,helper);
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
    closeOverrideUnits: function (component, event, helper) {       
        component.set("v.OverrideUnitsEditMode", false);        
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
    closeFAPCBox :function (component, event, helper) {       
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
     closeELTDBox: function (component, event, helper) {       
        component.set("v.ELTDEditMode", false);        
    },
    closeEstDaysBox: function (component, event, helper) {
        component.set("v.EstDaysEditMode", false);   
    }, 
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
                var rowIndex = component.get("v.lineItemId");

        
        $A.util.removeClass(LineItemtable, "maintable");
       // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId",rowIndex);
        component.set("v.displayBidHist",true);
        
    },
    
    //--END
    
    // This method is to collect the Prod NPR Histroy--START
    
    displayProdNPRHist:function (component, event, helper) {
       var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---'+LineItemtable);
                var rowIndex = component.get("v.lineItemId");

        
        $A.util.removeClass(LineItemtable, "maintable");
       // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId",rowIndex);
        component.set("v.displayProdNPRHist",true);
        
    },
    
    //--END
   
   // This method is to collect IMS Market Share--START
    
    displayIMSMarketShare:function (component, event, helper) {
         var LineItemtable = component.get("v.tableRef");
        console.log('modalstart---'+LineItemtable);
                var rowIndex = component.get("v.lineItemId");

        
        $A.util.removeClass(LineItemtable, "maintable");
       // var rowIndex = event.getSource().get("v.name");
        component.set("v.bidLineItemId",rowIndex);
        component.set("v.displayIMS",true);
        
    },
    
    //--END
    
     // This method is to collect IMS Market Share--START
    
    displayHistoricalPricing:function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
/*
        $A.util.removeClass(LineItemtable, "maintable");
        var selectedRec = event.getSource().get("v.name");
        component.set("v.bidLineItemId",selectedRec);
        component.set("v.displayHistPricing",true); */
         var rowIndex = component.get("v.lineItemId");
            $A.util.removeClass(LineItemtable, "maintable");
            component.set("v.bidLineItemId",rowIndex);
            component.set("v.displayHistPricing",true);
        
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
        helper.getCalculations(component, event, helper, 'No Change', '', false, false, false);
        component.set("v.isPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
     displayFutureRecords: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        var rowIndex = component.get("v.lineItemId");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayFutureDisplay", true);
    },
    /*Product Positions logic End*/
    
    openBidSimulator : function (component, event, helper){
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showBidSimulator",true);
    },
    closeBidSim : function (component, event, helper){
        component.set("v.showBidSimulator",false);
    },
    
    updateLineItemWithSimVal : function(component, event, helper){
        var marketingItems = event.getParam("marketingItems"); 
        console.log('marketingItems --> '+JSON.stringify(marketingItems));
        if(marketingItems.sNumber == component.get("v.sNo")){
            component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c", marketingItems.proposedVal);
            component.set("v.showBidSimulator",false);
            helper.getCalculations(component,event,helper, marketingItems.proposedVal, 'MarketingPrice',false,true,false);
            var LineItemtable = component.get("v.tableRef");
            $A.util.addClass(LineItemtable, "maintable");
        }
    }
    
})