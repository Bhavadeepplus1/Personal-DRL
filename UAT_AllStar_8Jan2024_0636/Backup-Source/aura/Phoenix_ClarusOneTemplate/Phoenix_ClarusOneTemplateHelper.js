({
     getBidInfoForValids : function(component,event,helper){
        component.set('v.isSpinnerLoad',true);
        var action = component.get("c.getSubmitBidInfo");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var resposneString =  response.getReturnValue(); 
                                   console.log(resposneString);
                                   if(resposneString=='Success'){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Success!",
                                           "message":"Bid is sent for approval.",
                                           "type":"success",
                                           "mode":"dismissible"
                                       });
                                       toastEvent.fire();
                                       component.set('v.isSpinnerLoad',false);
                                       component.find("navigationService").navigate({
                                           type: "standard__recordPage",
                                           attributes: {
                                               recordId: component.get("v.recordId"),
                                               actionName: "view"
                                           }
                                       }, false);
                                   }
                                   else{
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Error!",
                                           "message":resposneString,
                                           "type":"error",
                                           "mode":"dismissible"
                                       });
                                       toastEvent.fire(); 
                                       component.set('v.isSpinnerLoad',false);
                                   }
                               }
                           });
        $A.enqueueAction(action);
    },
      getUpdateLines: function(component,event,helper){
            var bidLines = component.get("v.BidLineItemListAll");
            var action = component.get("c.getUpdatedList");
          	action.setParams
            ({
                bidId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var responseValue= response.getReturnValue();
                                   component.set("v.BidLineItemListAll",responseValue);
                                    component.set('v.isSpinnerLoad',false);
                               }
                           });
          $A.enqueueAction(action);
        },
    getAllTotalValues :function(component, event, helper) {
        var action = component.get("c.getAllTotals");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var responseValue= response.getReturnValue();
                                   component.set("v.CurOSRADUnitsTotal",responseValue[0].osRadUnits);
                                   component.set("v.CurWMTDirUnitTotal",responseValue[0].wmtcurDirUnit);
                                   component.set("v.CurWMTIndUnitTotal",responseValue[0].wmtCurIndUnit);
                                   component.set("v.ORCurOSRADUnitsTotal",responseValue[0].overRideOSRAD);
                                   component.set("v.ORCurWMTDirUnitTotal",responseValue[0].overRideWMTIndi);
                                   component.set("v.ORCurWMTIndUnitTotal",responseValue[0].overRideWMTDire);
                                   component.set("v.PropOSUnitTotal",responseValue[0].propOS);
                                   component.set("v.PropRADUnitTotal",responseValue[0].propRAD);
                                   component.set("v.PropWMTUnitTotal",responseValue[0].propWMT);
                                   component.set("v.MacandRADNetSales",responseValue[0].MacRadNetSales);
                                   component.set("v.WMTDirectNetSales",responseValue[0].wmtDirectNetSales);
                                   component.set("v.WMTindirectNetSales",responseValue[0].wmtIndirectnetSales);
                                   component.set("v.CDSUTotal",responseValue[0].cdsu);
                                   component.set("v.netSalesIntTotal",responseValue[0].netsint);
                                   component.set("v.LCostTotal",responseValue[0].lesscost);
                                   component.set("v.ThptMrgnDTotal",responseValue[0].thptm);
                                   component.set("v.intDeadNetTotal",responseValue[0].intdead);
                                    component.set("v.proNetSaleDir",responseValue[0].pnsd);
                                   component.set("v.proNetSaleInd",responseValue[0].pnsInd);
                                   component.set("v.proTPTDir",responseValue[0].pTPTDir);
                                   component.set("v.proTPTInd",responseValue[0].pTPTInd);
                                   component.set("v.MckRadTPT",responseValue[0].macRADTPT);
                                   component.set("v.WMTDirTPT",responseValue[0].WMTDirTPTDollr);
                                   component.set("v.WMTIndirTPT",responseValue[0].WMTIndirTPTDolar);
                                   component.set("v.totalNetSalesCom",responseValue[0].totalNetSalesCom);
                                   component.set("v.totalTPTDollar",responseValue[0].totalTPTDollar);
                                   component.set("v.totalWMTNetSales",responseValue[0].totalWMTNetSales);
                                   component.set("v.totalWMTTPT",responseValue[0].TotalWMTTPT);
                                   component.set("v.scmQty",responseValue[0].scmQty);
                                   
                                   console.log('TPT--->'+JSON.stringify(responseValue))
                                   component.set("v.scmOSUnits",responseValue[0].scmOSUnits);
                                   component.set("v.scmRADUnits",responseValue[0].scmRADUnits);
                                   component.set("v.scmWMTUnits",responseValue[0].scmWMTUnits);
                                   component.set("v.twlveMonRAADSales",responseValue[0].twlveMonRAADSales);
                                   component.set("v.twlveMonWMTIndiSales",responseValue[0].twlveMonWMTIndiSales);
                                   component.set("v.twlveMonWMTDIiSales",responseValue[0].twlveMonWMTDIiSales);
                                  
                                   component.set("v.CurMckNetSales",responseValue[0].CurMckNetSales);
                                   component.set("v.CurWMTDirNetSales",responseValue[0].CurWMTDirNetSales);
                                   component.set("v.CurWMTIndirNetSales",responseValue[0].CurWMTIndirNetSales);
                                   
                                   component.set("v.MckStokingOvrAmt",responseValue[0].MckStokingOvrAmt);
                                   component.set("v.WMTStokingOvrAmt",responseValue[0].WMTStokingOvrAmt);
                                   console.log('MckStokingOvrAmt--->'+responseValue[0].MckStokingOvrAmt)
                                   var ProposedTPTDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTDir/responseValue[0].pnsd)*100 : 0;
                                   var ProposedTPTInDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTInd/responseValue[0].pnsInd)*100 : 0;
                                   var BlendedTPMargin = responseValue[0].netsint =! 0 ? (responseValue[0].thptm/responseValue[0].netsint)*100 : 0;
                                   component.set("v.proTPTPerDir",ProposedTPTDir);
                                   component.set("v.proTPTPerIndir",ProposedTPTInDir);
                                   component.set("v.BlendedTPMargin",BlendedTPMargin);
                                   /* New Product Launch*/
                                   component.set("v.MCKOpeningOrderTotal",responseValue[0].mckOpeningOrder);
                                   component.set("v.MCKNetSalesTotal",responseValue[0].mckNetsales);
                                   component.set("v.MCKTPTdlTotal",responseValue[0].mcktptdl);
                                   var mcktptperc = responseValue[0].mckNetsales =! 0 ? (responseValue[0].mcktptdl/responseValue[0].mckNetsales)*100 : 0;
                                   component.set("v.MCKTPTPercTotal",mcktptperc);
                                   component.set("v.WMTOpeningOrderTotal",responseValue[0].wmtOpeningOrder);
                                   component.set("v.WMTNetSalesTotal",responseValue[0].wmtNetSales);
                                   component.set("v.WMTTPTdlTotal",responseValue[0].wmtOpeningOrderTPTdl);
                                   var wmttptperc = responseValue[0].wmtNetSales =! 0 ? (responseValue[0].wmtOpeningOrderTPTdl/responseValue[0].wmtNetSales)*100 : 0;
                                   component.set("v.WMTTPTPercTotal",wmttptperc);
                                   /* END New Product Launch*/
                                   
                               }
                               else{
                                   console.log('totals-error');
                               }
                           });
        $A.enqueueAction(action);
    },
    
    getBidDetails:function(component,event) {
        var action = component.get("c.getbidRecordDetails");
        action.setParams({
            bidId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var bidRecord=response.getReturnValue();
            }
        })
    },
    requiredValidation : function(component,event) {
        var allRecords = component.get("v.BidLineItemListAll");
        var isValid = true;
        for(var i = 0; i < allRecords.length;i++){
            if(allRecords[i].Name == null || allRecords[i].Name.trim() == ''){
                alert('Complete this field : Row No ' + (i+1) + ' Name is null' );
                isValid = false;
            }
        }
        return isValid;
    },
    searchHelper : function(component,event,getInputkeyWord) {
        var li = component.get("v.defaultlistOfProductFamily");
        console.log('list of pro family-->'+li);
        var excludelist=component.get("v.lstSelectedRecords");
        console.log('excludelist---'+excludelist);
        console.log('getInputkeyWord--'+getInputkeyWord);
        var final=[];
        let difference = li.filter(x => !excludelist.includes(x) && x.toLowerCase().startsWith(getInputkeyWord.toLowerCase()));
        console.log(difference);
        if(difference.length>0){
            component.set("v.listOfSearchRecords", difference); 
            component.set("v.Message", '');
        }else{
            component.set("v.Message", 'No Records Found...');
            component.set("v.listOfSearchRecords", null); 
        }
    },
    searchHelperProdDir : function(component,event,getInputkeyWord) {
        var li = component.get("v.defaultlistOfProductDirectors");
        console.log('list of pro dirs-->'+li);
        var excludelist=component.get("v.lstSelectedPDRecords");
        console.log('excludelist---'+excludelist);
        console.log('getInputkeyWord--'+getInputkeyWord);
        var final=[];
        let difference = li.filter(x => !excludelist.includes(x) && x.toLowerCase().startsWith(getInputkeyWord.toLowerCase()));
        console.log(difference);
        if(difference.length>0){
            component.set("v.listOfSearchPDRecords", difference); 
            component.set("v.MessagePD", '');
        }else{
            component.set("v.MessagePD", 'No Records Found...');
            component.set("v.listOfSearchPDRecords", null); 
        }
    },
    searchProductFamilyChange: function(component, event,helper) {
        component.set('v.isSpinnerLoad',true);
        var action = component.get("c.findByProductFamily");
        console.log("listOfPD----->"+component.get("v.lstSelectedPDRecords"))
        action.setParams({
            "searchKey": component.get("v.lstSelectedRecords"),
            "lineItemId" : component.get("v.recordId"),
            "sRxOtcList" : component.get("v.RxSrxList"),
            "searchPDList" : component.get("v.lstSelectedPDRecords")
        });
        action.setCallback(this, function(a) {
            var lineItemsList =a.getReturnValue();
            component.set("v.BidLineItemListAll", lineItemsList);
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
    fetchContratcs : function(component,event,helper,bidCustomer,searchInput) {
        console.log('bidCustomer---'+bidCustomer);
        var action = component.get("c.getContracts");
        action.setParams
        ({
            customerID: bidCustomer,
            searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   var responseList = response.getReturnValue();
                                   console.log('---responseList---'+responseList.length);
                                   //component.set("v.contratcsList",responseList);
                                   
                                   //below code is for remove seleceted while fetch contracts in table
                                   var sltcntcntrcs=component.get('v.selectedCntrcts');
                                   var finalContratcs = responseList.filter(comparer(sltcntcntrcs)); 
                                   function comparer(otherArray){
                                       return function(current){
                                           return otherArray.filter(function(other){                                               
                                               return other == current.Phoenix_Contract_Number__c 
                                           }).length == 0;
                                       }
                                   }
                                 
                                   for (var i = 0; i < finalContratcs.length; i++) {
                                       var row = finalContratcs[i];
                                       if(row.Phoenix_Customer__c){
                                           row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                                       }                                      
                                   }
                                    component.set("v.contratcsList",finalContratcs);
                               }
                                
                               
                           });
        $A.enqueueAction(action);
    },
    getNPRDataOfContracts :  function(component,event,helper,selectrcs,templateType) {
        
        var action = component.get("c.getNPRData");
        action.setParams
        ({
            selectrcs: selectrcs,
            // currentCd : currentCd,
            BidId:component.get("v.recordId"),
            templateType:templateType
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   helper.searchProductFamilyChange(component, event,helper);
                               }
                               
                           });
        $A.enqueueAction(action);
    },
   convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidType,isReBid,isScmapproved){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var myMap = new Map();
       myMap.set("NDC", "Phoenix_NDC__c");
       myMap.set("SAP Number", "Phoenix_Product_Code1__c");
       myMap.set("Product Family", "Product_Family_Name__c");
       myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
       myMap.set("Product Name", "Phoenix_Product__r.Name"); 
       if(isReBid == true){
           myMap.set("Previous Bid", "Phoenix_Previous_Bid__r.Name");
           myMap.set("Previous Bid Line Item", "Phoenix_Previous_LineItem__r.Name");
       }
       myMap.set("Case Pack", "Phoenix_Case_Pack__c");
       myMap.set("MOQ","Phoenix_MOQ1__c");
       myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
       myMap.set("Product Director", "Phoenix_Product_Director__c");
       myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating1__c");
       myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
       myMap.set("WAC", "Phoenix_WAC__c");
       //myMap.set("IMS Market Share", "Phoenix_IMS_Market_Share__c");
       myMap.set("REMS Programme", "Phoenix_REMS__c");
       if(bidType!='New Product Launch'){
           myMap.set("Current WMT Position", "Phoenix_Current_WMT_Position__c");
           myMap.set("Current MCK Position", "Phoenix_Current_MCK_Position__c");
           
       }
       myMap.set("Proposed WMT/MCK Position", "Phoenix_Proposed_Position__c");
       

       if(bidType!='New Product Launch'){
       if(bidType != 'Price Change' && bidType != 'Customer Rebate Change'){
           myMap.set("New Opportunities Bidding", "Phoenix_New_Opportunities_Bidding__c");
           myMap.set("New Opportunities Value", "Phoenix_New_Opportunities_Value__c");
           
       }
       
       myMap.set("Last 12 Months OS And RAD Units", "Phoenix_12_Months_Actual_Sales__c");
       myMap.set("Last 12 Months WMT Direct Units", "Phoenix_12_Months_IndirectSaleUnit__c");
       myMap.set("Last 12 Months WMT Indirect Units", "Phoenix_3_Months_Actual_Sales__c");
       myMap.set("Last 12 Months Total Units", "Phoenix_3_Months_Actual_Sales1__c");
       myMap.set("3 Months Annualized OS And RAD Units", "Phoenix_OS_and_RAD_Cur_Direct_Units_C__c");
       myMap.set("3 Months Annualized WMT Direct Units", "Phoenix_WMT_Current_Direct_Units__c");
       myMap.set("3 Months Annualized WMT Indirect Units", "Phoenix_WMT_Current_Indirect_Units__c");
       myMap.set("3 Months Annualized Total Units", "Phoenix_Proposed_Smith_Drug_Units1__c");
       myMap.set("Override OS And RAD Units", "Phoenix_Override_Current_Direct_Units__c");
       myMap.set("Override WMT Direct Units", "Phoenix_Override_Current_Indirect_Units__c");
       myMap.set("Override WMT Indirect Units", "Phoenix_Proposed_Smith_Drug_Units__c");
       myMap.set("Override Total Units", "Phoenix_Override_Current_Indirect_Units1__c");
       }
       if(bidType == "RFP Bids" ||bidType == "New Product Launch" || bidType == "Product Addition" || bidType=="Volume Review Only"){
          if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){
               myMap.set("Proposed OS Units(Current + Increment)", "Phoenix_Proposed_OS_Units__c");
           myMap.set("Proposed RAD Units(Current + Increment)", "Phoenix_Proposed_RAD_Units__c");
           myMap.set("Proposed  WMT Units(Current + Increment)", "Phoenix_Proposed_WMT_Units__c");
            }
            else{
               myMap.set("Proposed OS Units", "Phoenix_Proposed_OS_Units__c");
           myMap.set("Proposed RAD Units", "Phoenix_Proposed_RAD_Units__c");
           myMap.set("Proposed  WMT Units", "Phoenix_Proposed_WMT_Units__c");
            }
         
           myMap.set("Total Proposed Units", "Phoenix_Proposed_OS_Units1__c");
     /*  if(bidType != "New Product Launch"){
           if(isScmapproved){
               myMap.set("SCM Approved OS Units", "Phoenix_ProposedIndirectAholdDelhaizeUni__c");
               myMap.set("SCM Approved RAD Units", "Phoenix_Proposed_IndirectGaintEagleUnits__c");
               myMap.set("SCM Approved  WMT Units", "Phoenix_Final_Direct_Selling_Units_Calc__c");
           }else{
               myMap.set("SCM Approved OS Units", "");
               myMap.set("SCM Approved RAD Units", "");
               myMap.set("SCM Approved  WMT Units", "");
           }
       }*/
          
       }
       if(bidType != "New Product Launch" && bidType != "Price Change" && isScmapproved){
           myMap.set("Total SCM Approved Qty", "Phoenix_Total_SCM_Approved_Qty__c");
       }else if(bidType != "New Product Launch" && bidType != "Customer Rebate Change"){
            myMap.set("Total SCM Approved Qty", "");
       }
       
       if(bidType!='New Product Launch'){
       myMap.set("OS And RAD CP", "Phoenix_OS_RAD_CP__c");
       myMap.set("WMT Direct CP", "Phoenix_WMT_Direct_CP__c");
       myMap.set("WMT Indirect CP", "Phoenix_WMT_Indirect_CP__c");
       
       myMap.set("OS And RAD PUR", "Phoenix_OS_RAD_PUR__c");
       myMap.set("WMT Direct PUR", "Phoenix_WMT_Direct_PUR__c");
       myMap.set("WMT Indirect PUR", "Phoenix_WMT_Indirect_PUR__c");
       myMap.set("OS And RAD NCP", "Phoenix_OS_RAD_NCP__c");
       myMap.set("WMT Direct NCP", "Phoenix_WMT_Direct_NCP__c");
       myMap.set("WMT Indirect NCP", "Phoenix_WMT_Indirect_NCP__c");
       myMap.set("Current Customer Dead Net", "Phoenix_Customer_Dead_Net1__c");
       myMap.set("Current McK OS Dead Net", "Phoenix_Current_McK_RAD_Dead_net__c");
       myMap.set("Current WMT Direct Dead Net", "Phoenix_Current_WMT_Direct_Dead_net__c");
       myMap.set("Current WMT Indirect Dead Net", "Phoenix_Current_WMT_Indirect_Dead_net__c");
       
       
       
       myMap.set("Current OS and RAD Net Sales", "Phoenix_Wholesaler_Net_Sales__c");
       myMap.set("Current WMT Direct Net Sales", "Phoenix_Retail_Direct_Net_sales__c");
       myMap.set("Current WMT Indirect Net Sales", "Proposed_Net_Sales_Indirect__c");
       }
       if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
           myMap.set("Customer Guidance", "Phoenix_Guidance_Price__c");
           myMap.set("Proposed Sales NCP for McK OS And RAD", "Phoenix_Sales_Proposed_NCP_McK_And_RAD__c");
           myMap.set("Sales Proposed NCP WMT", "Phoenix_ProposedContract_Bid_Price_Sales__c");
           if(bidType=="New Product Launch"){
               //myMap.set("Current Supplier for MCK OS & RAD", "Phoenix_Current_Supplier__c");
               //myMap.set("Current Supplier for WMT", "Phoenix_Pricing_Notes__c");
               myMap.set("Brand WAC", "Brand_WAC__c");
               myMap.set("% Brand WAC for MCK OS & RAD", "Phoenix_Brand_WAC_Per__c");
               myMap.set("% Brand WAC for WMT", "Phoenix_NLC__c");
           }
           myMap.set("Proposed NCP for McK OS And RAD (Marketing)", "Phoenix_Proposed_McK_OS_And_RAD_NCP__c");
           myMap.set("Proposed NCP for WMT Direct (Marketing)", "Phoenix_Proposed_WMT_Direct_NCP__c"); 
           myMap.set("Proposed NCP for WMT Indirect (Marketing)", "Phoenix_Proposed_WMT_Indirect_NCP__c");   
           if(bidType!='New Product Launch'){
           myMap.set("% Reduction in NCP McK And RAD", "Phoenix_Reduc_in_NCP_McK_And_RAD__c");
           myMap.set("% Reduction in NCP WMT", "Phoenix_Reduction_in_NCP_WMT__c");
           }
           
       } 
       if(bidType =='Customer Rebate Change'){
           myMap.set("Proposed Rebate %", "Phoenix_Opening_Order_TPT_Per__c");
       }
       myMap.set("Mck & RAD Global Rebate", "Phoenix_Customer_Rebates1__c");
       myMap.set("Mck & RAD Admin Fee", "Phoenix_Admin_Fee_Proposed_McK_OS_RAD__c");
       myMap.set("Mck & RAD Cash terms", "Phoenix_Cash_terms_Proposed_McK_OS_RAD__c");
       myMap.set("Mck & RAD Mck RDC", "RDC_Proposed_McK_OS_RAD__c");
       myMap.set("Customer Dead net McK And RAD  (Proposed)", "Phoenix_Customer_Dead_Net_McK_RAD_Propse__c");
       myMap.set("Mck & RAD Data Fee", "Phoenix_Anda_VIP__c");
       myMap.set("McK & RAD Dead net", "Phoenix_Direct_Dead_Net__c");
       myMap.set("McK & RAD TPT in $", "Phoenix_Indirect_Dead_Net__c");
       myMap.set("McK & RAD TPT %", "Proposed_TPT_Per_Direct__c");
       if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch" ){
       myMap.set("Mck & RAD Stocking Allowance Per Unit", "Phoenix_Anda_Old_Acqusition_Costs__c");
       myMap.set("Mck & RAD Stocking Allowance Overall Amount", "Phoenix_ANDA_IOD_Overall_Amount__c");
       }
       myMap.set("Medicaid Returns  Per Unit", "Phoenix_Estimated_Medicaid_Returns__c");
       myMap.set("McK & RAD Net Sales", "Proposed_Net_Sales_Direct__c");
       myMap.set("McK & RAD TPT $", "Proposed_TPT_Indirect__c");
       myMap.set("McK & RAD TPT % Margin", "Proposed_TPT_Per_Indirect__c");
       if(bidType == "New Product Launch"){
           myMap.set("Opening Order for MCK OS and RAD", "Phoenix_Opening_Order__c");
           myMap.set("Opening Order Net Sales for MCK OS and RAD", "Phoenix_Anda_Net_Model_Sales__c");
           myMap.set("Opening Order TPT $ for MCK OS and RAD", "Phoenix_Wholesaler_Customer_Net_Price__c");
           myMap.set("Opening Order TPT % for MCK OS and RAD", "Phoenix_Opening_Order_WMTTPT__c");
       }
        
       myMap.set("WMT Direct Invoice Allowance", "Phoenix_Current_Anda_Invoice_Price__c");
       myMap.set("WMT Direct Cash Terms", "Phoenix_Cash_Terms_RxSS__c");
       myMap.set("WMT Direct Admin Fee", "Phoenix_Admin_Fee_WMT_Direct_NCP__c");
       myMap.set("WMT Direct Dead Net", "Phoenix_WMT_Direct_Dead_Net_Proposed__c");
       myMap.set("WMT Direct TPT $ Per Unit", "Phoenix_Retail_Direct_DRL_TPT__c");
       myMap.set("WMT Direct TPT %", "Phoenix_Sales_Out_Promotion_Proposed__c");
       myMap.set("WMT Indirect Admin Fee", "Phoenix_Anda_Admin_Fees__c");
       myMap.set("WMT Indirect CD", "Phoenix_Charge_Back__c");
       myMap.set("WMT Indirect RDC", "Phoenix_RDC_WMT_Indirect__c");
       myMap.set("WMT Indirect CM Fees", "Phoenix_CM_Fee_WMT_Indirect__c");
       myMap.set("WMT Indirect Dead Net", "Phoenix_Current_Retail_Indirect_Price__c");
       myMap.set("WMT Indirect TPT $ Per Unit", "Phoenix_Costco_TPT__c");
       myMap.set("WMT Indirect TPT %", "Phoenix_Retail_Direct_DRL_TPT_Percent__c");
       if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch" ){
       myMap.set("WMT Stocking Allowance Per Unit", "Phoenix_Stocking_Allowance_Per_Unit__c");
       myMap.set("WMT Stocking Allowance Overall Amount", "Phoenix_WMT_Stck_Allowance_Overall_Amnt__c");
       }
       myMap.set("WMT Direct Net Sales", "Phoenix_Retail_Indirect_Net_Sales__c");
       myMap.set("WMT Direct TPT $", "Phoenix_Wholesaler_DRL_TPT__c");
       myMap.set("WMT Direct TPT % Margin", "Phoenix_Wholesaler_DRL_TPT_Percent__c");
       myMap.set("WMT Indirect Net Sales", "Phoenix_WMT_Indirect_Net_Sales__c");
       myMap.set("WMT Indirect TPT $", "Phoenix_WMT_Indirect_TPT__c");
       myMap.set("WMT Indirect TPT % Margin", "Phoenix_WMT_Indirect_TPT_Margin__c");
       myMap.set("Total WMT Net Sales", "Phoenix_Current_Anda_Net_Model_Units__c");
       myMap.set("Total WMT TPT $", "Phoenix_Current_Anda_Units__c");
       myMap.set("Total WMT TPT %", "Phoenix_Anda_DRL_TPT_Percent__c");
       if(bidType == "New Product Launch"){
           myMap.set("Opening Order for WMT", "Phoenix_Direct_Accerodo__c");
           myMap.set("Opening Order Net Sales for WMT", "Phoenix_Opening_Order_Net_sales__c");
           myMap.set("Opening Order TPT $ for WMT", "Phoenix_Opening_Order_TPT__c");
           myMap.set("Opening Order TPT % for WMT", "Phoenix_Costco_TPTPer__c");
       }
        
       myMap.set("Total Net Sales (Combined)", "Phoenix_ProposedDirectGaintEagleUnits__c");
       myMap.set("TP $", "Phoenix_ProposedDirectAholdDelhaizeUnits__c");
       myMap.set("TP%", "Phoenix_Retail_Indirect_DRL_TPT_Percent__c");
       myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
       myMap.set("% to Budgeted ASP", "Phoenix_Proposed_to_Budget__c");
       myMap.set("Latest Estimate ASP", "Phoenix_Latest_Estimate__c");
       myMap.set("% to Latest Estimate ASP", "Phoenix_Proposed_as_of_Latest_Estimate__c");
       myMap.set("Lowest Price SKU", "Phoenix_Lowest_Price_SKU1__c");
       myMap.set("Approved Lowest Price /SKU", "Phoenix_Approved_Lowest_Price_SKU__c");
       if(bidType != "New Product Launch" && bidType != "Price Change" && bidType != "Customer Rebate Change"){
       myMap.set("Initial Stocking Order Volume", "Phoenix_Initial_Stocking_Order_Volume__c");
       myMap.set("Initial Stocking Order Comments", "Phoenix_Initial_Stocking_Order_Comments__c");
       
       myMap.set("Estimated Lead Time", "Phoenix_Estimated_Lead_Time_Days__c");
       myMap.set("SCM Approval (Y/N)", "Phoenix_SCM_Approval_Y_N__c");
       myMap.set("SCM Comments", "Phoenix_SCM_Notes__c");
       }
       if(bidType == "New Product Launch"){
		myMap.set("Estimated Lead Time", "Phoenix_Estimated_Lead_Time_Days__c");           
       }
       if(bidType == "New Product Launch"){
		myMap.set("Opening Order Comments", "Phoenix_Initial_Stocking_Order_Comments__c");           
       }
       myMap.set("Customer Comments", "Phoenix_Sales_Notes__c");
       if(bidType != "Volume Review" ){
           myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
           myMap.set("Marketing Notes", "Phoenix_Marketing_Notes__c");
           myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
           myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
           
       }
       myMap.set("Contract Status", "Phoenix_Contract_Approval__c");
       myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
       myMap.set("WAC Check", "Phoenix_WAC_Check__c");
       if(bidType == "RFP Bids" ||  bidType == "Product Addition" || bidType=="New Product Launch"){
           myMap.set("IOD Qty (Rounded To MOQ)", "Phoenix_IOD_Qty__c");
       }

        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                //console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                
                 if(value=='Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                }
                else if(value=='Phoenix_Previous_Bid__r.Name'){	
                    if(objectRecords[i]['Phoenix_Is_Re_Bid_Line_Item__c']== true){
                     csvStringResult += '"'+ objectRecords[i]["Phoenix_Previous_Bid__r"]["Name"]+'"';
                    }
                    
                }
                else if(value=='Phoenix_Previous_LineItem__r.Name') {
                    if(objectRecords[i]['Phoenix_Is_Re_Bid_Line_Item__c']== true){
                     csvStringResult += '"'+ objectRecords[i]["Phoenix_Previous_LineItem__r"]["Name"]+'"';
                    }
                }
               /* else if(value=='Phoenix_Estimated_Lead_Time_Days__c') {
                    var estleadtime = objectRecords[i]["Phoenix_Estimated_Lead_Time_Days__c"];
                    if(estleadtime != null){
                      csvStringResult += '"'+estleadtime+'"';
                    }
                    else{
                       csvStringResult += '"'+''+'"'; 
                    }
                 
                }*/
             else if(value == 'Phoenix_Proposed_Smith_Drug_Units1__c'){
                 if(key == '3 Months Annualized Total Units'){
                    var overOSRADRideUnits =objectRecords[i]['Phoenix_Override_Current_Direct_Units__c'] != null ?objectRecords[i]['Phoenix_Override_Current_Direct_Units__c'] :0 ;
                    var overWMTDirRideUnits =objectRecords[i]['Phoenix_Override_Current_Indirect_Units__c'] != null ?objectRecords[i]['Phoenix_Override_Current_Indirect_Units__c'] :0 ;
                    var overWMTInddirRideUnits =objectRecords[i]['Phoenix_Proposed_Smith_Drug_Units__c'] != null ?objectRecords[i]['Phoenix_Proposed_Smith_Drug_Units__c'] :0 ;
                    
                    var totalOverride = overOSRADRideUnits+overWMTDirRideUnits+overWMTInddirRideUnits;
                    var oSRADUnits =objectRecords[i]['Phoenix_OS_and_RAD_Cur_Direct_Units_C__c'] != null ?objectRecords[i]['Phoenix_OS_and_RAD_Cur_Direct_Units_C__c'] :0 ;
                    var WMTDiretUnits =objectRecords[i]['Phoenix_WMT_Current_Direct_Units__c'] != null ?objectRecords[i]['Phoenix_WMT_Current_Direct_Units__c'] :0 ;
                    var WMTIndiretUnits =objectRecords[i]['Phoenix_WMT_Current_Indirect_Units__c'] != null ?objectRecords[i]['Phoenix_WMT_Current_Indirect_Units__c'] :0 ;
                    var totalCurUnits = oSRADUnits+WMTDiretUnits+WMTIndiretUnits;
                    var finalUnits = totalOverride > 0 ? totalOverride :totalCurUnits;
                    csvStringResult += '"'+ finalUnits +'"';
                 }
                }
                else if(value == 'Phoenix_Proposed_OS_Units1__c'){
                	if(key = 'Total Proposed Units'){
                       /* if(objectRecords[i]['Phoenix_Proposed_OS_Units__c'] != null){
                          var OSRideUnits =objectRecords[i]['Phoenix_Proposed_OS_Units__c'];  
                        }
                        else{
                            var OSRideUnits =0 ;
                        }*/
                     var OSRideUnits =objectRecords[i]['Phoenix_Proposed_OS_Units__c'] != null ?objectRecords[i]['Phoenix_Proposed_OS_Units__c'] :0 ;
                   console.log('test by satya-->'+OSRideUnits);
                   var RADUnits =objectRecords[i]['Phoenix_Proposed_RAD_Units__c'] !=null ?objectRecords[i]['Phoenix_Proposed_RAD_Units__c'] :0 ;
                  var WMTnits =objectRecords[i]['Phoenix_Proposed_WMT_Units__c'] != null ?objectRecords[i]['Phoenix_Proposed_WMT_Units__c'] :0 ;
                    
                    var finalUnits = OSRideUnits + RADUnits + WMTnits;
                       // var finalUnits = OSRideUnits;
                     csvStringResult += '"'+ finalUnits +'"';
                     }
                }
                else if(value == 'Phoenix_Override_Current_Indirect_Units1__c'){
                	if(key = 'Override Total Units'){
                       /* if(objectRecords[i]['Phoenix_Proposed_OS_Units__c'] != null){
                          var OSRideUnits =objectRecords[i]['Phoenix_Proposed_OS_Units__c'];  
                        }
                        else{
                            var OSRideUnits =0 ;
                        }*/
                     var OSRideUnits =objectRecords[i]['Phoenix_Override_Current_Direct_Units__c'] != null ?objectRecords[i]['Phoenix_Override_Current_Direct_Units__c'] :0 ;
                   console.log('test by satya-->'+OSRideUnits);
                   var RADUnits =objectRecords[i]['Phoenix_Override_Current_Indirect_Units__c'] != null ?objectRecords[i]['Phoenix_Override_Current_Indirect_Units__c'] :0 ;
                  var WMTnits =objectRecords[i]['Phoenix_Proposed_Smith_Drug_Units__c'] != null ?objectRecords[i]['Phoenix_Proposed_Smith_Drug_Units__c'] :0 ;
                    
                    var finalUnits = OSRideUnits + RADUnits + WMTnits;
                       // var finalUnits = OSRideUnits;
                     csvStringResult += '"'+ finalUnits +'"';
                     }
                }
                else if(value == 'Phoenix_3_Months_Actual_Sales1__c'){
                	if(key = 'Last 12 Months Total Units'){
                       /* if(objectRecords[i]['Phoenix_Proposed_OS_Units__c'] != null){
                          var OSRideUnits =objectRecords[i]['Phoenix_Proposed_OS_Units__c'];  
                        }
                        else{
                            var OSRideUnits =0 ;
                        }*/
                     var OSRideUnits =objectRecords[i]['Phoenix_12_Months_Actual_Sales__c'] != null ?objectRecords[i]['Phoenix_12_Months_Actual_Sales__c'] :0 ;
                   console.log('test by satya-->'+OSRideUnits);
                   var RADUnits =objectRecords[i]['Phoenix_12_Months_IndirectSaleUnit__c'] != null ?objectRecords[i]['Phoenix_12_Months_IndirectSaleUnit__c'] :0 ;
                  var WMTnits =objectRecords[i]['Phoenix_3_Months_Actual_Sales__c'] != null ?objectRecords[i]['Phoenix_3_Months_Actual_Sales__c'] :0 ;
                    
                    var finalUnits = OSRideUnits + RADUnits + WMTnits;
                       // var finalUnits = OSRideUnits;
                     csvStringResult += '"'+ finalUnits +'"';
                     }
                }
                 else if(value == 'Proposed_TPT_Per_Direct__c'){
                        var Proposed_tpt=objectRecords[i]['Proposed_TPT_Per_Direct__c'];
                        //console.log('Proposed_tpt direct initialvalue-->'+Proposed_tpt);
                    if(Proposed_tpt != null){
						var rounded_tpt = Math.round(Proposed_tpt * 100)/100
                        //var rounded_tpt=Math.round((Proposed_tpt + Number.EPSILON) * 100) / 100
                        //console.log('Proposed_tpt direct rounded value-->'+rounded_tpt);
                        csvStringResult += '"'+ rounded_tpt +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                    }
               else if(value == 'Proposed_TPT_Per_Indirect__c'){
                        var Proposed_tpt=objectRecords[i]['Proposed_TPT_Per_Indirect__c'];
                        //console.log('Proposed_tpt Indirect initialvalue-->'+Proposed_tpt);
                   if(Proposed_tpt != null){
                        var rounded_tpt=Math.round(Proposed_tpt * 100)/100
                        //console.log('Proposed_tpt indirect rounded value-->'+rounded_tpt);
                        csvStringResult += '"'+ Proposed_tpt +'"';
                   }
                   else{
                       csvStringResult += '"'+''+'"';
                   }
                }
                else if(value == 'Phoenix_Internal_Dead_Net_Price__c'){
                        var deadnetprice=objectRecords[i]['Phoenix_Internal_Dead_Net_Price__c'];
                        //console.log('deadnetprice initialvalue-->'+deadnetprice);
                    if(deadnetprice != null){
                        var rounded_price=Math.round(deadnetprice * 100)/100
                        //console.log('deadnetprice rounded value-->'+rounded_price);
                        csvStringResult += '"'+ deadnetprice +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                    }
                else if(value == 'Phoenix_Rebate_Perc_In__c'){
                   var rebateperindl=objectRecords[i]['Phoenix_Rebate_Perc_In__c'];
                       // console.log('rebateperindl-->'+rebateperindl);
                    if(rebateperindl != null){
                        var rounded_rebateperindl=Math.round(rebateperindl * 100)/100
                        //console.log('rebateperindl rounded value-->'+rounded_price);
                        csvStringResult += '"'+ rebateperindl +'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }
                }
                    else if(value == 'Phoenix_Admin_Fee_in__c'){
                      var adminfeeindl=objectRecords[i]['Phoenix_Admin_Fee_in__c'];
                       // console.log('adminfeeindl-->'+adminfeeindl);
                    if(adminfeeindl != null){
                        var rounded_adminfeeindl=Math.round(adminfeeindl * 100)/100
                        csvStringResult += '"'+ adminfeeindl+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }  
                    }
                 else if(value == 'Direct_VIP_Per_Unit__c'){
                         var vipperunitdl=objectRecords[i]['Direct_VIP_Per_Unit__c'];
                       // console.log('vipperunitdl-->'+vipperunitdl);
                    if(vipperunitdl != null){
                        var rounded_vipperunitdl=Math.round(vipperunitdl * 100)/100
                        csvStringResult += '"'+ vipperunitdl+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }     
               }
               else if(value == 'Phoenix_Sales_Out_Promotion_Per_unit_in__c'){
                   var salesoutpmpudl=objectRecords[i]['Phoenix_Sales_Out_Promotion_Per_unit_in__c'];
                       // console.log('salesoutpmpudl-->'+salesoutpmpudl);
                    if(salesoutpmpudl != null){
                        var rounded_salesoutpmpudl=Math.round(salesoutpmpudl * 100)/100
                        csvStringResult += '"'+ salesoutpmpudl+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }   
                         
               }
               else if(value == 'Phoenix_IOD_Per_Unit_in__c'){
                 var iodperunitindl=objectRecords[i]['Phoenix_IOD_Per_Unit_in__c'];
                       // console.log('iodperunitindl-->'+iodperunitindl);
                    if(iodperunitindl != null){
                        var rounded_iodperunitindl=Math.round(iodperunitindl * 100)/100
                        csvStringResult += '"'+ iodperunitindl+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }         
               }
                else if(value == 'Phoenix_Direct_CD_Per_Unit__c'){
                      var cdperunitdirect=objectRecords[i]['Phoenix_Direct_CD_Per_Unit__c'];
                       // console.log('cdperunitdirect-->'+cdperunitdirect);
                    if(cdperunitdirect != null){
                        var rounded_cdperunitdirect=Math.round(cdperunitdirect * 100)/100
                        csvStringResult += '"'+ cdperunitdirect+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }  
                   }
                 else if(value == 'Phoenix_RDC_NLC__c'){
                   var totalrdcnlcper=objectRecords[i]['Phoenix_RDC_NLC__c'];
                       // console.log('totalrdcnlcper-->'+totalrdcnlcper);
                    if(totalrdcnlcper != null){
                        var rounded_totalrdcnlcper=Math.round(totalrdcnlcper * 100)/100
                        csvStringResult += '"'+ totalrdcnlcper+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }        
                }
                else if(value == 'Phoenix_RDC_NLC_Per_Unit_in__c'){
                     var rdcnlcperunitindl=objectRecords[i]['Phoenix_RDC_NLC_Per_Unit_in__c'];
                       // console.log('rdcnlcperunitindl-->'+rdcnlcperunitindl);
                    if(rdcnlcperunitindl != null){
                        var rounded_rdcnlcperunitindl=Math.round(rdcnlcperunitindl * 100)/100
                        csvStringResult += '"'+ rdcnlcperunitindl+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }     
               }
                else if(value == 'Phoenix_Customer_Fees__c'){
                  var cmfeeperunit=objectRecords[i]['Phoenix_Customer_Fees__c'];
                       // console.log('cmfeeperunit-->'+cmfeeperunit);
                    if(cmfeeperunit != null){
                        var rounded_cmfeeperunit=Math.round(cmfeeperunit * 100)/100
                        csvStringResult += '"'+ cmfeeperunit+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }        
                }
                else if(value == 'Phoenix_Medicaid_Returns_Per_Unit_in__c'){
                  var medicaidretperunit=objectRecords[i]['Phoenix_Medicaid_Returns_Per_Unit_in__c'];
                       // console.log('medicaidretperunit-->'+medicaidretperunit);
                    if(medicaidretperunit != null){
                        var rounded_medicaidretperunit=Math.round(medicaidretperunit * 100)/100
                        csvStringResult += '"'+ medicaidretperunit+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }        
               }
               else if(value == 'Phoenix_Direct_Dead_Net__c'){
                 var directdeadnet=objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                       // console.log('directdeadnet-->'+directdeadnet);
                    if(directdeadnet != null){
                        var rounded_directdeadnet=Math.round(directdeadnet * 100)/100
                        csvStringResult += '"'+ directdeadnet+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }        
               }
               else if(value == 'Phoenix_Proposed_ZITD__c'){
                 var proposedzitd=objectRecords[i]['Phoenix_Proposed_ZITD__c'];
                       // console.log('proposedzitd-->'+proposedzitd);
                    if(proposedzitd != null){
                        var rounded_proposedzitd=Math.round(proposedzitd * 100)/100
                        csvStringResult += '"'+ proposedzitd+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }        
               }
              else if(value == 'Phoenix_Indirect_Dead_Net__c'){
                  var indirectdeadnet=objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                       // console.log('indirectdeadnet-->'+indirectdeadnet);
                    if(indirectdeadnet != null){
                        var rounded_indirectdeadnet=Math.round(indirectdeadnet * 100)/100
                        csvStringResult += '"'+ indirectdeadnet+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    } 
                       
                }
                  else if(value == 'Phoenix_Net_Sales_Internal__c'){
                      var netsalesinternal=objectRecords[i]['Phoenix_Net_Sales_Internal__c'];
                       // console.log('netsalesinternal-->'+netsalesinternal);
                    if(netsalesinternal != null){
                        var rounded_indirectdeadnet=Math.round(netsalesinternal)
                        csvStringResult += '"'+ netsalesinternal+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    } 
                      
                  }
                else if(value == 'Phoenix_IOD_Total_Amount__c'){
                        var iodtotalamount=objectRecords[i]['Phoenix_IOD_Total_Amount__c'];
                       // console.log('iodtotalamount-->'+iodtotalamount);
                    if(iodtotalamount != null){
                        var rounded_iodtotalamount=Math.round(iodtotalamount*100)/100
                        csvStringResult += '"'+ iodtotalamount+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }    
                 }
                else if(value == 'Phoenix_DRL_Dead_Net_After_IOD_w_o_MR__c'){
                   var drldaednetafteriod=objectRecords[i]['Phoenix_DRL_Dead_Net_After_IOD_w_o_MR__c'];
                       // console.log('drldaednetafteriod-->'+drldaednetafteriod);
                    if(drldaednetafteriod != null){
                        var rounded_drldaednetafteriod=Math.round(drldaednetafteriod*100)/100
                        csvStringResult += '"'+ drldaednetafteriod+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }  
                }
                    else if(value == 'Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c'){
                     var drldaednetafteriodwo=objectRecords[i]['Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c'];
                       // console.log('drldaednetafteriodwo-->'+drldaednetafteriodwo);
                    if(drldaednetafteriodwo != null){
                        var rounded_drldaednetafteriodwo=Math.round(drldaednetafteriodwo*100)/100
                        csvStringResult += '"'+ drldaednetafteriodwo+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }     
                    }
                  else if(value == 'Phoenix_INDIRECT_CD__c'){
                     var indirectcdperundl=objectRecords[i]['Phoenix_INDIRECT_CD__c'];
                       // console.log('indirectcdperundl-->'+indirectcdperundl);
                    if(indirectcdperundl != null){
                        var rounded_indirectcdperundl=Math.round(indirectcdperundl*100)/100
                        csvStringResult += '"'+ indirectcdperundl+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }          
                  }
                  else if(value == 'Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c'){
                  var indirectdeadnetmedret=objectRecords[i]['Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c'];
                       // console.log('indirectdeadnetmedret-->'+indirectdeadnetmedret);
                    if(indirectdeadnetmedret != null){
                        var rounded_indirectdeadnetmedret=Math.round(indirectdeadnetmedret*100)/100
                        csvStringResult += '"'+ indirectdeadnetmedret+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }         
                  }
                else if(value == 'Proposed_Net_Sales_Direct__c'){
                  var proposednetsalesdirect=objectRecords[i]['Proposed_Net_Sales_Direct__c'];
                       // console.log('proposednetsalesdirect-->'+proposednetsalesdirect);
                    if(proposednetsalesdirect != null){
                        var rounded_proposednetsalesdirect=Math.round(proposednetsalesdirect*100)/100
                        csvStringResult += '"'+ proposednetsalesdirect+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }       
                }
                else if(value  == 'Proposed_Net_Sales_Indirect__c'){
                 var proposednetsalesindirect=objectRecords[i]['Proposed_Net_Sales_Indirect__c'];
                       // console.log('proposednetsalesindirect-->'+proposednetsalesindirect);
                    if(proposednetsalesindirect != null){
                        var rounded_proposednetsalesindirect=Math.round(proposednetsalesindirect*100)/100
                        csvStringResult += '"'+ rounded_proposednetsalesindirect+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }        
                 }
                 else if(value == 'Proposed_TPT_Direct__c'){
                  var proposedtpdldirect=objectRecords[i]['Proposed_TPT_Direct__c'];
                       // console.log('proposedtpdldirect-->'+proposedtpdldirect);
                    if(proposedtpdldirect != null){
                        var rounded_proposedtpdldirect=Math.round(proposedtpdldirect*100)/100
                        csvStringResult += '"'+ rounded_proposedtpdldirect+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    }       
                 }
                 else if(value == 'Proposed_TPT_Indirect__c'){
                     var proposedtpdlindirect=objectRecords[i]['Proposed_TPT_Indirect__c'];
                       // console.log('proposedtpdlindirect-->'+proposedtpdlindirect);
                    if(proposedtpdlindirect != null){
                        var rounded_proposedtpdlindirect=Math.round(proposedtpdlindirect*100)/100
                        csvStringResult += '"'+ rounded_proposedtpdlindirect+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    } 
                         
                  }
                  else if(value == 'Phoenix_Latest_Estimate__c'){
                       var latestestimateasp=objectRecords[i]['Phoenix_Latest_Estimate__c'];
                       // console.log('latestestimateasp-->'+latestestimateasp);
                    if(latestestimateasp != null){
                        var rounded_latestestimateasp=Math.round(latestestimateasp*100)/100
                        csvStringResult += '"'+ rounded_latestestimateasp+'"'; 
                    }
                    else{
                     csvStringResult += '"'+''+'"';   
                    } 
                         
                 }
                else if(value == 'Phoenix_REMS__c' ){
                    var rems_value= objectRecords[i]['Phoenix_REMS__c'];
                   // console.log("remss valuee-->"+rems_value);
                    if(rems_value == true){
                       // console.log("yesss");
                       csvStringResult += '"'+ 'Yes'+'"'; 
                    }
                    else{
                        csvStringResult += '"'+ 'No'+'"'; 
                    }
                }
               else if (value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' || value == 'Phoenix_SCM_Approval_Y_N__c' || value == 'Phoenix_SCM_Notes__c') {
                    if (objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"] != 'N- Not Approved' && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"] != '') {
                        // console.log('scm approval status is true');
                        if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } else {
                            csvStringResult += '"' + objectRecords[i][value] + '"';
                        }
                    } 
                    else {
                         if(bidType == "New Product Launch" && value == 'Phoenix_Estimated_Lead_Time_Days__c'){
                             if (objectRecords[i][value] == undefined) {
                                 csvStringResult += '"'+''+'"';
                             }
                             else{
                                 csvStringResult += '"'+ objectRecords[i][value]+'"';  
                                 
                             }
                            
                        }
                        else{
                              csvStringResult += '"'+''+'"';
                        }
                    }
                }
                else if(value == 'Phoenix_Finance_Approval__c'||value == 'Phoenix_Finance_Comments__c'){
                 	 if(objectRecords[i]["Phoenix_Final_Finance_Approval__c"]==true){
						if(objectRecords[i][value]==undefined){
                        //console.log('Iam in last ELSEE if---->');
                       	csvStringResult += '"'+''+'"';
                    	}   
                      else{
                          csvStringResult += '"'+ objectRecords[i][value]+'"'; 
                      }
                     }
                 }
               
                else if(objectRecords[i][value]==undefined){
                        //console.log('Iam in last ELSEE if---->');
                        csvStringResult += '"'+''+'"';
                    }
                    else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;        
    },
    submitForProceed : function(component,event,helper,isContracts){ 
        component.set('v.isSpinnerLoad',true);
        var ismarketingDeligator = component.get("v.ismarketingDeligator");
        var deligatedUserName = component.get("v.deligatedUserName");
        var isOverrideUnitsavl = false;
        var action = component.get("c.submitToProceddStep");      
        action.setParams
        ({
            bidId:component.get("v.recordId"),
            isContracts:isContracts,
            ismarketingDeligator: ismarketingDeligator,
            deligatedUserName: deligatedUserName
        });
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   component.set('v.isSpinnerLoad',false);
                                   var ResultData = response.getReturnValue();
                                   var resultlength=ResultData.length;
                                    var bidtype=component.get("v.BidTypeVal");
                                   console.log('resultslength--'+resultlength);
                                   var contrcts=component.get('v.selectedCntrcts');
                                   var indirectCons = new Array();
                                   var DirectCons = new Array();
                                   var qtyError;
                                   indirectCons=contrcts.filter((contrcts) => contrcts.startsWith("3"));
                                   DirectCons=contrcts.filter((contrcts) => contrcts.startsWith("1"));
                                   var isMacRADContract = (indirectCons != null && (indirectCons.includes("3000000224") || indirectCons.includes("3000000418") || indirectCons.includes("3000000047") || indirectCons.includes("3000001263")));
                                   var isMacOSContract = (indirectCons != null && (indirectCons.includes("3000000071")));
                                   var isWMTIndirectContract = (indirectCons != null && indirectCons.includes("3000000143"));
                                   var isWMRDirectContract = (DirectCons != null && DirectCons.includes("1000000120"));
                                   var isBisCanSubmit = false;
                                   var delegatedUser = component.get("v.deligatedUserName");
                                   for(var i=0;i<resultlength;i++){
                                       var scmOSRADUnits  = (ResultData[i].Phoenix_ProposedIndirectAholdDelhaizeUni__c!=null?ResultData[i].Phoenix_ProposedIndirectAholdDelhaizeUni__c:0)+(ResultData[i].Phoenix_Proposed_IndirectGaintEagleUnits__c!=null?ResultData[i].Phoenix_Proposed_IndirectGaintEagleUnits__c:0)
                                       var proposedOsRADUnits = (ResultData[i].Phoenix_SCM_Final_Approval__c) ? scmOSRADUnits : (ResultData[i].Phoenix_Proposed_RAD_Units__c!=null ?ResultData[i].Phoenix_Proposed_RAD_Units__c:0) + (ResultData[i].Phoenix_Proposed_OS_Units__c!=null?ResultData[i].Phoenix_Proposed_OS_Units__c:0);
                                       var scmWMTDirectUnits = (ResultData[i].Phoenix_Final_Direct_Selling_Units_Calc__c !=null ? ResultData[i].Phoenix_Final_Direct_Selling_Units_Calc__c : 0)
                                       var proposedWMTUnits = (ResultData[i].Phoenix_SCM_Final_Approval__c) ? scmWMTDirectUnits : (ResultData[i].Phoenix_Proposed_WMT_Units__c !=null ? ResultData[i].Phoenix_Proposed_WMT_Units__c : 0);
                                       var OSAndRADCP = ResultData[i].Phoenix_OS_RAD_CP__c;
                                       var WMTDirCP = ResultData[i].Phoenix_WMT_Direct_CP__c;
                                       var WMTndirCP = ResultData[i].Phoenix_WMT_Indirect_CP__c;
                                           if((proposedOsRADUnits+proposedWMTUnits) == 0 && (bidtype=='Product Addition' || bidtype =='RFP Bids' || bidtype == 'Volume Review Only' )){
                                               qtyError='All of the Proposed units can not be 0. Please review again for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;
                                           }
                                          /*if(isMacRADContract && bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && (ResultData[i].Phoenix_Proposed_RAD_Units__c==null && ResultData[i].Phoenix_Proposed_OS_Units__c==null)){
                                               qtyError='Please Enter The Proposed OS/RAD Units for ' +  unitsMsg +bidlines[i].Phoenix_Product__r.Name;
                                               break;
                                           }*/
                                          /* if(isMacOSContract && bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && (ResultData[i].Phoenix_Proposed_OS_Units__c==null )){
                                               qtyError='Please Enter The Proposed OS Units for ' +  unitsMsg +bidlines[i].Phoenix_Product__r.Name;
                                               break;
                                           }*/
                                          /*if( (isWMTIndirectContract || isWMRDirectContract) && bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && (ResultData[i].Phoenix_Proposed_WMT_Units__c==null )){
                                               qtyError='Please Enter The Proposed WMT Units for ' +  unitsMsg +bidlines[i].Phoenix_Product__r.Name;
                                               break;
                                           }*/
                                          if(bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && (ResultData[i].Phoenix_Proposed_RAD_Units__c==null || ResultData[i].Phoenix_Proposed_OS_Units__c==null || ResultData[i].Phoenix_Proposed_WMT_Units__c ==null)){
                                              isBisCanSubmit = true;
                                           }
                                       if( (proposedOsRADUnits > 0) && component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Proposed_McK_OS_And_RAD_NCP__c==null && bidtype != 'Customer Rebate Change' && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Proposed NCP for McK OS And RAD for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }else if( (OSAndRADCP) && component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Proposed_McK_OS_And_RAD_NCP__c==null && (bidtype == 'Customer Rebate Change' || bidtype == 'Price Change') ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Proposed NCP for McK OS And RAD for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                      else if( (proposedWMTUnits > 0) && component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Proposed_WMT_Indirect_NCP__c==null && bidtype != 'Customer Rebate Change' && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Propsed WMT Indirect NCP for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                          else if( (WMTDirCP || WMTndirCP) && component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Proposed_WMT_Indirect_NCP__c==null && (bidtype == 'Customer Rebate Change' || bidtype == 'Price Change') ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Propsed WMT Indirect NCP for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                       
                                       else if((proposedWMTUnits > 0) && component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||  (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Proposed_WMT_Direct_NCP__c==null && bidtype != 'Customer Rebate Change' && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Propsed WMT Direct NCP for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                       else if((WMTDirCP || WMTndirCP) && component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||  (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Proposed_WMT_Direct_NCP__c==null && (bidtype == 'Customer Rebate Change' || bidtype == 'Price Change') ){
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Propsed WMT Direct NCP for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                       else if(component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Proposed_WMT_Direct_NCP__c > ResultData[i].Phoenix_Proposed_WMT_Indirect_NCP__c && bidtype != 'Customer Rebate Change' && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='WMT Indirect cannot be less than direct price for '+ResultData[i].Phoenix_Product__r.Name;
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                     /*  else if (bidtype == 'New Product Launch' && ResultData[i].Phoenix_Customer_Dead_Net_McK_RAD_Propse__c < ResultData[i].Phoenix_Lowest_Price_SKU__c){
                         					if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                             				qtyError='You cannot submit this Bid for Approval as Customer Dead net McK And RAD (Proposed) is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                              				break;
                         					}
                          					else {
                            					break;
                        					}
                     					}*/
                                    /*   else if (component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Direct_Dead_Net__c !=0 && ResultData[i].Phoenix_Direct_Dead_Net__c < ResultData[i].Phoenix_Lowest_Price_SKU__c){
                         					if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                             				qtyError='You cannot submit this Bid for Approval as McK & RAD Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                              				break;
                         					}
                          					else {
                            					break;
                        					}
                     					}
                                      else if (component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype == 'New Product Launch' && ResultData[i].Phoenix_WMT_Direct_Dead_Net_Proposed__c !=0 && ResultData[i].Phoenix_WMT_Direct_Dead_Net_Proposed__c < ResultData[i].Phoenix_Lowest_Price_SKU__c){
                         					if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                             				qtyError='You cannot submit this Bid for Approval as WMT Direct Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                              				break;
                         					}
                          					else {
                            					break;
                        					}
                     					}*/
                                       /* For Delegation*/
                                     /*  else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director1__c))) && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Direct_Dead_Net__c !=0 && ResultData[i].Phoenix_Direct_Dead_Net__c < ResultData[i].Phoenix_Lowest_Price_SKU__c){
                         					if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                             				qtyError='You cannot submit this Bid for Approval as McK & RAD Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                              				break;
                         					}
                          					else {
                            					break;
                        					}
                     					}
                                      else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director1__c))) && bidtype == 'New Product Launch' && ResultData[i].Phoenix_WMT_Direct_Dead_Net_Proposed__c !=0 && ResultData[i].Phoenix_WMT_Direct_Dead_Net_Proposed__c < ResultData[i].Phoenix_Lowest_Price_SKU__c){
                         					if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                             				qtyError='You cannot submit this Bid for Approval as WMT Direct Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                              				break;
                         					}
                          					else {
                            					break;
                        					}
                     					}*/
                                       /* End For Delegation*/
                                      
                                   }
                                   for(var i=0;i<resultlength;i++){
                                        // override unit starts
                                       if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Direct_Units__c==null && (ResultData[i].Phoenix_OS_and_RAD_Cur_Direct_Units_C__c==null || ResultData[i].Phoenix_OS_and_RAD_Cur_Direct_Units_C__c==undefined || ResultData[i].Phoenix_OS_and_RAD_Cur_Direct_Units_C__c==0)){                                             
                                                           isOverrideUnitsavl =true;
                                                           break;
                                                       }
                                        else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Indirect_Units__c==null && (ResultData[i].Phoenix_WMT_Current_Direct_Units__c==null || ResultData[i].Phoenix_WMT_Current_Direct_Units__c==undefined || ResultData[i].Phoenix_WMT_Current_Direct_Units__c==0)){                                             
                                                           isOverrideUnitsavl =true;
                                                           break;
                                                       }
                                        else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Proposed_Smith_Drug_Units__c==null && (ResultData[i].Phoenix_WMT_Current_Indirect_Units__c==null || ResultData[i].Phoenix_WMT_Current_Indirect_Units__c==undefined || ResultData[i].Phoenix_WMT_Current_Indirect_Units__c==0)){                                             
                                                           isOverrideUnitsavl =true;
                                                           break;
                                                       }
                                        else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Indirect_Units1__c==null && (ResultData[i].Phoenix_Proposed_Smith_Drug_Units1__c==null || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==undefined || ResultData[i].Phoenix_Proposed_Smith_Drug_Units1__c==0)){                                             
                                                           isOverrideUnitsavl =true;
                                                           break;
                                                       }
                                      // override unit end 
                                   }
                                   var modalMessage = isOverrideUnitsavl ? 'The 3 Months Annualized Current Units is 0. Are you sure you want to submit this bid for approval?' : 'Are you sure you want to submit this bid for approval?';
                                       component.set('v.modalMessage',modalMessage);
                                   if(isBisCanSubmit){
                                       component.set("v.fieldRequiredModel",true);
                                   }
                                   else if(qtyError){	
                                       var toastEvent = $A.get("e.force:showToast");	
                                       toastEvent.setParams({	
                                           "title": "Error!",	
                                           "type":"error",	
                                           "message":qtyError	
                                       });	
                                       toastEvent.fire();	
                                   }	
                                   else{	
                                   var isApproved = false;
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   if(resultlength==0){
                                       isApproved = true;
                                   }
                                   else{
                                       if(isContracts==false){
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_Marketing_Approval__c'] == 'None' || line['Phoenix_Marketing_Approval__c'] == '' || line['Phoenix_Marketing_Approval__c'] == null || line['Phoenix_Marketing_Approval__c'] == 'undefined'){
                                                   isApproved = true;
                                                   //console.log("marketingApproval--->"+line['Phoenix_Marketing_Approval__c']);
                                               }
                                               if(line['Phoenix_Marketing_Approval__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });  
                                       }
                                       else{
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_Contract_Approval__c'] == 'None' || line['Phoenix_Contract_Approval__c'] == '' || line['Phoenix_Contract_Approval__c'] == null || line['Phoenix_Contract_Approval__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Contract_Approval__c--->"+line['Phoenix_Contract_Approval__c']);
                                               }
                                               if(line['Phoenix_Contract_Approval__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });
                                       }
                                   }
                                   if(isApproved == true){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm each approval to proceed further"
                                       });
                                       toastEvent.fire();
                                       
                                   }
                                   else{
                                       if(isContracts){
                                           helper.MarkApprovalsContracts(component,event,helper,ResultData,approveStatusFlag,isContracts);  
                                       }else{
                                           helper.MarkApprovals(component,event,helper,ResultData,approveStatusFlag);  
                                       }
                                       
                                   }
                               }
                               }
                               else{
                                   component.set('v.isSpinnerLoad',false);
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "type":"error",
                                       "title": "error!",
                                       "message": "Something went wrong,please contact admin."
                                   });
                                   toastEvent.fire();
                               }
                               
                           });
        $A.enqueueAction(action);
    },
    MarkApprovals: function(component,event,helper,ResultData,approveStatusFlag){
        var action = component.get("c.makeApprovals");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var wrapNextSteps=response.getReturnValue();
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                var flagSCMStop= wrapNextSteps.flagSCMStop;
                var flagMarketStop=wrapNextSteps.flagMarketStop;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                if(flagSCMStop==false && flagMarketStop==false){
                    helper.UpdateNextSteps(component,event,helper,marketStepLsit,flagSCMStop,flagMarketStop); 
                }
                $A.get('e.force:refreshView').fire();
            }
            else{
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    MarkApprovalsContracts : function(component,event,helper,ResultData,approveStatusFlag,isContracts){
        console.log('MarkApprovalsContracts--');
        var action = component.get("c.makeApprovalsContracts");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
            isContracts:isContracts
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var responseList=response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                helper.UpdateNextStepsContracts(component,event,helper,responseList); 
                $A.get('e.force:refreshView').fire();
            }
            else{
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    UpdateNextStepsContracts :function(component,event,helper,Stepsist){
        console.log('UpdateNextStepsContracts--');
        var action = component.get("c.updateNextContractProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: Stepsist
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    UpdateNextSteps : function(component,event,helper,marketStepLsit,flagSCMStop,flagMarketStop){
        var action = component.get("c.updateNextProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: marketStepLsit,
            flagSCMStop:flagSCMStop,
            flagMarketStop:flagMarketStop
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
     /*ProductPositions Logix*/
     fetchPositions: function (component, event, helper, bidCustomer) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: bidCustomer
            // searchInput:searchInput

        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);

                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedPosistions');
                var finalPositions = responseList.filter(comparer(slctpositions));

                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log(other);
                            return other == current.Name
                        }).length == 0;
                    }
                }

                for (var i = 0; i < finalPositions.length; i++) {
                    var row = finalPositions[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.positionsList", finalPositions);
             
            }


        });
        $A.enqueueAction(action);
    },
    fetchMCKPositions: function (component, event, helper, bidCustomer) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: bidCustomer
            // searchInput:searchInput

        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);

                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedMCKPosistions');
                var finalPositions = responseList.filter(comparer(slctpositions));

                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log(other);
                            return other == current.Name
                        }).length == 0;
                    }
                }

                for (var i = 0; i < finalPositions.length; i++) {
                    var row = finalPositions[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.MCKpositionsList", finalPositions);
             
            }


        });
        $A.enqueueAction(action);
    },
    /*Product Position Logic End*/
    
})