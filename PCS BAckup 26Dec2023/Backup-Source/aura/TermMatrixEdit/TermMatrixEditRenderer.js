({
	validateInputs: function(component, helper, currentInputComponent, fieldsMap){
        console.log("---validateInputs---");
        let curInput = currentInputComponent;
        let curFieldName = curInput.get("v.fieldName");

        let curInpValue = curInput.get('v.value');

        if(curFieldName == "Phoenix_Is_Customer_Prepay__c"){
            let isToDisable = curInpValue == 'Yes'? true: false;
            fieldsMap.get("Phoenix_ACH__c").set("v.value", null);
            fieldsMap.get("Phoenix_ACH__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_ACH_Net_Days__c").set("v.value", null);
            fieldsMap.get("Phoenix_ACH_Net_Days__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_ACH_Discount_Days__c").set("v.value", null);
            fieldsMap.get("Phoenix_ACH_Discount_Days__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_Check_Payment__c").set("v.value", null);
            fieldsMap.get("Phoenix_Check_Payment__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_Check_Payment_Discount_Days__c").set("v.value", null);
            fieldsMap.get("Phoenix_Check_Payment_Discount_Days__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_Check_Payment_Net_Days__c").set("v.value", null);
            fieldsMap.get("Phoenix_Check_Payment_Net_Days__c").set("v.disabled", isToDisable);
        }else if(curFieldName == "Phoenix_Customer_s_Purchase_Method__c"){
            let isToDisable = curInpValue == 'Direct (WAC Purchaser)'? true: false;
            fieldsMap.get("Phoenix_Days_Notice_Needed_for_WAC_Price__c").set("v.value", null);
            fieldsMap.get("Phoenix_Days_Notice_Needed_for_WAC_Price__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_Special_Terms_WAC_Price_Incs__c").set("v.value", null);
            fieldsMap.get("Phoenix_Special_Terms_WAC_Price_Incs__c").set("v.disabled", isToDisable);

        }else if(curFieldName == "Phoenix_Is_Customer_Indirect_GPO__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            fieldsMap.get("Phoenix_Customer_has_membership_list__c").set("v.value", null);
            fieldsMap.get("Phoenix_Customer_has_membership_list__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_How_to_Obtain_Membership_Lists__c").set("v.value", null);
            fieldsMap.get("Phoenix_How_to_Obtain_Membership_Lists__c").set("v.disabled", isToDisable);

            fieldsMap.get("Phoenix_Does_Agreement_allow_direct_ind__c").set("v.value", null);
            fieldsMap.get("Phoenix_Does_Agreement_allow_direct_ind__c").set("v.disabled", isToDisable);

            fieldsMap.get("Phoenix_DSH_Pricing_Exists__c").set("v.value", null);
            fieldsMap.get("Phoenix_DSH_Pricing_Exists__c").set("v.disabled", isToDisable);

        }else if(curFieldName == "Has_Rebates__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            fieldsMap.get("Phoenix_Customer_Rebate_CONSOLIDATED_Det__c").set("v.value", true);
            fieldsMap.get("Phoenix_Customer_Rebate_CONSOLIDATED_Det__c").set("v.disabled", isToDisable);            
           
        }else if(curFieldName == "Phoenix_Has_Damage_Allowance__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            fieldsMap.get("Phoenix_Damage_Allowance_Details__c").set("v.value", true);
            fieldsMap.get("Phoenix_Damage_Allowance_Details__c").set("v.disabled", isToDisable);            
           
        }else if(curFieldName == "Has_Bonafide_Fee_s__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            fieldsMap.get("Phoenix_Customer_BonafideFee_CONSOLIDATE__c").set("v.value", true);
            fieldsMap.get("Phoenix_Customer_BonafideFee_CONSOLIDATE__c").set("v.disabled", isToDisable);            
           
        }else if(curFieldName == "Phoenix_Does_the_Agreement_have__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            fieldsMap.get("Phoenix_VIP_Details__c").set("v.value", true);
            fieldsMap.get("Phoenix_VIP_Details__c").set("v.disabled", isToDisable);            
           
        }else if(curFieldName == "Phoenix_Customer_has_FTS_or_Service_Leve__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval = curInpValue == 'No'? 'N/A': null;
            fieldsMap.get("Phoenix_FTS_SL_Threshold_Above_Normal_Us__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_FTS_SL_Threshold_Above_Normal_Us__c").set("v.disabled", isToDisable);
            
            fieldsMap.get("Phoenix_FTS_Bar_on_Claims_Period_If_Any__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_FTS_Bar_on_Claims_Period_If_Any__c").set("v.disabled", isToDisable);

            fieldsMap.get("Phoenix_FTS_SL_Brand_Eligible__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_FTS_SL_Brand_Eligible__c").set("v.disabled", isToDisable);

            fieldsMap.get("Phoenix_FTS_Duration_of_Liability__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_FTS_Duration_of_Liability__c").set("v.disabled", isToDisable);

            fieldsMap.get("Phoenix_FTS_SL_Calculation_Language__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_FTS_SL_Calculation_Language__c").set("v.disabled", isToDisable);

            fieldsMap.get("Phoenix_FTS_SL_Price_Cap__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_FTS_SL_Price_Cap__c").set("v.disabled", isToDisable);
           
        }else if(curFieldName == "Phoenix_Has_Service_Level_Penalties__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            let inpval = curInpValue == 'No'? false: true;
            fieldsMap.get("Phoenix_Service_Level_Penalty_Details__c").set("v.value", inpval);
            fieldsMap.get("Phoenix_Service_Level_Penalty_Details__c").set("v.disabled", isToDisable);
           
        }else if(curFieldName == "Phoenix_Full_SDEA_or_Section_in_Agreemen__c"){
            let isToDisable = curInpValue == 'No'? true: false;
            fieldsMap.get("Phoenix_Service_Level_Penalty_Details__c").set("v.value", true);
            fieldsMap.get("Phoenix_Service_Level_Penalty_Details__c").set("v.disabled", isToDisable);
           
        }
    },
    onLoadchanges : function(component, event, helper) {
        let allFields = component.find("fieldLableId");
        console.log(JSON.Stringfy(allFields));

          /*component.find("fieldLableId").forEach(
              function(auraId)
              {
                if(auraId.get("v.value") == 'Yes' && auraId.get("v.fieldName") == "Phoenix_Is_Customer_Prepay__c"){
                    if(auraId.get("v.fieldName") == "Phoenix_ACH__c"){
                        auraId.set("v.value",null);
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_ACH_Net_Days__c"){
                        auraId.set("v.value",null);
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_ACH_Discount_Days__c"){
                        auraId.set("v.value",null);
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_Check_Payment__c"){
                        auraId.set("v.value",null);
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_Check_Payment_Discount_Days__c"){
                        auraId.set("v.value",null);
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_Check_Payment_Net_Days__c"){
                        auraId.set("v.value",null);
                        auraId.set("v.disabled",true);
                    }
                }
                if(auraId.get("v.value") == 'Direct (WAC Purchaser)' && auraId.get("v.fieldName") == "Phoenix_Customer_s_Purchase_Method__c"){
                    if(auraId.get("v.fieldName") == "Phoenix_Days_Notice_Needed_for_WAC_Price__c"){
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_Special_Terms_WAC_Price_Incs__c"){
                        auraId.set("v.disabled",true);
                    }
                }
                if(auraId.get("v.value") == 'No' && auraId.get("v.fieldName") == "Phoenix_Is_Customer_Indirect_GPO__c"){
                    if(auraId.get("v.fieldName") == "Phoenix_Customer_has_membership_list__c"){
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_How_to_Obtain_Membership_Lists__c"){
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_Does_Agreement_allow_direct_ind__c"){
                        auraId.set("v.disabled",true);
                    }
                    if(auraId.get("v.fieldName") == "Phoenix_DSH_Pricing_Exists__c"){
                        auraId.set("v.disabled",true);
                    }
                    
                }
                if(auraId.get("v.value") == 'No' && auraId.get("v.fieldName") == "Has_Rebates__c"){
                    if(auraId.get("v.fieldName") == "Phoenix_Customer_Rebate_CONSOLIDATED_Det__c"){
                        auraId.set("v.disabled",true);
                    }
                }
                if(auraId.get("v.value") == 'No' && auraId.get("v.fieldName") == "Phoenix_Has_Damage_Allowance__c"){
                        if(auraId.get("v.fieldName") == "Phoenix_Damage_Allowance_Details__c"){
                            auraId.set("v.disabled",true);
                        }
                }
                if(auraId.get("v.value") == 'No' && auraId.get("v.fieldName") == "Has_Bonafide_Fee_s__c"){
                        if(auraId.get("v.fieldName") == "Phoenix_Customer_BonafideFee_CONSOLIDATE__c"){
                            auraId.set("v.disabled",true);
                        }
                        
                }
                if(auraId.get("v.value") == 'No' && auraId.get("v.fieldName") == "Phoenix_Does_the_Agreement_have__c"){
                        if(auraId.get("v.fieldName") == "Phoenix_VIP_Details__c"){
                            auraId.set("v.disabled",true);
                        }
                 }
                if(auraId.get("v.value") == 'No' && auraId.get("v.fieldName") == "Phoenix_Customer_has_FTS_or_Service_Leve__c"){
                        console.log('eachfield-->'+auraId.get("v.fieldName"))
                        if(auraId.get("v.fieldName") == "Phoenix_FTS_SL_Threshold_Above_Normal_Us__c"){
                            auraId.set("v.value",'N/A');
                            auraId.set("v.disabled",true);
                        }
                        if(auraId.get("v.fieldName") == "Phoenix_FTS_Bar_on_Claims_Period_If_Any__c"){
                            auraId.set("v.value",'N/A');
                            auraId.set("v.disabled",true);
                        }
                        if(auraId.get("v.fieldName") == "Phoenix_FTS_SL_Brand_Eligible__c"){
                            auraId.set("v.disabled",true);
                        }
                        if(auraId.get("v.fieldName") == "Phoenix_FTS_Duration_of_Liability__c"){
                            auraId.set("v.value",'N/A');
                            auraId.set("v.disabled",true);
                        }
                        if(auraId.get("v.fieldName") == "Phoenix_FTS_SL_Calculation_Language__c"){
                            auraId.set("v.value",'N/A');
                            auraId.set("v.disabled",true);
                        }
                        if(auraId.get("v.fieldName") == "Phoenix_FTS_SL_Price_Cap__c"){
                            auraId.set("v.value",'N/A');
                            auraId.set("v.disabled",true);
                        }
                    
                }
                if(auraId.get("v.value")  == 'No' && auraId.get("v.fieldName") == "Phoenix_Has_Service_Level_Penalties__c"){
                        if(auraId.get("v.fieldName") == "Phoenix_Service_Level_Penalty_Details__c"){
                            auraId.set("v.disabled",true);
                        }
                        
                }
                if(auraId.get("v.value") == 'No' && auraId.get("v.fieldName") == "Phoenix_Full_SDEA_or_Section_in_Agreemen__c"){
                        if(auraId.get("v.fieldName") == "Phoenix_Service_Level_Penalty_Details__c"){
                            auraId.set("v.disabled",true);
                        }
                        
                }
            });
        
        */
    },
    closeActionPanel: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})