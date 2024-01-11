({
    
    
    
    pageReferenceChangeHandler: function(component, event, helper){
        
        let pageReference = component.get("v.pageReference");
        
        let recordId = pageReference.state.c__recordId;
        
        component.set("v.recordId",recordId);
        
        
        if (recordId != null && recordId!=undefined && recordId!='') {
            helper.getBidDetails(component, helper);  
            /*Selected records count*/
            var action = component.get("c.showselectedProducts");
            action.setParams({ "bidId": component.get("v.recordId") });
            action.setCallback(this, function (response) {
                var actState = response.getState();
                console.log('actState' + actState)
                if (actState === 'SUCCESS') {
                    var resposeData = response.getReturnValue();
                    component.set("v.selectedProductsCount",resposeData.length);  
                    console.log('---count--'+resposeData.length);
                    //alert(component.get('v.selectedProductsCount'));
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    doInit : function(component,event,helper) {
        
          component.set("v.showSpinnerSelProds",true);
           component.set("v.showProducts",true);
        
        helper.getBidDetails(component, helper); 
        component.set("v.showSpinnerSelProds",false);
        component.set("v.selectedCount",0);
        component.set("v.selectedProductsCount",0);
        /*Selected records count*/
        var action = component.get("c.showselectedProducts");
        action.setParams({ "bidId": component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                var resposeData = response.getReturnValue();
                component.set("v.selectedProductsCount",resposeData.length);
                console.log('---count--'+resposeData.length);
                //alert(component.get('v.selectedProductsCount'));
            }
            
        });
        $A.enqueueAction(action);           
    },
    openImportModal: function (component, event, helper) {
        component.set("v.showImportModal",true);  
    },
    
    onsearchFamily: function (component, event, helper) {
        console.log('on search family--')
        component.set("v.noData",false);
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList = component.get("v.RxSrxList");
        console.log('searchFamily--->'+searchFamily)
        console.log('searchName--->'+searchName)
        console.log('SearchKeyWordPD--->'+SearchKeyWordPD)
        console.log('RxSrxList--->'+RxSrxList)
        if(searchFamily!=null && searchFamily!='' && searchFamily!=undefined){
            helper.onsearchFamilyhelper(component,helper);   
        }
        else if(searchName!=null && searchName!='' && searchName!=undefined){
            helper.searchTablehelper(component,helper);
        }
            else if(SearchKeyWordPD.length>0){
                helper.onsearchDirectorhelper(component,helper);   
            }
                else if(RxSrxList.length>0){
                    helper.searchTablehelper(component, helper);   
                }
        
        
        
        //component.set("v.showProducts",false);  
    },
    closeImportPopup:function(component,event,helper){
        component.set("v.showImportModal",false); 
        component.set("v.hasFile",false); 
        var count=0;
        component.set("v.TotalRecords",count); 
        component.set("v.SuccessRecords",count); 
        component.set("v.FailureRecords",count); 
        component.set("v.duplicateRecords",count); 
        component.set("v.ndcCount",count); 
        component.set("v.upcCount",count); 
        component.find("file").set('v.value','');
        
        
        
    },
    showfiledata: function (component, event, helper) 
    {
        console.log('method start'+Date.now());
        var currentrecID=component.get("v.recordId");
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if (file)
        {
            
            component.set('v.hasFile',true);
            component.set('v.showImportSpinner',true);
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) 
            {
                var csv = evt.target.result;
                
                var arr = []; 
                arr =  csv.split('\n');
                console.log('array elements before'+JSON.stringify(arr));
                console.log('array length before'+arr.length);
                // arr.pop();
                arr = arr.filter(Boolean);
                
                console.log('array elements'+JSON.stringify(arr));
                console.log('array length'+arr.length);
                var jsonObj = [];
                var headers = arr[0].split(',');
                //alert('headers---'+headers);
                component.set("v.TotalRecords",arr.length-1);
                for(var i = 1; i < arr.length; i++)
                {
                    var data = arr[i].split(',');
                    var obj = {};
                    for(var j = 0; j < data.length; j++) 
                    {
                        console.log('array length1'+arr.length);
                        console.log('data[j]'+data[j]);
                        //data[j] = data[j].replace("\"","");
                        // data[j] = data[j].replace(","," ");
                        
                        if(data[j]!=undefined && data[j]!=null && data[j]!='' ){
                            obj[headers[j].trim()] = data[j].trim();
                            //jsonObj.push(customstring);
                        }
                        
                    }
                    jsonObj.push(obj);
                }
                var json = JSON.stringify(jsonObj);
                console.log('json13----'+json);
                //console.log('Date.now()'+Date.now());
                // *****************Calling Server side Action **********************
                var action = component.get('c.bidcountrecords');
                action.setParams({
                    strfromle : json,
                    bitid	  : currentrecID,
                    totalRecords: component.get("v.TotalRecords")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") 
                    {  
                        console.log('END Date.now()1'+Date.now()); 
                        var result=response.getReturnValue();
                        //var obj = result;
                        //obj=result;
                        //alert('bidcountrecords method is calling--'+result)    
                        /*var resultarr = [];
                resultarr =  result.split(',');
                component.set("v.SuccessRecords",resultarr[0]);
                component.set("v.duplicateRecords",resultarr[1]);
                component.set("v.FailureRecords",resultarr[2]);*/
                        component.set("v.SuccessRecords",result.successcount);
                        component.set("v.duplicateRecords",result.duplicatecount);
                        component.set("v.FailureRecords",result.failedreccount);
                        /*alert('wrpsuccesslist--1-----'+result.wrpsuccesslist);
                alert('wrpUnMatchedlist--1---'+result.wrpUnMatchedlist);
                alert('wrpDuplicateslist--1--'+result.wrpDuplicateslist);
                 alert('wrpsuccesslist--2-----'+result.wrpsuccesslist.length);*/
                        component.set("v.Successlist",result.wrpsuccesslist);
                        component.set("v.UnMatchedlist",result.wrpUnMatchedlist);
                        component.set("v.Duplicateslist",result.wrpDuplicateslist);
                        component.set("v.ndcCount",result.ndcListcount);
                        component.set("v.upcCount",result.upcListcount);
                        component.set('v.showImportSpinner',false);
                        
                        /*============working=================
                 var Successlistcmp= component.get("v.Successlist");
                alert('Successlistcmp----'+Successlistcmp);
                var successobj = {};
                successobj = Successlistcmp;
                for(var i in successobj)
                 alert(successobj[i].NDC11);*/
                        console.log('END Date.now()2'+Date.now()); 
                    }
                    else if (state === "ERROR")
                    {
                        component.set('v.showImportSpinner',false);
                        alert('bidcountrecords method is error') ;
                    }
                }); 
                
                $A.enqueueAction(action);  
                
            }
        }
    },
    showProductFormat: function (component, event, helper) {
        var currentrecID=component.get("v.recordId");
        
        
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        columnDivider = ',';
        lineDivider =  '\n';
        keys = ['NDC11','Proposed_direct_Selling_Unit ','Proposed_Indirect_Selling_Unit' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvStringResult);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'Bid Product Sample Format.csv';  // CSV file Name* you can change it.[only name not .csv]           document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": currentrecID,
            "slideDevName": "related"
        });
        // navEvt.fire();
    },
    SuccessRecordsdownload: function (component, event, helper) 
    {
        var currentrecID=component.get("v.recordId");
        var UnMatchedlistcmp= component.get("v.Successlist");
        var UnMatchedobj = {};
        UnMatchedobj = UnMatchedlistcmp;
        
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        columnDivider = ',';
        lineDivider =  '\n';
        keys = ['NDC11','Proposed_direct_Selling_Unit ','Proposed_Indirect_Selling_Unit' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        //alert('$$$$$'+UnMatchedobj.length);
        for(var i=0; i < UnMatchedobj.length; i++)
        {
            if(UnMatchedobj[i]["NDC11"]==undefined)UnMatchedobj[i]["NDC11"]='';
            //if(UnMatchedobj[i]["UPC"]==undefined)UnMatchedobj[i]["UPC"]='';
            if(UnMatchedobj[i]["Proposed_direct_Selling_Unit"]==undefined)UnMatchedobj[i]["Proposed_direct_Selling_Unit"]='';
            if(UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"]==undefined)UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"]='';
            csvStringResult += UnMatchedobj[i]["NDC11"]+','+UnMatchedobj[i]["Proposed_direct_Selling_Unit"]+','+UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"];
            //+','+UnMatchedobj[i]['UPC']+; 
            
            csvStringResult += lineDivider;
        }
        
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvStringResult);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'Matching Records.csv';  // CSV file Name* you can change it.[only name not .csv]           document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": currentrecID,
            "slideDevName": "related"
        });
        // navEvt.fire();
        
    },
    duplicateRecords: function (component, event, helper) 
    {
        var currentrecID=component.get("v.recordId");
        var UnMatchedlistcmp= component.get("v.Duplicateslist");
        var UnMatchedobj = {};
        UnMatchedobj = UnMatchedlistcmp;
        
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        columnDivider = ',';
        lineDivider =  '\n';
        keys = ['NDC11','Proposed_direct_Selling_Unit ','Proposed_Indirect_Selling_Unit' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        //alert('$$$$$'+UnMatchedobj.length);
        for(var i=0; i < UnMatchedobj.length; i++)
        {
            if(UnMatchedobj[i]["NDC11"]==undefined)UnMatchedobj[i]["NDC11"]='';
            //if(UnMatchedobj[i]["UPC"]==undefined)UnMatchedobj[i]["UPC"]='';
            if(UnMatchedobj[i]["Proposed_direct_Selling_Unit"]==undefined)UnMatchedobj[i]["Proposed_direct_Selling_Unit"]='';
            if(UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"]==undefined)UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"]='';
            csvStringResult += UnMatchedobj[i]["NDC11"]+','+UnMatchedobj[i]["Proposed_direct_Selling_Unit"]+','+UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"];
            //+','+UnMatchedobj[i]['UPC']+; 
            
            csvStringResult += lineDivider;
        }
        
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvStringResult);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'duplicateRecords.csv';  // CSV file Name* you can change it.[only name not .csv]           document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": currentrecID,
            "slideDevName": "related"
        });
        // navEvt.fire();
        
    },
    FailureRecords: function (component, event, helper) 
    {
        var currentrecID=component.get("v.recordId");
        var UnMatchedlistcmp= component.get("v.UnMatchedlist");
        var UnMatchedobj = {};
        UnMatchedobj = UnMatchedlistcmp;
        
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        columnDivider = ',';
        lineDivider =  '\n';
        keys = ['NDC11','Proposed_direct_Selling_Unit ','Proposed_Indirect_Selling_Unit' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        //alert('$$$$$'+UnMatchedobj.length);
        for(var i=0; i < UnMatchedobj.length; i++)
        {
            if(UnMatchedobj[i]["NDC11"]==undefined)UnMatchedobj[i]["NDC11"]='';
            //if(UnMatchedobj[i]["UPC"]==undefined)UnMatchedobj[i]["UPC"]='';
            if(UnMatchedobj[i]["Proposed_direct_Selling_Unit"]==undefined)UnMatchedobj[i]["Proposed_direct_Selling_Unit"]='';
            if(UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"]==undefined)UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"]='';
            csvStringResult += UnMatchedobj[i]["NDC11"]+','+UnMatchedobj[i]["Proposed_direct_Selling_Unit"]+','+UnMatchedobj[i]["Proposed_Indirect_Selling_Unit"];
            //+','+UnMatchedobj[i]['UPC']+; 
            
            csvStringResult += lineDivider;
        }
        
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvStringResult);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'UnMatched Records.csv';  // CSV file Name* you can change it.[only name not .csv]           document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": currentrecID,
            "slideDevName": "related"
        });
        // navEvt.fire();
        
    },
    SuccessRecords: function (component, event, helper) 
    {   
        if(component.get("v.hasFile")){
            var wrap=component.get("v.wrap");
            var currentrecID=component.get("v.recordId");
            var Successlistcmp= component.get("v.Successlist");
            var selectedCon = component.get('v.selectedCntrcts');
            var successobj = {};
            successobj = Successlistcmp;
            //var jsonObj = [];
            //jsonObj.push(successobj);
            var json = JSON.stringify(successobj);
            //alert('json----'+json);
            // *****************Calling Server side Action **********************
            var action = component.get('c.insersuccesslist');
            
            action.setParams({
                strfromle : json,
                bitid	  : currentrecID,
                selectrcs: selectedCon,
                totalRecords:component.get("v.TotalRecords"),
                totalNDC: component.get("v.ndcCount"),
                totalUPC: component.get("v.upcCount")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") 
                {  
                    var result=response.getReturnValue();
                    component.set("v.showImportModal",false); 
                    component.set("v.hasFile",false); 
                    var count=0;
                    component.set("v.TotalRecords",count); 
                    component.set("v.SuccessRecords",count); 
                    component.set("v.FailureRecords",count); 
                    component.set("v.duplicateRecords",count); 
                    component.set("v.ndcCount",count); 
                    component.set("v.upcCount",count); 
                    component.find("file").set('v.value','');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'success',
                        "message": "New Line Items has been added successfully."
                    });
                    toastEvent.fire();
                    /*alert(result+' Records are Successfully Imported')
                 var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": currentrecID,
                    "slideDevName": "related"
                });
                navEvt.fire();*/
                    var urlEvent = $A.get("e.force:navigateToURL");
                    if(wrap.bid.Phoenix_Customer_Type__c=='Walgreens'||wrap.bid.Phoenix_Customer_Type__c=='ABC Progen'){
                        urlEvent.setParams({
                            "url": "/lightning/n/Walgreens_View?c__id="+currentrecID
                        }); 
                    }
                    else if(wrap.bid.Phoenix_Customer_Type__c=='Econdisc'){
                        urlEvent.setParams({
                            "url": "/lightning/n/Econdisc?c__id="+currentrecID
                        });
                    }
                    else if(wrap.bid.Phoenix_Customer_Type__c=='Humana Indirect retail'){
                        urlEvent.setParams({
                            "url": "/lightning/n/Humana?c__id="+currentrecID
                        });
                    }
                     else if(wrap.bid.Phoenix_Customer_Type__c=='Humana Indirect CII'){
                        urlEvent.setParams({
                            "url": "/lightning/n/Humana?c__id="+currentrecID
                        });
                    }
                        else if(wrap.bid.Phoenix_Customer_Type__c=='Sams Club'){
                            urlEvent.setParams({
                                "url": "/lightning/n/SamsClub?c__id="+currentrecID
                            });
                        }
                            else if(wrap.bid.Phoenix_Customer_Type__c=='Government Pricing'){
                                urlEvent.setParams({
                                    "url": "/lightning/n/GovernmentPricing?c__id="+component.get("v.recordId")
                                });
                            }
                                else if(wrap.bid.Phoenix_Customer_Type__c=='Net Indirect Pricing'){
                                    urlEvent.setParams({
                                        "url": "/lightning/n/NetIndirectView?c__id="+component.get("v.recordId")
                                    });
                                }
                                    else if(wrap.bid.Phoenix_Customer_Type__c=='RXSS'){
                                        urlEvent.setParams({
                                            "url": "/lightning/n/RXSS?c__id="+component.get("v.recordId")
                                        });
                                    }
                    
                                        else if(wrap.bid.Phoenix_Customer_Type__c=='BASE/DSH'){
                                            urlEvent.setParams({
                                                "url": "/lightning/n/DSH?c__id="+component.get("v.recordId")
                                            });
                                        }
                                            else if(wrap.bid.Phoenix_Customer_Type__c=='Costco'){
                                                urlEvent.setParams({
                                                    "url": "/lightning/n/Costco?c__id="+component.get("v.recordId")
                                                });
                                            }
                                                else if(wrap.bid.Phoenix_Customer_Type__c=='ABC Pharmagen'){
                                                    urlEvent.setParams({
                                                        "url": "/lightning/n/ABCPharmagen?c__id="+component.get("v.recordId")
                                                    });
                                                }
                                                    else if(wrap.bid.Phoenix_Customer_Type__c=='ClarusOne'){
                                                        urlEvent.setParams({
                                                            "url": "/lightning/n/ClarusOne?c__id="+component.get("v.recordId")
                                                        });
                                                    }
                    
                                                        else{console.log('test type--'+wrap.bid.Phoenix_Bid_Type__c);
                                                             
                                                             
                                                             if(wrap.bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
                                                                 urlEvent.setParams({
                                                                     "url": "/lightning/n/Bid_Floor_Price_Change?c__id="+currentrecID
                                                                 }); 
                                                             }
                                                             else if(wrap.bid.Phoenix_Bid_Type__c=='Direct Order Form Pricing Update'){
                                                                 urlEvent.setParams({
                                                                     "url": "/lightning/n/Direct_Order_Price_Update?c__id="+currentrecID
                                                                 }); 
                                                             }
                                                                 else if(wrap.bid.Phoenix_Bid_Type__c=='Short Dated OTB'  || wrap.bid.Phoenix_Bid_Type__c=='Platform Bid'){
                                                                     console.log('test type-******************************-'+wrap.bid.Phoenix_Bid_Type__c);
                                                                     urlEvent.setParams({
                                                                         "url": "/lightning/n/OneTimeBuy?c__id="+currentrecID
                                                                     }); 
                                                                 }
                                                                     //else if(wrap.bid.Phoenix_Bid_Type__c=='Pharma Bid OTB' || wrap.bid.Phoenix_Bid_Type__c=='Pharma Bid PO OTB'){
                                                                     else if(wrap.bid.Phoenix_Bid_Type__c=='Platform OTB' || wrap.bid.Phoenix_Bid_Type__c=='Platform PO OTB'){
                                                                         urlEvent.setParams({
                                                                             "url": "/lightning/n/Platform_OTB?c__id="+component.get("v.recordId")
                                                                         }); 
                                                                     }
                                                                     else if(wrap.bid.Phoenix_Bid_Type__c=='Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                                                                         urlEvent.setParams({
                                                                             "url": "/lightning/n/IODCustomerWAC?c__id="+component.get("v.recordId")
                                                                         }); 
                                                                     }else if(wrap.bid.Phoenix_is_OTC_Bid__c){
                                                                         urlEvent.setParams({
                                                                             "url": "/lightning/n/OTC_Template?c__id="+component.get("v.recordId")
                                                                         }); 
                                                                     }
                                                                     else{
                                                                         urlEvent.setParams({
                                                                             "url": "/lightning/n/Edit_Bid_Line_Items?c__id="+currentrecID
                                                                         }); 
                                                                     }
                                                            }
                    urlEvent.fire();
                    
                }
                else if (state === "ERROR")
                {
                    
                }
            }); 
            
            $A.enqueueAction(action);  
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": 'error',
                "message": "Please choose the file to add products."
            });
            toastEvent.fire();
        }
    },
    onsearch: function (component, event, helper) {
        
        component.set("v.noData",false);
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        console.log('searchName-------'+searchName);
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList = component.get("v.RxSrxList");
        
        //component.set("v.showSpinnerSelProds",true);
        if(searchName==null || searchName=='undefined' || searchName==''){
            if(searchName!=null && searchName!='undefined' && searchName!=''){
                helper.searchTablehelper(component,helper); 
            }
            else if(searchFamily!=null && searchFamily!='undefined' && searchFamily!=''){
                helper.onsearchFamilyhelper(component, helper);  
            }
                else if(SearchKeyWordPD.length>0){
                    helper.onsearchDirectorhelper(component,helper);   
                }
                    else if(RxSrxList.length>0){
                        helper.searchRx(component, helper);
                    }
                        else{
                            component.set("v.showSpinnerSelProds",true);
                            var resposeData=component.get("v.Allproduct");
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);  
                            component.set("v.showSpinnerSelProds",false);
                        }
        }
        // component.set("v.showSpinnerSelProds",false);
        
        
    },
    onsearchDirector: function (component, event, helper) {
        
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        console.log('SearchKeyWordPD----'+SearchKeyWordPD);
        if(SearchKeyWordPD!=null && SearchKeyWordPD!='' && SearchKeyWordPD!=undefined){
            
            helper.onsearchDirectorhelper(component,helper);   
        }
        
    },
    
    onchangeFamily:  function (component, event, helper) {
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        console.log('searchName-------'+searchName);
        component.set("v.noData",false);
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        console.log('searchFamily-------'+searchFamily);
        console.log('SearchKeyWordPD-------'+SearchKeyWordPD);
        var RxSrxList = component.get("v.RxSrxList");
        console.log('RxSrxList-------'+RxSrxList);
        if(searchFamily==null || searchFamily=='undefined' || searchFamily==''){
            if(searchName!=null && searchName!='undefined' && searchName!=''){
                helper.searchTablehelper(component,helper); 
            }
            else if(searchFamily!=null && searchFamily!='undefined' && searchFamily!=''){
                helper.onsearchFamilyhelper(component, helper);  
            }
                else if(SearchKeyWordPD.length>0){
                    helper.onsearchDirectorhelper(component,helper);   
                }
                    else if(RxSrxList.length>0){
                        helper.searchRx(component, helper);
                    }
                        else{
                            component.set("v.showSpinnerSelProds",true);
                            var resposeData=component.get("v.Allproduct");
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper); 
                            component.set("v.showSpinnerSelProds",false);
                        }
        }
        // component.set("v.showSpinnerSelProds",false);
        
        
        /*if (searchFamily=== null ||searchFamily === 'undefined' || searchFamily === ' '|| searchFamily === undefined ||searchFamily === ''){
        if (( searchName===null||  searchName==='undefined' ||searchName===' ' ||searchName===undefined || searchName==='') && (! SearchKeyWordPD.length>0)&& (! RxSrxList.length>0))
        {
            
           console.log('Hi');
                  var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper); 
                
        }   
        else 
        {
             console.log('Bye');
          helper.onsearchFamilyhelper(component, helper); 
            
            
        }
        }*/
        
        
    },
    
    searchTable: function (component, event, helper) {
        
        var searchName=component.get("v.searchText");
        if(searchName!=null && searchName!='' && searchName!=undefined){
            
            helper.searchTablehelper(component,helper);
        }
        
        
    },
    
    ShowProdList: function (component, event, helper) {
        
        component.set("v.showProducts", true);
        component.set("v.showSelectedProducts", false);
        
        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);
        
        
        
    },
    onblurProDir : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        var toggleclass = component.find("zvalue");      
        $A.util.addClass(toggleclass, "zindex");  
        component.set("v.listOfSearchPDRecords", null );
        component.set("v.SearchKeyWordPD", '');
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocusProdDir : function(component,event,helper){       
        // show the spinner,show child search result component and call helper function
        /* $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchPDRecords", null ); 
        var forOpen = component.find("searchResPD");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelperProdDir(component,event,getInputkeyWord);*/
    },    
    keyPressControllerProdDir : function(component, event, helper) {
        var toggleclass = component.find("zvalue");      
        $A.util.removeClass(toggleclass, "zindex"); 
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWordPD");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchResPD");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperProdDir(component,event,getInputkeyWord);
            console.log('getInputkeyWord if--->'+getInputkeyWord)
        }
        else{  
            component.set("v.listOfSearchPDRecords", null ); 
            var forclose = component.find("searchResPD");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },    
    // function for clear the Record Selaction 
    clearProdDir :function(component,event,helper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedPDRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedPDRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWordPD",null);
        //component.set("v.showSpinnerSelProds",true);
        component.set("v.listOfSearchPDRecords", null ); 
        component.set("v.noData",false);
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        console.log('searchName-------'+searchName);
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList = component.get("v.RxSrxList");
        if(!SearchKeyWordPD.length>0){
            
            if(searchName!=null && searchName!='undefined' && searchName!=''){
                helper.searchTablehelper(component,helper); 
            }
            else if(searchFamily!=null && searchFamily!='undefined' && searchFamily!=''){
                helper.onsearchFamilyhelper(component, helper);  
            }
                else if(SearchKeyWordPD.length>0){
                    helper.onsearchDirectorhelper(component,helper);   
                }
                    else if(RxSrxList.length>0){
                        helper.searchRx(component, helper);
                    }
                        else{
                            component.set("v.showSpinnerSelProds",true);
                            var resposeData=component.get("v.Allproduct");
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                            component.set("v.showSpinnerSelProds",false);
                        }
        }
        else{
            if(SearchKeyWordPD.length>0){
                helper.onsearchDirectorhelper(component,helper);   
            }   
        }
        
    }, 
    handleComponentEventProdDir : function(component, event, helper) {
        component.set("v.SearchKeyWordPD",null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedPDRecords");
        var selectedAccountGetFromEvent = event.getParam("PDrecordByEvent");       
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedPDRecords" , listSelectedItems); 
        
        var forclose = component.find("lookup-pill-PD");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    
    
    
    closeModal: function (component, event, helper) {
        component.set("v.showSelectedProducts", false);
        component.set("v.showProducts", false);
        component.set("v.noData",false);
       
       
        let recordId =component.get("v.recordId");
        var selIds=component.get("v.selectedProductsIds");
        var selIds2=component.get("v.selectedContId");
        var alldata=component.get("v.allData");
        var UpdateAllData=[];
        for(var i=0;i<alldata.length;i++){
            if (selIds.includes(alldata[i].prdlist.Id)) 
            {
                
                alldata[i].isSelected = false;
                UpdateAllData.push(alldata[i]);
            }
            
        }
        var alldata2=component.get("v.allDataCV");
        var UpdAllData=[];
        for(var i=0;i<alldata2.length;i++){
            if (selIds2.includes(alldata2[i].Id)) 
            {
                
                alldata2[i].isSelected = false;
                UpdAllData.push(alldata2[i]);
            }
            
        }
        component.set("v.allData",UpdateAllData);
        component.set("v.allDataCV",UpdAllData);
        var selectedProducts=[];
        component.set("v.selectedProductsIds",selectedProducts);
        component.set("v.selectedContId",[]);
        var getSelectedNumber = 0;
        component.set("v.selectedRowsCount",getSelectedNumber);
        component.set("v.selectedCount",getSelectedNumber);
        var count=0;
        var searchText='';
        component.set("v.isContractSelectionNeeded",false);
        component.set("v.isRxChecked",false);
        component.set("v.isSRxChecked",false);
        component.set("v.isOtcChecked",false);
        component.set("v.searchFamily",searchText);
        component.set("v.searchText",searchText);
        for(var i=0;i<alldata.length;i++){
            if (alldata[i].isSelected==false)
            {
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
    selectAllCheckbox : function (component, event, helper){
        var selectedHeaderCheck = event.getSource().get("v.checked");
        var allRecords=component.get("v.allData");
        var updatedAllRecords=[];
        var updatedPageList=[];
        
        var ProductList=component.get("v.ProductList");
        var getSelectedNumber = component.get("v.selectedCount");
        
        var selIds=component.get("v.selectedProductsIds");
        for(var j=0;j<ProductList.length;j++){
            if(selectedHeaderCheck==true){
                
                ProductList[j].isSelected=selectedHeaderCheck;
                if(selIds.includes(ProductList[j].prdlist.Id)){
                    continue; 
                }
                
                selIds.push(ProductList[j].prdlist.Id);
                
            }
            else{
                
                
                const index = selIds.indexOf(ProductList[j].prdlist.Id);
                if (index > -1) {
                    selIds.splice(index, 1);
                }
                
                ProductList[j].isSelected=selectedHeaderCheck;
                var arry = component.get("v.QLlist1");
                
                if(arry!=null && arry!=undefined && arry!=''){
                    
                    
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
        console.log('seleected ids-->'+component.get("v.selectedProductsIds").length)
        component.set("v.selectedProductsIds",selIds);
        var selectedProdcount=component.get("v.selectedProductsIds").length;
        
        component.set("v.selectedCount", selectedProdcount);
        var count = component.get("v.selectedCount")
        if (count > 0) {
            component.set("v.showbutton", false);
        }
        else if (count == 0) {
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
            
            
            
        }
        
        else {
            getSelectedNumber--;
            var selProds = component.get("v.selectedProductsIds");
            selIds = selProds;
            var prodId = event.getSource().get("v.name");
            
            const index = selIds.indexOf(prodId);
            if (index > -1) {
                selIds.splice(index, 1);
            }
            var arry = component.get("v.QLlist1");
            
            if(arry!=null && arry !=undefined && arry!=''){
                
                
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
        var count = component.get("v.selectedCount");
        if (count > 0) {
            component.set("v.showbutton", false);
        }
        else if (count == 0) {
            component.set("v.showbutton", true);
        }
        //helper.buildData(component, helper); 
    },
    
    processProducts: function (component, event, helper) {
        component.set("v.showProducts", false);
        //component.set("v.showSpinnerSelProds",true);
        component.set("v.showSelectedProducts", true);
        component.set("v.isQLlistempty",false);
        var allProducts=component.get("v.Allproduct");
        var selectedProductsIds = component.get("v.selectedProductsIds");
        console.log('selectedProductsIds are '+selectedProductsIds);
        console.log('allProducts are '+JSON.stringify(allProducts));
        
        var data=[];
        var pData;
        for(let j = 0; j < allProducts.length; j++){
            pData=allProducts[j];
            if (selectedProductsIds.includes(pData.prdlist.Id)) {
                
                pData.isSelected = true;
                data.push(pData); 
            }
            
        }
        
        component.set("v.QLlist",data);
        
    },
    
    
    
    insertProducts: function (component, event, helper) {
        
        component.set("v.showSpinnerSelProds",true);
        var quoteId =component.get("v.recordId");
        
        var  saveitems1=[];
        saveitems1=component.get("v.QLlist");
        
        // For Contracts View Code
        var selectedCon = component.get('v.selectedCntrcts');
        
        var action = component.get("c.savequoteitems");
        
        
        var wrap=component.get("v.wrap");
        
        
        action.setParams({ "saveitems": saveitems1, "bidWrapper": component.get("v.wrap"), selectrcs: selectedCon });
        
        action.setCallback(this, function (response) {
            
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                
                component.set("v.showSelectedProducts", false);
                component.set("v.showProducts", false);
                console.log('bid template==>'+wrap.bid.Phoenix_Customer_Type__c);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'success',
                    "message": "New Line Items has been added successfully."
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                
                
                /* var pageReference = {
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        objectApiName: "Phoenix_Bid__c",
                        actionName: "view"
                    }
                };
                var navService = component.find("navigationService");
                navService.navigate(pageReference);*/
				 var urlEvent = $A.get("e.force:navigateToURL");
                	
                    if(wrap.bid.Phoenix_Customer_Type__c=='Walgreens'||wrap.bid.Phoenix_Customer_Type__c=='ABC Progen'){
                        urlEvent.setParams({
                            "url": "/lightning/n/Walgreens_View?c__id="+component.get("v.recordId")
                        }); 
                    }  
                    else if(wrap.bid.Phoenix_Customer_Type__c=='Econdisc'){
                        urlEvent.setParams({
                            "url": "/lightning/n/Econdisc?c__id="+component.get("v.recordId")
                        });
                    }
                        else if(wrap.bid.Phoenix_Customer_Type__c=='Sams Club'){
                            urlEvent.setParams({
                                "url": "/lightning/n/SamsClub?c__id="+component.get("v.recordId")
                            });
                        }
                            else if(wrap.bid.Phoenix_Customer_Type__c=='Humana Indirect retail'){
                                urlEvent.setParams({
                                    "url": "/lightning/n/Humana?c__id="+component.get("v.recordId")
                                });
                            }
                                else if(wrap.bid.Phoenix_Customer_Type__c=='Humana Indirect CII'){
                                    urlEvent.setParams({
                                        "url": "/lightning/n/Humana?c__id="+component.get("v.recordId")
                                    });
                                }
                            else if(wrap.bid.Phoenix_Customer_Type__c=='Government Pricing'){
                                urlEvent.setParams({
                                    "url": "/lightning/n/GovernmentPricing?c__id="+component.get("v.recordId")
                                });
                            }
                                else if(wrap.bid.Phoenix_Customer_Type__c=='Net Indirect Pricing'){
                                    urlEvent.setParams({
                                        "url": "/lightning/n/NetIndirectView?c__id="+component.get("v.recordId")
                                    });
                                }
                                    else if(wrap.bid.Phoenix_Customer_Type__c=='RXSS'){
                                        urlEvent.setParams({
                                            "url": "/lightning/n/RXSS?c__id="+component.get("v.recordId")
                                        });
                                    }
                                        else if(wrap.bid.Phoenix_Customer_Type__c=='BASE/DSH'){
                                            urlEvent.setParams({
                                                "url": "/lightning/n/DSH?c__id="+component.get("v.recordId")
                                            });
                                        }
                                            else if(wrap.bid.Phoenix_Customer_Type__c=='Costco'){
                                                urlEvent.setParams({
                                                    "url": "/lightning/n/Costco?c__id="+component.get("v.recordId")
                                                });
                                            }
                                                else if(wrap.bid.Phoenix_Customer_Type__c=='ABC Pharmagen'){
                                                    urlEvent.setParams({
                                                        "url": "/lightning/n/ABCPharmagen?c__id="+component.get("v.recordId")
                                                    });
                                                }
                                                    else if(wrap.bid.Phoenix_Customer_Type__c=='ClarusOne'){
                                                        urlEvent.setParams({
                                                            "url": "/lightning/n/ClarusOne?c__id="+component.get("v.recordId")
                                                        });
                                                    }
                                                        else if(wrap.bid.Phoenix_Customer_Type__c=='ROS'){
                                                            urlEvent.setParams({
                                                                "url": "/lightning/n/ROS?c__id="+component.get("v.recordId")+"&c__fetchNprData=true"
                                                            });
                                                        }
                                                            else{console.log('test type--'+wrap.bid.Phoenix_Bid_Type__c);
                                                                 if(wrap.bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
                                                                     urlEvent.setParams({
                                                                         "url": "/lightning/n/Bid_Floor_Price_Change?c__id="+component.get("v.recordId")
                                                                     }); 
                                                                 }
                                                                 else if(wrap.bid.Phoenix_Bid_Type__c=='Direct Order Form Pricing Update'){
                                                                     urlEvent.setParams({
                                                                         "url": "/lightning/n/Direct_Order_Price_Update?c__id="+component.get("v.recordId")
                                                                     }); 
                                                                 }
                                                                     else if(wrap.bid.Phoenix_Bid_Type__c=='Short Dated OTB' || wrap.bid.Phoenix_Bid_Type__c=='Good Dated OTB'|| wrap.bid.Phoenix_Bid_Type__c=='One Time Buy Good Dated Shelf Life for New Product Launch' || wrap.bid.Phoenix_Bid_Type__c=='Platform Bid'){
                                                                         urlEvent.setParams({
                                                                             "url": "/lightning/n/OneTimeBuy?c__id="+component.get("v.recordId")
                                                                         }); 
                                                                     }
                                                                         //else if(wrap.bid.Phoenix_Bid_Type__c=='Pharma Bid OTB' || wrap.bid.Phoenix_Bid_Type__c=='Pharma Bid PO OTB'){
                                                                         else if(wrap.bid.Phoenix_Bid_Type__c=='Platform OTB' || wrap.bid.Phoenix_Bid_Type__c=='Platform PO OTB'){
                                                                             urlEvent.setParams({
                                                                                 "url": "/lightning/n/Platform_OTB?c__id="+component.get("v.recordId")
                                                                             }); 
                                                                         }else if(wrap.bid.Phoenix_is_OTC_Bid__c){
                                                                             urlEvent.setParams({
                                                                                 "url": "/lightning/n/OTC_Template?c__id="+component.get("v.recordId")
                                                                             }); 
                                                                         }
                                                                         else{
                                                                             urlEvent.setParams({
                                                                                 "url": "/lightning/n/Edit_Bid_Line_Items?c__id="+component.get("v.recordId")
                                                                             }); 
                                                                         }
                }
                //if(wrap.bid.Phoenix_Bid_Type__c=='Pharma Bid OTB' || wrap.bid.Phoenix_Bid_Type__c=='Pharma Bid PO OTB'){
                if(wrap.bid.Phoenix_Bid_Type__c=='Platform OTB' || wrap.bid.Phoenix_Bid_Type__c=='Platform PO OTB'){
                    urlEvent.setParams({
                        "url": "/lightning/n/Platform_OTB?c__id="+component.get("v.recordId")
                    }); 
                }
                if(wrap.bid.Phoenix_Bid_Type__c=='Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                    urlEvent.setParams({
                        "url": "/lightning/n/IODCustomerWAC?c__id="+component.get("v.recordId")
                    }); 
                }
                urlEvent.fire();
            }
            else{
                component.set("v.showSpinnerSelProds",false);
                console.log(':::: response failed from savequoteitems :::: EXCEPTION : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    removeDeletedRow: function (component, event, helper) {
        
        var selectedRec = event.getSource().get("v.name");
        
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
        
        component.set("v.QLlist",[]);
        component.set("v.QLlist", AllRowsList);
        
        if (AllRowsList.length === 0) {
            component.set("v.isQLlistempty", true);
        }
        else
            component.set("v.isQLlistempty", false);
        
        
        
        
        var saveditems = component.get("v.QLlist");
        var productList=component.get("v.ProductList");
        var alldata=component.get("v.allData");
        
        var prdlist1=[];
        component.set("v.selectedProductsIds",[]);
        
        var count=0;
        
        
        if(AllRowsList!=undefined && AllRowsList!=null && AllRowsList!='' && AllRowsList.length>0)
        {
            
            
            for (let i = 0; i < AllRowsList.length; i++) {
                
                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].prdlist.Id == AllRowsList[i].prdlist.Id)
                    {
                        
                        
                        count=count+1;
                        alldata[j].isSelected=true;
                        
                        prdlist1.push(alldata[j].prdlist.Id);
                        break;
                    }                                   
                }
                
            }
        }
        
        component.set("v.selectedCount",count);
        if(count==0)
            component.set("v.showbutton",true);
        else
            component.set("v.showbutton",false);
        
        component.set("v.selectedProductsIds",prdlist1);
        
        helper.buildData(component, helper);
    },
    
    onNext: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop=0;
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.buildData(component, helper);
    },
    
    onPrev: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop=0;
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.buildData(component, helper);
    },
    
    processMe: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop=0;
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop=0;
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop=0;
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    
    
    
    showSelectedproducts:function(component,event,helper){
        component.set("v.isModalOpen",true);
        
        var showselectedIds=component.get("v.selectedProductsIds");
        var alldata=component.get("v.allData");
        var modalProductList=[];
        
        var action = component.get("c.showselectedProducts");
        
        action.setParams({ "bidId": component.get("v.recordId") });
        
        action.setCallback(this, function (response) {
            
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                console.log('respose-------Data'+JSON.stringify(resposeData));
                component.set("v.modalProductList",resposeData);  
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    closePopup:function(component,event,helper){
        component.set("v.isModalOpen",false);    
    },
    sortProductName: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'ProductName');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Name');
    },
    
    sortProductCode: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'ProductCode');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'ProductCode');
    },
    
    sortProductFamily: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'ProductFamily');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Family');
    },
    sortProductDirector: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'ProductDirector');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_Product_Director__c');
    },
    
    sortGPI: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'GPI');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_GPI_Generic_Product_Identifier__c');
    },
    sortGCN: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'GCN');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_GCN_Generic_Code_Number__c');
    },
    
    
    sortNDC11: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'NDC11');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_NDC_11__c');
    },
    
    sortUPC: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'UPC');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_UPC_Universal_Product_Code__c');
    },
    sortStrength: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Strength');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Strength__c');
    },
    sortPackSize: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'PackSize');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Pkg_Size__c');
    },
    sortWAC: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'WAC');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_WAC__c');
    },
    sortBrandName: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'BrandName');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Compare_to_Brand_Name__c');
    },
    sortDiscontinuation: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Discontinuation');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Date_of_Discontinuation__c');
    },
    sortSupplyPlanner: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'SupplyPlanner');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Supply_Chain_Planner__r.Name');
    },
    searchSrxRxOttc : function(component,event,helper){
        helper.searchRx(component, helper);
    },
    
    // JS Controller for Contract View
    searchContracts: function(component, event, helper) {
        component.set("v.currentPage",1);
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");            
        var bidCustomerId=component.get("v.bidCustomerId");
        console.log('--bidCustomerId--'+bidCustomerId); 
        if(checkToggle==true){
            helper.fetchContratcs(component, event, helper, null, searchInput);
        }
        else{
            if(bidCustomerId != null && bidCustomerId != undefined){
                helper.fetchContratcs(component, event, helper, bidCustomerId, searchInput);
            }else{
                component.set("v.contratcsList",null);
            }
        }
        
    }, 
    
    showAllContracts: function(component, event, helper) {
        component.set("v.selectedRowsCount",0);
        component.set("v.currentPage",1);
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");
        console.log('--checkToggle--'+checkToggle); 
        var bCustomerId=component.get('v.bidCustomerId');
        console.log('--showAllContracts bCustomerId --'+bCustomerId);
        if(checkToggle==true){
            helper.fetchContratcs(component, event, helper, null, searchInput);
        }
        else{
            if(bCustomerId != null && bCustomerId != undefined){
                helper.fetchContratcs(component, event, helper, bCustomerId, searchInput);
            }else{
                component.set("v.PaginationList",null);
            }
        }
    },
    
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSizeCV");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'First' then call 'First' helper method
            else if (whichBtn == 'first') {
                var starting = pageSize;
                var lastPage = pageSize - 1;
                component.set("v.currentPage", 1);
                helper.previous(component, event, sObjectList, lastPage, starting, pageSize);
            }
        // check if whichBtn value is 'Last' then call 'Last' helper method
                else if (whichBtn == 'last') {
                    var tPageCount = component.get("v.totalPagesCount");
                    var starting = (tPageCount-2)* pageSize;
                    var lastPage = (tPageCount - 1)* pageSize - 1;
                    component.set("v.currentPage", component.get("v.totalPagesCount"));
                    helper.next(component, event, sObjectList, lastPage, starting, pageSize);
                }
        
        var curPage = component.get("v.currentPage");
        var totalPC = component.get("v.totalPagesCount");
        
        if(curPage == 1) component.set('v.isFirstPage', true);
        else component.set('v.isFirstPage', false);
        
        if(curPage == totalPC) component.set('v.isLastPage', true);
        else component.set('v.isLastPage', false);
        
        var elmnt = document.getElementById("tableDiv");
        elmnt.scrollTop=0;
        
        helper.getPaginationList(component, helper);
    },
    
    processMeCV: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var pageSize = component.get("v.pageSizeCV");
        var whichPage = event.target.name;
        var totalPC = component.get("v.totalPagesCount");
        var curPage = component.get('v.currentPage');
        console.log('totalPC::'+totalPC);
        
        if(whichPage == 1) component.set('v.isFirstPage', true);
        else component.set('v.isFirstPage', false);
        
        if(whichPage == totalPC) component.set('v.isLastPage', true);
        else component.set('v.isLastPage', false);
        
        component.set('v.isSelectedNo', whichPage);
        
        console.log('whichPage::'+whichPage);
        
        console.log('isSelectedNo::'+component.get('v.isSelectedNo'));
        
        if (whichPage) {
            var start = (whichPage - 1) * pageSize;
            var end = (start + pageSize) - 1;
            console.log('end::'+end);
            component.set('v.currentPage', parseInt(whichPage));
            helper.processPageNumber(component, event, sObjectList, end, start, pageSize);
        }
        var elmnt = document.getElementById("tableDiv");
        elmnt.scrollTop=0;
        
        helper.getPaginationList(component, helper);
    },
    
    selectAllCheckboxes: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        // play a for loop on all records list 
        /*for (var i = 0; i < listOfAllAccounts.length; i++) {
            // check if header checkbox is 'true' then update all checkbox with true and update selected records count
            // else update all records with false and set selectedCount with 0  
            if (selectedHeaderCheck == true) {
                listOfAllAccounts[i].isChecked = true;
                component.set("v.selectedRowsCount", listOfAllAccounts.length);
            } else {
                listOfAllAccounts[i].isChecked = false;
                component.set("v.selectedRowsCount", 0);
            }
            updatedAllRecords.push(listOfAllAccounts[i]);
        }*/
        // update the checkbox for 'PaginationList' based on header checbox 
        var selectedRowsCount = component.get("v.selectedRowsCount");
        var selectedContId = component.get('v.selectedContId');
        for (var i = 0; i < PaginationList.length; i++) {
            console.log('PaginationList length::'+PaginationList.length);
            if (selectedHeaderCheck == true) {
                if(!PaginationList[i].isChecked) {
                    PaginationList[i].isChecked = true;
                    selectedContId.push(PaginationList[i].Id);
                    selectedRowsCount++;
                }
            } else {
                if(PaginationList[i].isChecked && selectedContId.includes(PaginationList[i].Id)) {
                    selectedContId.pop(PaginationList[i].Id);
                }
                PaginationList[i].isChecked = false;
                selectedRowsCount--;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set('v.selectedContId',selectedContId);
        if(selectedRowsCount > 0) component.set("v.selectedRowsCount",selectedRowsCount);
        else component.set("v.selectedRowsCount",0);
        //component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },
    
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var selectedRecId = event.getSource().get("v.text");
        console.log('selectedRecId::'+selectedRecId);
        var selectedContId = component.get('v.selectedContId');
        var getSelectedNumber = component.get("v.selectedRowsCount");
        if (selectedRec == true) {
            if (!selectedContId.includes(selectedContId)) {
                getSelectedNumber++;
                selectedContId.push(selectedRecId);
            }
            
        } else {
            selectedContId.pop(selectedRecId);
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedRowsCount", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCountCV")) {
            component.find("selectAllId").set("v.value", true);
        }
        helper.getPaginationList(component, helper);
    },
    
    fetchProducts: function (component, event, helper) {
        var allRecords = component.get("v.listOfAllAccounts");
        var selectedRecords = [];
        var selectedCntrcts = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i].Id);
                selectedCntrcts.push(allRecords[i].Phoenix_Contract_Number__c);
            }
        }
        console.log('selected contracts-->'+selectedCntrcts);
        var templateType = component.get("v.templateType");
        var bidType = component.get("v.bidType");
        console.log('template type is in-->'+component.get("v.templateType")) 
        if(templateType == 'ABC Pharmagen'){
            if(selectedCntrcts.length >=3){
                var  errormsg = 'You should select only 3000000551 and 3000000957 contracts';
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message":errormsg
                });
                toastEvent.fire(); 
                component.set('v.goToProducts',false);
            }
            else if(selectedCntrcts[0] != '3000000551' && selectedCntrcts[1] !='3000000551'){
                
                var  errormsg = 'Please select 3000000551 and 3000000957 contracts';
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message":errormsg
                });
                toastEvent.fire();
                component.set('v.goToProducts',false);
            } else if(selectedCntrcts[0] != '3000000957' && selectedCntrcts[1] != '3000000957'){
                var  errormsg = 'Please select 3000000551 and 3000000957 contracts';
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message":errormsg
                });
                toastEvent.fire();  
                component.set('v.goToProducts',false);
            }
                else{
                    component.set('v.goToProducts',true); 
                }
        }
        else{
            component.set('v.goToProducts',true); 
        }
        console.log('present go to products value-->'+component.get('v.goToProducts'))
        component.set('v.selectedContratcsIdList',selectedRecords);
        component.set('v.selectedCntrcts',selectedCntrcts);
        if(component.get('v.goToProducts') == true){
            helper.getContractProducts(component, event, helper);
        }
    },
    
    moveToContractsView: function (component, event, helper) {
        component.set('v.isSpinnerLoad',false);
        component.set('v.navigateToComponent',false);
        component.set('v.showProducts',false);
        component.set('v.showContracts',true);
    },
    keyCheck:function (component, event, helper) {
        if (event.which == 13){
            component.set("v.noData",false);
            var searchFamily = component.get("v.searchFamily");
            var searchName=component.get("v.searchText");
            var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
            var RxSrxList = component.get("v.RxSrxList");
            if(searchFamily!=null && searchFamily!='' && searchFamily!=undefined){
                helper.onsearchFamilyhelper(component,helper);   
            }
            else if(searchName!=null && searchName!='' && searchName!=undefined){
                helper.searchTablehelper(component,helper);
            }
                else if(SearchKeyWordPD.length>0){
                    helper.onsearchDirectorhelper(component,helper);   
                }
                    else if(RxSrxList.length>0){
                        helper.searchRx(component, helper);   
                    }
            
            
        }  
    },
    keyCheckContracts:function (component, event, helper) {
        if (event.which == 13){ 
            var action = component.get('c.searchContracts');
            $A.enqueueAction(action);
            //this.searchContracts(component, event,helper);
        }
    }
})