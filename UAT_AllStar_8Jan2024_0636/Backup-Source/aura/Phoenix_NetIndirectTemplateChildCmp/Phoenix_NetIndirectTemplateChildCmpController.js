({    
    doInit: function(component, event, helper) {
        var wacPercent;
        var currentContractPrice;
        var wholesalerPrice;
        var wholesalerwacPercent;
        if(component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") > 0 && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != null && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != '' && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != undefined){
            wacPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2) + '%';
            currentContractPrice = (component.get("v.singleRec.Phoenix_Current_Retail_Direct_Price__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2) + '%';
        } else{
            wacPercent = 'NA'; 
            currentContractPrice = 'NA';
          
        }
        if(component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") > 0 && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != null && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != '' && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != undefined){
            wholesalerwacPercent = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")*100).toFixed(2) + '%';
            
            wholesalerPrice = (component.get("v.singleRec.Phoenix_Current_Retail_Indirect_Price__c")/component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")*100).toFixed(2) + '%';
            
        }
        else{
          
            wholesalerPrice = 'NA';
            wholesalerwacPercent ='NA';
        }
        component.set("v.singleRec.wacPercent",wacPercent);
        component.set("v.singleRec.currentContractPrice",currentContractPrice);
        component.set("v.singleRec.wholesalerPrice",wholesalerPrice);
        component.set("v.singleRec.wholesalerwacPercent",wholesalerwacPercent);

        console.log('childdonint');
         /*Positions Logix*/
        var alreadySelctdPositions = component.get("v.singleRec.Phoenix_Proposed_Position__c");
        if (alreadySelctdPositions != null) {
            component.set("v.LineselectedPosistions", alreadySelctdPositions.split(','));
        }
        /*end Positions Logix*/
        console.log('approved person--'+component.get("v.isContractsApprovePerson"));
        console.log('aprovalstatus==='+component.get("v.BidAprrovalStatus")); 
        console.log('cnt--approvaer==='+component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name"));
        console.log('v.singleRec.Phoenix_Marketing_Final_Approval__c==='+component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
        var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
        var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
        var Deadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
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
        //helper.fetchPickListVal(component, 'Phoenix_Initial_Order_Discount_Type__c', 'ratingPicklistOpts');
    },
    
    inlineEditCISUnit : function(component,event,helper){  
        component.set("v.CISUEditMode", true);
        setTimeout(function(){
            component.find("inputCISUId").focus();
        }, 100);
    },
    inlineEditOverrideUnits : function(component,event,helper){  
        component.set("v.OverrideUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverrideUnits").focus();
        }, 100);
    },
    inlineEditOverrideDirectUnits : function(component,event,helper){  
        component.set("v.OverrideDirectUnitsEditMode", true);
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
    /* End New Product Launch*/
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
    openGoalseek :  function(component,event,helper){
        component.set("v.isGoalseekModalOpen",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    calcGoalSeek : function(component,event,helper){
        var bidRecord=component.get("v.bidRecordParent");
        let deadnetPrice=component.get("v.expectDdeadnet");
        let currentcashterms=bidRecord.Phoenix_Current_CD__c;
        //if(currentcashterms!=null){currentcashterms=parseFloat(currentcashterms/100);}
        currentcashterms = currentcashterms!=null ? parseFloat(currentcashterms/100) : 0;
        
        /* let vipperunit= parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100);
            console.log('VIP PER UNIT $--->'+vipperunit);
            console.log('CD PER UNIT $--->'+currentcashterms)
            let propadminfee=bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
            console.log('ADMIN FEE %'+propadminfee)
            if(propadminfee!=null){propadminfee=parseFloat(propadminfee/100);} 
            let proposedrebatepercentage=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);
           console.log(' proposedrebatepercentage-->'+proposedrebatepercentage);
            //oenix_Current_Rebate__c */
            let requiredPriceNumer=deadnetPrice;
            let requiredPricedeNumer=(1-currentcashterms);  
            //requiredPricedeNumer=1-(vipperunit-(currentcashterms+propadminfee)*vipperunit)-proposedrebatepercentage-currentcashterms-propadminfee;
            //console.log('requiredPricedeNumer next--->'+requiredPricedeNumer);
            component.set("v.RequiredPrice",requiredPriceNumer/requiredPricedeNumer);
            component.set("v.expectInddeadnet",null); 
            var copyText=component.get("v.RequiredPrice");
            console.log("required pirce-->"+copyText);
            var WAC = component.get("v.singleRec.Phoenix_WAC__c");
            var proposedPriceMarketing = component.get("v.RequiredPrice"); 
            if(WAC != 0 && WAC != undefined && WAC<proposedPriceMarketing){
                //onCISUChange(component, event,helper);
                component.set("v.errMsg","Proposed Price can not be greater than WAC");
                component.set("v.err",true);
                component.set("v.ShowSaveButton",false);
            }/*
        else if(component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")<proposedPriceMarketing){
                component.set("v.errMsg","Required Price can not be Less than Indirect Price");
                component.set("v.err",true);
                component.set("v.ShowSaveButton",false);
            }*/
            else{
                component.set("v.err",false);
                component.set("v.ShowSaveButton",true);
            }
            
        },
    
    
    calcIndDeadNetGoalSeek:  function(component,event,helper){
        var bidRecord=component.get("v.bidRecordParent");
        console.log('bidRecord--->'+bidRecord)
        let deadnetPrice=component.get("v.expectInddeadnet");
        /*console.log('deadnetPrice--->'+component.get("v.expectCustmerDdeadnet"))
            //t customerdeadnet=component.get("v.singleRec.Phoenix_Customer_Dead_net__c");
            
            let vipperunit= parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100);
            console.log('vipperunit--->'+vipperunit)
            let cdperunit=parseFloat(component.get("v.singleRec.Phoenix_Direct_CD_Per_Unit__c")/100);
             console.log('cdperunit--->'+cdperunit)
             //let currenadminfee= bidRecord.Phoenix_Current_Admin_Fee__c;
             //console.log('currenadminfee--->'+currenadminfee) */
            let currentcashterms=bidRecord.Phoenix_Current_CD__c;
            if(currentcashterms!=null){currentcashterms=parseFloat(currentcashterms/100);}
            /*console.log('currentcashterms--->'+currentcashterms)
              let propadminfee=bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
            console.log('propadminfee--->'+propadminfee)
            if(propadminfee!=null){propadminfee=parseFloat(propadminfee/100);} */
            let requiredPriceNumer=deadnetPrice;
            let requiredPricedeNumer = (1-currentcashterms);  
            /*  requiredPricedeNumer=1-(vipperunit-(currentcashterms+propadminfee)*vipperunit);
            console.log('requiredPricedeNumer next--->'+requiredPricedeNumer); */
            component.set("v.RequiredPrice",requiredPriceNumer/requiredPricedeNumer);
            console.log("valueee-->",requiredPriceNumer/requiredPricedeNumer)
            component.set("v.expectDdeadnet",null);
            
            var WAC = component.get("v.singleRec.Phoenix_WAC__c");
            var proposedPriceMarketing = component.get("v.RequiredPrice");
            if(WAC != 0 && WAC != undefined && WAC<proposedPriceMarketing){
                //onCISUChange(component, event,helper);
                component.set("v.errMsg","Proposed Price can not be greater than WAC");
                component.set("v.err",true);
                component.set("v.ShowSaveButton",false);
            }/*else if(component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")>proposedPriceMarketing){
                component.set("v.errMsg","Proposed Price can not be Less than Direct Price");
                component.set("v.err",true);
                component.set("v.ShowSaveButton",false);
            }*/
            else{
                component.set("v.err",false);
                component.set("v.ShowSaveButton",true);
                console.log("test price value--"+component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")	)
            }
        },
    
    onCISUChange : function(component,event,helper){       
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var currentValue, fieldName;
        var isGuidancePrice = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice'? true:false;
        var isMarketingPrice = event.getSource().get('v.class') == 'slds-input inputWidth MarketingPrice'? true:false;
        var isSalesPrice = event.getSource().get('v.class') == 'slds-input inputWidth SalesPrice'? true:false;
        var isPropIndirectmarketing = event.getSource().get('v.class') == 'slds-input inputWidth propIndirectmarketing'? true:false;
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
        
        var goalseek = component.get("v.isGoalseekModalOpen");
        console.log("goalseek value--->"+goalseek);
        if( goalseek == true){
            var copyText=component.get("v.RequiredPrice");
            console.log("required pirce-->"+copyText);
            component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c",copyText);
        }
        component.set("v.isGoalseekModalOpen",false);
        
        helper.getCalculations(component,event,helper, currentValue, fieldName,isGuidancePrice,isMarketingPrice,isSalesPrice,isPropIndirectmarketing);
          var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        //component.set("v.showSaveCancelBtn",true);
        
        
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
    closeOverrideUnits: function (component, event, helper) {       
        component.set("v.OverrideUnitsEditMode", false);        
    },
    closeOverrideDirectUnits:function (component, event, helper) {       
        component.set("v.OverrideDirectUnitsEditMode", false);        
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
    /* New Product Launch*/
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
    closeEstDaysBox: function (component, event, helper) {
        component.set("v.EstDaysEditMode", false);   
    },
    /*END New Product Launch*/
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
    }
    /*Product Positions logic End*/
})