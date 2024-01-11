({
    doInit : function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        component.set('v.showSaveCancelBtn',false);
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        console.log('RecordID is:: '+recordId);
        component.set("v.pageNumbers",[]);
        component.set("v.recordId", recordId);
        var action = component.get("c.getRelatedList1");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data = [];
            if (state == "SUCCESS") {
                
                
                
                var wrapperObj =  response.getReturnValue();
                var lineItemsList = wrapperObj.lineItemsList;
                var bidRecord = wrapperObj.bidRecord;
                var loggedinUserName=wrapperObj.loggedInUserName;
                var loggedInUserId=wrapperObj.loggedInUserId;
                var summaryViewList =[];
                var summaryViewNDCList =[];

                var isMarketingHeadPerson=wrapperObj.isMarketingHeadApprovePerson;
                var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                
                component.set("v.isMarketingHeadPerson",isMarketingHeadPerson);
                lineItemsList.forEach(function(item){
                    console.log('summaryViewList NDC-----'+item.Phoenix_Cust_Number__c);
                    if(item.Phoenix_System_WAC__c != item.Phoenix_Proposed_WAC__c){
                        if(!summaryViewList.includes(item)){
                           
                            if(!summaryViewNDCList.includes(item.Phoenix_NDC11__c)){
                                summaryViewNDCList.push(item.Phoenix_NDC11__c);
                                summaryViewList.push(item); 
                                
                            }
                        }
                        
                    }
                });
                summaryViewList.forEach(function(item){
                    
                });
                if( isContractsApprovePerson!=null && isContractsApprovePerson!=undefined){
                    component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                }
                component.set("v.isVistexApprovePerson",isVistexApprovePerson);
                
                
                
                
                component.set('v.isSpinnerLoad',false);                                  
                component.set("v.bidNumber",bidRecord.Name);                                 
                component.set("v.bidName",bidRecord.Phoenix_WAC_Change_Name__c);               
                component.set('v.summaryViewList',summaryViewList);
                console.log('summaryViewList-----'+JSON.stringify(summaryViewList));
                                console.log('summaryViewList len-----'+summaryViewList.length);

                if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                    component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                }
                
                if( loggedinUserName!=null && loggedinUserName!=undefined){
                    component.set("v.loggedInUserName",loggedinUserName);
                }
                if( loggedInUserId!=null && loggedInUserId!=undefined){
                    component.set("v.loggedInUserId",loggedInUserId);
                }
                
                if(lineItemsList.length > 50){
                    function calculatePagesCount(pageSize, totalCount) {
                        return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                    }
                    
                    var pageSize = 50;
                    var itemsCount = lineItemsList.length;
                    var pagesCount = calculatePagesCount(pageSize, itemsCount);
                    var pageNumbers = [];
                    for(var i=0;i<pagesCount;i++){
                        pageNumbers.push(i+1);
                    }
                    component.set("v.pageNumbers",pageNumbers);
                    var pagedLineItems = lineItemsList.slice(0,50);
                    component.set("v.pagedLineItems",pagedLineItems);
                }
                else{
                    component.set("v.pagedLineItems",lineItemsList);
                    var pageNum=[];
                    component.set("v.pageNumbers",pageNum);
                }
                component.set("v.selectedPageNumber",'1');
                component.set("v.NDCLineItemList",lineItemsList);
                component.set("v.NDCLineItemListDuplicates", lineItemsList);
                
               //Pagination for summary view
                if(summaryViewList.length > 50){
                    function calculatePagesCountSumView(pageSizeSumView, totalCountSumView) {
                        return totalCountSumView < pageSizeSumView ? 1 : Math.ceil(totalCountSumView / pageSizeSumView);
                    }
                    
                    var pageSizeSumView = 50;
                    var itemsCountSumView = summaryViewList.length;
                    var pagesCountSumView = calculatePagesCountSumView(pageSize, itemsCount);
                    var pageNumbersSumView = [];
                    for(var i=0;i<pagesCountSumView;i++){
                        pageNumbersSumView.push(i+1);
                    }
                    component.set("v.pageNumbersSumView",pageNumbersSumView);
                    var pagedSumView = summaryViewList.slice(0,50);
                    component.set("v.pagedSumView",pagedSumView);
                }
                else{
                    component.set("v.pagedSumView",summaryViewList);
                    var pageNum=[];
                    component.set("v.pageNumbersSumView",pageNum);
                }
                component.set("v.selectedPageNumberSumView",'1');
                
                //Pagination for summary view end
                var OutDiv = component.find("mainDiv");
                if(lineItemsList.length<10){
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");
                }else{
                    $A.util.removeClass(OutDiv, "noheightClass");
                }
            } else {
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action); 
    },
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        
        var message = event.getParam("message");
        var action = component.get("c.getRelatedList1");
        action.setParams
        ({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               var wrapperObj =  response.getReturnValue();
                               var lineItemsList = wrapperObj.lineItemsList;
                               
                               
                               if(lineItemsList.length > 50){
                                   function calculatePagesCount(pageSize, totalCount) {
                                       return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                                   }
                                   
                                   var pageSize = 50;
                                   var itemsCount = lineItemsList.length;
                                   var pagesCount = calculatePagesCount(pageSize, itemsCount);
                                   var pageNumbers = [];
                                   for(var i=0;i<pagesCount;i++){
                                       pageNumbers.push(i+1);
                                   }
                                   component.set("v.pageNumbers",pageNumbers);
                                   //var pagedLineItems = lineItemsList.slice(0,50);
                                   //component.set("v.pagedLineItems",pagedLineItems);
                                   var selectedPageNumber = component.get("v.selectedPageNumber");
                                   if(pagesCount<selectedPageNumber)
                                       selectedPageNumber = pagesCount;
                                   var pagedLineItems = lineItemsList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
                                   component.set("v.pagedLineItems",pagedLineItems);
                                   
                                   
                               }
                               else{
                                   component.set("v.pagedLineItems",lineItemsList);
                                   var pageNum=[];
                                   component.set("v.pageNumbers",pageNum);
                               }
                               component.set("v.NDCLineItemList",lineItemsList);
                               component.set('v.isSpinnerLoad',false);
                               var OutDiv = component.find("mainDiv");
                               if(lineItemsList.length<10){
                                   console.log('--no-hight---');
                                   $A.util.addClass(OutDiv, "noheightClass");
                               }else{
                                   $A.util.removeClass(OutDiv, "noheightClass");
                               }
                           });
        $A.enqueueAction(action);
    },
    initRejectedStatus : function(component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.IPArejectedStatusRefresh();
    },
    openModel: function (component, event, helper) {
        var appStatus = component.get("v.BidAprrovalStatus");
        console.log('Approval Status:::: ' + appStatus);
        component.set("v.isCustSpecific", false);
        if (appStatus == 'Contracts' || appStatus == 'Customer' || appStatus == "Customer's Update" || appStatus == 'Vistex Update' || appStatus == 'Closed') {
            component.set("v.isOpen", true);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                message: 'You can only generate offer document when in Contracts stage or later stage',
                duration: ' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        }
    },
    openCustSpecificModel: function (component, event, helper) {
        var appStatus = component.get("v.BidAprrovalStatus");
        console.log('Approval Status:::: ' + appStatus);
        if (appStatus == 'Contracts' || appStatus == 'Customer' || appStatus == "Customer's Update" || appStatus == 'Vistex Update' || appStatus == 'Closed') {
            component.set("v.isCustSpecific", true);
            component.set("v.isOpen", true);
        } else {
            component.set("v.isCustSpecific", false);
            component.set("v.isOpen", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                message: 'You can only generate offer document when in Contracts stage or later stage',
                duration: ' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        }
    },
    Save: function(component, event, helper) {
        
        
        
        
        var saveditems = component.get("v.NDCLineItemList");
        
        
        var IsshowLeadTime=false;
        var IsshowAwardedQty=false;
        
        
        
        
        
        //if(IsshowLeadTime==false){
        component.set('v.isSpinnerLoad',true);
        var action = component.get("c.updateWACItems");
        action.setParams({
            "recordId": component.get("v.recordId"),
            'lineItems': component.get("v.NDCLineItemList")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse.length > 50){
                    function calculatePagesCount(pageSize, totalCount) {
                        return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                    }
                    
                    var pageSize = 50;
                    var itemsCount = storeResponse.length;
                    var pagesCount = calculatePagesCount(pageSize, itemsCount);
                    var pageNumbers = [];
                    for(var i=0;i<pagesCount;i++){
                        pageNumbers.push(i+1);
                    }
                    component.set("v.pageNumbers",pageNumbers);
                    //var pagedLineItems = lineItemsList.slice(0,50);
                    //component.set("v.pagedLineItems",pagedLineItems);
                    var selectedPageNumber = component.get("v.selectedPageNumber");
                    if(pagesCount<selectedPageNumber)
                        selectedPageNumber = pagesCount;
                    var pagedLineItems = storeResponse.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
                    component.set("v.pagedLineItems",pagedLineItems);
                    
                    
                }
                else{
                    component.set("v.pagedLineItems",storeResponse);
                    var pageNum=[];
                    component.set("v.pageNumbers",pageNum);
                }
                component.set("v.showSaveCancelBtn",false);
                component.set('v.isSpinnerLoad',false);
                component.set('v.NDCLineItemList',storeResponse);
                //alert('Updated...');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Success",
                    "title": "Success",
                    "message": "Records are saved successfully"
                });
                toastEvent.fire();   
            } else {
                component.set("v.showSaveCancelBtn",false);
                component.set('v.isSpinnerLoad',false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        //}
    },
    
    downloadCsv: function (component, event, helper) {
        
        var action = component.get("c.getupdatedforExport");
        action.setParams({
            "bidId" : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            
            var ResultData =a.getReturnValue();        
            
            var bidNumber=component.get("v.bidNumber");
            var bidName=component.get("v.bidName");
            
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSV(component,ResultData);   
            if (csv == null){return;} 
            
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
            var hiddenElement = document.createElement('a');
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
            hiddenElement.download = 'Input View'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
        });
        $A.enqueueAction(action);
        
    },
    
    backToBid : function(component, event, helper){
        
        console.log('recordId-----'+component.get("v.recordId"));
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
    },
    onApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        //component.set("v.isApprovalChanged",true);
        var LineItemList= component.get("v.NDCLineItemList");
        var contractApproval;
        var contractApprovaltype = component.find("headerContractApproval");
        if(contractApprovaltype != null){
            contractApproval = contractApprovaltype.get("v.value");
        }else{
            contractApproval= '';
        }
        if(contractApproval!=null && contractApproval!='' && contractApproval!=undefined){
            LineItemList.forEach(function(line){
                //if(line.Phoenix_Final_Status__c!='Not Approved'){
                
                line['Phoenix_Contracts_Approval__c'] = contractApproval;
                //}
                
                
                
            });
        }
        component.set("v.NDCLineItemList",LineItemList);
        
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
        
        
        
        
    },
    onCustomerApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        //component.set("v.isApprovalChanged",true);
        var LineItemList= component.get("v.NDCLineItemList");
        var contractApproval;
        // var LineItemListcopy=[];
        var contractApprovaltype = component.find("headerCustomerApproval");
        if(contractApprovaltype != null){
            contractApproval = contractApprovaltype.get("v.value");
        }else{
            contractApproval= '';
        }
        if(contractApproval!=null && contractApproval!='' && contractApproval!=undefined){
            LineItemList.forEach(function(line){
                //if(line.Phoenix_Final_Status__c!='Not Approved'){
                line['Phoenix_Customer_Update_Approval__c'] = contractApproval;
                //LineItemListcopy.push(line);
                // }
                
                
                
            });
        }
        component.set("v.NDCLineItemList",LineItemList);
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
    },
    
    onMarketingHeadRemarksChange:  function(component,event, helper){
        
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.NDCLineItemList");
        //var LineItemListcopy=[];
        var MarketingHeadRemarks;
        var headerMarketingHeadRemarks = component.find("headerMarketingHeadRemarks");
        if(headerMarketingHeadRemarks != null){
            MarketingHeadRemarks = headerMarketingHeadRemarks.get("v.value");
        }else{
            MarketingHeadRemarks= '';
        }
        console.log('MarketingHeadRemarks-----'+MarketingHeadRemarks);
        //if(financeRemarks!=null && financeRemarks!='' && financeRemarks!=undefined){
        LineItemList.forEach(function(line){
            if(line.Phoenix_Final_Status__c!='Not Approved'){
                line['Phoenix_Head_of_PM_Comments__c'] = MarketingHeadRemarks;
                //LineItemListcopy.push(line);
            }
            
            
            
        });
        //} 
        component.set("v.NDCLineItemList",LineItemList);
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
        
    },
    onContractsRemarksChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.NDCLineItemList");
        var ContractsRemarks;
        var headerContractsRemarks = component.find("headerContractsRemarks");
        if(headerContractsRemarks != null && headerContractsRemarks !=undefined ){
            ContractsRemarks = headerContractsRemarks.get("v.value");
        }else{
            ContractsRemarks= '';
        }
        console.log('ContractsRemarks---'+ContractsRemarks);
        LineItemList.forEach(function(line){
            //if(line.Phoenix_Final_Status__c!='Not Approved'){
            line['Phoenix_Contracts_Comments__c'] = ContractsRemarks;
            //}
            
            
            
        });
        
        component.set("v.NDCLineItemList",LineItemList);
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
    },
    onCustomerRemarksChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.NDCLineItemList");
        var CustomerRemarks;
        var headerCustomerRemarks = component.find("headerCustomerRemarks");
        if(headerCustomerRemarks != null){
            CustomerRemarks = headerCustomerRemarks.get("v.value");
        }else{
            CustomerRemarks= '';
        }
        
        LineItemList.forEach(function(line){
            // if(line.Phoenix_Final_Status__c!='Not Approved'){
            line['Phoenix_Customer_Update_Remarks__c'] = CustomerRemarks;
            // }
            
            
            
        });
        
        component.set("v.NDCLineItemList",LineItemList);
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
    },
    onVistexRemarksChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.NDCLineItemList");
        //var LineItemListcopy=[];
        var vistexRemarks;
        var headerVistexRemarks = component.find("headerVistexRemarks");
        if(headerVistexRemarks != null && headerVistexRemarks !=undefined ){
            vistexRemarks = headerVistexRemarks.get("v.value");
        }else{
            vistexRemarks= '';
        }
        console.log('vistexRemarks----'+vistexRemarks);
        LineItemList.forEach(function(line){
            //if(line.Phoenix_Final_Status__c!='Not Approved'){
            line['Phoenix_Vistex_Remarks__c'] = vistexRemarks;
            //LineItemListcopy.push(line);
            
            //}
            
            
            
        });
        
        component.set("v.NDCLineItemList",LineItemList);
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
    },
    
    onMarketingHeadChange :  function(component,event, helper){
        
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.NDCLineItemList");
        var MarketingHead;
        var headerMarketingHead = component.find("headerMarketingHead");
        if(headerMarketingHead != null){
            MarketingHead = headerMarketingHead.get("v.value");
        }else{
            MarketingHead= '';
        }
        console.log('MarketingHead-----'+MarketingHead);
        if(MarketingHead!=null && MarketingHead!='' && MarketingHead!=undefined){
            LineItemList.forEach(function(line){
                //if(line.Phoenix_Final_Status__c!='Not Approved'){
                line['Phoenix_Head_of_PM_Group_Approval__c'] = MarketingHead;
                //}
                
                
                
                
            });
        } 
        component.set("v.NDCLineItemList",LineItemList);
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
        
    },
    
    onApprovalVistexChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.NDCLineItemList");
        var LineItemListcopy=[];
        var vistexApproval;
        var headerVistexApproval = component.find("headerVistexApproval");
        if(headerVistexApproval != null){
            vistexApproval = headerVistexApproval.get("v.value");
        }else{
            vistexApproval= '';
        }
        if(vistexApproval!=null && vistexApproval!='' && vistexApproval!=undefined){
            LineItemList.forEach(function(line){
                // if(line.Phoenix_Final_Status__c!='Not Approved'){
                line['Phoenix_Vistex_Update_Approval__c'] = vistexApproval;
                //LineItemListcopy.push(line);
                
                //}
                
                
                
            });
        }
        component.set("v.NDCLineItemList",LineItemList);
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var pagedLineItems = LineItemList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
        component.set("v.pagedLineItems",pagedLineItems);
        
    },
    
    
    saveToProceedMarketingHead:function(component,event,helper){
        
        
        var isFinance=true;
        var isContracts=false;
        var isCustomer=false;
        var isVistex=false;
        
        helper.submitForProceed(component,event,helper,isFinance,isContracts,isCustomer,isVistex);
    },
    saveToProceedContracts: function(component,event,helper){
        
        var isFinance=false;
        var isContracts=true;
        var isCustomer=false;
        var isVistex=false;
        
        helper.submitForProceed(component,event,helper,isFinance,isContracts,isCustomer,isVistex);
    },
    
    saveToProceedVistex: function(component,event,helper){
        
        var isFinance=false;
        var isContracts=false;
        var isCustomer=false;
        var isVistex=true;
        helper.submitForProceed(component,event,helper,isFinance,isContracts,isCustomer,isVistex);    
    },
    saveToProceedCustomer: function(component,event,helper){
        
        var isFinance=false;
        var isContracts=false;
        var isCustomer=true;
        var isVistex=false;
        helper.submitForProceed(component,event,helper,isFinance,isContracts,isCustomer,isVistex);    
    },
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
        // component.set("v.showPriceMsg",false);
    },
    
    
    
    keyCheck: function(component, event, helper){
        if(event.which == 13){
            console.log('keychek');
            var searchName=component.get("v.searchText"); 
            if(searchName!=null && searchName!='undefined' && searchName!=''){
                component.set("v.IsSearch",true);
                helper.searchTablehelper(component,helper); 
            }
        }
    },
    
    onsearch: function(component, event, helper){
        var searchName=component.get("v.searchText"); 
        console.log('searchName---'+searchName);
        if(searchName!=null && searchName!='undefined' && searchName!=''){
            component.set("v.IsSearch",true);
            helper.searchTablehelper(component,helper); 
        }
        else{
            var lineItems=component.get("v.NDCLineItemListDuplicates");
            if(lineItems.length > 50){
                function calculatePagesCount(pageSize, totalCount) {
                    return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                }
                
                var pageSize = 50;
                var itemsCount = lineItems.length;
                var pagesCount = calculatePagesCount(pageSize, itemsCount);
                var pageNumbers = [];
                for(var i=0;i<pagesCount;i++){
                    pageNumbers.push(i+1);
                }
                component.set("v.pageNumbers",pageNumbers);
                var pagedLineItems = lineItems.slice(0,50);
                component.set("v.pagedLineItems",pagedLineItems);
            }
            else{
                component.set("v.pagedLineItems",lineItems);
                var pageNum=[];
                component.set("v.pageNumbers",pageNum);
            }
            component.set("v.NDCLineItemList",lineItems);
            var OutDiv = component.find("mainDiv");
            if(lineItems.length<10){
                console.log('--no-hight---');
                $A.util.addClass(OutDiv, "noheightClass");
            }else{
                $A.util.removeClass(OutDiv, "noheightClass");
            }
        }
    },
    onClear:function(component, event, helper){
        var searchName=component.get("v.searchText"); 
        if(searchName==null || searchName=='undefined'|| searchName==''){
            
            
            var lineItems=component.get("v.NDCLineItemListDuplicates");
            
            
            
            if(lineItems.length > 50){
                function calculatePagesCount(pageSize, totalCount) {
                    return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                }
                
                var pageSize = 50;
                var itemsCount = lineItems.length;
                var pagesCount = calculatePagesCount(pageSize, itemsCount);
                var pageNumbers = [];
                for(var i=0;i<pagesCount;i++){
                    pageNumbers.push(i+1);
                }
                component.set("v.pageNumbers",pageNumbers);
                var pagedLineItems = lineItems.slice(0,50);
                component.set("v.pagedLineItems",pagedLineItems);
            }
            else{
                component.set("v.pagedLineItems",lineItems);
                var pageNum=[];
                component.set("v.pageNumbers",pageNum);
            }
            
            component.set("v.NDCLineItemList",lineItems); 
            var OutDiv = component.find("mainDiv");
            if(lineItems.length<10){
                console.log('--no-hight---');
                $A.util.addClass(OutDiv, "noheightClass");
            }else{
                $A.util.removeClass(OutDiv, "noheightClass");
            }
        }
    },
    //Sorting logic
    sortByWACChangeLineReference: function(component, event, helper) {
        helper.sortBy(component,event, "Name");
    },
    sortByContractNumber: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Contr_Number__c");
    },
    sortByContractInternalDescription: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Contr_IntDesc__c");
    },
    sortByCustomerName: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Cust_Name__c");
    },
    sortByCustomerNumber: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Cust_Number__c");
    },
    sortByMaterialNumber: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Matl_No__c");
    },
    sortByDescription: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Description__c");
    },
    sortByProduct: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Product__r.Name");
    },
    sortByProductFamily: function(component, event, helper){
        helper.sortBy(component,event, 'Phoenix_Product_Family__c');
    },
    sortByNDC11: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_NDC11__c");
    },
    sortByAccount: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Account__r.Name");
    },
    sortByNPR: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_NPR__r.Name");
    },
    sortBySystemWAC: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_System_WAC__c");
    },
    sortBySystemContractPrice: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_System_Contract_price__c");
    },
    sortByUploadedWAC: function(component, event, helper) {
        helper.sortBy(component, event,"Phoenix_Uploaded_WAC__c");
    },
    sortByUploadedContractPrice: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Uploaded_Contr_Price__c");
    },
    sortBySystemWACVsUploadedWAC: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_SysWAC_Vs_UploadedWAC__c");
    },
    sortBySysContrPriceVsUploadedContrPrice: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_SysContPrice_Vs_UploadContrPrice__c");
    },
    sortByProposedWAC: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Proposed_WAC__c");
    },
    sortByProposedContractPrice: function(component, event, helper) {
        helper.sortBy(component, event,"Phoenix_Proposed_Contr_Price__c");
    },
    sortByComments: function(component, event, helper) {
        helper.sortBy(component,event,"Phoenix_Comments__c");
    },
    sortByContractsComments: function(component, event, helper) {
        helper.sortBy(component,event,"Phoenix_Contracts_Comments__c");
    },
    sortByOfferLetterSent: function(component, event, helper) {
        helper.sortBy(component,event,"Phoenix_Offer_Letter_Sent__c");
    },
    sortByDateOfferSent: function(component, event, helper) {
        helper.sortBy(component,event,"Phoenix_Date_Offer_Sent__c");
    },
    sortByCustomerResponseDate: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Customer_Response_Date__c");
    },
    sortByCustomerResponseStatus: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Customer_Response_Status__c");
    },
    sortByDatePostedInVistex: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Date_Posted_in_Vistex__c");
    },
    sortByVistexRemarks: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Vistex_Remarks__c");
    },
    sortByHeadPMGroupApproval: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Head_of_PM_Group_Approval__c");
    },
    sortByHeadofPMRemarks: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Head_of_PM_Comments__c");
    },
    sortByContractsApproval: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Contracts_Approval__c");
    },
    sortByContractsComments: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Contracts_Comments__c");
    },
    sortByCustomerApproval: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Customer_Update_Approval__c");
    },
    sortByCustomerRemarks: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Customer_Update_Remarks__c");
    },
    sortByVistexApproval: function(component, event, helper) {
        helper.sortBy(component,event, "Phoenix_Vistex_Update_Approval__c");
    },
    sortByDescriptionSummaryView: function(component, event, helper) {
        helper.sortBySummaryView(component,event, "Phoenix_Description__c");
    },
    sortByMatlNoSummaryView: function(component, event, helper) {
        helper.sortBySummaryView(component,event, "Phoenix_Matl_No__c");
    },
    sortByNDC11SummaryView: function(component, event, helper) {
        helper.sortBySummaryView(component,event, "Phoenix_NDC11__c");
    },
    sortBySystemWACSummaryView: function(component, event, helper) {
        helper.sortBySummaryView(component,event, "Phoenix_System_WAC__c");
    },
    sortByProposedWACSummaryView: function(component, event, helper) {
        helper.sortBySummaryView(component,event, "Phoenix_Proposed_WAC__c");
    },
    openPage : function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var selectedPageNumber = event.getSource('').get('v.label');
        if(selectedPageNumber != component.get("v.selectedPageNumber")){
            var bidLineItems = component.get("v.NDCLineItemList");
            var pagedLineItems = bidLineItems.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
            component.set("v.pagedLineItems",pagedLineItems);
            component.set("v.selectedPageNumber",selectedPageNumber);
            
            //var LineItemtable = component.find("LineTable");
            // $A.util.addClass(LineItemtable, "maintable");
        }
        component.set("v.isSpinnerLoad", false);
    },
     openPageSummaryView : function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var selectedPageNumber = event.getSource('').get('v.label');
                     console.log('selectedPageNumber summary----'+selectedPageNumber);
                     console.log('selectedPageNumber summary cmp----'+component.get("v.selectedPageNumberSumView"));

        if(selectedPageNumber != component.get("v.selectedPageNumberSumView")){
            var bidLineItems = component.get("v.summaryViewList");
            var pagedSumView = bidLineItems.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
            component.set("v.pagedSumView",pagedSumView);
            component.set("v.selectedPageNumberSumView",selectedPageNumber);
            //var LineItemtable = component.find("LineTable");
            // $A.util.addClass(LineItemtable, "maintable");
        }
        component.set("v.isSpinnerLoad", false);
    },
    openUploadPopup: function(component, event, helper){
        component.set("v.productFile", null);
        component.set("v.competitorFile", null);
        component.set("v.isOpenUploadPopup", true);
        component.set("v.dataExist", false);
    },
    closeUploadPopup: function(component, event, helper){
        component.set("v.isOpenUploadPopup", false);
    },
    initCompetitorWAC: function(component, event, helper){
		helper.initCompetitorWAC(component, event, helper);
    },
    handleImport: function(component, event, helper){
        var uploadedFiles = event.getParam("files");
        var updatedLinesList = [];
        var isProductUpload = true;
        var documentId = uploadedFiles[0].documentId;
        component.set("v.documentId", uploadedFiles[0].documentId);
        var action = component.get("c.csvFileRead");
        action.setParams({
            "contentDocumentId": uploadedFiles[0].documentId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var resp = response.getReturnValue();
                var data = [];
                var productCodes = [];
                for(var i=0; i<resp.length; i++){
                    var instance = {};
                    var respInstance = resp[i];
                    instance.Phoenix_WAC_Change__c = component.get("v.recordId");
                    instance.Phoenix_Material_Code__c = respInstance[0];
                    instance.NDC__c = respInstance[1];
                    instance.Product_Name__c = respInstance[2];
                    instance.packSize = respInstance[3];
                    instance.currentDRL = respInstance[4];
                    instance.Phoenix_Proposed_DRL_WAC__c = respInstance[5];
                    instance.Phoenix_Lowest_Dead_net__c = respInstance[6];
                    instance.Phoenix_Max_Dead_net__c = respInstance[7];
                    instance.Phoenix_Avg_Dead_net__c = respInstance[8];
                    instance.Phoenix_ReduPrecent__c = respInstance[9];
                    instance.Phoenix_GTNLowestDeadNet__c = respInstance[10];
                    instance.Phoenix_GTN_at_Avg_Dead_net__c = respInstance[11];
                    instance.Phoenix_Min_WAC__c = respInstance[12];
                    instance.Phoenix_TPT_Costs__c = respInstance[13];
                    instance.Phoenix_TPT_costs_as_of_Proposed_WAC__c = respInstance[14];
                    var productData = component.get("v.productData");
                    for(var j=0; j<productData.length; j++){
                        if(instance.Phoenix_Material_Code__c == productData[j].Phoenix_Material_Code__c){
                            instance.Id = productData[j].Id;
                        }
                    }
                    productCodes.push(respInstance[0]);
                    data.push(instance);
                }
                component.set("v.productData", data);
                component.set("v.productCodes", productCodes);
                helper.handleUpload(component, event, documentId, isProductUpload);
                helper.updateData(component, event, helper);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        }); 
        $A.enqueueAction(action);
    },
    handleCompetitorImport: function(component, event, helper){
        var uploadedFiles = event.getParam("files");
        var updatedLinesList = [];
        var isProductUpload = false;
        var documentId = uploadedFiles[0].documentId;
        component.set("v.competitorInfoDocumentId", uploadedFiles[0].documentId);
        var action = component.get("c.csvCompetitorFileRead");
        action.setParams({
            "contentDocumentId": uploadedFiles[0].documentId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var resp = response.getReturnValue();
                helper.handleUpload(component, event, documentId, isProductUpload);
                var dataWithoutHeader = [];
                var headers = [];
                resp.forEach(function(value, index) {
                    if ( index != 0 ) {
                        if(component.get("v.competitorDataToUpdate").length == 0){
                            var obj = {};
                            var d = value.split(",");
                            obj.Phoenix_Material_Code__c = d[0];
                            obj.Phoenix_WAC_Change__c = component.get("v.recordId");
                            obj.Phoenix_Competitor_Name__c = d[1];
                            obj.Phoenix_WAC_Price__c = d[2]-0;
                            dataWithoutHeader.push(obj);
                            headers.push(d[1]);   
                        } else{
                            var competitorData = component.get("v.competitorData");
                            var obj = {};
                            var d = value.split(",");
                            obj.Phoenix_Material_Code__c = d[0];
                            obj.Phoenix_WAC_Change__c = component.get("v.recordId");
                            obj.Phoenix_Competitor_Name__c = d[1];
                            obj.Phoenix_WAC_Price__c = d[2]-0;
                            var unqKey = d[0]+d[1];
                            for(var i=0; i<competitorData.length; i++){
                                if(competitorData[i].Competitor_WACs__r){
                                    for(var j=0; j<competitorData[i].Competitor_WACs__r.length; j++){
                                        var uniqKey = competitorData[i].Competitor_WACs__r[j].Phoenix_Material_Code__c+competitorData[i].Competitor_WACs__r[j].Phoenix_Competitor_Name__c;
                                        if(unqKey == uniqKey){
                                            obj.Id = competitorData[i].Competitor_WACs__r[j].Id;
                                        }
                                    }   
                                }
                            }
                            dataWithoutHeader.push(obj);
                            headers.push(d[1]);
                        }
                    }
                });
                component.set("v.competes", headers);
                component.set("v.comps", dataWithoutHeader);
                //helper.buildData(component, event, helper, headers);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        }); 
        $A.enqueueAction(action);
    },
    deleteProductAttachment: function (component, event, helper) {
        var deleteProductFile = true;
        helper.deleteAttachment(component, event, helper, deleteProductFile);     
    },
    deleteCompetitorAttachment: function (component, event, helper) {
        var deleteProductFile = false;
        helper.deleteAttachment(component, event, helper, deleteProductFile);     
    },
    saveUploadedData: function(component, event, helper){
        component.set("v.loadSpinner", true);
        var action = component.get("c.saveWACCompetitorProduct");
        var productData = component.get("v.productData");
        action.setParams({
            'competitorWACProduct': component.get("v.productData"),
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var competitorData = component.get("v.comps");
                var updatedCompetitorData = [];
                var resp = response.getReturnValue();
                for(var i=0; i<resp.length; i++){
                    for(var j=0; j<competitorData.length; j++){
                        if(competitorData[j].Phoenix_Material_Code__c == resp[i].Phoenix_Material_Code__c){
                            competitorData[j].Phoenix_WAC_Competitor_Product__c = resp[i].Id;
                            updatedCompetitorData.push(competitorData[j]);
                        }
                    }
                }
                component.set("v.comps", updatedCompetitorData);
                helper.saveCompetitorInfo(component, event, helper, competitorData);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})