({
    doInit : function(component, event, helper) {
        component.set("v.isOtcProdFam",component.get("v.AccTemplate") == 'OTC Customer'? true:false);
        var prodObj = {};
        var optyProdObj = component.get("v.prodItem");
        console.log('optyProdObj =====>',JSON.stringify(optyProdObj));
        component.set("v.prodOptyObj",optyProdObj);
        prodObj.Id = optyProdObj.Product__r.Id;
        prodObj.fullName=optyProdObj.Product__r.Name;
        if(optyProdObj.Product__r.Name.length>58){
            prodObj.Name = optyProdObj.Product__r.Name.substring(0,58);
            component.set("v.showDots",true);
        }
        else{
            prodObj.Name = optyProdObj.Product__r.Name;
            component.set("v.showDots",false);
        }
        prodObj.Phoenix_Pkg_Size__c = optyProdObj.Product__r.Phoenix_Pkg_Size__c != undefined ? optyProdObj.Product__r.Phoenix_Pkg_Size__c : 1;
        component.set("v.prodObj",prodObj);
        
        var isValidNum = !isNaN(optyProdObj.Vision_Disc_Pkg_Size__c) ? true : false;
        component.set("v.isValidPkgSize",isValidNum);
        
        if(isValidNum)
            helper.getUpdatedTotalPropUnits(component, event, helper);
        else
            helper.calculateProposedUnits(component, event, helper, optyProdObj, 1, 1);
    },
    closeSearch : function(component, event, helper){
        component.set("v.isSearchProd",false);
    },
    openSearch : function(component, event, helper){
        component.set("v.smallSpinner",true);
        var itemObj = component.get("v.prodOptyObj");
        var action = component.get("c.getProdList");
        action.setParams({
            optyProdId:itemObj.Id
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from getProdList --> '+state);
            if(state == 'SUCCESS'){
                var retProdList = response.getReturnValue();
                component.set("v.prodList",retProdList);
                component.set("v.isSearchProd",true);
                component.set("v.smallSpinner",false);
            }else
                console.log('Error--->'+JSON.stringify(response.getError()));
        });
        $A.enqueueAction(action);
    },
    updateWithSelectedProd : function(component, event, helper){
        var selectedProdId = component.find('selectProd').get('v.value');
        if(selectedProdId != 'Select A Prod'){
            /*console.log('selectedProdID --> '+selectedProdId);
            component.set("v.smallSpinner",true);
            var itemObj = component.get("v.prodItem");
            var prodList = component.get("v.prodList");
            var prodName = '';
            var prodObj = {};*/
            /*for(var key in prodList){
                if(prodName != '' && key == selectedProdId){
                    console.log('Inside match prodName');
                    prodName = prodList[key];
                    prodObj.Id = selectedProdId;
                    prodObj.Name = prodName;
                }
            }*/
            /*prodList.forEach(function(item){
                console.log('item.label --> '+item.label);
                console.log('item.value : '+item.value+','+selectedProdId);
                if(item.value == selectedProdId){
                    console.log('Inside match prodName');
                    prodName = item.label;
                    prodObj.Id = selectedProdId;
                    prodObj.Name = prodName;
                }
            });
            itemObj.Product__c = selectedProdId;
            itemObj.Product__r.Id = selectedProdId;
            itemObj.Product__r.Name = prodName;
            component.set("v.prodItem",itemObj);
            component.set("v.prodObj",prodObj);
            component.set("v.isSearchProd",false);
            component.set("v.smallSpinner",false);*/
            //("c.updateWithNewProd");
            var itemObj = component.get("v.prodOptyObj");
            var action = component.get("c.getUpdatedPkgSize");
            action.setParams({
                optyProdId:itemObj.Id,
                selectedProdId:selectedProdId
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    var retOptyProd = response.getReturnValue();
                    component.set("v.prodOptyObj",retOptyProd);
                    var prodObj = {};
                    prodObj.Id = retOptyProd.Product__r.Id;
                    prodObj.fullName=retOptyProd.Product__r.Name;
                    if(retOptyProd.Product__r.Name.length>58){
                        prodObj.Name = retOptyProd.Product__r.Name.substring(0,58);
                        component.set("v.showDots",true);
                    }
                    else{
                        prodObj.Name = retOptyProd.Product__r.Name;
                        component.set("v.showDots",false);
                    }
                    
                    prodObj.Phoenix_Pkg_Size__c = retOptyProd.Product__r.Phoenix_Pkg_Size__c;
                    component.set("v.prodObj",prodObj);
                    component.set("v.isSearchProd",false);
                    component.set("v.smallSpinner",false);
                    helper.getUpdatedTotalPropUnits(component, event, helper);
                }else
                    console.log('Error--->'+JSON.stringify(response.getError()));
            });
            $A.enqueueAction(action);
        }
    },
    moveToMatch : function(component, event, helper){
        component.set("v.smallSpinnerWhileMatch",true);
        var optyProd = component.get("v.prodOptyObj");
        var prodObj = component.get("v.prodObj");
        if(component.get("v.existingProducts").includes(prodObj.Id)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "mode": 'sticky',
                "title": "Error!",
                "type":"error",
                "message":'Selected Product Aready exists in matched products. Please select another product or alter the proposed units under Opportunity Products.'
            });
            toastEvent.fire(); 
        }
        else{
            var action = component.get("c.updateWithNewProd");
            if(component.get("v.isValidPkgSize") && component.get("v.useNewFields")){
                optyProd.Vision_Uploaded_Pkg_Size__c = parseInt(optyProd.Vision_Disc_Pkg_Size__c);
                optyProd.Proposed_Direct_Selling_Units__c = component.get("v.ProposedDirectSellingUnits"); 
                optyProd.Proposed_Indirect_Selling_Units__c = component.get("v.ProposedIndirectSellingUnits");   
                optyProd.Vision_Proposed_OS_Units__c = component.get("v.VisionProposedOSUnits");   
                optyProd.Vision_Proposed_RAD_Units__c = component.get("v.VisionProposedRADUnits");   
                optyProd.Vision_Proposed_WMT_Units__c = component.get("v.VisionProposedWMTUnits");   
                optyProd.Vision_Proposed_BASE_Units__c = component.get("v.VisionProposedBASEUnits");   
                optyProd.Vision_Proposed_DSH_Units__c = component.get("v.VisionProposedDSHUnits");   
                optyProd.Vision_Proposed_AutoSub_Units__c = component.get("v.VisionProposedAutoSubUnits");   
                optyProd.Vision_Proposed_Smith_Drug_Units__c = component.get("v.VisionProposedSmithDrugUnits");   
                optyProd.Vision_Proposed_Anda_Units__c = component.get("v.VisionProposedAndaUnits");   
                optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = component.get("v.VisionProposedDirectAholdDelhaizeUnits");   
                optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = component.get("v.VisionProposedDirectGaintEagleUnits");   
                optyProd.Vision_Proposed_TotalRetailIndirectUnits__c = component.get("v.VisionProposedTotalRetailIndirectUnits");   
                
                optyProd.Vision_Proposed_Direct_ESI_Units__c = component.get("v.VisionProposedDirectESIUnits");   
                optyProd.Vision_Proposed_Indirect_ESI_Units__c = component.get("v.VisionProposedIndirectESIUnits");   
                optyProd.Vision_Proposed_Direct_Kroger_Units__c = component.get("v.VisionProposedDirectKrogerUnits");   
                optyProd.Vision_Proposed_Indirect_Kroger_Units__c = component.get("v.VisionProposedIndirectKrogerUnits");   
                optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = component.get("v.VisionProposedDirectRxOutreachUnits");   
                optyProd.Vision_Proposed_IndirectRxOutreach_Units__c = component.get("v.VisionProposedIndirectRxOutreachUnits");   
                optyProd.Vision_Proposed_Direct_Supervalu_Units__c = component.get("v.VisionProposedDirectSupervaluUnits");   
                optyProd.Vision_Proposed_Indirect_Supervalu_Units__c = component.get("v.VisionProposedIndirectSupervaluUnits");   
                optyProd.Vision_Proposed_Direct_Cigna_Units__c = component.get("v.VisionProposedDirectCignaUnits");   
                optyProd.Vision_Proposed_Indirect_Cigna_Units__c = component.get("v.VisionProposedIndirectCignaUnits");   
                optyProd.Vision_Proposed_Direct_Cordant_Units__c = component.get("v.VisionProposedDirectCordantUnits");   
                optyProd.Vision_Proposed_Indirect_Cordant_Units__c = component.get("v.VisionProposedIndirectCordantUnits");    
                optyProd.Vision_Proposed_Direct_Accerodo_Units__c = component.get("v.VisionProposedDirectAccerodoUnits");   
                optyProd.Vision_Proposed_Indirect_Accerodo_Units__c = component.get("v.VisionProposedIndirectAccerodoUnits");   
                
                optyProd.Vision_Proposed_CVS_Direct_Units__c = component.get("v.VisionProposedCVSDirectUnits");   
                optyProd.Vision_Proposed_CVS_Indirect_Units__c = component.get("v.VisionProposedCVSIndirectUnits");   
                optyProd.Vision_Proposed_Cardinal_Units__c = component.get("v.VisionProposedCardinalUnits");    
                optyProd.Vision_Proposed_Major_Units__c = component.get("v.VisionProposedMajorUnits"); 
                optyProd.Vision_Total_Annual_Units__c = component.get("v.totalProposedUnits");
                optyProd.Vision_isNewProposedUnits__c=component.get("v.useNewFields");
            }
            console.log('optyProd as string---> '+JSON.stringify(optyProd));
            action.setParams({optyProdStr:JSON.stringify(optyProd),
                              selectedProdId:prodObj.Id});
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state from getProdList --> '+state);
                if(state == 'SUCCESS'){
                    var prodOptyObj = response.getReturnValue();
                    if(component.get("v.discType") != 'Duplicate Product'){
                        var cmpEvent = component.getEvent("sampleCmpEvent"); 
                        cmpEvent.setParams({"rowNumber" : component.get("v.indVar"),
                                            optyProdObj : prodOptyObj}); 
                        cmpEvent.fire(); 
                        component.set("v.prodOptyObj",prodOptyObj);
                        component.set("v.smallSpinnerWhileMatch",false);
                    }
                    else{
                        component.set("v.refreshScreen",component.get("v.refreshScreen")?false:true);
                    }
                }else
                    console.log('Error--->'+JSON.stringify(response.getError()));
            });
            $A.enqueueAction(action);
        }
    },
    updateProdWithNewPropUnits : function(component, event, helper){
        var totalProposedUnits =parseInt(component.get("v.ProposedDirectSellingUnits"))+parseInt(component.get("v.ProposedIndirectSellingUnits"))
        +parseInt(component.get("v.VisionProposedOSUnits"))+parseInt(component.get("v.VisionProposedRADUnits"))+parseInt(component.get("v.VisionProposedWMTUnits"))
        +parseInt(component.get("v.VisionProposedBASEUnits"))+parseInt(component.get("v.VisionProposedDSHUnits"))+parseInt(component.get("v.VisionProposedAutoSubUnits"))
        +parseInt(component.get("v.VisionProposedSmithDrugUnits"))+parseInt(component.get("v.VisionProposedAndaUnits"))+parseInt(component.get("v.VisionProposedDirectAholdDelhaizeUnits"))
        +parseInt(component.get("v.VisionProposedDirectGaintEagleUnits"))+parseInt(component.get("v.VisionProposedTotalRetailIndirectUnits"))+parseInt(component.get("v.VisionProposedDirectESIUnits"))
        +parseInt(component.get("v.VisionProposedIndirectESIUnits"))+parseInt(component.get("v.VisionProposedDirectKrogerUnits"))+parseInt(component.get("v.VisionProposedIndirectKrogerUnits"))
        +parseInt(component.get("v.VisionProposedDirectRxOutreachUnits"))+parseInt(component.get("v.VisionProposedIndirectRxOutreachUnits"))+parseInt(component.get("v.VisionProposedDirectSupervaluUnits"))
        +parseInt(component.get("v.VisionProposedIndirectSupervaluUnits"))+parseInt(component.get("v.VisionProposedDirectCignaUnits"))+parseInt(component.get("v.VisionProposedIndirectCignaUnits"))
        +parseInt(component.get("v.VisionProposedDirectCordantUnits"))+parseInt(component.get("v.VisionProposedDirectAccerodoUnits"))+parseInt(component.get("v.VisionProposedIndirectAccerodoUnits"))
        +parseInt(component.get("v.VisionProposedIndirectCordantUnits"))+parseInt(component.get("v.VisionProposedCVSDirectUnits"))+parseInt(component.get("v.VisionProposedCVSIndirectUnits"))
        +parseInt(component.get("v.VisionProposedCardinalUnits"))+parseInt(component.get("v.VisionProposedMajorUnits"));
        component.set("v.totalProposedUnits",totalProposedUnits);
        
        var prodOptyObj=component.get("v.prodOptyObj");
        console.log('checked====='+prodOptyObj.isSelected);
        console.log('checkedProdOptyId====='+prodOptyObj.Id);
        if(component.get("v.isValidPkgSize") && component.get("v.useNewFields")&& prodOptyObj.isSelected){
            prodOptyObj.Vision_Uploaded_Pkg_Size__c = parseInt(prodOptyObj.Vision_Disc_Pkg_Size__c);
            prodOptyObj.Proposed_Direct_Selling_Units__c = component.get("v.ProposedDirectSellingUnits");
            console.log('Proposed_Direct_Selling_Units__c------'+prodOptyObj.Proposed_Direct_Selling_Units__c);
            prodOptyObj.Proposed_Indirect_Selling_Units__c = component.get("v.ProposedIndirectSellingUnits");
            console.log('Proposed_Indirect_Selling_Units__c------'+prodOptyObj.Proposed_Indirect_Selling_Units__c);
            prodOptyObj.Vision_Proposed_OS_Units__c = component.get("v.VisionProposedOSUnits");   
            prodOptyObj.Vision_Proposed_RAD_Units__c = component.get("v.VisionProposedRADUnits");   
            prodOptyObj.Vision_Proposed_WMT_Units__c = component.get("v.VisionProposedWMTUnits");   
            prodOptyObj.Vision_Proposed_BASE_Units__c = component.get("v.VisionProposedBASEUnits");   
            prodOptyObj.Vision_Proposed_DSH_Units__c = component.get("v.VisionProposedDSHUnits");   
            prodOptyObj.Vision_Proposed_AutoSub_Units__c = component.get("v.VisionProposedAutoSubUnits");   
            prodOptyObj.Vision_Proposed_Smith_Drug_Units__c = component.get("v.VisionProposedSmithDrugUnits");   
            prodOptyObj.Vision_Proposed_Anda_Units__c = component.get("v.VisionProposedAndaUnits");   
            prodOptyObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = component.get("v.VisionProposedDirectAholdDelhaizeUnits");   
            prodOptyObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = component.get("v.VisionProposedDirectGaintEagleUnits");   
            prodOptyObj.Vision_Proposed_TotalRetailIndirectUnits__c = component.get("v.VisionProposedTotalRetailIndirectUnits");   
            
            prodOptyObj.Vision_Proposed_Direct_ESI_Units__c = component.get("v.VisionProposedDirectESIUnits");   
            prodOptyObj.Vision_Proposed_Indirect_ESI_Units__c = component.get("v.VisionProposedIndirectESIUnits");   
            prodOptyObj.Vision_Proposed_Direct_Kroger_Units__c = component.get("v.VisionProposedDirectKrogerUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Kroger_Units__c = component.get("v.VisionProposedIndirectKrogerUnits");   
            prodOptyObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = component.get("v.VisionProposedDirectRxOutreachUnits");   
            prodOptyObj.Vision_Proposed_IndirectRxOutreach_Units__c = component.get("v.VisionProposedIndirectRxOutreachUnits");   
            prodOptyObj.Vision_Proposed_Direct_Supervalu_Units__c = component.get("v.VisionProposedDirectSupervaluUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Supervalu_Units__c = component.get("v.VisionProposedIndirectSupervaluUnits");   
            prodOptyObj.Vision_Proposed_Direct_Cigna_Units__c = component.get("v.VisionProposedDirectCignaUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Cigna_Units__c = component.get("v.VisionProposedIndirectCignaUnits");   
            prodOptyObj.Vision_Proposed_Direct_Cordant_Units__c = component.get("v.VisionProposedDirectCordantUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Cordant_Units__c = component.get("v.VisionProposedIndirectCordantUnits");    
            prodOptyObj.Vision_Proposed_Direct_Accerodo_Units__c = component.get("v.VisionProposedDirectAccerodoUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Accerodo_Units__c = component.get("v.VisionProposedIndirectAccerodoUnits");   
            
            prodOptyObj.Vision_Proposed_CVS_Direct_Units__c = component.get("v.VisionProposedCVSDirectUnits");   
            prodOptyObj.Vision_Proposed_CVS_Indirect_Units__c = component.get("v.VisionProposedCVSIndirectUnits");   
            prodOptyObj.Vision_Proposed_Cardinal_Units__c = component.get("v.VisionProposedCardinalUnits");    
            prodOptyObj.Vision_Proposed_Major_Units__c = component.get("v.VisionProposedMajorUnits"); 
            prodOptyObj.Vision_Total_Annual_Units__c = component.get("v.totalProposedUnits");
            prodOptyObj.Vision_isNewProposedUnits__c=component.get("v.useNewFields");
            prodOptyObj.isFromInputChange=true;
            console.log('isFromInputChange------'+prodOptyObj.isFromInputChange);
            var compEvent = component.getEvent("visionPartialMatchEvent");
            compEvent.setParams({"productOpty" : prodOptyObj
                                })
            compEvent.fire();
        }
        
    },
    checkBoxChangeHandler:function(component, event, helper){
        
        var prodOptyObj=component.get("v.prodOptyObj");
        //console.log('checked====='+prodOptyObj.isSelected);
        console.log('checkedProdOptyId====='+prodOptyObj.Id);
        if(component.get("v.isValidPkgSize") && component.get("v.useNewFields")){
            prodOptyObj.Vision_Uploaded_Pkg_Size__c = parseInt(prodOptyObj.Vision_Disc_Pkg_Size__c);
            prodOptyObj.Proposed_Direct_Selling_Units__c = component.get("v.ProposedDirectSellingUnits");
            console.log('Proposed_Direct_Selling_Units__c------'+prodOptyObj.Proposed_Direct_Selling_Units__c);
            
            prodOptyObj.Proposed_Indirect_Selling_Units__c = component.get("v.ProposedIndirectSellingUnits");
            console.log('Proposed_Indirect_Selling_Units__c------'+prodOptyObj.Proposed_Indirect_Selling_Units__c);
            prodOptyObj.Vision_Proposed_OS_Units__c = component.get("v.VisionProposedOSUnits");   
            prodOptyObj.Vision_Proposed_RAD_Units__c = component.get("v.VisionProposedRADUnits");   
            prodOptyObj.Vision_Proposed_WMT_Units__c = component.get("v.VisionProposedWMTUnits");   
            prodOptyObj.Vision_Proposed_BASE_Units__c = component.get("v.VisionProposedBASEUnits");   
            prodOptyObj.Vision_Proposed_DSH_Units__c = component.get("v.VisionProposedDSHUnits");   
            prodOptyObj.Vision_Proposed_AutoSub_Units__c = component.get("v.VisionProposedAutoSubUnits");   
            prodOptyObj.Vision_Proposed_Smith_Drug_Units__c = component.get("v.VisionProposedSmithDrugUnits");   
            prodOptyObj.Vision_Proposed_Anda_Units__c = component.get("v.VisionProposedAndaUnits");   
            prodOptyObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = component.get("v.VisionProposedDirectAholdDelhaizeUnits");   
            prodOptyObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = component.get("v.VisionProposedDirectGaintEagleUnits");   
            prodOptyObj.Vision_Proposed_TotalRetailIndirectUnits__c = component.get("v.VisionProposedTotalRetailIndirectUnits");   
            
            prodOptyObj.Vision_Proposed_Direct_ESI_Units__c = component.get("v.VisionProposedDirectESIUnits");   
            prodOptyObj.Vision_Proposed_Indirect_ESI_Units__c = component.get("v.VisionProposedIndirectESIUnits");   
            prodOptyObj.Vision_Proposed_Direct_Kroger_Units__c = component.get("v.VisionProposedDirectKrogerUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Kroger_Units__c = component.get("v.VisionProposedIndirectKrogerUnits");   
            prodOptyObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = component.get("v.VisionProposedDirectRxOutreachUnits");   
            prodOptyObj.Vision_Proposed_IndirectRxOutreach_Units__c = component.get("v.VisionProposedIndirectRxOutreachUnits");   
            prodOptyObj.Vision_Proposed_Direct_Supervalu_Units__c = component.get("v.VisionProposedDirectSupervaluUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Supervalu_Units__c = component.get("v.VisionProposedIndirectSupervaluUnits");   
            prodOptyObj.Vision_Proposed_Direct_Cigna_Units__c = component.get("v.VisionProposedDirectCignaUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Cigna_Units__c = component.get("v.VisionProposedIndirectCignaUnits");   
            prodOptyObj.Vision_Proposed_Direct_Cordant_Units__c = component.get("v.VisionProposedDirectCordantUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Cordant_Units__c = component.get("v.VisionProposedIndirectCordantUnits");    
            prodOptyObj.Vision_Proposed_Direct_Accerodo_Units__c = component.get("v.VisionProposedDirectAccerodoUnits");   
            prodOptyObj.Vision_Proposed_Indirect_Accerodo_Units__c = component.get("v.VisionProposedIndirectAccerodoUnits");   
            
            prodOptyObj.Vision_Proposed_CVS_Direct_Units__c = component.get("v.VisionProposedCVSDirectUnits");   
            prodOptyObj.Vision_Proposed_CVS_Indirect_Units__c = component.get("v.VisionProposedCVSIndirectUnits");   
            prodOptyObj.Vision_Proposed_Cardinal_Units__c = component.get("v.VisionProposedCardinalUnits");    
            prodOptyObj.Vision_Proposed_Major_Units__c = component.get("v.VisionProposedMajorUnits"); 
            prodOptyObj.Vision_Total_Annual_Units__c = component.get("v.totalProposedUnits");
            prodOptyObj.Vision_isNewProposedUnits__c=component.get("v.useNewFields");
        }
        console.log('isFromInputChange-Fromcheckbox-----'+prodOptyObj.isFromInputChange);
        var compEvent = component.getEvent("visionPartialMatchEvent");
        //compEvent.setParams({"optyProductId" : prodOptyObj.Id,
        //"checked":prodOptyObj.isSelected});
        compEvent.setParams({"productOpty" : prodOptyObj})
        compEvent.fire();
    },
    
    openCalcdirUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirUnitsCalc');
    },
    openCalcIndirUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'inDirUnitsCalc');
        helper.getDupItems(component, event, helper, 'inDirUnitsCalc');
    },
    openCalcOsUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'osUnitsCalc');
        helper.getDupItems(component, event, helper, 'osUnitsCalc');
    },
    openCalcRadUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'radUnitsCalc');
        helper.getDupItems(component, event, helper, 'radUnitsCalc');
    },
    openCalcWmtUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'WmtUnitsCalc');
        helper.getDupItems(component, event, helper, 'WmtUnitsCalc');
    },
    openCalcBasUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'BasUnitsCalc');
        helper.getDupItems(component, event, helper, 'BasUnitsCalc');
    },
    openCalcDshUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'AutSubUnitsCalc');
        helper.getDupItems(component, event, helper, 'AutSubUnitsCalc');
    },
    openCalcAutSubUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'AutSubUnitsCalc');
        helper.getDupItems(component, event, helper, 'AutSubUnitsCalc');
    },
    openCalcDvsDirUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'cvsDirUnitsCalc');
        helper.getDupItems(component, event, helper, 'cvsDirUnitsCalc');
    },
    openCalcCvsIndUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'cvsIndUnitsCalc');
        helper.getDupItems(component, event, helper, 'cvsIndUnitsCalc');
    },
    openCalcCarUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'CarUnitsCalc');
        helper.getDupItems(component, event, helper, 'CarUnitsCalc');
    },
    openCalcMajUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'majUnitsCalc');
        helper.getDupItems(component, event, helper, 'majUnitsCalc');
    },
    openCalcSmithUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'smithUnitsCalc');
        helper.getDupItems(component, event, helper, 'smithUnitsCalc');
    },
    openCalcAndaUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'andaUnitsCalc');
        helper.getDupItems(component, event, helper, 'andaUnitsCalc');
    },
    openCalcDirAhoUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirAhoUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirAhoUnitsCalc');
    },
    openCalcDirGEUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirGEUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirGEUnitsCalc');
    },
    openCalcRetIndUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'retIndUnitsCalc');
        helper.getDupItems(component, event, helper, 'retIndUnitsCalc');
    },
    openCalcDirEsiUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirEsiUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirEsiUnitsCalc');
    },
    openCalcIndEsiUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'IndEsiUnitsCalc');
        helper.getDupItems(component, event, helper, 'IndEsiUnitsCalc');
    },
    openCalcDirKroUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirKroUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirKroUnitsCalc');
    },
    openCalcIndKroUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'indKroUnitsCalc');
        helper.getDupItems(component, event, helper, 'indKroUnitsCalc');
    },
    openCalcDirRxUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirRxUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirRxUnitsCalc');
    },
    openCalcIndRxUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'indRxUnitsCalc');
        helper.getDupItems(component, event, helper, 'indRxUnitsCalc');
    },
    openCalcDirSupUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirSupUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirSupUnitsCalc');
    },
    openCalcIndSupUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'indSupUnitsCalc');
        helper.getDupItems(component, event, helper, 'indSupUnitsCalc');
    },
    openCalcDirCigUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirCigUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirCigUnitsCalc');
    },
    openCalcIndCigUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'indCigUnitsCalc');
        helper.getDupItems(component, event, helper, 'indCigUnitsCalc');
    },
    openCalcDirCorUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirCorUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirCorUnitsCalc');
    },
    openCalcIndCorUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'indCorUnitsCalc');
        helper.getDupItems(component, event, helper, 'indCorUnitsCalc');
    },
    openCalcDirAccUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'dirAccUnitsCalc');
        helper.getDupItems(component, event, helper, 'dirAccUnitsCalc');
    },
    openCalcIndAccUnits : function(component, event, helper){
        if(component.get("v.selectedCalUnits") != undefined)
            document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'indAccUnitsCalc');
        helper.getDupItems(component, event, helper, 'indAccUnitsCalc');
    },
    addedCalcUnits : function(component, event, helper){
        var calcList = component.get("v.calcItems");
        var totalCalcUnits = 0;
        calcList.forEach(function(obj){
            if(obj.isSelected)
                totalCalcUnits += parseInt(obj.unitsVal);
        });
        component.set("v.totalCalcUnits",totalCalcUnits);
    },
    
    saveCal : function(component, event, helper){
        var fieldItem = component.get("v.selectedCalUnits");
        console.log('fieldItem --> '+fieldItem);
        console.log('totalcal --> '+component.get("v.totalCalcUnits"));
        if(fieldItem == 'inDirUnitsCalc')
            component.set("v.ProposedIndirectSellingUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirUnitsCalc')
            component.set("v.ProposedDirectSellingUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'osUnitsCalc')
            component.set("v.VisionProposedOSUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'radUnitsCalc')
            component.set("v.VisionProposedRADUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'WmtUnitsCalc')
            component.set("v.VisionProposedWMTUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'BasUnitsCalc')
            component.set("v.VisionProposedBASEUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'DshUnitsCalc')
            component.set("v.VisionProposedDSHUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'AutSubUnitsCalc')
            component.set("v.VisionProposedAutoSubUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'cvsDirUnitsCalc')
            component.set("v.VisionProposedCVSDirectUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'cvsIndUnitsCalc')
            component.set("v.VisionProposedCVSIndirectUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'CarUnitsCalc')
            component.set("v.VisionProposedCardinalUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'majUnitsCalc')
            component.set("v.VisionProposedMajorUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'smithUnitsCalc')
            component.set("v.VisionProposedSmithDrugUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'andaUnitsCalc')
            component.set("v.VisionProposedAndaUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirAhoUnitsCalc')
            component.set("v.VisionProposedDirectAholdDelhaizeUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirGEUnitsCalc')
            component.set("v.VisionProposedDirectGaintEagleUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'retIndUnitsCalc')
            component.set("v.VisionProposedTotalRetailIndirectUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirEsiUnitsCalc')
            component.set("v.VisionProposedDirectESIUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'IndEsiUnitsCalc')
            component.set("v.VisionProposedIndirectESIUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirKroUnitsCalc')
            component.set("v.VisionProposedDirectKrogerUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'indKroUnitsCalc')
            component.set("v.VisionProposedIndirectKrogerUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirRxUnitsCalc')
            component.set("v.VisionProposedDirectRxOutreachUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'indRxUnitsCalc')
            component.set("v.VisionProposedIndirectRxOutreachUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirSupUnitsCalc')
            component.set("v.VisionProposedDirectSupervaluUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'indSupUnitsCalc')
            component.set("v.VisionProposedIndirectSupervaluUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirCigUnitsCalc')
            component.set("v.VisionProposedDirectCignaUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'indCigUnitsCalc')
            component.set("v.VisionProposedIndirectCignaUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirCorUnitsCalc')
            component.set("v.VisionProposedDirectCordantUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'indCorUnitsCalc')
            component.set("v.VisionProposedIndirectCordantUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'dirAccUnitsCalc')
            component.set("v.VisionProposedDirectAccerodoUnits",component.get("v.totalCalcUnits"));
        if(fieldItem == 'indAccUnitsCalc')
            component.set("v.VisionProposedIndirectAccerodoUnits",component.get("v.totalCalcUnits"));
        //var action = component.get('c.closeCal');
        //$A.enqueueAction(action);
        document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
    },
    
    closeCal : function(component, event, helper){
        document.getElementById(component.get("v.prodOptyObj").Id+''+component.get("v.selectedCalUnits")).style.display="none";
        component.set("v.selectedCalUnits",'');
    },
    
    onblur : function(component,event,helper){      
        component.set("v.listOfSearchResults", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    orderSearchKeyEntered: function(component, event, helper){
        var searchKey = event.target.value;
        console.log('searchKey:: '+searchKey);
        component.set("v.searchResultMessage",'');
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var action = component.get("c.getProductListSearch");
        action.setParams({
            searchKeyWord : searchKey,
            filterIds : component.get("v.existingProducts")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from getProductListSearch-->'+state);
            if(state == 'SUCCESS'){
                var respList = response.getReturnValue();
                if(respList.length == 0){
                    component.set("v.searchResultMessage",'There are No Products found...');
                }
                else{
                    component.set("v.listOfSearchResults",respList);
                }
            }else{
                console.log('Error--->'+JSON.stringify(response.getError()));
            }
            $A.util.addClass(component.find("mySpinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    },
    selectedRecordFromSearch : function(component, event, helper){
        var selectedPlanId = event.currentTarget.dataset.id;
        console.log('selectedPlanId --> '+selectedPlanId);
        var action = component.get("c.updateWithNewProdDesc");
        action.setParams({
            productId : selectedPlanId.replace('/',''),
            optyProd:component.get("v.prodOptyObj")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state updateWithNewProd-->'+state);
            if(state == 'SUCCESS'){
                var wrapperObj = response.getReturnValue();
                component.set("v.prodOptyObj",wrapperObj);
                var a = component.get('c.doInit');
                $A.enqueueAction(a);
            }else
                console.log('Error updateWithNewProd--->'+JSON.stringify(response.getError()));    
            
        });
        $A.enqueueAction(action);
    },
    removeProdLookup : function(component, event, helper){
        var action = component.get("c.removeProductLookup");
        var itemObj = component.get("v.prodItem");
        action.setParams({
            optyProdId : itemObj.Id
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from remove ---> '+state);
            if(state =='SUCCESS'){
                itemObj.Product__c = null;
                component.set("v.prodItem",itemObj);
                component.set("v.isSearchProd",true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
            }
            else{
                console.log('error ---> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    openSearchProd : function(component, event, helper){
        component.set("v.isSearchProdPro",true);
    },
    closeSearchProd : function(component, event, helper){
        component.set("v.isSearchProdPro",false);
    },
    onKeyUpHandler : function(component, event, helper){
        var searchKey = component.get("v.searchItemName");
        console.log('searchKey --> '+searchKey);
        if(searchKey.length > 5){
            var timer = component.get('v.timer');
            clearTimeout(timer);
            var timer = setTimeout(function(){
                var newlst = [];
                helper.searchHelperResults(component,event,helper)
                clearTimeout(timer);
                component.set('v.timer', null);
            }, 1500);
            component.set('v.timer', timer);
        }
    },
    onKeyDownHandler:function(component) {
        let timer = component.get("v.timer");
        clearTimeout(timer);
        component.set("v.timer", null);
    },
    handleSelectedProd : function(component, event, helper){
        var selectedProd = event.getSource().get("v.name");
        component.set("v.selectedProdIdFromSearch",selectedProd);
        var itemsList = component.get("v.listOfSearchResults");
        var finalList = [];
        itemsList.forEach(function(prd){
            prd.isSelected = prd.Id == selectedProd ? true : false;
            finalList.push(prd);
        });
        component.set("v.listOfSearchResults",finalList);
    },
    saveSelectedProd : function(component, event, helper){
        var selectedPrdId = component.get("v.selectedProdIdFromSearch");
        var action = component.get("c.updateWithNewProdDesc");
        action.setParams({
            productId : selectedPrdId,
            optyProdId:component.get("v.prodOptyObj").Id
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state updateWithNewProd-->'+state);
            if(state == 'SUCCESS'){
                component.set("v.refreshScreen",component.get("v.refreshScreen")?false:true);
                /*var wrapperObj = response.getReturnValue();
                component.set("v.prodOptyObj",wrapperObj);
                component.set("v.isSearchProdPro",false);
                var a = component.get('c.doInit');
                $A.enqueueAction(a);*/
            }else
                console.log('Error updateWithNewProd--->'+JSON.stringify(response.getError()));    
            
        });
        $A.enqueueAction(action);
    }
})