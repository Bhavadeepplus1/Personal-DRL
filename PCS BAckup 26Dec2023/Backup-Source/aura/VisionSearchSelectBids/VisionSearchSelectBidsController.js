({
	doInit : function(component, event, helper) {
        console.log('selectedBids: '+component.get("v.selectedBids"));
        var action;
        if(component.get("v.bidType") == 'RFP Bids'){
            action = component.get("c.getRFPBids");
        } else{
         	action = component.get("c.getBids");   
        }
        var selectedBidIds = component.get("v.selectedBidIds");
        const index = selectedBidIds.indexOf('selectedBidIds');
        if (index > -1) {
            selectedBidIds.splice(index, 1);
        }
        component.set("v.selectedBidIds", selectedBidIds);
        component.set("v.showSpinnerSelProds", true);
        action.setParams({
            'searchText': component.get("v.searchText")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var response = response.getReturnValue();
                if(response != null){
                    var selIds = component.get("v.selectedBidIds");
                    for(var i=0; i<response.length; i++){
                        if(response[i].Phoenix_Bid_Submitted_Date__c){
                            response[i].formattedSubmittedDate = new Date(response[i].Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        }   
                        if(selIds.includes(response[i].Id)){
                            response[i].isSelected = true;
                            continue; 
                        } else{
                            response[i].isSelected = false;
                        }
                    }
                }
                component.set("v.BidList", response);
                component.set("v.Allproduct", response);
                component.set("v.totalPages", Math.ceil(response.length / component.get("v.pageSize")));
                component.set("v.allData", response);
                component.set("v.totalRecordsCount", response.length);
                component.set("v.currentPageNumber", 1);
                component.set("v.showProducts", true);
                component.set("v.showSpinnerSelProds", false);

                helper.buildData(component, event, helper);
            } else{
                console.log("Error: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
	},
    onsearch: function (component, event, helper) {
        component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        if(searchName!=null && searchName!='undefined' && searchName!='' && (searchName.trim().length > 2 || searchName.trim().length == 0)){
            component.set("v.showSpinnerSelProds", true);
            helper.searchTablehelper(component,helper, event); 
        }
    },
    onClearSearch: function (component, event, helper) {
        component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        if(searchName == ''){
            component.set("v.showSpinnerSelProds", true);
           helper.searchTablehelper(component,helper, event);  
        }
    },
    
	calculateAnalysis : function(component, event, helper) {
        //Call Parent aura method
        var parentComponent = component.get("v.parent");   
        //parentComponent.getSelectedBids(component.get("v.selectedBidIds"));
        if(component.get("v.bidType") == 'RFP Bids'){
            component.set("v.selectedBids", component.get("v.selectedBidIds"));
        } else{
            parentComponent.getSelectedBids(component.get("v.selectedBidIds"));
        }
        component.set("v.showSelectedBids", false);
    },
    
    keyCheck:function (component, event, helper) {
        if (event.which == 13){
            var searchName=component.get("v.searchText");
            if(searchName!=null && searchName!='undefined' && searchName!='' && (searchName.trim().length > 2 || searchName.trim().length == 0)){
                helper.searchTablehelper(component,helper, event);  
            }     
        }  
    },
    checkBoxChangeHandler: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.checked");
        var selectedRec1 = event.getSource().get("v.name");
        var getSelectedNumber = component.get("v.selectedCount");
        var selIds = [];
        if (selectedRec == true) {
            getSelectedNumber++;
            var selProds = component.get("v.selectedBidIds");
            selIds = selProds;
            selIds.push(selectedRec1);
        }
        else {
            getSelectedNumber--;
            var selProds = component.get("v.selectedBidIds");
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
                        if (arry[i].Id === prodId) {
                            arry.splice(i, 1);
                        }
                    }
                    component.set("v.QLlist1", arry);
                }
            }
        }
        component.set("v.selectedBidIds", selIds);
        component.set("v.selectedCount", getSelectedNumber);
        var count = component.get("v.selectedCount");
        if (count > 0) {
            component.set("v.showbutton", false);
        }
        else if (count == 0) {
            component.set("v.showbutton", true);
        }
    },
    selectAllCheckbox : function (component, event, helper){
        var selectedHeaderCheck = event.getSource().get("v.checked");
        var updatedAllRecords=[];
        var updatedPageList=[];
        var BidList=component.get("v.BidList");
        var getSelectedNumber = component.get("v.selectedCount");
        var selIds=component.get("v.selectedBidIds");
        console.log('BidList: '+JSON.stringify(BidList));
        for(var j=0;j<BidList.length;j++){
            if(selectedHeaderCheck==true){
                console.log('True');
                BidList[j].isSelected=selectedHeaderCheck;
                if(selIds.includes(BidList[j].Id)){
                    continue; 
                }
                selIds.push(BidList[j].Id);
            }
            else{
                const index = selIds.indexOf(BidList[j].Id);
                if (index > -1) {
                    selIds.splice(index, 1);
                }
                BidList[j].isSelected=selectedHeaderCheck;
                var arry = component.get("v.QLlist1");
                if(arry!=null && arry!=undefined && arry!=''){
                    if (arry.length > 0) {
                        for (var i = 0; i < arry.length; i++) {
                            if (arry[i].Id === BidList[j].Id) {
                                arry.splice(i, 1);
                            }
                        }
                        component.set("v.QLlist1", arry);
                    }
                }
            }
        }
        component.set("v.BidList", BidList);
        component.set("v.selectedBidIds",selIds);
        console.log('Selected Bids::::: '+selIds);
        var selectedProdcount=component.get("v.selectedBidIds").length;
        
        component.set("v.selectedCount", selectedProdcount);
        var count = component.get("v.selectedCount")
        if (count > 0) {
            component.set("v.showbutton", false);
        }
        else if (count == 0) {
            component.set("v.showbutton", true);
        }
    },
    processProducts: function (component, event, helper) {
        component.set("v.showProducts", false);
        //component.set("v.showSpinnerSelProds",true);
        component.set("v.showSelectedBids", true);
        component.set("v.isQLlistempty",false);
        var allProducts=component.get("v.allData");
        var selectedBidIds = component.get("v.selectedBidIds");
        var data=[];
        var pData;
        for(let j = 0; j < allProducts.length; j++){
            pData=allProducts[j];
            if (selectedBidIds.includes(pData.Id)) {
                pData.isSelected = true;
                data.push(pData); 
            }
        }
        component.set("v.QLlist",data); 
    },
    
    closePopup: function(component, event, helper){
        component.set("v.isModalOpen", false);
    },
    
    showSelectedBids: function(component, event, helper){
        component.set("v.isModalOpen", true);
        var allData=component.get("v.allData");
        console.log('allData: '+JSON.stringify(allData));
        var selectedBidIds = component.get("v.selectedBidIds");
        var data=[];
        var pData;
        for(let j = 0; j < allData.length; j++){
            pData=allData[j];
            if (selectedBidIds.includes(pData.Id)) {
                pData.isSelected = true;
                data.push(pData); 
            }
        }
        component.set("v.modalBidList", data);
    },
    
    
    removeDeletedRow: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.name");
        var AllRowsList = component.get("v.QLlist"); 
        var modalBidList = component.get("v.modalBidList");
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.Id == selectedRec) {
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    AllRowsList.splice(index, 1);
                }
            }
        }
        if(modalBidList != null){
            for (let i = 0; i < modalBidList.length; i++) {
                var pItem = modalBidList[i];
                if (pItem.Id == selectedRec) {
                    var index = modalBidList.indexOf(pItem);
                    if (index > -1) {
                        modalBidList.splice(index, 1);
                    }
                }
            }   
        }
        component.set("v.modalBidList", modalBidList);
        component.set("v.QLlist",[]);
        component.set("v.QLlist", AllRowsList);
        if (AllRowsList.length === 0) {
            component.set("v.isQLlistempty", true);
        }
        else
            component.set("v.isQLlistempty", false);
        var saveditems = component.get("v.QLlist");
        var productList=component.get("v.BidList");
        var alldata=component.get("v.allData");
        var prdlist1=[];
        component.set("v.selectedBidIds",[]);
        var count=0;
        if(AllRowsList!=undefined && AllRowsList!=null && AllRowsList!='' && AllRowsList.length>0)
        {
            for (let i = 0; i < AllRowsList.length; i++) {
                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].Id == AllRowsList[i].Id)
                    {
                        count=count+1;
                        alldata[j].isSelected=true;
                        prdlist1.push(alldata[j].Id);
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
        
        component.set("v.selectedBidIds",prdlist1);
        
        helper.buildData(component, helper);
    },
    closeModal: function(component, event, helper){
        component.set("v.showProducts", false);
        component.set("v.showSelectedBids", false);
        component.set("v.searchText", '');
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
    ShowProdList: function (component, event, helper) {
        component.set("v.showProducts", true);
        component.set("v.showSelectedBids", false);
        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);
    },
    sortBidNo: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'BidNo');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Name');
    },
    
    sortBidName: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'BidName');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Bid_Name__c');
    },
    sortBidType: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'BidType');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_Bid_Type__c');
    },
    
    sortBidOwner: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'BidOwner');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_Bid_Owner__r.Name');
    },
    sortDate: function(component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'Date');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_Bid_Submitted_Date__c');
    },
})