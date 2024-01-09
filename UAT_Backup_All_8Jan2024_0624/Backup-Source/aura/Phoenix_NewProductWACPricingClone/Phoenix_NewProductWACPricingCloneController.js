({
    doInit: function (component, event, helper) {
        component.set("v.showSpinnerSelProds", true);
        var Status = component.get("v.simpleRecord").Phoenix_Approval_Status__c;
        var recTypeName = component.get("v.simpleRecord").Phoenix_Bid_Type__c;
        component.set("v.bidType", recTypeName);
        if (Status == 'Closed') {
            component.set("v.isPopup", true);
            var action = component.get("c.getActiveBidProductFamilies");
            var opts = [];
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var resp = response.getReturnValue();
                                       component.set("v.activeBidProductFamilies", resp);
                                       for(var i=0;i< resp.length;i++){
                                           opts.push({"class": "optionClass", label: resp[i], value: resp[i]});
                                       }
                                       component.set("v.ProductFamilyOptions", opts);
                                   }
                               });
            var action1 = component.get("c.getProducts1");
            action1.setParams({
                'productFamily': component.get("v.simpleRecord.Phoenix_Product_Family__c")
            });
            action1.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    component.set("v.showSpinnerSelProds", false);
                    var resp = response.getReturnValue();
                    component.set("v.ProductList", resp);
                    component.set("v.allData", resp);
                    component.set("v.QLlist1", resp);
                    console.log('Response: '+JSON.stringify(resp));
                } else{
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            })
            $A.enqueueAction(action);
            $A.enqueueAction(action1);
        } else {
            component.set("v.showSpinnerSelProds", false);
            component.set("v.showProducts", false);
            component.set("v.isPopup", false);
            component.set("v.showSelectedProducts", false); 
            component.set("v.showModalHeader", false);
            component.set("v.showMessage", true);
        }
    },
    closeModal: function(component, event){
        component.set("v.isPopup", false);
        component.set("v.showProducts", false); 
        component.set("v.showSelectedProducts", false); 
        component.set("v.showModalHeader", false);
        component.set("v.noData", false);
        component.set("v.showMessage", false);


        let recordId = component.get("v.recordId");
        var selIds = component.get("v.selectedProductsIds");

        var alldata = component.get("v.allData");
        var UpdateAllData = [];
        for (var i = 0; i < alldata.length; i++) {
            if (selIds.includes(alldata[i].prdlist.Id)) {

                alldata[i].isSelected = false;
                UpdateAllData.push(alldata[i]);
            }

        }

        var selectedProducts = [];
        component.set("v.selectedProductsIds", selectedProducts);

        var getSelectedNumber = 0;
        //component.set("v.selectedRowsCount",getSelectedNumber);
        component.set("v.selectedCount", getSelectedNumber);
        var count = 0;
        for (var i = 0; i < alldata.length; i++) {
            if (alldata[i].isSelected == false) {
                count++;

            }

        }

        if (recordId != null && recordId != undefined && recordId != '') {
            // Go to record

            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: recordId,
                    actionName: "view"
                }
            }, false);
        }
    },
    selectAllCheckbox: function (component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.checked");
        var allRecords = component.get("v.allData");
        var updatedAllRecords = [];
        var updatedPageList = [];
        
        var ProductList = component.get("v.ProductList");
        var getSelectedNumber = component.get("v.selectedCount");
        
        var selIds = component.get("v.selectedProductsIds");
        for (var j = 0; j < ProductList.length; j++) {
            if (selectedHeaderCheck == true) {
                console.log('selectedHeaderCheck: true');
                ProductList[j].isSelected = selectedHeaderCheck;
                if (selIds.includes(ProductList[j].prdlist.Id)) {
                    console.log('Includes');
                    continue;
                } else{
                    console.log('Not Includes');
                }
                
                selIds.push(ProductList[j].prdlist.Id);
                
            } else {
                console.log('selectedHeaderCheck: false');
                
                const index = selIds.indexOf(ProductList[j].prdlist.Id);
                if (index > -1) {
                    selIds.splice(index, 1);
                }
                
                ProductList[j].isSelected = selectedHeaderCheck;
                var arry = component.get("v.QLlist1");
                
                if (arry != null && arry != undefined && arry != '') {
                    
                    
                    if (arry.length > 0) {
                        
                        for (var i = 0; i < arry.length; i++) {
                            if (arry[i].prdlist.Id === ProductList[j].prdlist.Id) {
                                arry.splice(i, 1);
                                
                            }
                        }
                        component.set("v.QLlist1", arry);
                        
                    }
                }
                
                
            }
            
        }
        helper.buildData(component, helper);
        
        component.set("v.selectedProductsIds", selIds);
        var selectedProdcount = component.get("v.selectedProductsIds").length;
        
        component.set("v.selectedCount", selectedProdcount);
        var count = component.get("v.selectedCount")
        if (count > 0) {
            component.set("v.showbutton", false);
        } else if (count == 0) {
            component.set("v.showbutton", true);
        }
        
    },
    checkBoxChangeHandler: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.checked");
        var selectedRec1 = event.getSource().get("v.name");
        
        
        var getSelectedNumber = component.get("v.selectedCount");
        var allProds = component.get("v.Allproduct");
        var selIds = [];
        
        if (selectedRec == true) {
            getSelectedNumber++;
            var selProds = component.get("v.selectedProductsIds");
            
            selIds = selProds;
            selIds.push(selectedRec1);
            var arry = component.get("v.QLlist1");
            
        } else {
            getSelectedNumber--;
            var selProds = component.get("v.selectedProductsIds");
            selIds = selProds;
            var prodId = event.getSource().get("v.name");
            
            const index = selIds.indexOf(prodId);
            if (index > -1) {
                selIds.splice(index, 1);
            }
            var arry = component.get("v.QLlist1");
            
            if (arry != null && arry != undefined && arry != '') {
                if (arry.length > 0) {
                    
                    for (var i = 0; i < arry.length; i++) {
                        if (arry[i].prdlist.Id === prodId) {
                            arry.splice(i, 1);
                            
                        }
                    }
                    component.set("v.QLlist1", arry);
                    
                }
            }
            
        }
        
        component.set("v.selectedProductsIds", selIds);
        component.set("v.selectedCount", getSelectedNumber);
        console.log('Selected Ids are::: '+selIds+' Selected Count::: '+getSelectedNumber);
        var count = component.get("v.selectedCount");
        if (count > 0) {
            component.set("v.showbutton", false);
        } else if (count == 0) {
            component.set("v.showbutton", true);
        }
        //helper.buildData(component, helper); 
    },
    
    processProducts: function (component, event, helper) {
        
        var wacN = component.get("v.simpleRecord.Phoenix_WAC_Price_for_New_Launch_Name__c");
        if (wacN == null || wacN == '' || wacN == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!!",
                "message": "Name is required"
            });
            toastEvent.fire();
        } else {
            component.set("v.showProducts", false);
            component.set("v.showSelectedProducts", true);
            component.set("v.showSpinnerSelProds", true);
            component.set('v.bidName', wacN);
            console.log('Name: '+wacN);
            component.set("v.isQLlistempty", false);
            var qt = component.get("v.QLlist1");
            var selReBidProductIds = [];
            
            for (var j = 0; j < qt.length; j++) {
                selReBidProductIds.push(qt[j].prdlist.Id);
            }
            var allProducts = component.get("v.allData");
            var selectedProductsIds = component.get("v.selectedProductsIds");
            console.log('Selected Product Ids:: '+selectedProductsIds);
            var data = [];
            var pData;
            for (let j = 0; j < allProducts.length; j++) {
                pData = allProducts[j];
                console.log('Product: '+JSON.stringify(pData));
                if (selectedProductsIds.includes(pData.prdlist.Id)) {
                    if (selReBidProductIds.includes(pData.prdlist.Id)) {
                        
                    }
                    
                    pData.isSelected = true;
                    data.push(pData);
                }
            }
            component.set("v.QLlist", data);
            console.log('Data::: '+JSON.stringify(data));
            component.set("v.showSpinnerSelProds", false);
            console.log('>>>>showSpinnerSelProds>>>>>' + component.get("v.showSpinnerSelProds"));
        }
    },
    removeDeletedRow: function (component, event, helper) {
        
        var selectedRec = event.getParam("recordIdToDelete");;
        
        var AllRowsList = component.get("v.QLlist");
        
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }
        
        for (let i = 0; i < AllRowsList.length; i++) {
            
            var pItem = AllRowsList[i];
            
            if (pItem.prdlist.Id == selectedRec) {
                
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                    
                }
                
            }
        }
        
        component.set("v.QLlist", []);
        component.set("v.QLlist", AllRowsList);
        var countSelect = 0;
        for (let j = 0; j < AllRowsList.length; j++) {
            var pData = AllRowsList[j];
            if (pData.prdlist.Phoenix_SCM_Review__c == true) {
                countSelect++;
            }
            
        }
        
        if (AllRowsList.length === 0) {
            component.set("v.isQLlistempty", true);
        } else
            component.set("v.isQLlistempty", false);
        
        
        var saveditems = component.get("v.QLlist");
        var productList = component.get("v.ProductList");
        var alldata = component.get("v.allData");
        
        var prdlist1 = [];
        component.set("v.selectedProductsIds", []);
        
        var count = 0;
        
        
        if (AllRowsList != undefined && AllRowsList != null && AllRowsList != '' && AllRowsList.length > 0) {
            
            for (let i = 0; i < AllRowsList.length; i++) {
                
                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].prdlist.Id == AllRowsList[i].prdlist.Id) {
                        count = count + 1;
                        alldata[j].isSelected = true;
                        
                        prdlist1.push(alldata[j].prdlist.Id);
                        break;
                    }
                }
                
            }
        }
        
        component.set("v.selectedCount", count);
        if (count == 0)
            component.set("v.showbutton", true);
        else
            component.set("v.showbutton", false);
        
        component.set("v.selectedProductsIds", prdlist1);
        
        helper.buildData(component, helper);
    },
    ShowProdList: function (component, event, helper) {
        component.set("v.showProducts", true);
        component.set("v.showSelectedProducts", false);
        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);
    },
    duplicateBid: function (component, event, helper) {
        component.set("v.showSpinnerSelProds1",true);
        
        var recId = component.get("v.recordId");
        console.log('>>>>recId>>>>>' + recId);
        var bidName = component.get("v.bidName");
        
        
        var allData = component.get("v.allData");
        var bidlines = [];
        var listOfData = [];
        for (var x = 0; x < allData.length; x++) {
            var pData = allData[x];
            if (pData) {
                if (pData.isSelected == true){
                    console.log('PData: '+JSON.stringify(pData));
                    var rec = {};
                    rec.Phoenix_Brand_WAC__c = pData.prdlist.Phoenix_Brand_WAC__c;
                    rec.Phoenix_Lowest_Price__c = pData.prdlist.Phoenix_Lowest_Price__c;
                    rec.Phoenix_NDC_11__c = pData.prdlist.Phoenix_NDC_11__c;
                    rec.Phoenix_Pkg_Size__c = pData.prdlist.Phoenix_Pkg_Size__c;
                    rec.Phoenix_TPT_GM__c = pData.prdlist.Phoenix_TPT_GM__c;
                    rec.Phoenix_Product__c = pData.prdlist.Id;
                    rec.Phoenix_Material_Number__c = pData.prdlist.ProductCode;
                    rec.Phoenix_WAC__c = pData.prdlist.Phoenix_WAC1__c;
                    console.log('Record: '+JSON.stringify(rec));
                    listOfData.push(rec);
                    bidlines.push(pData.prdlist);
                }
            }
        }
        var isValid = false;
        if(listOfData!= null || listOfData != ''){
            for(var i=0; i<listOfData.length; i++){
                if(listOfData[i].Phoenix_WAC__c == '' || listOfData[i].Phoenix_WAC__c == null || listOfData[i].Phoenix_WAC__c == undefined
                   || listOfData[i].Phoenix_Lowest_Price__c == '' || listOfData[i].Phoenix_Lowest_Price__c == null || listOfData[i].Phoenix_Lowest_Price__c == undefined
                   || listOfData[i].Phoenix_TPT_GM__c == '' || listOfData[i].Phoenix_TPT_GM__c == null || listOfData[i].Phoenix_TPT_GM__c == undefined
                   || listOfData[i].Phoenix_Brand_WAC__c == '' || listOfData[i].Phoenix_Brand_WAC__c == null || listOfData[i].Phoenix_Brand_WAC__c == undefined){
                    helper.showToast({
                        "type": "error",
                        "message": 'Please enter WAC, Brand WAC, Lowest Price and Margin.'
                    });
                } else if(listOfData[i].Phoenix_WAC__c < listOfData[i].Phoenix_Lowest_Price__c){
                    helper.showToast({
                        "type": "warning",
                        "message": 'Lowest Price should not be greater than WAC.'
                    });  
                } else{
                    isValid = true;
                }   
            }
        }
        console.log('>>>>bidlines>>>>>' + JSON.stringify(bidlines));
        console.log('>>>>listOfData>>>>>' + JSON.stringify(listOfData));
        if(isValid){

            var DupAction = component.get("c.processRebid");
            DupAction.setParams({
                bidId: recId,
                SelectedbidLIItem: listOfData,
                reBidName: bidName
            });
            
            DupAction.setCallback(this, function (dupres) {
                console.log('===duplicate state======' + dupres.getState());
                var dupState = dupres.getState();
                var reslist = dupres.getReturnValue();
                console.log('===duplicate respones result======' + JSON.stringify(reslist));
                if (dupState === "SUCCESS") {
                    if (reslist[0] == "false") {
                        helper.showToast({
                            "type": "success",
                            "message": 'Rebid record create successfully.'
                        });
                        
                        /*var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": reslist[1],
                            "slideDevName": "detail"
                        });
                        navEvt.fire();*/
                        component.find("navigationService").navigate({
                            type: "standard__component",
                            attributes: {
                                componentName: "c__Phoenix_New_Product_WAC_Pricing" },
                            state: {
                                c__recordId: reslist[1]
                                
                            }
                        }, true); // replace = true
                    } else if (reslist[0] == "true") {
                        helper.showToast({
                            "title": "Error!!",
                            "type": "error",
                            "message": reslist[1]
                        });
                    }
                    component.set("v.showSpinnerSelProds1",false);
                    
                } else {
                    component.set("v.showSpinnerSelProds1",false);
                    console.log('>>>>>> Error >>>>>>>>>>', dupres.getError()[0].message);
                    var errors = dupres.getError();
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": errors[0].message
                    });
                }
                
            });
            
            $A.enqueueAction(DupAction);
        } else{
            component.set("v.showSpinnerSelProds1",false);
        }
    },
})