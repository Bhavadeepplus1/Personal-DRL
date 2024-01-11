({    
    doInit: function(component, event, helper) {
        
        console.log('childdonint');
        console.log('approved person--'+component.get("v.isContractsApprovePerson"));
        console.log('aprovalstatus==='+component.get("v.BidAprrovalStatus")); 
        console.log('cnt--approvaer==='+component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name"));
        console.log('v.singleRec.Phoenix_Marketing_Final_Approval__c==='+component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
        var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
        var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
        var directDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
        var indirectDeadnet = component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") : 0;
        var otbDirIndir=component.get("v.otbDirIndirect");
        
        directDeadnet = (Math.round(directDeadnet * 100) / 100).toFixed(2);
        indirectDeadnet = (Math.round(indirectDeadnet * 100) / 100).toFixed(2);
        component.set("v.directDeadnet",directDeadnet);
        component.set("v.indirectDeadnet",indirectDeadnet);
        
        var productDirector = component.get("v.singleRec.Phoenix_Product_Director__c");
        var delegatedUser = component.get("v.deligatedUserName");
        console.log("Deligation user-->"+delegatedUser);
        console.log("productDirector user-->"+productDirector);
        console.log('isBala--->'+productDirector+"-->"+component.get("v.deligatedUserName").includes(productDirector))
         var directWac;
          var indirectWac;
        if(component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") > 0 && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != null && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != '' && component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c") != undefined){
            directWac = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")*100).toFixed(2) + '%';
        }
        else{
             directWac = 'NA'; 
        }
          if(component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") > 0 && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != null && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != '' && component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c") != undefined){
            indirectWac = (component.get("v.singleRec.Phoenix_WAC__c")/component.get("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c")*100).toFixed(2) + '%';
        }
        else{
             indirectWac = 'NA'; 
        }
        component.set("v.singleRec.directWac",directWac);
        component.set("v.singleRec.indirectWac",indirectWac);
        if(productDirector != null && delegatedUser != null && delegatedUser.includes(productDirector) && component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c") == false){
           component.set("v.isdeligationApprover",true) 
            
        }
        if(otbDirIndir=='Direct'){
                //    helper.getCalculations(component,event,helper, currentValue, fieldName,isGuidancePrice,isMarketingPrice,isSalesPrice);

            
            if(latestEstimate > 0){
                var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < directDeadnet ? true : false;
                var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < directDeadnet ? true : false;
                component.set("v.isAccpetable",isAccpetable);
                component.set("v.isNotAccpetable",isNotAccpetable)
            }
            else if(BudgetedASP > 0){
                var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < directDeadnet ? true : false;
                var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < directDeadnet ? true : false;
                component.set("v.isAccpetable",isAccpetable);
                component.set("v.isNotAccpetable",isNotAccpetable)
            }else{
                console.log('else condition--->')
                component.set("v.isAccpetable",false);
                component.set("v.isNotAccpetable",false);
            }     
            
            
        }
        else if(otbDirIndir=='Indirect'){
            console.log('-------otbDirIndir----indirect----'+otbDirIndir);  
                    // helper.getCalculations(component,event,helper, currentValue, fieldName,isGuidancePrice,isMarketingPrice,isSalesPrice);

            if(latestEstimate > 0){
                var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < indirectDeadnet ? true : false;
                var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < indirectDeadnet ? true : false;
                component.set("v.isIndirAccpetable",isAccpetable);
                component.set("v.isIndirNotAccpetable",isNotAccpetable)
            }
            else if(BudgetedASP > 0){
                var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < indirectDeadnet ? true : false;
                var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < indirectDeadnet ? true : false;
                component.set("v.isIndirAccpetable",isAccpetable);
                component.set("v.isIndirNotAccpetable",isNotAccpetable)
            }else{
                console.log('else condition--->')
                component.set("v.isIndirAccpetable",false);
                component.set("v.isIndirNotAccpetable",false);
            }     
            
        }
        
            else{
                //
            }

        
        //helper.fetchPickListVal(component, 'Phoenix_Initial_Order_Discount_Type__c', 'ratingPicklistOpts');
      
       
       // this.onCISUChange(component,event,helper);
    },
    
    inlineEditCISUnit : function(component,event,helper){  
        component.set("v.CISUEditMode", true);
        setTimeout(function(){
            component.find("inputCISUId").focus();
        }, 100);
    },
    inlineEditCMFeePer : function(component,event,helper){  
        component.set("v.CMFeePerEditMode", true);
        setTimeout(function(){
            component.find("CMFeePer").focus();
        }, 100);
    },
    inlineEditRDCNLCPer : function(component,event,helper){  
        component.set("v.RDCNLCPerEditMode", true);
        setTimeout(function(){
            component.find("RDCNLCPer").focus();
        }, 100);
    },    
    
    
    
    
    inlineEditProDirectUnits : function(component,event,helper){  
        component.set("v.ProDirectUnitsEditMode", true);
        setTimeout(function(){
            component.find("ProDirectUnits").focus();
        }, 100);
    },
    
    inlineEditProIndirectUnits : function(component,event,helper){  
        component.set("v.ProIndirectUnitsEditMode", true);
        setTimeout(function(){
            component.find("ProIndirectUnits").focus();
        }, 100);
    },
    
    inlineEditGuidancePrice : function(component,event,helper){  
        component.set("v.GuidancePriceEditMode", true);
        setTimeout(function(){
            component.find("GuidancePrice").focus();
        }, 100);
    },
    inlineEditSalesPriceDirect : function(component,event,helper){  
        component.set("v.SalesPriceDirectEditMode", true);
        setTimeout(function(){
            component.find("SalesPriceDirect").focus();
        }, 100);
    },
    
    inlineEditSalesPriceIndirect : function(component,event,helper){  
        component.set("v.SalesPriceIndirectEditMode", true);
        setTimeout(function(){
            component.find("SalesPriceIndirect").focus();
        }, 100);
    },
    inlineEditProDirContr : function(component,event,helper){  
        component.set("v.ProDirContrEditMode", true);
        setTimeout(function(){
            component.find("ProDirContr").focus();
        }, 100);
    },
    
    
    inlineEditProIndirContr : function(component,event,helper){  
        component.set("v.ProIndirContrEditMode", true);
        setTimeout(function(){
            component.find("ProIndirContr").focus();
        }, 100);
    },
    
    inlineEditPURDollar : function(component,event,helper){  
        component.set("v.PURDollarEditMode", true);
        setTimeout(function(){
            component.find("PURDollar").focus();
        }, 100);
    },
    
    inlineEditVIRDollar : function(component,event,helper){  
        component.set("v.VIRDollarEditMode", true);
        setTimeout(function(){
            component.find("VIRDollar").focus();
        }, 100);
    },
    inlineEditRebFeePercent : function(component,event,helper){  
        component.set("v.RebFeePercentEditMode", true);
        setTimeout(function(){
            component.find("RebFeePercent").focus();
        }, 100);
    },
    inlineEditExpiryDt : function(component,event,helper){  
        component.set("v.ExpiryDtEditMode", true);
        setTimeout(function(){
            component.find("ExpiryDt").focus();
        }, 100);
    },
    inlineEditBatchNum : function(component,event,helper){  
        component.set("v.BatchNumEditMode", true);
        setTimeout(function(){
            component.find("BatchNum").focus();
        }, 100);
    },
    
    inlineEditCustServComments : function(component,event,helper){  
        component.set("v.CustServCommentsEditMode", true);
        setTimeout(function(){
            component.find("CustServComments").focus();
        }, 100);
    },
    
    inlineEditCustServApproval : function(component,event,helper){  
        component.set("v.CustServApprovalEditMode", true);
        setTimeout(function(){
            component.find("CustServApprovalId").focus();
        }, 100);
    },
    
    
    
    
    inlineEditOverrideDirectUnits: function(component,event,helper){  
        component.set("v.OverrideDirEditMode", true);
        setTimeout(function(){
            component.find("OverrideDirectUnits").focus();
        }, 100);
    },
    
    inlineEditOverrideIndirectUnits: function(component,event,helper){  
        component.set("v.OverrideIndirEditMode", true);
        setTimeout(function(){
            component.find("OverrideIndirectUnits").focus();
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
    inlineEditPCBPS1 : function(component,event,helper){  
        component.set("v.PCBPSEditMode1", true);
        setTimeout(function(){
            component.find("inputPCBPSId1").focus();
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
    inlineEdiCustServApproval : function(component,event,helper){  
        component.set("v.CustServApprovalEditMode", true);
        setTimeout(function(){
            component.find("CustServApprovalId").focus();
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
    closeGoalseekPopupIndirect : function(component,event,helper){
        component.set("v.isGoalseekModalOpenIndirect",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    openGoalseek :  function(component,event,helper){
        component.set("v.isGoalseekModalOpen",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    openGoalseekIndirect :  function(component,event,helper){
        component.set("v.isGoalseekModalOpenIndirect",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
    },
    calcGoalSeek : function(component,event,helper){
        var bidRecord=component.get("v.bidRecordParent");
        let deadnetPrice=parseFloat(component.get("v.expectDdeadnet"));
        let vipperunit= component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c") != null ? parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100) : 0;
        let currentcashterms=bidRecord.Phoenix_Current_CD__c;
        //if(currentcashterms!=null) ? currentcashterms=parseFloat(currentcashterms/100);}
            currentcashterms = currentcashterms!=null ? parseFloat(currentcashterms/100) : 0;
        let propadminfee=bidRecord.Phoenix_Proposed_Value_Admin_Fee__c;
        //if(propadminfee!=null){propadminfee=parseFloat(propadminfee/100);} 
        propadminfee = propadminfee!=null ? parseFloat(propadminfee/100) : 0;
        //let proposedrebatepercentage=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);
        var proposedrebatepercentagenullchecker=component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c");
        
        let proposedrebatepercentage;
        if(proposedrebatepercentagenullchecker != null)
        {
         proposedrebatepercentage=parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);
          
        }
        else{
            proposedrebatepercentage=0;
        }
        console.log('=======pur=========='+proposedrebatepercentage);
        //let propCashTerms= parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c")/100);
        var propCashTermsnullchecker=component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c");
        
        let propCashTerms;
        if(propCashTermsnullchecker != null)
        {
         propCashTerms= parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c")/100);
         
        }
        else{
            propCashTerms=0;
        }
        console.log('=======pur=========='+propCashTerms);
        var vipvalue=component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c");
        let vipPercent;
        if(vipvalue != null)
        {
         vipPercent= parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100);
           
        }
        else{
            vipPercent=0;
        }
         console.log('=======pur=========='+vipPercent);
        let directDeadNet= parseFloat(component.get("v.singleRec.Phoenix_Direct_Dead_Net__c"));
         console.log('=======pur=========='+directDeadNet);
        let pur= component.get("v.singleRec.Phoenix_Proposed_Per_Unit_Rebate__c") != null ? parseFloat(component.get("v.singleRec.Phoenix_Proposed_Per_Unit_Rebate__c")) : 0;
         console.log('=======pur=========='+pur);
        let vip= component.get("v.singleRec.Phoenix_Wholesaler_VIP__c") != null ? parseFloat(component.get("v.singleRec.Phoenix_Wholesaler_VIP__c")) : 0;
         console.log('=======pur=========='+vip);
        //let rebFeesPercent= parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);
        var rebFeesPercentnullchecker=component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c");
        
        let rebFeesPercent;
        if(rebFeesPercentnullchecker != null)
        {
         rebFeesPercent= parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100);
          
        }
        else{
            rebFeesPercent=0;
        }
        
         console.log('rebFeesPercent'+rebFeesPercent);
        console.log('======START=========');
        console.log('=======pur=========='+pur);
        console.log('========vip========='+vip);
        console.log('========rebFeesPercent========='+rebFeesPercent);
        console.log('========propCashTerms=========='+propCashTerms);
        console.log('========deadnetPrice==========='+deadnetPrice);
        console.log('=========END===========');
        
        let requiredPriceNumer=(deadnetPrice+pur);
        console.log('requiredPriceNumer next--->'+requiredPriceNumer);
        let requiredPricedeNumer;  
        console.log('rebFeesPercent next--->'+rebFeesPercent);
        console.log('propCashTerms next--->'+propCashTerms);
        requiredPricedeNumer=1-rebFeesPercent-propCashTerms-vipPercent;
        console.log('requiredPricedeNumer next--->'+requiredPricedeNumer);
        //  component.set("v.RequiredPrice",(requiredPriceNumer/requiredPricedeNumer).toFixed(2));
        component.set("v.RequiredPrice",(requiredPriceNumer/requiredPricedeNumer));
        
        component.set("v.expectCustmerDdeadnet",null); 
        var copyText=component.get("v.RequiredPrice");
        console.log("required pirce-->"+copyText);
        var WAC = component.get("v.singleRec.Phoenix_WAC__c");
        var proposedPriceMarketing = component.get("v.RequiredPrice");
        if(WAC<proposedPriceMarketing){
            component.set("v.errMsg","Marketing Price can not be greater than WAC");
            component.set("v.err",true);
            component.set("v.ShowSaveButton",false);
        }
        else{
            component.set("v.err",false);
            component.set("v.ShowSaveButton",true);
        }
    },
    
    
    calcIndirectDeadNetGoalSeek:  function(component,event,helper){
        var bidRecord=component.get("v.bidRecordParent");
        console.log('bidRecord--->'+bidRecord)
        let deadnetPrice=component.get("v.expectCustmerDdeadnet");
        console.log('deadnetPrice--->'+component.get("v.expectCustmerDdeadnet"))
        let pur = component.get("v.singleRec.Phoenix_Proposed_Per_Unit_Rebate__c") != null ? component.get("v.singleRec.Phoenix_Proposed_Per_Unit_Rebate__c") : 0;
        console.log('pur-->'+pur);
        let proposedcashterms = bidRecord.Phoenix_Proposed_Cash_Terms__c;
        //if(proposedcashterms!=null){proposedcashterms=parseFloat(proposedcashterms/100);}
        proposedcashterms = proposedcashterms!=null ? parseFloat(proposedcashterms/100) : 0; 
        console.log('proposedcashterms-->'+proposedcashterms);
        var WAC = component.get("v.singleRec.Phoenix_WAC__c") != null ? component.get("v.singleRec.Phoenix_WAC__c") : 0;
        console.log('WAC-->'+WAC);
        let rdcperc = component.get("v.singleRec.Phoenix_RDC_NLC__c") != null ? parseFloat(component.get("v.singleRec.Phoenix_RDC_NLC__c")/100) :0;
        console.log('rdcperc-->'+rdcperc);
        let rebate_feeperc = component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c") != null ? parseFloat(component.get("v.singleRec.Phoenix_Proposed_Current_Rebate__c")/100) :0;
        console.log('rebate_feeperc-->'+rebate_feeperc);
        let vipperc= component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c") != null ? parseFloat(component.get("v.singleRec.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c")/100) : 0;
        console.log('vipperc-->'+vipperc);
        let cmfeeperc = component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c") != null ? parseFloat(component.get("v.singleRec.Phoenix_Contract_Mngment_Fee_Wholesaler__c")/100) : 0;
        console.log('cmfeeperc-->'+cmfeeperc);
        let cdwac = (proposedcashterms*WAC);
        console.log('cdwac-->'+cdwac);
        let rdcwac = (rdcperc* WAC);
        console.log('rdcwac-->'+rdcwac);
        let pur_cd_rdc_wac = (pur)+(cdwac)+(rdcwac);
        console.log('pur_cd_rdc_wac-->'+pur_cd_rdc_wac);
        let requiredPriceNumer;
         requiredPriceNumer = (deadnetPrice*1) + (pur_cd_rdc_wac*1);
        console.log('requiredPriceNumer first-->'+ requiredPriceNumer);
        let requiredPricedeNumer;  
        requiredPricedeNumer=1- rebate_feeperc - vipperc - cmfeeperc;
        console.log('requiredPricedeNumer next--->'+requiredPricedeNumer);
        component.set("v.RequiredPrice",requiredPriceNumer/requiredPricedeNumer);
        //component.set("v.RequiredPrice",requiredPriceNumer);
        console.log("valueee-->",requiredPriceNumer/requiredPricedeNumer)
        component.set("v.expectDdeadnet",null);
        var proposedPriceMarketing = component.get("v.RequiredPrice");
        if(WAC<proposedPriceMarketing){
            
            //onCISUChange(component, event,helper);
            component.set("v.errMsg","Marketing Price can not be greater than WAC");
            component.set("v.err",true);
            component.set("v.ShowSaveButton",false);
        }
        else{
            component.set("v.err",false);
            component.set("v.ShowSaveButton",true);
            console.log("test price value--"+component.get("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c")	)
        }
    },
    
    onCISUChange : function(component,event,helper){  
        /*  var date = component.find("ExpiryDt").get('v.value');
        console.warn("date is: ", date);
        var fValue = event.getSource().get("v.value");
        console.log('fValue changeSEDDate'+fValue);*/
        
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('----------val----------'+val);
        console.log('-------nameofEditfield---------'+nameofEditfield);
        var currentValue, fieldName;
        var isGuidancePrice = event.getSource().get('v.class') == 'slds-input inputWidth guidancePrice'? true:false;
        var isMarketingPrice = event.getSource().get('v.class') == 'slds-input inputWidth MarketingPrice'? true:false;
        var indirprice = event.getSource().get('v.id') == 'indirprice'? true:false;
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
                    else if(nameofEditfield == 'CustServApproval'){
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
            //var deadNetDir=component.get("v.expectDdeadnet");
            var copyText=component.get("v.RequiredPrice");
            console.log("required pirce-->"+copyText);
            component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c",copyText);
            // component.set("v.singleRec.Phoenix_Direct_Dead_Net__c",deadNetDir);
            component.set("v.isGoalseekModalOpen",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        }
        
        /* store the indirect price throgh goal seek*/
        var goalseekIndirect = component.get("v.isGoalseekModalOpenIndirect");
        if( goalseekIndirect == true){
             var copyText=component.get("v.RequiredPrice");
            console.log("required pirce-->"+copyText);
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c",copyText);
            component.set("v.isGoalseekModalOpenIndirect",false);
        var LineItemtable = component.get("v.tableRef");
            $A.util.addClass(LineItemtable, "maintable");
        }
        
        helper.getCalculations(component,event,helper, currentValue, fieldName,isGuidancePrice,isMarketingPrice,isSalesPrice);
        
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
    closeCustServApprovalBox : function (component, event, helper) {
        component.set("v.CustServApprovalEditMode", false);
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
    closeCustServComments: function (component, event, helper) {
        component.set("v.CustServCommentsEditMode", false);
        
    },
    closePISUBox: function (component, event, helper) {
        component.set("v.PISUditMode", false);
        
    },
    closeExpiryDt: function (component, event, helper) {
        component.set("v.ExpiryDtEditMode", false);
        
    },
    closeBatchNum: function (component, event, helper) {
        component.set("v.BatchNumEditMode", false);
        
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
    closePCBPSBox1: function (component, event, helper) {       
        component.set("v.PCBPSEditMode1", false);        
    },
    
    
    closeProDirectUnits: function (component, event, helper) {       
        component.set("v.ProDirectUnitsEditMode", false);        
    },
    closeProIndirectUnits: function (component, event, helper) {       
        component.set("v.ProIndirectUnitsEditMode", false);        
    },
    closeGuidancePrice: function (component, event, helper) {       
        component.set("v.GuidancePriceEditMode", false);        
    },
    closeSalesPriceDirect: function (component, event, helper) {       
        component.set("v.SalesPriceDirectEditMode", false);        
    },
    closeSalesPriceIndirect: function (component, event, helper) {       
        component.set("v.SalesPriceIndirectEditMode", false);        
    },
    closeProDirContr: function (component, event, helper) {       
        component.set("v.ProDirContrEditMode", false);        
    },
    closeProIndirContr: function (component, event, helper) {       
        component.set("v.ProIndirContrEditMode", false);        
    },
    closePURDollar: function (component, event, helper) {       
        component.set("v.PURDollarEditMode", false);        
    },
    closeVIRDollar: function (component, event, helper) {       
        component.set("v.VIRDollarEditMode", false);        
    },
    closeRebFeePercent: function (component, event, helper) {       
        component.set("v.RebFeePercentEditMode", false);        
    },
    closeCMFeePer: function (component, event, helper) {       
        component.set("v.CMFeePerEditMode", false);        
    },
    closeRDCNLCPer: function (component, event, helper) {       
        component.set("v.RDCNLCPerEditMode", false);        
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
     displayFutureRecords: function (component, event, helper) {
        var LineItemtable = component.get("v.tableRef");
        var rowIndex = component.get("v.lineItemId");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.bidLineItemId", rowIndex);
        component.set("v.displayFutureDisplay", true);
    },

    
    //--END
})