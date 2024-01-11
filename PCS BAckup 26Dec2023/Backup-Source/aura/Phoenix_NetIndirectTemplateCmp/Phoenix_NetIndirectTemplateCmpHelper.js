({
     getBidLastActivity : function(component,event,helper){
        var action = component.get("c.getLastBidActivity");
        console.log('bid id test'+component.get("v.recordId"))
         action.setParams
            ({
                bidId: component.get("v.recordId"),
            });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('record created successfully')
                               }else{
                                   console.log('error in bid last activity')
                               }
                           });
                             $A.enqueueAction(action);
    },
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
                                   component.set("v.PISUTotal",responseValue[0].pisu);
                                   component.set("v.PDSUTotal",responseValue[0].pdsu);
                                   //component.set("v.totSelUnits",responseValue[0].tsu);
                                   component.set("v.finTotSelUnits",responseValue[0].ftsu);
                                   component.set("v.CISUTotal",responseValue[0].cisu);
                                   component.set("v.CDSUTotal",responseValue[0].cdsu);
                                   component.set("v.totSelUnits",(responseValue[0].cisu + responseValue[0].cdsu));
                                   component.set("v.netSalesIntTotal",responseValue[0].netsint);
                                   component.set("v.LCostTotal",responseValue[0].lesscost);
                                   component.set("v.ThptMrgnDTotal",responseValue[0].thptm);
                                   component.set("v.intDeadNetTotal",responseValue[0].intdead);
                                   component.set("v.proNetSaleDir",responseValue[0].pnsd);
                                   component.set("v.proNetSaleInd",responseValue[0].pnsInd);
                                   component.set("v.proTPTDir",responseValue[0].pTPTDir);
                                   component.set("v.proTPTInd",responseValue[0].pTPTInd);
                                   component.set("v.actSaDir12Months",responseValue[0].actSaDir12Months);
                                   component.set("v.actSalInd12months",responseValue[0].actSalInd12months);
                                   component.set("v.actTotal12Months",responseValue[0].actTotal12Months);
                                   component.set("v.overrideDirTotalUnits",responseValue[0].OverrideDirTotalUnits);
                                   component.set("v.overrideIndirTotalUnits",responseValue[0].OverrideIndirTotalUnits);
                                   component.set("v.overrideTotalUnits",responseValue[0].OverrideTotalUnits);
                                   component.set("v.FISUTotal",responseValue[0].fisu);
                                   component.set("v.FDSUTotal",responseValue[0].fdsu);
                                   component.set("v.ScmApprovedTot",responseValue[0].ScmApprovedTot)
                                   component.set("v.ScmApprovedTotal",responseValue[0].ScmApprovedTotal);
                                   component.set("v.proDirUnits",responseValue[0].proDirUnits);
                                   component.set("v.proIndUnits",responseValue[0].proIndUnits);
                                   component.set("v.proDirMark",responseValue[0].proDirMark);
                                   component.set("v.proIndiMark",responseValue[0].proIndiMark);
                                   component.set("v.netIndirPrice",responseValue[0].netIndirPrice);
                                   component.set("v.actTotal12Months",responseValue[0].actTotal12Months);
                                   component.set("v.netSaleDir",responseValue[0].netSaleDir);
                                   component.set("v.netSaleIndir",responseValue[0].netSaleIndir);
                                   component.set("v.tptDir",responseValue[0].tptDir);
                                   component.set("v.tptIndir",responseValue[0].tptIndir);
                                   component.set("v.TputMargin",responseValue[0].TputMargin);
                                   component.set("v.propoTpDir",responseValue[0].propoTpDir);
                                   component.set("v.propoTpIndir",responseValue[0].propoTpIndir);
                                   component.set("v.TPMarginPerc",responseValue[0].TPMarginPerc);
                                   component.set("v.totalIOD",responseValue[0].totalIOD != null ? responseValue[0].totalIOD : 0);
                                   var ProposedTPTDir = responseValue[0].netSaleDir != 0 ? (responseValue[0].tptDir/responseValue[0].netSaleDir)*100 : 0;
                                   var ProposedTPTInDir = responseValue[0].netSaleIndir != 0 ? (responseValue[0].tptIndir/responseValue[0].netSaleIndir)*100 : 0;
                                   
                                   //var ProposedTPTDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTDir/responseValue[0].pnsd)*100 : 0;
                                   //var ProposedTPTInDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTInd/responseValue[0].pnsInd)*100 : 0;
                                   var BlendedTPMargin = responseValue[0].netsint =! 0 ? (responseValue[0].TputMargin/responseValue[0].netsint)*100 : 0;
                                   component.set("v.proTPTPerDir",ProposedTPTDir);
                                   component.set("v.proTPTPerIndir",ProposedTPTInDir);
                                   component.set("v.BlendedTPMargin",BlendedTPMargin);
                                   component.set("v.OpeningOrderTotal",responseValue[0].OpeningOrder);
                                   component.set("v.OpeningOrderNetSalesTotal",responseValue[0].OpeningOrderNetSales);
                                   component.set("v.OpeningOrderTPTTotal",responseValue[0].OpeningOrderTPT);
                                   var opntptPerc = responseValue[0].OpeningOrderNetSales =! 0 ? (responseValue[0].OpeningOrderTPT / responseValue[0].OpeningOrderNetSales)*100 :0;
                                   component.set("v.OpeningOrderTPTPercTotal",opntptPerc);
                                   
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
                component.set("v.BidLineItemListAll",lineItemsList);
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
    convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidType,isReBid){
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
        if(bidType != 'New Product Launch'){
            myMap.set("Current Position", "Phoenix_Current_Position__c");
        }
        myMap.set("Proposed Position", "Phoenix_Proposed_Position__c");
        if(bidType != 'New Product Launch'){
            myMap.set("3 Months Annualized Current Direct Selling Units", "Phoenix_Current_Direct_Selling_Unit__c");
            myMap.set("3 Months Annualized Current Indirect Selling Units", "Phoenix_Current_Indirect_Selling_Unit__c");
            myMap.set("3 Months Annualized Total Selling Units", "Phoenix_Total_Selling_Unit__c");
            myMap.set("Last 12 Months Actuals Current Direct Selling Units", "Phoenix_12_Months_Actual_Sales__c");
            myMap.set("Last 12 Months Actuals Current Indirect Selling Units", "Phoenix_12_Months_IndirectSaleUnit__c");
            myMap.set("Last 12 Months Actuals Total Selling Units", "Phoenix_12_Months_TotalSaleUnits__c");
            myMap.set("Override Current Direct Selling Units", "Phoenix_Override_Current_Direct_Units__c");
            myMap.set("Override Current Indirect Selling Units", "Phoenix_Override_Current_Indirect_Units__c");
            myMap.set("Override Total Units", "Phoenix_Override_Total_units__c");
        }
        if(bidType != 'Price Change'){
              if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){
                myMap.set("Proposed Direct Selling Units(Current + Increment)", "Phoenix_Proposed_Direct_Selling_Unit__c");
        myMap.set("Proposed Indirect Selling Unit(Current + Increment)", "Phoenix_Proposed_Indirect_Selling_Unit__c");
                }
           else{
                myMap.set("Proposed Direct Selling Units", "Phoenix_Proposed_Direct_Selling_Unit__c");
            myMap.set("Proposed Indirect Selling Units", "Phoenix_Proposed_Indirect_Selling_Unit__c");
           }
      
           
            myMap.set("Proposed Total Selling Units", "Phoenix_Final_Total_Selling_Unit__c");
            if(bidType != "New Product Launch"){
                myMap.set("SCM Approved Direct Selling Units", "Phoenix_Final_Direct_Selling_Units_Calc__c");
                myMap.set("SCM Approved Indirect Selling Units", "Phoenix_Final_Indirect_Selling_Units_Cal__c");
                myMap.set("Total SCM Approved Qty", "Phoenix_Total_SCM_Approved_Qty__c");
            }
        }
        if(bidType != 'New Product Launch'){
            myMap.set("Current Direct Contract Price", "Phoenix_Current_Direct_Price__c");
            myMap.set("Current Indirect Contract Price", "Phoenix_Current_Indirect_Price__c");
            myMap.set("Current Per Unit Rebate", "Phoenix_Current_Per_Unit_Rebate__c");
            myMap.set("Current Net Indirect Price", "Phoenix_Current_Net_Indirect_Price__c");
        }
        if(bidType != 'Volume Review Only'){
            myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
            myMap.set("Sales Price(Sales)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
        }
        if(bidType != 'New Product Launch'){
            myMap.set("Reduction", "Phoenix_Reduction__c");
        }
        if(bidType == 'New Product Launch'){
            //myMap.set("Current Supplier", "Phoenix_Current_Supplier__c");
            myMap.set("Brand WAC", "Brand_WAC__c"); 
            myMap.set("Brand WAC %", "Phoenix_Brand_WAC_Per__c"); 
              
        }
        if(bidType != 'Volume Review Only'){
            myMap.set("Proposed Direct Contract Price(Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
            myMap.set("Proposed Indirect Contract Price(Marketing)", "Phoenix_Wholesaler_Diff_Price_Indirect__c");
        }
        myMap.set("Net Indirect Price", "Phoenix_Customer_Dead_Net1__c");
        myMap.set("Direct CD $", "Phoenix_Direct_CD_Per_Unit__c");
        myMap.set("Indirect CD $", "Phoenix_INDIRECT_CD__c");
        myMap.set("CM Fees $", "Phoenix_Contract_Mngmnt_Fee_Wholesaler__c");
        myMap.set("PUR $", "Phoenix_Proposed_Per_Unit_Rebate__c");
        myMap.set("Wholesaler Controlled Substance Fee$", "Phoenix_Whlsr_Controlled_Substance_Fee__c");
        myMap.set("Direct Dead Net $", "Phoenix_Direct_Dead_Net__c");
        myMap.set("Direct TPT$", "Phoenix_Direct_TP_In__c");
        myMap.set("Direct TPT %", "Phoenix_Direct_TP__c");
        myMap.set("Indirect Dead Net $", "Phoenix_Indirect_Dead_Net__c");
        myMap.set("Indirect TPT$", "Indirect_TP__c");
        myMap.set("Indirect TPT %", "Phoenix_Indirect_TP__c");
        if(bidType != 'Price Change' && bidType != 'Volume Review Only'){
            myMap.set("IOD per unit", "Phoenix_Wholesaler_IOD_per_unit__c");
            myMap.set("IOD Total $", "Phoenix_IOD_Total_Amount__c");
        }
        myMap.set("Medicaid & Returns  per unit", "Phoenix_Medicaid_Returns_Per_Unit_in__c");
        myMap.set("Direct Net sales", "Proposed_Net_Sales_Direct__c");
        myMap.set("Indirect Net sales", "Proposed_Net_Sales_Indirect__c");
        myMap.set("Total Net sales", "Phoenix_Net_Sales_Internal__c");
        myMap.set("Direct TPT", "Proposed_TPT_Direct__c");
        myMap.set("Indirect TPT", "Proposed_TPT_Indirect__c");
        myMap.set("Total TPT", "Phoenix_Th_Put_Margin__c");
        myMap.set("Direct TPT % ", "Proposed_TPT_Per_Direct__c");
        myMap.set("Indirect TPT % ", "Proposed_TPT_Per_Indirect__c");
        myMap.set("Total TPT %", "Phoenix_TP_Margin__c");
        if(bidType == 'New Product Launch'){
            myMap.set("Opening Order", "Phoenix_Opening_Order__c");
            myMap.set("Opening Order Net Sales", "Phoenix_Opening_Order_Net_sales__c"); 
            myMap.set("Opening Order TPT $", "Phoenix_Opening_Order_TPT__c"); 
            myMap.set("Opening Order TPT %", "Phoenix_Opening_Order_TPT_Per__c"); 
        }
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
        
        
        myMap.set("Proposed as % of Budget","Phoenix_Proposed_to_Budget__c");
        myMap.set("Latest Estimate ASP","Phoenix_Latest_Estimate__c");
        myMap.set("Proposed as % of Latest Estimate","Phoenix_Proposed_as_of_Latest_Estimate__c");
        
        myMap.set("Lowest Price /SKU","Phoenix_Lowest_Price_SKU__c");
        myMap.set("Approved Lowest Price /SKU","Phoenix_Approved_Lowest_Price_SKU__c");
        if(bidType != "Price Change" && bidType != "New Product Launch" ){
            myMap.set("Initial Stocking Order Volume","Phoenix_Initial_Stocking_Order_Volume__c");
            myMap.set("Initial Stocking Order Comments","Phoenix_Initial_Stocking_Order_Comments__c");
            //myMap.set("Total SCM Approved Qty","Phoenix_Total_SCM_Approved_Qty__c");
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
            myMap.set("SCM Comments","Phoenix_SCM_Notes__c");
        }
        if(bidType == 'New Product Launch'){
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("Opening Order Comments","Phoenix_Initial_Stocking_Order_Comments__c");   
        }
        myMap.set("Sales Notes","Phoenix_Sales_Notes__c");
        if(bidType != "Volume Review Only"){
            myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
        }
        myMap.set("Marketing Notes","Phoenix_Marketing_Notes__c");
        if(bidType != "Volume Review Only"){
            myMap.set("Finance Approval","Phoenix_Finance_Approval__c");
            myMap.set("Finance Comments","Phoenix_Finance_Comments__c");
        }
        myMap.set("Contract Status","Phoenix_Contract_Approval__c"); 
        myMap.set("Contract Comments","Phoenix_Contract_Comments__c");
        myMap.set("WAC Check","Phoenix_WAC_Check__c");
        if(bidType != "Price Change" && bidType != "Volume Review Only"){
            myMap.set("IOD Qty (rounded to MOQ)","Phoenix_IOD_Qty__c");
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
                      csvStringResult += '"'+ objectRecords[i]["Phoenix_Estimated_Lead_Time_Days__c"]+'"';
                 
                }*/
                        else if(value == 'Phoenix_Contract_Mngmnt_Fee_Wholesaler__c'){
                            var rounded_CmFee = objectRecords[i]['Phoenix_Contract_Mngmnt_Fee_Wholesaler__c'];
                            rounded_CmFee = Math.round(rounded_CmFee * 100) / 100
                            csvStringResult += '"'+ rounded_CmFee +'"';
                        }
                            else if(value == 'Phoenix_Proposed_Per_Unit_Rebate__c'){
                                var rounded_pur = objectRecords[i]['Phoenix_Proposed_Per_Unit_Rebate__c'];
                                rounded_pur = Math.round(rounded_pur * 100) / 100
                                csvStringResult += '"'+ rounded_pur +'"';
                            }
                                else if(value == 'Phoenix_Wholesaler_IOD_per_unit__c'){
                                    var rounded_iod = objectRecords[i]['Phoenix_Wholesaler_IOD_per_unit__c'];
                                    rounded_iod = Math.round(rounded_iod * 100) / 100
                                    csvStringResult += '"'+ rounded_iod +'"';
                                }
                                    else if(value == 'Phoenix_Total_Selling_Unit__c'){
                                        var totalSellingUnits = ((objectRecords[i]['Phoenix_Current_Direct_Selling_Unit__c'] != null ? 
                                                                  objectRecords[i]['Phoenix_Current_Direct_Selling_Unit__c'] : 0 ) + (objectRecords[i]['Phoenix_Current_Indirect_Selling_Unit__c'] != null ? objectRecords[i]['Phoenix_Current_Indirect_Selling_Unit__c'] : 0 ))
                                        csvStringResult += '"'+ totalSellingUnits +'"';
                                    }
                                        else if(value == 'Phoenix_Final_Total_Selling_Unit__c'){
                                            var totalSellingUnits = ((objectRecords[i]['Phoenix_Proposed_Direct_Selling_Unit__c'] != null ? 
                                                                      objectRecords[i]['Phoenix_Proposed_Direct_Selling_Unit__c'] : 0 ) + (objectRecords[i]['Phoenix_Proposed_Indirect_Selling_Unit__c'] != null ? objectRecords[i]['Phoenix_Proposed_Indirect_Selling_Unit__c'] : 0 ))
                                            csvStringResult += '"'+ totalSellingUnits +'"';
                                        }
                                            else if(value=='Phoenix_Reduction__c'){
                                                var rounded_red = objectRecords[i]['Phoenix_Reduction__c'];
                                                if(rounded_red != null){
                                                    rounded_red = Math.round(rounded_red * 100) / 100
                                                    csvStringResult += '"'+ rounded_red +'"';
                                                }
                                                else
                                                    csvStringResult += '"'+''+'"';
                                            }
                                                else if(value == 'Proposed_TPT_Per_Direct__c'){
                                                    var Proposed_tpt=objectRecords[i]['Proposed_TPT_Per_Direct__c'];
                                                    console.log('Proposed_tpt direct initialvalue-->'+Proposed_tpt);
                                                    if(Proposed_tpt != null){
                                                        var rounded_tpt = Math.round(Proposed_tpt * 100)/100
                                                        //var rounded_tpt=Math.round((Proposed_tpt + Number.EPSILON) * 100) / 100
                                                        //console.log('Proposed_tpt direct rounded value-->'+rounded_tpt);
                                                        csvStringResult += '"'+ rounded_tpt +'"';
                                                    }
                                                    else{
                                                        csvStringResult += '"'+'tptNull'+'"';
                                                    }
                                                }
                                                    else if(value == 'Proposed_TPT_Per_Indirect__c'){
                                                        var Proposed_tpt=objectRecords[i]['Proposed_TPT_Per_Indirect__c'];
                                                        console.log('Proposed_tpt Indirect initialvalue-->'+Proposed_tpt);
                                                        if(Proposed_tpt != null){
                                                            var rounded_tpt=Math.round(Proposed_tpt * 100)/100
                                                            //console.log('Proposed_tpt indirect rounded value-->'+rounded_tpt);
                                                            csvStringResult += '"'+ rounded_tpt +'"';
                                                        }
                                                        else{
                                                            csvStringResult += '"'+'tptNullInd'+'"';
                                                        }
                                                    }
                                                        else if(value == 'Phoenix_Internal_Dead_Net_Price__c'){
                                                            var deadnetprice=objectRecords[i]['Phoenix_Internal_Dead_Net_Price__c'];
                                                            //console.log('deadnetprice initialvalue-->'+deadnetprice);
                                                            if(deadnetprice != null){
                                                                var rounded_price=Math.round(deadnetprice * 100)/100
                                                                //console.log('deadnetprice rounded value-->'+rounded_price);
                                                                csvStringResult += '"'+ rounded_price +'"';
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
                                                                    csvStringResult += '"'+ rounded_rebateperindl +'"'; 
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
                                                                        csvStringResult += '"'+ rounded_adminfeeindl+'"'; 
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
                                                                            csvStringResult += '"'+ rounded_iodperunitindl+'"'; 
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
                                                                                csvStringResult += '"'+ rounded_cdperunitdirect+'"'; 
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
                                                                                    csvStringResult += '"'+ rounded_totalrdcnlcper+'"'; 
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
                                                                                        csvStringResult += '"'+ rounded_rdcnlcperunitindl+'"'; 
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
                                                                                            csvStringResult += '"'+ rounded_cmfeeperunit+'"'; 
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
                                                                                                csvStringResult += '"'+ rounded_medicaidretperunit+'"'; 
                                                                                            }
                                                                                            else{
                                                                                                csvStringResult += '"'+''+'"';   
                                                                                            }        
                                                                                        }
                                                                                          /*  else if(value == 'Phoenix_Direct_Dead_Net__c'){
                                                                                                var directdeadnet=objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                                                                                                // console.log('directdeadnet-->'+directdeadnet);
                                                                                                if(directdeadnet != null){
                                                                                                    var rounded_directdeadnet=Math.round(directdeadnet * 100)/100
                                                                                                    csvStringResult += '"'+ rounded_directdeadnet+'"'; 
                                                                                                }
                                                                                                else{
                                                                                                    csvStringResult += '"'+''+'"';   
                                                                                                }        
                                                                                            }*/
                                                                                              /*  else if(value == 'Phoenix_Indirect_Dead_Net__c'){
                                                                                                    var indirectdeadnet=objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                                                                                         
                                                                                                    if(indirectdeadnet != null){
                                                                                                        var rounded_indirectdeadnet=Math.round(indirectdeadnet * 100)/100
                                                                                                        csvStringResult += '"'+ rounded_indirectdeadnet+'"'; 
                                                                                                    }
                                                                                                    else{
                                                                                                        csvStringResult += '"'+''+'"';   
                                                                                                    } 
                                                                                                    
                                                                                                }*/
                                                                                                    else if(value == 'Phoenix_Net_Sales_Internal__c'){
                                                                                                        var netsalesinternal=objectRecords[i]['Phoenix_Net_Sales_Internal__c'];
                                                                                                        // console.log('netsalesinternal-->'+netsalesinternal);
                                                                                                        if(netsalesinternal != null){
                                                                                                            var rounded_indirectdeadnet=Math.round(netsalesinternal)
                                                                                                            csvStringResult += '"'+ rounded_indirectdeadnet+'"'; 
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
                                                                                                                csvStringResult += '"'+ rounded_iodtotalamount+'"'; 
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
                                                                                                                    csvStringResult += '"'+ rounded_indirectcdperundl+'"'; 
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
                                                                                                                        csvStringResult += '"'+ rounded_proposednetsalesdirect+'"'; 
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
                                                                                                                                var rounded_proposedtpdldirect=Math.round(proposedtpdldirect);//Math.round(proposedtpdldirect*100)/100
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
                                                                                                                                    var rounded_proposedtpdlindirect=Math.round(proposedtpdlindirect);//Math.round(proposedtpdlindirect*100)/100
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
        var contrcts=component.get('v.selectedCntrcts');
        var indirectCons;
        var DirectCons;
        var isOverrideUnitsavl = false;
        if(contrcts!=null){
            indirectCons=contrcts.filter((contrcts) => contrcts.startsWith("3"));
            DirectCons=contrcts.filter((contrcts) => contrcts.startsWith("1"));  
        }
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
                                   var delegatedUser = component.get("v.deligatedUserName");
                                   var bidtype=component.get("v.BidTypeVal");
                                   console.log('resultslength--'+resultlength);
                                   var qtyError;	
                                   for(var i=0;i<resultlength;i++){
                                       if(DirectCons.length>0 && bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && ResultData[i].Phoenix_Proposed_Direct_Selling_Unit__c==null){
                                           qtyError='Please Enter Proposed Direct Selling Units for '+ResultData[i].Phoenix_Product__r.Name;
                                           console.log('in direct');
                                           break;
                                       }
                                       if(indirectCons.length>0 && bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && ResultData[i].Phoenix_Proposed_Indirect_Selling_Unit__c==null ){
                                           qtyError='Please Enter Proposed Indirect Selling Units for '+ResultData[i].Phoenix_Product__r.Name;
                                           console.log('in Indirect');
                                           break;
                                       }
                                       if(component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName")||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Wholesaler_Diff_Price_Indirect__c==null && bidtype != 'Customer Rebate Change' && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Indirect Contract Price';	
                                               console.log('marketing Price');	
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                       else if(component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName")|| (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_ProposedContractBidPriceMktng__c==null && bidtype != 'Customer Rebate Change' && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' ){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Direct Contract Price';	
                                               console.log('marketing Price');	
                                               break;	  
                                           } else{
                                               break;
                                           }
                                       }
                                           else if(component.get("v.BidAprrovalStatus")!='Draft' 
                                                   && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                                                   &&  ResultData[i].Phoenix_Wholesaler_Diff_Price_Indirect__c < ResultData[i].Phoenix_Customer_Dead_Net1__c 
                                                   && bidtype!='Customer Rebate Change' && bidtype!='Volume Review Only' 
                                                   && bidtype!='Sales Out Rebate'){	
                                               if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                                   qtyError='Indirect Price can not be less than Net Indirect Price '+ResultData[i].Phoenix_Product__r.Name;
                                                   console.log('marketing Price');
                                                   break;	  
                                               } else{
                                                   break;
                                               }
                                           }
                                             /*  else if (component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Direct_Dead_Net__c < ResultData[i].Phoenix_Lowest_Price_SKU__c &&  ResultData[i].Phoenix_Direct_Dead_Net__c !=0){
                                                   if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                       qtyError='You cannot submit this Bid for Approval as Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                                       break;
                                                   }
                                                   else {
                                                       break;
                                                   }
                                               }*/
                                       /*For Delegation*/
                                     /*  else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName")|| (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Direct_Dead_Net__c < ResultData[i].Phoenix_Lowest_Price_SKU__c &&  ResultData[i].Phoenix_Direct_Dead_Net__c !=0){
                                                   if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                       qtyError='You cannot submit this Bid for Approval as Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                                       break;
                                                   }
                                                   else {
                                                       break;
                                                   }
                                               }8/
                                       /*End For Delegation*/
                                        
                                   }	
                                   for(var i=0;i<resultlength;i++){
                                       if(ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && (ResultData[i].Phoenix_Override_Current_Indirect_Units__c==null || ResultData[i].Phoenix_Override_Current_Indirect_Units__c==undefined || ResultData[i].Phoenix_Override_Current_Indirect_Units__c=='undefined') && (ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==null || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==undefined || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==0)){                                             
                                           isOverrideUnitsavl =true;
                                               break;
                                           }
                                        else if( ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && (ResultData[i].Phoenix_Override_Current_Direct_Units__c==null  || ResultData[i].Phoenix_Override_Current_Direct_Units__c==undefined || ResultData[i].Phoenix_Override_Current_Direct_Units__c=='undefined') && (ResultData[i].Phoenix_Current_Direct_Selling_Unit__c==null || ResultData[i].Phoenix_Current_Direct_Selling_Unit__c==undefined || ResultData[i].Phoenix_Current_Direct_Selling_Unit__c==0)){                                             
                                           isOverrideUnitsavl =true;
                                               break;
                                           }
                                   }
                                   console.log('isOverrideUnitsavl-----'+isOverrideUnitsavl);
                                    var modalMessage = isOverrideUnitsavl ? 'The 3 Months Annualized Current Selling Units is 0. Are you sure you want to submit this bid for approval?' : 'Are you sure you want to submit this bid for approval?';
                                       component.set('v.modalMessage',modalMessage);
                                   if(qtyError){	
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
    }
})