({
    myAction : function(component, event, helper) {
        var elem1 = component.find("downloadLink");
        var elem = elem1.getElement();
        var table = document.getElementById("table");
        var html = table.outerHTML;
        var url = 'data:application/vnd.ms-excel,' + escape(html); // Set your html table into url
        elem.setAttribute("href", url);
        elem.setAttribute("download", "export.xls"); // Choose the file name
        return false;
    },
    downloadCsvAllRec : function(component,event,helper){    
        var rxPreviewList = component.get("v.rxPreviewList");
        var srxPreviewList = component.get("v.srxPreviewList");
        var otcPreviewList = component.get("v.otcPreviewList");
        var specialtyPreviewList = component.get("v.specialtyPreviewList");

        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSVAllRec(component,rxPreviewList,otcPreviewList);   
        if (csv == null){return;} 
        
        
        var csvString = csv;
        var universalBOM = "\uFEFF";
        var a = window.document.createElement('a');
        a.setAttribute('href', 'data:text/csv; charset=utf-8,' + encodeURIComponent(universalBOM+csvString));
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        a.setAttribute('download','Product Launch Calendar – Next 18 Months'+'-'+Now+'.csv');
        window.document.body.appendChild(a);
        a.click();
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        /* var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //      
            var date = new Date(); 
            var hours = date.getHours(); 
            var minutes = date.getMinutes(); 
            var newformat = hours >= 12 ? 'PM' : 'AM';  
            hours = hours % 12;  
            hours = hours ? hours : 12;  
            minutes = minutes < 10 ? '0' + minutes : minutes;        
            var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
            hiddenElement.download = 'Rx Launch Calendar – Next 18 Months'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file */
     },
      downloadCsvAll : function(component,event,helper){    
        var allProducts = component.get("v.DuplicateProductList");
           var data=[];
                  var selectedProductsIds = component.get("v.selectedProductsIds");

        var pData;
        for(let j = 0; j < allProducts.length; j++){
            pData=allProducts[j];
            if (selectedProductsIds.includes(pData.Id)) {
                pData.isSelected = true;
                data.push(pData); 
            }
        }
        
        console.log('allProducts::: '+JSON.stringify(allProducts));
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSVAll(component,data);   
        if (csv == null){return;} 
        
        
        var csvString = csv;
        var universalBOM = "\uFEFF";
        var a = window.document.createElement('a');
        a.setAttribute('href', 'data:text/csv; charset=utf-8,' + encodeURIComponent(universalBOM+csvString));
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        a.setAttribute('download','Product Launch Calendar – Next 18 Months'+'-'+Now+'.csv');
        window.document.body.appendChild(a);
        a.click();
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        /* var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //      
            var date = new Date(); 
            var hours = date.getHours(); 
            var minutes = date.getMinutes(); 
            var newformat = hours >= 12 ? 'PM' : 'AM';  
            hours = hours % 12;  
            hours = hours ? hours : 12;  
            minutes = minutes < 10 ? '0' + minutes : minutes;        
            var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
            hiddenElement.download = 'Rx Launch Calendar – Next 18 Months'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file */
     },
    downloadCsv : function(component,event,helper){    
        var rxPreviewList = component.get("v.rxPreviewList");
        console.log('rxPreviewList::: '+JSON.stringify(rxPreviewList));
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,rxPreviewList);   
        if (csv == null){return;} 
        
        
        var csvString = csv;
        var universalBOM = "\uFEFF";
        var a = window.document.createElement('a');
        a.setAttribute('href', 'data:text/csv; charset=utf-8,' + encodeURIComponent(universalBOM+csvString));
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        a.setAttribute('download','Rx Launch Calendar – Next 18 Months'+'-'+Now+'.csv');
        window.document.body.appendChild(a);
        a.click();
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        /* var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //      
            var date = new Date(); 
            var hours = date.getHours(); 
            var minutes = date.getMinutes(); 
            var newformat = hours >= 12 ? 'PM' : 'AM';  
            hours = hours % 12;  
            hours = hours ? hours : 12;  
            minutes = minutes < 10 ? '0' + minutes : minutes;        
            var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
            hiddenElement.download = 'Rx Launch Calendar – Next 18 Months'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file */
     },
     downloadCsvSRX : function(component,event,helper){    
      var srxPreviewList = component.get("v.srxPreviewList");
                         console.log('srxPreviewList::: '+JSON.stringify(srxPreviewList));

            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSVSRX(component,srxPreviewList);   
            if (csv == null){return;} 
            
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--#### 
             var csvString = csv;
        var universalBOM = "\uFEFF";
        var a = window.document.createElement('a');
        a.setAttribute('href', 'data:text/csv; charset=utf-8,' + encodeURIComponent(universalBOM+csvString));
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        a.setAttribute('download','Rx Specialty Injectables Launch Calendar – Next 18 Months'+'-'+Now+'.csv');
        window.document.body.appendChild(a);
        a.click();
            
         /*   var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //      
            var date = new Date(); 
            var hours = date.getHours(); 
            var minutes = date.getMinutes(); 
            var newformat = hours >= 12 ? 'PM' : 'AM';  
            hours = hours % 12;  
            hours = hours ? hours : 12;  
            minutes = minutes < 10 ? '0' + minutes : minutes;        
            var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
            hiddenElement.download = 'Rx Specialty Injectables Launch Calendar – Next 18 Months'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file */
          },
    downloadCsvOTC : function(component,event,helper){  
          var otcPreviewList = component.get("v.otcPreviewList");
                         console.log('otcPreviewList::: '+JSON.stringify(otcPreviewList));
        // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSVOTC(component,otcPreviewList);   
            if (csv == null){return;} 
            
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####    
                var csvString = csv;
        var universalBOM = "\uFEFF";
        var a = window.document.createElement('a');
        a.setAttribute('href', 'data:text/csv; charset=utf-8,' + encodeURIComponent(universalBOM+csvString));
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        a.setAttribute('download','OTC Launch Calendar'+'-'+Now+'.csv');
        window.document.body.appendChild(a);
        a.click(); 
          /*  var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //      
            var date = new Date(); 
            var hours = date.getHours(); 
            var minutes = date.getMinutes(); 
            var newformat = hours >= 12 ? 'PM' : 'AM';  
            hours = hours % 12;  
            hours = hours ? hours : 12;  
            minutes = minutes < 10 ? '0' + minutes : minutes;        
            var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
            hiddenElement.download = 'OTC Launch Calendar'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file*/
      var action = component.get("c.getOTCData");
         action.setParams({                   
                    'otcPreviewList': otcPreviewList//component.get('v.otcPreviewList')
                });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                console.log('inside Process Products');
                var responseWrapper=response.getReturnValue();
                                console.log('OTCListClass-----'+JSON.stringify(responseWrapper));
                                console.log('pipelineWrapperList-----'+JSON.stringify(responseWrapper.pipelineWrapperList));
								component.set("v.otcPreviewObj",responseWrapper.pipelineWrapperList);
                                console.log('otcPreviewObj-----'+component.get("v.otcPreviewObj"));
            }
                });
            $A.enqueueAction(action);
            
             
    },
    downloadCsvSpecialty : function(component,event,helper){    
      var specialtyPreviewList = component.get("v.specialtyPreviewList");
                         console.log('specialtyPreviewList::: '+JSON.stringify(specialtyPreviewList));

            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSVSpecialty(component,specialtyPreviewList);   
            if (csv == null){return;} 
            
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
                 var csvString = csv;
        var universalBOM = "\uFEFF";
        var a = window.document.createElement('a');
        a.setAttribute('href', 'data:text/csv; charset=utf-8,' + encodeURIComponent(universalBOM+csvString));
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        a.setAttribute('download','Specialty Launch Calendar / Product list - Next 18 months'+'-'+Now+'.csv');
        window.document.body.appendChild(a);
        a.click(); 
           /* var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //      
            var date = new Date(); 
            var hours = date.getHours(); 
            var minutes = date.getMinutes(); 
            var newformat = hours >= 12 ? 'PM' : 'AM';  
            hours = hours % 12;  
            hours = hours ? hours : 12;  
            minutes = minutes < 10 ? '0' + minutes : minutes;        
            var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
            hiddenElement.download = 'Specialty Launch Calendar / Product list - Next 18 months'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file */
          },
    previewData : function(component, event, helper) {
        var previewList =[];
        var rxPreviewList =[];
        var srxPreviewList =[];
        var otcPreviewList =[];
        var specialtyPreviewList = [];
        previewList  = component.get("v.QLlist");
        previewList.forEach(function(ql){
            if(ql.Vision_Segment__c == 'RX' || ql.Vision_Segment__c == 'Rx'){
                rxPreviewList.push(ql);  
            }
            else if(ql.Vision_Segment__c == 'SRX' || ql.Vision_Segment__c == 'SRx'  || ql.Vision_Segment__c == 'srx'){
                rxPreviewList.push(ql);  
            }
                else if(ql.Vision_Segment__c == 'OTC' || ql.Vision_Segment__c == 'otc'){
                    rxPreviewList.push(ql);  
                }
            else if(ql.Vision_Segment__c == 'Specialty' || ql.Vision_Segment__c == 'Specialty'){
                    rxPreviewList.push(ql);  
                }
        });
    },
    doInit : function(component,event,helper) {
        //console.log('Page Reference:: '+JSON.stringify(component.get("v.pageReference")));
        component.set("v.showProducts",true);
        component.set("v.showSelectedProducts",false);
        component.set("v.showProductsPage",true);
        component.set("v.showSpinnerSelProds",true);
        //helper.getBidDetails(component, helper); 
        helper.loadProducts(component, event, helper);
        var action = component.get("c.getProductPipelines");
        //action.setParams({ "bidId": component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var responseData = response.getReturnValue();
                 component.set("v.isProcessed",responseData.isProcessed); 
                console.log('::: '+JSON.stringify(responseData.pipelineList));
                component.set("v.totalCount", responseData.length);
                component.set("v.ProductList", responseData.pipelineList);
                component.set("v.DuplicateProductList", responseData.pipelineList);
                component.set("v.selectedProductsCount",responseData.length);
                component.set("v.prismUpdateDate",responseData.prismUpdateDate); 
                component.set("v.visionUpdateDate",responseData.visionUpdateDate); 

                console.log('---count--'+responseData.length);
                //alert(component.get('v.selectedProductsCount'));
            }
            
        });
        $A.enqueueAction(action);          
    },
    handleChange : function(component, event, helper){
        console.log('handleChange called-->');
        
        component.set('v.isSpinnerLoad', true);
        var accountId = component.find("rangeId").get("v.value");
        
        var getBidInfoAction = component.get("c.getAccountInPreview");
        getBidInfoAction.setParams({
            accountId : accountId
            
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set('v.previewfirstaccount',responseWrapper);

                /* var con = res.getReturnValue();
                component.set("v.street", responseWrapper[0].street);
                component.set("v.city", responseWrapper[0].MailingCity);
                component.set("v.country", responseWrapper[0].MailingCountry);
                component.set("v.postalCode", responseWrapper[0].MailingPostalCode);
                component.set("v.province", responseWrapper[0].MailingState);
                
                var street;
                var address = JSON.stringify(responseWrapper[0].BillingAddress);
                                 street = address.street;  
                
                                console.log('street-->'+street);
  console.log('address street-->'+JSON.stringify(responseWrapper[0].street)); */
                component.set("v.accountNameInPreview",responseWrapper[0].Name);
                component.set("v.BillingStreet",responseWrapper[0].BillingStreet);
                component.set("v.BillingCity",responseWrapper[0].BillingCity);
                component.set("v.BillingState",responseWrapper[0].BillingState);
                component.set("v.BillingPostalCode",responseWrapper[0].BillingPostalCode);
                component.set("v.BillingCountry",responseWrapper[0].BillingCountry);
                
                component.set('v.isSpinnerLoad', false);
                console.log('Bid analysis handle change-->'+responseWrapper[0].BillingStreet);
                
            }
        });
          $A.enqueueAction(getBidInfoAction);
          
      },
    onsearch: function (component, event, helper) {
        
        component.set("v.noData",false);
        
        var searchName = component.get("v.searchText");
        console.log('searchName ' + searchName);
       
        
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList = component.get("v.RxSrxList");
        var accIdList = new Map();
        var accList = component.get("v.Diplicateaccount");
        if(accList!=null && accList !=undefined){
            accList.forEach(function(accunt){
                accIdList[accunt.acc.Id]= accunt.isSelected;
            })
        }
        console.log('accIdList-->'+JSON.stringify(accIdList))
        var action = component.get("c.getFilterAccounts");
        
        action.setParams({
            searchText : searchName,
            allAccounts : accIdList 
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Success");
                var resp = response.getReturnValue();
                if(searchName != null && searchName != undefined)
                    component.set("v.Allaccount", resp);
                else
                    component.set("v.Allaccount", accList);
            }  else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        //component.set("v.showSpinnerSelProds",true);
        /*if(searchName==null || searchName=='undefined' || searchName==''){
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
        }*/
           // component.set("v.showSpinnerSelProds",false);
           
           
       },
    openImportModal: function (component, event, helper) {
        component.set("v.showImportModal",true);  
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
        component.set("v.RxSrxList", []);
        
        
        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);
        console.log('QList799-->',qt)
        
        
        
    },
    backToObject: function(component, event, helper){
        /*var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "related"
        });
        navEvt.fire();*/
                component.set("v.selectedAccCount",0);

        component.set("v.showProductsPage",true);
        component.set("v.showButtonProducts",false);
        component.set("v.Allaccount",[]);
        component.set("v.RxSrxList", []);
        component.set("v.showAccounts", false);
        component.set("v.selectedCount",0);
        component.set("v.selectAll", false);
        component.set("v.selectAllAccount", false);
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
        //component.set("v.showProductsPage",true);
        //component.set("v.showButtonProducts",false);
        component.set("v.showSpinnerSelProds",false);
        //component.set("v.showButtonProducts", false);
    },
    closeModal: function (component, event, helper) {
        //component.set("v.showSelectedProducts", false);
        //component.set("v.showProducts", false);
        //component.set("v.noData",false);
        component.set("v.showAccounts",false);
        
        /* let recordId =component.get("v.recordId");
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
        } else{
            component.find("navigationService").navigate({
                type: "standard__component",
                attributes: {
                    componentName: "c__Phoenix_OpportunityEditPage" },
            }, true);
        }*/
    },
    selectAllCheckbox : function (component, event, helper){
        var selectedHeaderCheck = event.getSource().get("v.checked");
        var selectedValues= component.set('v.selectedValues', selectedHeaderCheck);
        var value =  event.getSource().get("v.value");
        var dataValue = component.set('v.dataValue', value); 
        var allRecords=component.get("v.allData");
        var updatedAllRecords=[];
        var updatedPageList=[];
        
        var ProductList=component.get("v.ProductList");
        var getSelectedNumber = component.get("v.selectedCount");
        console.log('ProductList.length---->'+ProductList.length)
        var selIds=component.get("v.selectedProductsIds");
        for(var j=0;j<ProductList.length;j++){
              component.set("v.Vision_GCP_Product_Family__c",true);
              component.set("v.Vision_Segment__c",true);
              component.set("v.Vision_GPI__c",true);
              component.set("v.Vision_GCN__c",true);
              component.set("v.Vision_Launch_Type__c",true);
             component.set("v.Vision_Potential_Launch_date__c",true);
             component.set("v.Vision_Launch_Month__c",true);
              component.set("v.GCP_Launch_Year__c",true);
              component.set("v.Vision_Authorized_Generic__c",true);
              component.set("v.Vision_Anda_Filed__c",true);
              component.set("v.Vision_Launch_Qtr__c",true);
              component.set("v.GCP_Launch_Year1__c",true);
              component.set("v.Vision_Launch_Year1__c",true);
              component.set("v.Vision_Dosage_Form__c",true);
              component.set("v.Vision_Reference_Brand__c",true);
              component.set("v.Vision_Api_Vertically_Integrated__c",true);
              component.set("v.Vision_Size__c",true);
             component.set("v.Vision_Comments__c",true);
                  component.set("v.Vision_Strength__c",true); 
               component.set("v.Vision_Unit_Dose__c",true); 

            if(selectedHeaderCheck==true){
                
                ProductList[j].isSelected=selectedHeaderCheck;
                if(selIds.includes(ProductList[j].Id)){
                    continue; 
                }
                selIds.push(ProductList[j].Id);
                
            }
            else{
 			component.set("v.Vision_GCP_Product_Family__c",false);
              component.set("v.Vision_Segment__c",false);
              component.set("v.Vision_GPI__c",false);
              component.set("v.Vision_GCN__c",false);
              component.set("v.Vision_Launch_Type__c",false);
             component.set("v.Vision_Potential_Launch_date__c",false);
             component.set("v.Vision_Launch_Month__c",false);
              component.set("v.GCP_Launch_Year__c",false);
              component.set("v.Vision_Authorized_Generic__c",false);
              component.set("v.Vision_Anda_Filed__c",false);
              component.set("v.Vision_Launch_Qtr__c",false);
              component.set("v.GCP_Launch_Year1__c",false);
              component.set("v.Vision_Launch_Year1__c",false);
              component.set("v.Vision_Dosage_Form__c",false);
              component.set("v.Vision_Reference_Brand__c",false);
              component.set("v.Vision_Api_Vertically_Integrated__c",false);
              component.set("v.Vision_Size__c",false);
             component.set("v.Vision_Comments__c",false);  
                  component.set("v.Vision_Strength__c",false); 
                component.set("v.Vision_Unit_Dose__c",false); 

                const index = selIds.indexOf(ProductList[j].Id);
                if (index > -1) {
                    selIds.splice(index, 1);
                }
                ProductList[j].isSelected=selectedHeaderCheck;
                var arry = component.get("v.QLlist1");
                
                if(arry!=null && arry!=undefined && arry!=''){
                    if (arry.length > 0) {
                        for (var i = 0; i < arry.length; i++) {
                            if (arry[i].Id === ProductList[j].Id) {
                                arry.splice(i, 1);
                            }
                        }
                        component.set("v.QLlist1", arry);
                    }
                }
            }
        }
        /*var checkbox = document.getElementById('selectedValues');
        if(document.getElementById('selectedValues').checked) {
        localStorage.setItem('selectedValues', true);
    }*/
        //console.log('checkbox---->'+checkbox)
        //helper.buildData(component, helper);
        component.set("v.selectedProductsIds",selIds);
        component.set("v.ProductList",ProductList)
        //component.set("v.DuplicateProductList", ProductList);

        var selectedProdcount=component.get("v.selectedProductsIds").length;
        if(selectedHeaderCheck){
            component.set("v.selectedCount",ProductList.length); 
        } else{
            component.set("v.selectedCount", 0);
        }
        var count = component.get("v.selectedCount")
        if (count > 0) {
            component.set("v.showbutton", false);  
        }
        else if (count == 0) {
            component.set("v.showbutton", true);
        }
       
    },
    selectColumnCheckbox: function(component, event, helper){
        console.log('Checkbox Fired:: ');
        var selectedColumns = component.get("v.selectedColumns");
        console.log("selectedColumns1--->"+ selectedColumns.length);
        if(selectedColumns.length > 3){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'You cannot choose more than 6 columns.',
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'sticky'
            });
            toastEvent.fire();
        } else{ 
            //var checkedColumns = component.get("v.checkedColumns");
            console.log('seg bool checkbox====='+component.get("v.Vision_Segment__c"))
            var columndata = component.get("v.columndata");
            var selectedRec = event.getSource().get("v.checked");
            var selectedRec2 = event.getSource().get("v.value");
            console.log('checked>>  '+event.getSource().get("v.value"));
            var selectId=component.find('checkbox');
            console.log('selectId>>'+selectId);
            var selectedRec1 = event.getSource().get("v.name");
            console.log(event.getSource().get("v.name"));
            console.log('selectedRec1--->'+ selectedRec1)
            var nameString = 'v.'+selectedRec1;
            console.log('nameString--->'+ nameString)
            var getSelectedNumber = component.get("v.columndata.length");
            console.log('getSelectedNumber-->'+getSelectedNumber);
            //component.set(nameString, selectedRec);
         /*   component.set("v.Vision_GCP_Product_Family__c",component.get("v.Vision_GCP_Product_Family__c"));
component.set("v.Vision_Segment__c",!component.get("v.Vision_Segment__c"));
component.set("v.Vision_GPI__c",!component.get("v.Vision_GPI__c"));
component.set("v.Vision_GCN__c",!component.get("v.Vision_GCN__c"));
component.set("v.Vision_Launch_Type__c",!component.get("v.Vision_Launch_Type__c"));
component.set("v.Vision_Launch_Month__c",!component.get("v.Vision_Launch_Month__c"));
component.set("v.Vision_Authorized_Generic__c",!component.get("v.Vision_Authorized_Generic__c"));
component.set("v.Vision_Anda_Filed__c",!component.get("v.Vision_Anda_Filed__c"));
component.set("v.Vision_Launch_Qtr__c",!component.get("v.Vision_Launch_Qtr__c"));
component.set("v.GCP_Launch_Year1__c",!component.get("v.GCP_Launch_Year1__c"));
component.set("v.Vision_Launch_Year1__c",!component.get("v.Vision_Launch_Year1__c"));
component.set("v.Vision_Dosage_Form__c",!component.get("v.Vision_Dosage_Form__c"));
component.set("v.Vision_Reference_Brand__c",!component.get("v.Vision_Reference_Brand__c"));
component.set("v.Vision_Api_Vertically_Integrated__c",!component.get("v.Vision_Api_Vertically_Integrated__c"));
component.set("v.Vision_Size__c",!component.get("v.Vision_Size__c"));
component.set("v.Vision_Comments__c",!component.get("v.Vision_Comments__c"));
component.set("v.Vision_Strength__c",!component.get("v.Vision_Strength__c")); 
component.set("v.Vision_Unit_Dose__c",!component.get("v.Vision_Unit_Dose__c")); 
*/
            if(selectedRec == true){
                console.log('inside if');
                if(selectedColumns.includes(selectedRec2)){
                    console.log('inside if@1');
                    getSelectedNumber++;
                    selectedColumns.push(selectedRec2);
                }
                 else if(!selectedColumns.includes(selectedRec2)){
                     console.log('inside else@1');
                     columndata.push(selectedRec2);
                    const index = selectedColumns.indexOf(selectedRec2);
                    if (index > -1) {
                        selectedColumns.splice(index, 1);
                    }
                }
            } else{
                console.log('inside else');
                getSelectedNumber--;
                if(columndata.includes(selectedRec2)){
                    console.log('inside else 2');
                    const index = columndata.indexOf(selectedRec2);
                    if (index > -1) {
                        console.log('inside index');
                        columndata.splice(index, 1);
                    }
                }
            }
            component.set("v.selectedColumns", selectedColumns);
            component.set("v.columndata", columndata)
            component.set("v.v.columndata.length", getSelectedNumber);
        }
        helper.convertArrayOfObjectsToCSV(component);
        helper.convertArrayOfObjectsToCSVSRX(component);
        helper.convertArrayOfObjectsToCSVOTC(component);
        console.log('Selected Columns:: '+selectedColumns);
        console.log("selectedColumns--->"+ selectedColumns.length);
    },
    checkBoxChangeHandler: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.checked");
        var selectedRec1 = event.getSource().get("v.name");
        var selectedRows= component.set('v.selectedRows', selectedRec1);
        var getSelectedNumber = component.get("v.selectedCount");
        var allProds = component.get("v.Allproduct");
        var allAccs = component.get("v.Allaccount");
        var diplicateaccountList = component.get("v.Diplicateaccount");
        var selIds = [];
        var selectedAccCount = 0;
        if(diplicateaccountList != null && diplicateaccountList != undefined && diplicateaccountList.length>0){
            diplicateaccountList.forEach(function(acct){
                console.log('Account display---'+acct);
                console.log('Account displayjson---'+JSON.stringify(acct));
                
                if(allAccs != null && allAccs != undefined && allAccs.length>0){
                    allAccs.forEach(function(accunt){
                        if(acct.isSelected){
                            //selectedAccCount =selectedAccCount+1;
                        }
                        if(accunt.acc.Id == acct.acc.Id){
                            acct.isSelected = accunt.isSelected; 
                            console.log('accunt displayjson---'+JSON.stringify(accunt));
                            //selectedAccCount =selectedAccCount+1;
                        }
                    });
                }
                
            });
        }
        if(diplicateaccountList != null && diplicateaccountList != undefined && diplicateaccountList.length>0){
            diplicateaccountList.forEach(function(acct){
                if(acct.isSelected){
                    selectedAccCount =selectedAccCount+1;
                    //   selectedAccountsList.push(acct);
                }
            });
        }
        console.log('selectedAccountsList==='+JSON.stringify(component.get("v.selectedAccountsList")));
        
        component.set("v.selectedAccCount",selectedAccCount)
        component.set("v.Diplicateaccount",diplicateaccountList)
        console.log('selcted Diplicateaccount'+JSON.stringify(component.get("v.Diplicateaccount")));
        
        if (selectedRec == true && selectedRec1!='acctCheckBox') {
            getSelectedNumber++;
            var selProds = component.get("v.selectedProductsIds");
            selIds = selProds;
            selIds.push(selectedRec1);
            var arry = component.get("v.QLlist1");  
            console.log('selIds-->',selIds)
            component.set("v.selectedProductsIds", selIds);
        console.log('selectedProds-->',component.get("v.selectedProductsIds"))
        }
        else if(selectedRec1!='acctCheckBox') {
            getSelectedNumber--;
            var selProds = component.get("v.selectedProductsIds");
            selIds = selProds;
            console.log('Line1175-->',selIds)
            var prodId = event.getSource().get("v.name");
            console.log('Line1176-->',prodId)
            const index = selIds.indexOf(prodId);
            if (index > -1) {
                selIds.splice(index, 1);
            }
            var arry = component.get("v.QLlist1");
            
            if(arry!=null && arry !=undefined && arry!=''){
                
                
                if (arry.length > 0) {
                    
                    for (var i = 0; i < arry.length; i++) {
                        if (arry[i].Id === prodId) {
                            arry.splice(i, 1);
                            
                        }
                    }
                    component.set("v.QLlist1", arry);
                }
            }        
        }
        console.log('QLlist1---'+ arry);
        
        var allAccountsList = [];
        var selectedAccountsList = [];
        var selectedAccountsoption = [];
        var accName;
        allAccountsList = component.get("v.Diplicateaccount")
        allAccountsList.forEach(function(account){
            if(account.isSelected == true){
                selectedAccountsoption.push({value:''+account.acc.Id,label:''+account.acc.Name});
                selectedAccountsList.push(account) 
                accName =account.Name;
            }
        });
        console.log('account id---'+accName)
        
        /*   selectedAccountsList.forEach(function(acc){
            for(var i=0; i<selectedAccountsList.length; i++){
                var obj = {};
                obj.label = selectedAccountsList[i].Name;
                obj.value = selectedAccountsList[i].Id;
                selectedAccountsoption.push(obj);
               console.log('obj--'+obj.length);
            }
        });*/
        component.set('v.selectedAccountsoption',selectedAccountsoption);    
        console.log('selectedAccountsListjson====='+JSON.stringify(selectedAccountsoption));
        //  console.log('selectedAccountsoption====='+JSON.parse(component.get('v.selectedAccountsoption')));
        console.log('selectedAccountsoption====='+selectedAccountsoption.length);
        
        
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
    sendProductPipeline: function (component, event, helper) {
        //console.log('Page Reference:: '+JSON.stringify(component.get("v.pageReference")));
        component.set("v.showProductsPage",false);
        component.set("v.showButtonProducts",true);
        component.set("v.showSpinnerSelProds",true);
        //helper.getBidDetails(component, helper); 
        helper.loadProducts(component, event, helper);
        var action = component.get("c.getProductPipelines");
        //action.setParams({ "bidId": component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var responseData = response.getReturnValue();
                console.log('::: '+JSON.stringify(responseData.pipelineList));
                component.set("v.totalCount", responseData.length);
                component.set("v.ProductList", responseData.pipelineList);
                component.set("v.DuplicateProductList", responseData.pipelineList);
				component.set("v.isRxChecked",false);
                component.set("v.isSRxChecked",false);
                component.set("v.isOtcChecked",false);
                component.set("v.selectedProductsCount",responseData.length);  
                component.set("v.prismUpdateDate",responseData.prismUpdateDate); 
                component.set("v.visionUpdateDate",responseData.visionUpdateDate); 
                console.log('---count--'+responseData.length);
                //alert(component.get('v.selectedProductsCount'));
            }
            
        });
        $A.enqueueAction(action);
    }, 
    processProducts: function (component, event, helper) {
     
        component.set("v.showSelectedProducts", true);
        component.set("v.isQLlistempty",false);
        
                console.log('newww ProductList-----'+JSON.stringify(component.get("v.DuplicateProductList")));

        console.log('newww ProductList-----'+JSON.stringify(component.get("v.ProductList")));
        var allProducts=component.get("v.DuplicateProductList");
        var selectedFirstAccount = [];
        var defaultAccount = component.get("v.Allaccount");
                defaultAccount.forEach(function(accountSelected){ 
                    if(accountSelected.isSelected == true){
                        selectedFirstAccount.push(accountSelected.acc);
                       // break;
                    }
                });
		component.set('v.previewfirstaccount',selectedFirstAccount);
        
        var selectedProductsIds = component.get("v.selectedProductsIds");
        var data=[];
        var pData;
        for(let j = 0; j < allProducts.length; j++){
            pData=allProducts[j];
            if (selectedProductsIds.includes(pData.Id)) {
                pData.isSelected = true;
                data.push(pData); 
            }
        }
        component.set("v.showAccounts",false);
        component.set("v.QLlist",data);
        var previewList =[];
        var rxPreviewList =[];
        var srxPreviewList =[];
        var otcPreviewList =[];
        var specialtyPreviewList =[];
        var picliList = component.get('v.RxSrxList');  
        previewList  = component.get("v.QLlist");
        allProducts.forEach(function(ql){
            if(ql.isSelected && (ql.Vision_Segment__c == 'RX' || ql.Vision_Segment__c == 'Rx'  || ql.Vision_Segment__c == 'rx')){
                rxPreviewList.push(ql);  
                console.log('inside rx')
            }
           else if(ql.isSelected && (ql.Vision_Segment__c == 'SRX' || ql.Vision_Segment__c == 'SRx'  || ql.Vision_Segment__c == 'srx')){
                srxPreviewList.push(ql); 
               console.log('inside srx')
            }
            else if(ql.isSelected && (ql.Vision_Segment__c == 'OTC' || ql.Vision_Segment__c == 'OTC' || ql.Vision_Segment__c == 'otc')){
                    otcPreviewList.push(ql); 
                 console.log('inside otc')
           }
           else if(ql.isSelected && (ql.Vision_Segment__c == 'Specialty' || ql.Vision_Segment__c == 'Specialty' || ql.Vision_Segment__c == 'specialty')){
                    specialtyPreviewList.push(ql);
                    console.log('inside Specialty')
           }
        });
        component.set("v.rxPreviewList",rxPreviewList);
        component.set("v.srxPreviewList",srxPreviewList);
        component.set("v.otcPreviewList",otcPreviewList);
        component.set("v.specialtyPreviewList",specialtyPreviewList);
        console.log('specialtyPreviewList@@--->', specialtyPreviewList);
        component.set("v.RxSrxList",previewList);
         var action = component.get("c.getOTCData");
         action.setParams({                   
                    'otcPreviewList': otcPreviewList//component.get('v.otcPreviewList')
                });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                console.log('inside Process Products');
                var responseWrapper=response.getReturnValue();
                                console.log('OTCListClass-----'+JSON.stringify(responseWrapper));
                                console.log('pipelineWrapperList-----'+JSON.stringify(responseWrapper.pipelineWrapperList));
                                //console.log('therapeuticArea-----'+JSON.stringify(responseWrapper.pipelineWrapperList.therapeuticArea));
								component.set("v.otcPreviewObj",responseWrapper.pipelineWrapperList);
                                var myMap= responseWrapper.pipelineWrapperList;
                                console.log('myMap-----'+ myMap);
                                var resList = myMap.values();
                                component.set("v.otcPreviewObj1",resList);
                                //console.log('otcPreviewObj-----'+component.get("v.otcPreviewObj"));
                                console.log('resList-----'+ resList);     
            }
                });
            $A.enqueueAction(action);

    },
    selectAccounts:function(component, event, helper){
        var recordId =component.get("v.recordId");
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
        }
        console.log('load accounts--->')
        var quotewrap = component.get("v.wrap");
        
        var searchText = component.get("v.searchText");
        
        var getAccountAction = component.get("c.getAccounts");
        getAccountAction.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('loading accounts state-->'+actState)
            if (actState === 'SUCCESS') {
                component.set('v.popupOpen',true);
                var resposeData = response.getReturnValue();
                console.log("response data in loadAccounts-->"+JSON.stringify(resposeData))
                console.log('loading inside accounts state-->'+resposeData.length)
                
                
                
                if(resposeData!=undefined && resposeData!='' && resposeData!=null ){
                    if (resposeData.length > 0) {
                        component.set("v.showAccounts", true);
                    }
                    else {
                        component.set("v.noProducts", true);
                    }
                    console.log('showAccounts in pagination-->'+component.get("v.showAccounts"));
                    
                    //component.set("v.Allaccount", resposeData);
                   // component.set("v.Diplicateaccount", resposeData);
                   var allaccountloop = component.get("v.Allaccount")
                    allaccountloop.forEach(function(account){
                        console.log('account sle-->'+account.isSelected)
                       if(account.isSelected == true) 
                           console.log('allaccountIsSelected---'+account);
                        
                    });
                    console.log('allAccounts-->'+component.get("v.Allaccount"))
                    if(component.get("v.Allaccount") ==  null || component.get("v.Allaccount") == undefined || component.get("v.Allaccount") == ''){
                          component.set("v.Allaccount", resposeData);
                    component.set("v.Diplicateaccount", resposeData);
                    }
                    console.log("v.Allaccount---->" + resposeData);
                    component.set("v.allData", response.getReturnValue());
                    console.log("v.allData---->" + component.get("v.allData"));
                    
                    component.set("v.totalRecordsCount", response.getReturnValue().length);
                    console.log("record length---->" + response.getReturnValue().length);
                    
                    if(component.get("v.totalRecordsCount")==0)
                        component.set("v.noProducts",true);
                    else{
                        component.set("v.noProducts",false);
                        console.log("Line 1123-->");
                    }
                    component.set("v.showSpinnerSelProds",false);
                    console.log("Line 1126-->")
                    var scrollOptions = {
                        left: 0,
                        top: 0,
                        
                        
                        behavior: 'smooth'
                    }
                    /*window.scrollTo(scrollOptions);
        var data = [];
        let selectedProductsIds = component.get("v.selectedProductsIds");
        console.log("%c--------selectedProductsIds-------" + selectedProductsIds, "background-color:red;color:white;");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.Allaccount");
        var x = (pageNumber - 1) * pageSize;
        var pData;
        var copyList=[];
        component.set("v.ProductCopyList",copyList);
        
        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            pData = allData[x];
            if (pData) {
                pData.isSelected = false;
                if (selectedProductsIds.includes(pData.Id)) {
                    
                    pData.isSelected = true;
                }
                data.push(pData);
            }
        }
        component.set("v.Allaccount", data);
        
        
        if(data.length>0){
            var selectCount=0;
            for(var i=0;i<data.length;i++){
                if(data[i].isSelected==true){
                    selectCount++;
                }
            }
            
            if(selectCount==pageSize ||selectCount==i){
                component.set("v.selectAll",true);  
                
            }
            else{
                component.set("v.selectAll",false); 
            }
        }*/  
                    }
            }
        });
        $A.enqueueAction(getAccountAction);
    },   
  
    generatePdfDocument:function(component, event, helper){
         var allProducts=component.get("v.DuplicateProductList");      
        var selectedProductsIds = component.get("v.selectedProductsIds");
        var generateList=[];
        var pData;
        for(let j = 0; j < allProducts.length; j++){
            pData=allProducts[j];
            if (selectedProductsIds.includes(pData.Id)) {
                pData.isSelected = true;
                generateList.push(pData); 
            }
        }
        var data = component.get("v.ProductList");
        component.set("v.showSpinnerSelProds",true);
           var newData = [];
           if(data!=null && data != undefined){
               data.forEach(function(product){
                   if(product.isSelected){
                       newData.push(product);
                   }
               })
           }
           component.set("v.QLlist",newData);
        console.log('newData-->', newData);
           var selectedColumns = component.get("v.selectedColumns");
          var selectedHeaderCheck = event.getSource().get("v.checked");
           var updatedData = [];
          /* if(data!= undefined){
               for(var i=0; i<data.length; i++){
                   var obj = {};
                   for(var j=0; j<selectedColumns.length; j++){
                       obj.Vision_Reporting_Molecule__c = data[i].Vision_Reporting_Molecule__c;
                       if(selectedColumns[j] in data[i]){
                           console.log('Exist:: '+JSON.stringify(data[i][selectedColumns[j]]));
                           obj[selectedColumns[j]] = data[i][selectedColumns[j]];
                       } else{
                           console.log('No match');
                       }
                   }
                   updatedData.push(obj);
                   console.log('Updated Data:: '+JSON.stringify(obj));
               }
           } */
        var accountIdList = [];
        var selectedaccList = component.get("v.selectedAccountsoption");
             selectedaccList.forEach(function(acc){
                   
                       accountIdList.push(acc.value);
                   
               })
           console.log('accountIdList-----'+JSON.stringify(accountIdList));
        let  action = component.get("c.generateDocument");
           action.setParams({
               'ppList': generateList
           });
           console.log('Columns-->'+component.get("v.selectedColumns"))
           console.log('ppList-->'+component.get("v.QLlist"))
           action.setCallback(this,function(response) {
                console.log('response');
               var state =response.getState();
               if(state == "SUCCESS"){
                     var resposeData = response.getReturnValue();
                   console.log('resposeData pdf ---- '+JSON.stringify(resposeData));
                   component.set("v.showSpinnerSelProds",false);
                        let downloadLink = document.createElement('a');
                        var date = new Date() 
                        var hours = date.getHours(); 
                        var minutes = date.getMinutes(); 
                        var newformat = hours >= 12 ? 'PM' : 'AM';  
                        hours = hours % 12;  
                        hours = hours ? hours : 12;  
                        minutes = minutes < 10 ? '0' + minutes : minutes;        
                        var Now= (date.getMonth()+1)+'-'+date.getDate()+'-'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
                        downloadLink.download = 'Product Pipeline  '+Now+'.pdf'; 
                        downloadLink.href = 'data:application/pdf;base64,'+encodeURI(response.getReturnValue());
                        downloadLink.click();
                    }
               else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
               }
           });
           
           $A.enqueueAction(action);
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
                component.set("v.modalProductList",resposeData);  
                 component.set("v.DuplicateProductList", responseData);

            }
            
        });
        $A.enqueueAction(action);
        
    },
    closePopup:function(component,event,helper){
        component.set("v.isModalOpen",false);    
    },
    sortByMolecule: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Reporting Molecule');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Generic_Name__c');
    },
    sortBySegment: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Segment__c');
    },
    sortByGPI: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'GPI');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_GPI__c');
    },
    sortByGCN: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'GCN');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_GCN__c');
    },
    sortByType: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Launch Type');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Launch_Type__c');
    },
    sortByMonth: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Launch Month');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Launch_Month__c');
    },
     sortByDate: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Launch Month');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Potential_Launch_date__c');
    },
    sortByQtr: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Launch Qtr');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Launch_Qtr__c');
    },
    sortByYear: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Launch Year');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Launch_Year__c');
    },
    sortByDosage: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Dosage Form');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Dosage_Form__c');
    },
    sortByStrength: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Strength');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Vision_Strength__c');
    },
    sortByBrand: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Reference Brand');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Reference_Brand__c');
    },
    sortBySize: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Size');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Size__c');
    },
    sortByAPI: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'API Vertically Integrated');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Api_Vertically_Integrated__c');
    },
    sortByComments: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Comments');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Comments__c');
    },
    sortByNumber: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Account Number');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Number');
    },
    sortByName: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Account Name');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Name');
    },
    sortByOwner: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Account Owner');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'OwnerId');
    },
    sortByParent: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Parent Account');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'ParentId');
    },
    sortByPreferred: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Preferred Wholesaler');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Preferred_Wholesaler__c');
    },
    sortByAPG: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Preferred Wholesaler');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Authorized_Generic__c');
    },
    sortByUnitDose: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Preferred Wholesaler');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Unit_Dose__c');
    },
    sortByAndaFiled: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Preferred Wholesaler');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Vision_Anda_Filed__c');
    },
    searchSrxRxOttc : function(component,event,helper){
        helper.searchRx(component, helper);
        
    },
    selectAllCheckboxes: function(component, event, helper) {
        var accountList = component.get("v.Allaccount");
        var diplicateaccountList = component.get("v.Diplicateaccount");
        console.log('isAllSelected--->'+JSON.stringify(component.get("v.selectAllAccount")))
        console.log('selected Account--->'+JSON.stringify(component.get("v.Diplicateaccount")))
       
        
        if(accountList != null && accountList != undefined && accountList.length>0){
            accountList.forEach(function(acc){
                acc.isSelected = component.get("v.selectAllAccount"); 
            });
        }
        component.set("v.Allaccount",accountList);
        if(component.get("v.selectAllAccount")) 
            component.set("v.selectedAccCount",accountList.length);
        else
            component.set("v.selectedAccCount",0);
        var selectedAccountsoption= [];
        var allaccSelectedList = component.get("v.Allaccount");
        allaccSelectedList.forEach(function(account){
            if(account.isSelected == true){
                selectedAccountsoption.push({value:''+account.acc.Id,label:''+account.acc.Name});
                // selectedAccountsList.push(account) 
                // accName =account.Name;
            }
        });
        console.log('selectedAccountsoption'+JSON.stringify(selectedAccountsoption));
        component.set("v.selectedAccountsoption",selectedAccountsoption);
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        // play a for loop on all records list 
        for (var i = 0; i < listOfAllAccounts.length; i++) {
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
        }
        console.log('Allaccount--->'+JSON.stringify(component.get("v.Allaccount")))
        
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
        console.log('updatedPaginationList--->' + updatedPaginationList);
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
})