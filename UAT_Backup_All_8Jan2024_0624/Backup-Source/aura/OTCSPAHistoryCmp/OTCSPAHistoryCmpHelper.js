({
    onLoad: function(component, event, helper) {
        component.set("v.bidsWithLines",[
            { label: 'Name', fieldName: 'lineItemUrl', type: 'url', sortable: true,
             typeAttributes: {
                 label: {
                     fieldName: 'Name',
                     target: '_self'
                 }
             }
             
            },
            {
                label : 'Customer',
                fieldName : 'Account_Name__c',
                type : 'text',
                sortable : true
            },
            {
                label : 'Current Contrat Price',
                fieldName : 'Current_Contract_Price__c',
                type : 'currency',
                sortable : true,
                 maximumFractionDigits: 2
            },
            {
                label : 'Price',
                fieldName : 'Price__c',
                type : 'currency',
                sortable : true,
                 maximumFractionDigits: 2
            },
            {
                label : 'Annual Volume',
                fieldName : 'Annual_Volume_units__c',
                type : 'number',
                sortable : true,
                 maximumFractionDigits: 0,minimumFractionDigits: 0
            },
            {
                label : 'Current Volume',
                fieldName : 'Current_Annual_Volume_units__c',
                type : 'number',
                sortable : true,
                 maximumFractionDigits: 0,minimumFractionDigits: 0
            },
            {
                label : 'New Annual Volume',
                fieldName : 'New_Annual_Volume_units__c',
                type : 'number',
                sortable : true,
                 maximumFractionDigits: 0,minimumFractionDigits: 0
            },
            {
                label : 'Promo Volume',
                fieldName : 'Promo_Volume__c',
                type : 'number',
                sortable : true,
                 maximumFractionDigits: 0,minimumFractionDigits: 0
            },
            {
                label : 'Approval Status',
                fieldName : 'Approval_Status__c',
                type : 'text',
                sortable : true
            },
            {
                label : 'Requested Price Effective Date',
                fieldName : 'Estimate_Effective_Date__c',
                type : 'date',
                sortable : true
            },
            {
                label : 'Record Type',
                fieldName : 'recordType',
                type : 'text',
                sortable : true,
                typeAttributes: {
                   }
                
            },
      {
                label : 'Pipeline or Flow Behind',
                fieldName : 'Pipeline_or_Flow_Behind__c',
                type : 'text',
                sortable : true,
                typeAttributes: {
                   }
            }
        ]);
        component.set("v.bidsHistoryHeaders",[
            { label: 'Bid #', fieldName: 'lineItemUrl', type: 'url', sortable: true,
             typeAttributes: {
                 label: {
                     fieldName: 'bidName',
                     target: '_self'
                 }
             }
             
            },
            {
                label : 'Customer',
                fieldName : 'customerUrl',
                type : 'url',
                sortable : true,
                typeAttributes: {
                    label: {
                        fieldName: 'AccountName',
                        target: '_self'
                    }
                }
            },
            {
                label : 'Current Price',
                fieldName : 'Phoenix_Current_Direct_Price__c',
                type : 'currency',
                sortable : true,
                 maximumFractionDigits: 2
            },
            {
                label : 'Proposed Price',
                fieldName : 'Phoenix_ProposedContractBidPriceMktng__c',
                type : 'currency',
                sortable : true,
                 maximumFractionDigits: 2
            },
            {
                label : 'Volume',
                fieldName : 'Phoenix_Final_Total_Selling_Unit__c',
                type : 'number',
                sortable : true,
                 maximumFractionDigits: 0,minimumFractionDigits: 0
            },
            {
                label : 'Customer Approval',
                fieldName : 'Phoenix_Customer_Approval_OTC__c',
                type : 'text',
                sortable : true
            },
            
            {
                label : 'Approval Status',
                fieldName : 'ApprovalStatus',
                type : 'text',
                sortable : true
            },
            {
                label : 'Price Effective Date',
                fieldName : 'Phoenix_Price_Effective_Date__c',
                type : 'date',
                sortable : true
            },
            {
                label : 'Bid Closed Date',
                fieldName : 'bidCloseDate',
                type : 'date',
                sortable : true
            },
            {
                label : 'Bid Type',
                fieldName : 'bidType',
                type : 'text',
                sortable : true,
                typeAttributes: {
                   }
                
            },
      {
                label : 'Pipeline or Flow Behind',
                fieldName : 'Phoenix_Supply_Type__c',
                type : 'text',
                sortable : true,
                typeAttributes: {
                   }
            }
        ]);
        component.set("v.nprDataColumns",[
            { label: 'Customer', fieldName: 'customerURL', type: 'url', sortable: true,
             typeAttributes: {
                 label: {
                     fieldName: 'customerName',
                     target: '_self'
                 }
             }
             
            },
             { label: 'Product', fieldName: 'productUrl', type: 'url', sortable: true,
             typeAttributes: {
                 label: {
                     fieldName: 'productName',
                     target: '_self'
                 }
             }
             
            },
            {
                label : 'Contract Price',
                fieldName : 'Phoenix_Contract_Price__c',
                type : 'currency',
                sortable : true,
                 maximumFractionDigits: 2
            },
            {
                label : 'Price Effective Date From',
                fieldName : 'Phoenix_Price_Effective_Value_From__c',
                type : 'date',
                sortable : true
            },
            {
                label : 'Price Effective Date To',
                fieldName : 'Phoenix_Price_Effective_Value_To__c',
                type : 'date',
                sortable : true
            },
        ]);
       /* var i=0;
        var bidWrkType=component.find("bidType").get("v.value");
        if(bidWrkType==undefined){
            bidWrkType='';  
        }
        var bidApprStatus=component.find("bidStatus").get("v.value");
        if(bidApprStatus==undefined){
            bidApprStatus='';  
        }
        var bidCustRes=component.find("custResp").get("v.value");
        console.log('-----------bidCustRes---------'+bidCustRes);
        if(bidCustRes==undefined){
            bidCustRes='';  
        }*/
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var action = component.get("c.getSPAHistory");
        console.log('showAll---->'+component.get("v.isAllCustomer"));
        action.setParams({
            'bidLineId':rowIndex,
            isAllCustomer: component.get("v.isAllCustomer"),
            isAllSPACustomer:component.get("v.isAllSPACustomer"),
            isAllNprData:component.get("v.isAllNprData"),
        });
        action.setCallback(this, function(response) {
            let wrapper = response.getReturnValue();
            console.log('response--->'+JSON.stringify(wrapper))
            var model,bidLinesData,nprDataRecords;
            if(wrapper!=undefined && wrapper!=null){
                model=wrapper.spaDataRecords
                bidLinesData=wrapper.bidLines;
                nprDataRecords=wrapper.nprData;
            }
            if(wrapper!=undefined && wrapper!=null)
             	component.set("v.productObj",wrapper.productRec);
            
            if(model!=undefined){
                model.forEach(function(item){
                   /* item.tptPercent = item.tptPercent/100;
                    item.bidUrl = '/'+item.bidIds;
                    item.i=i+1;
                    if(item.bidUrl == '/undefined'){
                        item.bidUrl = "";
                    } 
                    i++;  */
                    console.log('recordType-->'+item.RecordType.Name)
                    item.recordType=item.RecordType.Name;
                    item.lineItemUrl = '/'+item.Id;
                    var PVol = (item.Promo_Volume__c == 'NA' || item.Promo_Volume__c == '' || item.Promo_Volume__c == undefined) ? null :item.Promo_Volume__c.replaceAll(',','');
                    item.Promo_Volume__c = PVol;
                    var newAnnualUnits = (item.New_Annual_Volume_units__c == 'NA' || item.New_Annual_Volume_units__c == '' || item.New_Annual_Volume_units__c == undefined) ? null :item.New_Annual_Volume_units__c.replaceAll(',','');
                    item.New_Annual_Volume_units__c = newAnnualUnits;
                    var curVol = (item.Current_Annual_Volume_units__c == 'NA' || item.Current_Annual_Volume_units__c == '' || item.Current_Annual_Volume_units__c == undefined) ? null :item.Current_Annual_Volume_units__c.replaceAll(',','');
                    item.Current_Annual_Volume_units__c = curVol;
                    var annualUnits = (item.Annual_Volume_units__c == 'NA' || item.Annual_Volume_units__c == '' || item.Annual_Volume_units__c == undefined) ? null :item.Annual_Volume_units__c.replaceAll(',','');
                    item.Annual_Volume_units__c = annualUnits;
                    var currentContractPrice = (item.Current_Contract_Price__c == 'NA' || item.Current_Contract_Price__c == '' || item.Current_Contract_Price__c == undefined) ? null :item.Current_Contract_Price__c.replaceAll('$','');
                    item.Current_Contract_Price__c = currentContractPrice;
                    
                });    
                
                
            }
            if(bidLinesData != undefined){
                bidLinesData.forEach(function(item){
                    item.AccountName =item.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                    item.ApprovalStatus=item.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                    item.bidType=item.Phoenix_Bid__r.Phoenix_Bid_Type__c;
                    item.bidName=item.Phoenix_Bid__r.Name;
                    item.lineItemUrl='/'+item.Phoenix_Bid__c;
                    item.customerUrl='/'+item.Phoenix_Bid__r.Phoenix_Customer__c;
                    item.bidCloseDate = item.Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c;
                });
            }
            if(nprDataRecords!=undefined){
            nprDataRecords.forEach(function(nprRec){
                    nprRec.productName=nprRec.Phoenix_Product__r!=undefined ? nprRec.Phoenix_Product__r.Name:'';
                    nprRec.productUrl= '/'+nprRec.Phoenix_Product__c;
                    nprRec.customerURL= '/'+nprRec.Phoenix_Account__c;
           		    nprRec.customerName  = nprRec.Phoenix_Account__r.Name
            });
            }
            component.set("v.nprDataList",nprDataRecords);
            component.set("v.model", model);
            component.set("v.bidLinesData", bidLinesData);
            component.set("v.bidHistoryList",response.getReturnValue());
            component.set("v.isSpinnerLoad",false);
            if(wrapper!=undefined && wrapper!=null){
                component.set("v.pickListOptionStatus",wrapper.approvalStatusOptions); 
                component.set("v.pickListOption",wrapper.bidStatusOptions); 
            }
            
            
            /*if(response.getReturnValue()[0].nprHistCheck== 'noHist'){
                component.set("v.pickListOption",[]);
                component.set("v.pickListOptionStatus",[]);
                component.set("v.pickListOptionCustResp",[]);
                component.set("v.noRec",true);
            }
            else{
                component.set("v.pickListOption",response.getReturnValue()[0].pickListOptions);
                component.set("v.pickListOptionStatus",response.getReturnValue()[0].pickListOptionsStatus);
                component.set("v.pickListOptionCustResp",response.getReturnValue()[0].pickListOptionsCustResp);
                
                component.set("v.noRec",false);
            }   
            
            component.set("v.prodId",response.getReturnValue()[0].prodId);
            component.set("v.prodName",response.getReturnValue()[0].prodName);
            component.set("v.ndc",response.getReturnValue()[0].ndc);*/
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent1");
        event.setParam("message", "the message to send" );
        event.fire();
        
    },
    
    sortData : function(component,fieldName,sortDirection){
        
        var data = component.get("v.model");
        var bidLines = component.get("v.bidLinesData");
        var nprData =    component.get("v.nprDataList");
        if(data!=null){
            fieldName = fieldName=='lineItemUrl' ? 'Name':fieldName;
            //function to return the value stored in the field
            var key = function(a) { return a[fieldName]; }
            var reverse = sortDirection == 'asc' ? 1: -1;
            
            // to handel number/currency type fields 
            if(fieldName == 'Phoenix_Current_Direct_Price__c' || fieldName=='Phoenix_ProposedContractBidPriceMktng__c' || fieldName == 'Phoenix_ProposedContractBidPriceMktng__c' || fieldName == 'Price__c' || fieldName == 'netSales' || fieldName == 'volume' || fieldName == 'tptDollar' || fieldName == 'tptPercent'){ 
                console.log('if fieldName--->'+fieldName)
                data.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                }); 
            }
            else{// to handel text type fields 
                console.log('else case in sorting')
                data.sort(function(a,b){ 
                    var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                    var b = key(b) ? key(b).toLowerCase() : '';
                    return reverse * ((a>b) - (b>a));
                });    
            }
            //set sorted data to accountData attribute
            component.set("v.model",data);   
            
        }
        if(bidLines !=undefined){
    		fieldName = fieldName=='lineItemUrl' ? 'Name' :fieldName == 'customerUrl' ? 'AccountName' : fieldName;
             //function to return the value stored in the field
            var key = function(a) { return a[fieldName]; }
            var reverse = sortDirection == 'asc' ? 1: -1;
            
            // to handel number/currency type fields 
            if(fieldName == 'Phoenix_Current_Direct_Price__c' || fieldName == 'Phoenix_ProposedContractBidPriceMktng__c' ||  fieldName == 'Phoenix_Current_Price_Calc__c' || fieldName == 'Phoenix_Final_Total_Selling_Unit__c'){ 
                bidLines.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                }); 
            }
            else{// to handel text type fields 
                console.log('else case in sorting')
                bidLines.sort(function(a,b){ 
                    var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                    var b = key(b) ? key(b).toLowerCase() : '';
                    return reverse * ((a>b) - (b>a));
                });    
            }
            //set sorted data to accountData attribute
            component.set("v.bidLinesData",bidLines);   
           
            
        }
        if(nprData != undefined){
            fieldName = fieldName=='customerURL' ? 'customerName' :fieldName == 'productUrl' ? 'productName' : fieldName;
              //function to return the value stored in the field
            var key = function(a) { return a[fieldName]; }
            var reverse = sortDirection == 'asc' ? 1: -1;
            
            // to handel number/currency type fields 
            if(fieldName == 'Phoenix_Contract_Price__c' || fieldName=='customerName' || fieldName=='productName'){ 
                nprData.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                }); 
            }
            else{// to handel text type fields 
                console.log('else case in sorting')
                nprData.sort(function(a,b){ 
                    var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                    var b = key(b) ? key(b).toLowerCase() : '';
                    return reverse * ((a>b) - (b>a));
                });    
            }
            //set sorted data to accountData attribute
            component.set("v.nprDataList",nprData);   
           
        }
    } ,
    
    
    onLoadFilter: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        
        var spaApprStatus=component.find("spaApprovalStatus") != undefined ? component.find("spaApprovalStatus").get("v.value"):'';
        var bidApprStatus= component.find("bidStatus")!= undefined ?  component.find("bidStatus").get("v.value") : '';
        
        
      
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var action = component.get("c.getFilterData");
        action.setParams({
            bidLineId : rowIndex,
            isAllCustomer: component.get("v.isAllCustomer"),
            isAllSPACustomer:component.get("v.isAllSPACustomer"),
            spaApprStatus:spaApprStatus,
            bidApprStatus:bidApprStatus,
            searchText:component.get("v.SearchKeyWordPD"),
            SearchKeyWordSPA:component.get("v.SearchKeyWordSPA"),
            SearchKeyWordNpr:component.get("v.SearchKeyWordNpr"),
            isAllNprData:component.get("v.isAllNprData"),
        });
        action.setCallback(this, function(response) {
            let wrapper = response.getReturnValue();
            console.log('response--->'+JSON.stringify(wrapper))
            var model,bidLinesData,nprDataRecords;
            if(wrapper!=undefined && wrapper!=null){
                model=wrapper.spaDataRecords
                bidLinesData=wrapper.bidLines;
                 nprDataRecords=wrapper.nprData;
            }
            if(wrapper!=undefined && wrapper!=null){
             component.set("v.productObj",wrapper.productRec);
            }
            if(model!=undefined){
                model.forEach(function(item){
                    console.log('recordType-->'+item.RecordType.Name)
                    item.recordType=item.RecordType.Name;
                    item.lineItemUrl = '/'+item.Id;
                    var PVol = (item.Promo_Volume__c == 'NA' || item.Promo_Volume__c == '' || item.Promo_Volume__c == undefined) ? null :item.Promo_Volume__c.replaceAll(',','');
                    item.Promo_Volume__c = PVol;
                    var newAnnualUnits = (item.New_Annual_Volume_units__c == 'NA' || item.New_Annual_Volume_units__c == '' || item.New_Annual_Volume_units__c == undefined) ? null :item.New_Annual_Volume_units__c.replaceAll(',','');
                    item.New_Annual_Volume_units__c = newAnnualUnits;
                    var curVol = (item.Current_Annual_Volume_units__c == 'NA' || item.Current_Annual_Volume_units__c == '' || item.Current_Annual_Volume_units__c == undefined) ? null :item.Current_Annual_Volume_units__c.replaceAll(',','');
                    item.Current_Annual_Volume_units__c = curVol;
                    var annualUnits = (item.Annual_Volume_units__c == 'NA' || item.Annual_Volume_units__c == '' || item.Annual_Volume_units__c == undefined) ? null :item.Annual_Volume_units__c.replaceAll(',','');
                    item.Annual_Volume_units__c = annualUnits;
                    var currentContractPrice = (item.Current_Contract_Price__c == 'NA' || item.Current_Contract_Price__c == '' || item.Current_Contract_Price__c == undefined) ? null :item.Current_Contract_Price__c.replaceAll('$','');
                    item.Current_Contract_Price__c = currentContractPrice;
                    
                });    
                
                
            }
            if(bidLinesData != undefined){
                bidLinesData.forEach(function(item){
                    item.AccountName =item.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                    item.ApprovalStatus=item.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                    item.bidType=item.Phoenix_Bid__r.Phoenix_Bid_Type__c;
                    item.bidName=item.Phoenix_Bid__r.Name;
                    item.lineItemUrl='/'+item.Phoenix_Bid__c;
                    item.customerUrl='/'+item.Phoenix_Bid__r.Phoenix_Customer__c;
                    item.bidCloseDate = item.Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c;
                });
            }
            if(nprDataRecords!=undefined){
                nprDataRecords.forEach(function(nprRec){
                    nprRec.productName=nprRec.Phoenix_Product__r!=undefined ? nprRec.Phoenix_Product__r.Name:'';
                    nprRec.productUrl= '/'+nprRec.Phoenix_Product__c;
                    nprRec.customerURL= '/'+nprRec.Phoenix_Account__c;
                    nprRec.customerName  = nprRec.Phoenix_Account__r.Name
                });
            }
            component.set("v.nprDataList",nprDataRecords);
            component.set("v.model", model);
            component.set("v.bidLinesData", bidLinesData);
            component.set("v.bidHistoryList",response.getReturnValue());
            component.set("v.isSpinnerLoad",false);
            
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent1");
        event.setParam("message", "the message to send" );
        event.fire();
    }
    
})