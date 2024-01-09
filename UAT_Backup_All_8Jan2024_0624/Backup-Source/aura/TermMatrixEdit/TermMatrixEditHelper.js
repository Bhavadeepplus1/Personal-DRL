({
    loadInstance: function(component, helper){
        let pageReference = component.get("v.pageReference");
        console.log(pageReference);
        let recordId = pageReference.state.c__recordId;
        console.log("loadInstance recordId: " + recordId);
        if (recordId != null) {
            component.set("v.recordId", recordId);
        }
        let isClone = pageReference.state.c__isClone;
        console.log("isClone: " + isClone);
        if (isClone !== undefined && isClone != null) {
            component.set("v.isClone", isClone);
        }
        
        var action = component.get("c.getTermsMatrix");
        
        action.setParams({
            "recordId": recordId          
        });
        
        if(recordId  == null || recordId == undefined){
            component.set("v.isCreate",true);
        }
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                var wrapperObject = response.getReturnValue();
                component.set("v.WrapperObect",wrapperObject);
                //console.log("list of matrixes--->"+JSON.stringify(wrapperObject));
                
                window.setTimeout(
                    $A.getCallback(function() {
                        
                        //collect all inputs
                        let fieldsMap = new Map();
                        let allFields = component.find("fieldLableId");
                        allFields.forEach(function(eachInput){
                            fieldsMap.set(eachInput.get("v.fieldName"), eachInput);
                        });
                        
                        allFields.forEach(function(eachInput){
                            helper.validateInputs(component, helper, eachInput, fieldsMap,true);
                        });
                        
                    }), 5000
                );    
                
            }  else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.")
                
            } else if (state === "ERROR") {  
                console.log("Error: ");
            }
        });
        $A.enqueueAction(action);  
    },
    validateInputs: function(component, helper, currentInputComponent, fieldsMap, isOnload){
        console.log("---validateInputs---");
        let curInput = currentInputComponent;
        let curFieldName = curInput.get("v.fieldName");
        let recordId = component.get("v.recordId");
        let curInpValue = curInput.get('v.value');
        
        if(curFieldName == "Phoenix_Is_Customer_Prepay__c"){
            let isToDisable = curInpValue == 'Yes'? true: false;
            let ach = curInpValue == 'Yes'? null: fieldsMap.get("Phoenix_ACH__c").get("v.value");
            fieldsMap.get("Phoenix_ACH__c").set("v.value", ach);
            fieldsMap.get("Phoenix_ACH__c").set("v.disabled", isToDisable);
            
            let achNetDays = curInpValue == 'Yes'? null: fieldsMap.get("Phoenix_ACH_Net_Days__c").get("v.value");
            fieldsMap.get("Phoenix_ACH_Net_Days__c").set("v.value", achNetDays);
            fieldsMap.get("Phoenix_ACH_Net_Days__c").set("v.disabled", isToDisable);
            
            let  achDiscountDays= curInpValue == 'Yes'? null: fieldsMap.get("Phoenix_ACH_Discount_Days__c").get("v.value");
            fieldsMap.get("Phoenix_ACH_Discount_Days__c").set("v.value", achDiscountDays);
            fieldsMap.get("Phoenix_ACH_Discount_Days__c").set("v.disabled", isToDisable);
            
            let checkPayment = curInpValue == 'Yes'? null: fieldsMap.get("Phoenix_Check_Payment__c").get("v.value");
            fieldsMap.get("Phoenix_Check_Payment__c").set("v.value", checkPayment);
            fieldsMap.get("Phoenix_Check_Payment__c").set("v.disabled", isToDisable);
            
            let checkPaymentDiscoutDays = curInpValue == 'Yes'? null: fieldsMap.get("Phoenix_Check_Payment_Discount_Days__c").get("v.value");
            fieldsMap.get("Phoenix_Check_Payment_Discount_Days__c").set("v.value", checkPaymentDiscoutDays);
            fieldsMap.get("Phoenix_Check_Payment_Discount_Days__c").set("v.disabled", isToDisable);
            
            let checkPaymentNetDays = curInpValue == 'Yes'? null: fieldsMap.get("Phoenix_Check_Payment_Net_Days__c").get("v.value");
            fieldsMap.get("Phoenix_Check_Payment_Net_Days__c").set("v.value", checkPaymentNetDays);
            fieldsMap.get("Phoenix_Check_Payment_Net_Days__c").set("v.disabled", isToDisable);
        }else if(curFieldName == "Phoenix_Customer_s_Purchase_Method__c"){
            let isToDisable = curInpValue != 'Direct (WAC Purchaser)'? true: false;
            let daysNoticeWacPrice =isOnload ? fieldsMap.get("Phoenix_Days_Notice_Needed_for_WAC_Price__c").get("v.value") : curInpValue != 'Direct (WAC Purchaser)'? null : null;
            fieldsMap.get("Phoenix_Days_Notice_Needed_for_WAC_Price__c").set("v.value", daysNoticeWacPrice);
            fieldsMap.get("Phoenix_Days_Notice_Needed_for_WAC_Price__c").set("v.disabled", isToDisable);
            
            let specialTermNoticeWacPrice = isOnload ? fieldsMap.get("Phoenix_Special_Terms_WAC_Price_Incs__c").get("v.value") : curInpValue != 'Direct (WAC Purchaser)'? 'N/A':null;
            fieldsMap.get("Phoenix_Special_Terms_WAC_Price_Incs__c").set("v.value", specialTermNoticeWacPrice);
            fieldsMap.get("Phoenix_Special_Terms_WAC_Price_Incs__c").set("v.disabled", isToDisable);
            
        }else if(curFieldName == "Phoenix_Is_Customer_Indirect_GPO__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let customerHasMembership = isOnload ? fieldsMap.get("Phoenix_Customer_has_membership_list__c").get("v.value") : curInpValue == 'No'? 'N/A' : null; 
            
            //let customerHasMembership = curInpValue == 'No'? 'N/A':(recordId != null) ? null: (recordId == null)? null :fieldsMap.get("Phoenix_Customer_has_membership_list__c").get("v.value");
            fieldsMap.get("Phoenix_Customer_has_membership_list__c").set("v.value", customerHasMembership);
            fieldsMap.get("Phoenix_Customer_has_membership_list__c").set("v.disabled", isToDisable);
            
            let howObtainMembership = isOnload ? fieldsMap.get("Phoenix_How_to_Obtain_Membership_Lists__c").get("v.value") : curInpValue == 'No'? 'N/A' : null;            
            fieldsMap.get("Phoenix_How_to_Obtain_Membership_Lists__c").set("v.value", howObtainMembership);
            fieldsMap.get("Phoenix_How_to_Obtain_Membership_Lists__c").set("v.disabled", isToDisable);
            
            let doesAgreement = isOnload ? fieldsMap.get("Phoenix_Does_Agreement_allow_direct_ind__c").get("v.value") : curInpValue == 'No'? 'N/A' : null; 
            fieldsMap.get("Phoenix_Does_Agreement_allow_direct_ind__c").set("v.value", doesAgreement);
            fieldsMap.get("Phoenix_Does_Agreement_allow_direct_ind__c").set("v.disabled", isToDisable);
            
            let dshPricingExist = isOnload ? fieldsMap.get("Phoenix_DSH_Pricing_Exists__c").get("v.value") : curInpValue == 'No'? 'N/A' : null; 
            fieldsMap.get("Phoenix_DSH_Pricing_Exists__c").set("v.value", dshPricingExist);
            fieldsMap.get("Phoenix_DSH_Pricing_Exists__c").set("v.disabled", isToDisable);
            
        }else if(curFieldName == "Phoenix_Has_Rebates__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval = isOnload ? fieldsMap.get("Phoenix_Customer_Rebate_CONSOLIDATED_Det__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_Customer_Rebate_CONSOLIDATED_Det__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_Customer_Rebate_CONSOLIDATED_Det__c").set("v.disabled", isToDisable);            
            
        }else if(curFieldName == "Phoenix_Has_Damage_Allowance__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval = isOnload ? fieldsMap.get("Phoenix_Damage_Allowance_Details__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_Damage_Allowance_Details__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_Damage_Allowance_Details__c").set("v.disabled", isToDisable);            
            
        }else if(curFieldName == "Has_Bonafide_Fee_s__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval = isOnload ? fieldsMap.get("Phoenix_Customer_BonafideFee_CONSOLIDATE__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_Customer_BonafideFee_CONSOLIDATE__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_Customer_BonafideFee_CONSOLIDATE__c").set("v.disabled", isToDisable);            
            
        }else if(curFieldName == "Phoenix_Does_the_Agreement_have__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval = isOnload ? fieldsMap.get("Phoenix_VIP_Details__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_VIP_Details__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_VIP_Details__c").set("v.disabled", isToDisable);            
            
        }else if(curFieldName == "Phoenix_Customer_has_FTS_or_Service_Leve__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval = isOnload ? fieldsMap.get("Phoenix_FTS_SL_Threshold_Above_Normal_Us__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_FTS_SL_Threshold_Above_Normal_Us__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_FTS_SL_Threshold_Above_Normal_Us__c").set("v.disabled", isToDisable);
            
            let inpval1 = isOnload ? fieldsMap.get("Phoenix_FTS_Bar_on_Claims_Period_If_Any__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_FTS_Bar_on_Claims_Period_If_Any__c").set("v.value", inpval1);
            fieldsMap.get("Phoenix_FTS_Bar_on_Claims_Period_If_Any__c").set("v.disabled", isToDisable);
            
            let inpval2 = isOnload ? fieldsMap.get("Phoenix_FTS_SL_Brand_Eligible__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_FTS_SL_Brand_Eligible__c").set("v.value", inpval2);
            fieldsMap.get("Phoenix_FTS_SL_Brand_Eligible__c").set("v.disabled", isToDisable);
            
            let inpval3 = isOnload ? fieldsMap.get("Phoenix_FTS_Duration_of_Liability__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_FTS_Duration_of_Liability__c").set("v.value", inpval3);
            fieldsMap.get("Phoenix_FTS_Duration_of_Liability__c").set("v.disabled", isToDisable);
            
            let inpval4 = isOnload ? fieldsMap.get("Phoenix_FTS_SL_Calculation_Language__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_FTS_SL_Calculation_Language__c").set("v.value", inpval4);
            fieldsMap.get("Phoenix_FTS_SL_Calculation_Language__c").set("v.disabled", isToDisable);
            
            let inpval5 = isOnload ? fieldsMap.get("Phoenix_FTS_SL_Price_Cap__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_FTS_SL_Price_Cap__c").set("v.value", inpval5);
            fieldsMap.get("Phoenix_FTS_SL_Price_Cap__c").set("v.disabled", isToDisable);
            
        }else if(curFieldName == "Phoenix_Has_Service_Level_Penalties__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval =  isOnload ? fieldsMap.get("Phoenix_Service_Level_Penalty_Details__c").get("v.value") : curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_Service_Level_Penalty_Details__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_Service_Level_Penalty_Details__c").set("v.disabled", isToDisable);
            
        }else if(curFieldName == "Phoenix_Full_SDEA_or_Section_in_Agreemen__c"){
            let isToDisable = curInpValue == 'No PV/SDEA Language'? true: false;
            let inpval = isOnload ? fieldsMap.get("DRL_Customer_PV_SDEA_Language_Agreement__c").get("v.value") : curInpValue == 'No PV/SDEA Language'? 'N/A': null;
            fieldsMap.get("DRL_Customer_PV_SDEA_Language_Agreement__c").set("v.value", inpval);
            fieldsMap.get("DRL_Customer_PV_SDEA_Language_Agreement__c").set("v.disabled", isToDisable);
            
        }else if(curFieldName == "Phoenix_Full_QA_or_Section_in_Agreement__c"){
            let isToDisable = curInpValue == 'No QA Language'? true: false;
            let inpval = isOnload ? fieldsMap.get("Phoenix_DRL_or_Customer_QA_Language_Agre__c").get("v.value") : curInpValue == 'No QA Language'? 'N/A': null;
            fieldsMap.get("Phoenix_DRL_or_Customer_QA_Language_Agre__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_DRL_or_Customer_QA_Language_Agre__c").set("v.disabled", isToDisable);
            
        }
            else if(curFieldName == "Phoenix_IOD_Language_In_Purchase_Agreeme__c"){
                let checkedVal=fieldsMap.get("Phoenix_IOD_Language_In_Purchase_Agreeme__c").get("v.value");
                if(checkedVal!='Yes'){
                    fieldsMap.get("Phoenix_Contractual_IOD_Comment__c").set("v.disabled", true);
                    fieldsMap.get("Phoenix_Contractual_IOD_Comment__c").set("v.value", '');
                    
                }
                else{
                    fieldsMap.get("Phoenix_Contractual_IOD_Comment__c").set("v.disabled", false);  
                }
            }
                else if(curFieldName == "Phoenix_Overriding_Returns_Terms_in_AGR__c"){
                    let checkedVal=fieldsMap.get("Phoenix_Overriding_Returns_Terms_in_AGR__c").get("v.value");
                    if(checkedVal!='Yes'){
                        fieldsMap.get("Phoenix_Return_Term_Override_Comment__c").set("v.disabled", true);
                        fieldsMap.get("Phoenix_Return_Term_Override_Comment__c").set("v.value", '');
                    }
                    else{
                        fieldsMap.get("Phoenix_Return_Term_Override_Comment__c").set("v.disabled", false);  
                    }
                }
    },
    closeActionPanel: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})