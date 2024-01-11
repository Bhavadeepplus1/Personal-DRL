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
                                   console.log('totals---'+JSON.stringify(responseValue));
                                   component.set("v.PISUTotal",responseValue[0].proIndUnits);
                                   component.set("v.PDSUTotal",responseValue[0].pdsu);
                                   component.set("v.CISUTotal",responseValue[0].cisu);
                                   component.set("v.CDSUTotal",responseValue[0].cdsu);
                                   component.set("v.OvrideIUTotal",responseValue[0].OverrideInDirUnits);
                                   component.set("v.netSalesIntTotal",responseValue[0].netsint);
                                   component.set("v.LCostTotal",responseValue[0].lesscost);
                                   component.set("v.ThptMrgnDTotal",responseValue[0].TputMargin);
                                   component.set("v.iodTotalAmount",responseValue[0].IODTotalAmount);
                                   component.set("v.totalSCMQty",responseValue[0].scmAPQTY);
                                   // console.log('thoughtmargin Total--->'+responseValue[0].TputMargin);
                                   component.set("v.intDeadNetTotal",responseValue[0].intdead);
                                   component.set("v.OpeningOrderTotal",responseValue[0].OpeningOrder);
                                   component.set("v.OpeningOrderNetSalesTotal",responseValue[0].OpeningOrderNetSales);
                                   component.set("v.OpeningOrderTPTTotal",responseValue[0].OpeningOrderTPT);
                                   var BlendedTPMargin = responseValue[0].netsint =! 0 ? (responseValue[0].TputMargin/responseValue[0].netsint)*100 : 0;
                                   component.set("v.TPMarginPercent",BlendedTPMargin);
                                   var opntptPerc = responseValue[0].OpeningOrderNetSales =! 0 ? (responseValue[0].OpeningOrderTPT / responseValue[0].OpeningOrderNetSales)*100 :0;
                                   component.set("v.OpeningOrderTPTPercTotal",opntptPerc);                               
                               }
                               else{
                                   console.log('totals-errir-');
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
    /*Product Position Logic End*/
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
        myMap.set("IMS Market Share", "Phoenix_IMS_Market_Share__c");
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        if(bidType != "New Product Launch"){
            myMap.set("Current Position", "Phoenix_Current_Position__c");
        }
        myMap.set("Proposed Position", "Phoenix_Proposed_Position__c");
        if(bidType != "New Product Launch"){
            myMap.set("Current Indirect Selling Unit", "Phoenix_Current_Indirect_Selling_Unit__c");
            myMap.set("Override Current Units", "Phoenix_Override_Current_Units__c");
            myMap.set("12 Months Actual Sales Unit", "Phoenix_12_Months_Actual_Sales__c");
            myMap.set("Doses", "Phoenix_Doses__c");
        }
        if(bidType != "Price Change" && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate"){
            if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){
                
                myMap.set("Proposed Indirect Selling Units(Current + Increment)", "Phoenix_Proposed_Indirect_Selling_Unit__c");
            }
            else{
                myMap.set("Proposed Indirect Selling Units", "Phoenix_Proposed_Indirect_Selling_Unit__c");
                
            }
            myMap.set("Final Annual Extended Units", "Phoenix_Final_Annual_Extended_Units__c");
        }
        if(bidType != "Price Change" && bidType != "New Product Launch" && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate"){
            myMap.set("Total SCM Approved Qty","Phoenix_Total_SCM_Approved_Qty__c");
        }
        if(bidType != "New Product Launch"){
            myMap.set("Current Indirect Price", "Phoenix_Current_Indirect_Price__c");
        }
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
            myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
        }
        
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
            myMap.set("Proposed Contract Bid Price (Sales)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
        }
        if(bidType == "New Product Launch"){
            //myMap.set("Current Supplier", "Phoenix_Current_Supplier__c");
            myMap.set("Brand WAC", "Brand_WAC__c");
            myMap.set("Brand WAC %", "Phoenix_Brand_WAC_Per__c");
        }
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate" && bidType != "New Product Launch"){
            myMap.set("% Reduction", "Phoenix_Reduction_in_NCP_WMT__c");
        }
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
            myMap.set("Proposed Contract Bid Price (Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
        }
        
        if(template == "Walgreens"){
            myMap.set("VIP% Per Unit $", "Phoenix_Customer_VIP1__c");
        }
        if(template == "ABC Progen"){
            myMap.set("Local VIP%", "Phoenix_Local_VIP__c");
            myMap.set("Local VIP% Per Unit $", "Phoenix_Local_VIP_Per_Unit__c");
            myMap.set("Fee Per Unit $", "Phoenix_Customer_Fees__c");
            
        }
        if(template == "Walgreens"){
            //myMap.set("Local VIP% Per Unit $", "Phoenix_Local_VIP_Per_Unit__c");
            myMap.set("CM Fee %", "Phoenix_Contract_Mngment_Fee_Wholesaler__c");
            myMap.set("CM Fee Per Unit $", "Phoenix_Customer_Fees__c");
        }
        myMap.set("Cash Discount Per Unit $", "Phoenix_Customer_Cash_Discount1__c");
        myMap.set("Customer Dead Net", "Phoenix_Customer_Dead_Net1__c");
        if(bidType == "Sales Out Rebate"){
            myMap.set("Sales Out Promotion Per Unit $", "Phoenix_Sales_Out_Promotion_Per_unit_in__c");
            //myMap.set("Sales Out Promotion", "Phoenix_Sales_Out_Promotion__c");   
        }
        if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch"){
            myMap.set("IOD Per Unit $", "Phoenix_IOD_Per_Unit_in__c");
            // myMap.set("Initial Order Discount", "Phoenix_Initial_Order_Discount__c");
        }
        if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch"){
            
            myMap.set("IOD Total Amount $", "Phoenix_IOD_Total_Amount__c");
            
        }
        myMap.set("Current Rebate %", "Phoenix_Current_Rebate__c");
        if(bidType != "Volume Review Only"){
            myMap.set("Proposed Rebate %", "Phoenix_Proposed_Current_Rebate__c"); 
        }
        myMap.set("Rebate % Per Unit $", "Phoenix_Customer_Rebates1__c");
        if(template == "Walgreens"){
            myMap.set("Order Analytics Fee %", "Phoenix_Customer_Order_Analytics_Fee__c");
            myMap.set("Order Analytics Fee Per Unit $", "Phoenix_Customer_Order_Analytics_Fee1__c");
        }
        myMap.set("Group VIP Per Unit $", "Phoenix_Customer_Wbad_VIR1__c");
        if(template == "ABC Progen"){
            myMap.set("Customer VIP Per Unit $", "Phoenix_Customer_VIP_Per_Unit__c");
        }
        myMap.set("Estimated Medicaid and Returns Per Unit","Phoenix_Medicaid_Returns_Per_Unit_in__c");                                      
        myMap.set("Internal Dead Net Price","Phoenix_Internal_Dead_Net_Price__c");
        myMap.set("TP $","Indirect_TP__c");
        myMap.set("TP %","Phoenix_Indirect_TP__c");
        myMap.set("Net Sales (Internal)","Phoenix_Net_Sales_Internal__c");
        myMap.set("Th. Put Margin $$$","Phoenix_Th_Put_Margin__c");
        myMap.set("TP Margin %","Phoenix_TP_Margin__c");
        if(bidType == "New Product Launch"){
            myMap.set("Opening Order", "Phoenix_Opening_Order__c");
            myMap.set("Opening Order Net Sales", "Phoenix_Opening_Order_Net_sales__c");
            myMap.set("Opening Order TPT $", "Phoenix_Opening_Order_TPT__c");
            myMap.set("Opening Order TPT %", "Phoenix_Opening_Order_TPT_Per__c");
        }
        //myMap.set("Blended TP Margin %","Phoenix_TP_Margin__c");
        myMap.set("Budgeted ASP","Phoenix_Budgeted_ASP1__c");
        //if(template == "ABC Progen"){
        myMap.set("Proposed as % of Budget","Phoenix_Proposed_to_Budget__c");
        myMap.set("Latest Estimate ASP","Phoenix_Latest_Estimate__c");
        myMap.set("Proposed as % of Latest Estimate","Phoenix_Proposed_as_of_Latest_Estimate__c");
        // }
        myMap.set("Lowest Price /SKU","Phoenix_Lowest_Price_SKU1__c");
        myMap.set("Approved Lowest Price /SKU","Phoenix_Approved_Lowest_Price_SKU__c");
        if(bidType != "Price Change" && bidType != "New Product Launch" && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate"){
            myMap.set("Initial Stocking Order Volume","Phoenix_Initial_Stocking_Order_Volume__c");
            myMap.set("Initial Stocking Order Comments","Phoenix_Initial_Stocking_Order_Comments__c");
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            //myMap.set("SCM Rejection Reason","Phoenix_SCM_Rejection_Reason1__c");
            myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
            myMap.set("SCM Comments","Phoenix_SCM_Notes__c");
        }
        if(bidType == "New Product Launch"){
            myMap.set(" Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
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
            myMap.set("Contract Status","Phoenix_Contract_Approval__c"); 
            myMap.set("Contract Comments","Phoenix_Contract_Comments__c");
        }
        myMap.set("WAC Check","Phoenix_WAC_Check__c");
        /*if(bidType == "RFP Bids" || bidType == "Product Addition"){
        myMap.set("SSA Hit","Phoenix_SSA_Hit__c");
       }*/
        if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch"){
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
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                if(value=='Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                } else if(value=='Product_Family_Name__c'){
                    if(objectRecords[i]['Product_Family_Name__c'] != null){
                        csvStringResult += '"'+ objectRecords[i]["Product_Family_Name__c"]+'"';
                    } else{
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Product_Family__c"]+'"';
                    }
                }
                /*if('Phoenix_RCA_Agreement__r' in objectRecords[i]){
            if(value=='Phoenix_RCA_Agreement__r.Name'){*/
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
                        else if(value == 'Phoenix_Latest_Estimate__c'){
                            var latest_estimate=objectRecords[i]['Phoenix_Latest_Estimate__c'];
                            if(latest_estimate != null){
                                var rounded_le=Math.round((latest_estimate ) * 100) / 100
                                console.log('rounded value-->'+rounded_le);
                                csvStringResult += '"'+ latest_estimate +'"';
                            }
                            else{
                                csvStringResult += '"'+''+'"';
                                
                            }
                        }
                            else if(value == 'Phoenix_REMS__c' ){
                                var rems_value= objectRecords[i]['Phoenix_REMS__c'];
                                if(rems_value == true){
                                    csvStringResult += '"'+ 'Yes'+'"'; 
                                }
                                else{
                                    csvStringResult += '"'+ 'No'+'"'; 
                                }
                            }
                                else if(value == 'Phoenix_Customer_VIP1__c'){
                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Customer_VIP1__c'];
                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                    if(VIPPerUnitdl != null){
                                        var roundevipperudl=Math.round((VIPPerUnitdl ) * 100) / 100
                                        csvStringResult += '"'+VIPPerUnitdl+'"';  
                                    }
                                    else{
                                        csvStringResult += '"'+''+'"';
                                    }
                                }
                                    else if(value == 'Phoenix_Sales_Out_Promotion_Per_unit_in__c'){
                                        var salesoutpromotionpu = objectRecords[i]['Phoenix_Sales_Out_Promotion_Per_unit_in__c'];
                                        // console.log("salesoutpromotionpu--->"+salesoutpromotionpu);
                                        if(salesoutpromotionpu != null){
                                            var roundesopmpu=Math.round((salesoutpromotionpu ) * 100) / 100
                                            csvStringResult += '"'+salesoutpromotionpu+'"';  
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }     
                                    }
                                        else if(value == 'Phoenix_IOD_Per_Unit_in__c'){
                                            var iodperunit = objectRecords[i]['Phoenix_IOD_Per_Unit_in__c'];
                                            // console.log("iodperunit--->"+iodperunit);
                                            if(iodperunit != null){
                                                var roundeiodperunit=Math.round((iodperunit ) * 100) / 100
                                                csvStringResult += '"'+iodperunit+'"';  
                                            }
                                            else{
                                                csvStringResult += '"'+''+'"';
                                            }      
                                        }
                                            else if(value == 'Phoenix_Customer_Fees__c'){
                                                var cmfeeperunit = objectRecords[i]['Phoenix_Customer_Fees__c'];
                                                // console.log("cmfeeperunit--->"+cmfeeperunit);
                                                if(cmfeeperunit != null){
                                                    var roundecmfeeperunit=Math.round((cmfeeperunit ) * 100) / 100
                                                    csvStringResult += '"'+cmfeeperunit+'"';  
                                                }
                                                else{
                                                    csvStringResult += '"'+''+'"';
                                                }       
                                            }
                                                else if(value == 'Phoenix_Internal_Dead_Net_Price__c'){
                                                    var internaldeadnetprice = objectRecords[i]['Phoenix_Internal_Dead_Net_Price__c'];
                                                    // console.log("internaldeadnetprice--->"+internaldeadnetprice);
                                                    if(internaldeadnetprice != null){
                                                        var roundeinternaldeadnetprice=Math.round((internaldeadnetprice ) * 100) / 100
                                                        csvStringResult += '"'+internaldeadnetprice+'"';  
                                                    }
                                                    else{
                                                        csvStringResult += '"'+''+'"';
                                                    }         
                                                }
                                                    else if(value == 'Phoenix_Customer_Dead_Net1__c'){
                                                        var customerdeadnet = objectRecords[i]['Phoenix_Customer_Dead_Net1__c'];
                                                        // console.log("customerdeadnet--->"+customerdeadnet);
                                                        if(customerdeadnet != null){
                                                            var roundecustomerdeadnet=Math.round((customerdeadnet ) * 100) / 100
                                                            csvStringResult += '"'+customerdeadnet+'"';  
                                                        }
                                                        else{
                                                            csvStringResult += '"'+''+'"';
                                                        }       
                                                    }
                                                        else if(value == 'Phoenix_Customer_Rebates1__c'){
                                                            var rebateperindl = objectRecords[i]['Phoenix_Customer_Rebates1__c'];
                                                            // console.log("rebateperindl--->"+rebateperindl);
                                                            if(rebateperindl != null){
                                                                var rounderebateperindl=Math.round((rebateperindl ) * 100) / 100
                                                                csvStringResult += '"'+rebateperindl+'"';  
                                                            }
                                                            else{
                                                                csvStringResult += '"'+''+'"';
                                                            }      
                                                        }
                                                            else if(value == 'Phoenix_IOD_Total_Amount__c'){
                                                                var iodtotalamount = objectRecords[i]['Phoenix_IOD_Total_Amount__c'];
                                                                console.log("iodtotalamount--->"+iodtotalamount);
                                                                if(iodtotalamount != null){
                                                                    var roundeiodtotalamount=Math.round(iodtotalamount* 100) / 100
                                                                    csvStringResult += '"'+iodtotalamount+'"';  
                                                                }
                                                                else{
                                                                    csvStringResult += '"'+''+'"';
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
                                                                            console.log('Iam in last ELSEE if---->');
                                                                            csvStringResult += '"'+''+'"';
                                                                        }else{
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
        var action = component.get("c.submitToProceddStep");  
        var isOverrideUnitsavl = false;
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
                                       if(component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))&& ResultData[i].Phoenix_ProposedContractBidPriceMktng__c==null && bidtype!='Customer Rebate Change' && bidtype!='Volume Review Only' && bidtype!='Sales Out Rebate'){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Marketing Price';	
                                               console.log('marketing Price');	
                                               break;	  
                                           } 
                                           else{
                                               break;
                                           }
                                       }
                                       else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && ResultData[i].Phoenix_Proposed_Indirect_Selling_Unit__c==null){
                                           qtyError='Please Enter All Proposed Indirect Selling Units';
                                           console.log('in direct');
                                           break;
                                       }
                                           else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype!='New Customer' && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Units__c==null && (ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==null || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==undefined || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==0)){
                                               //qtyError= 'Please enter the Override Units as Current Indirect Selling Units is 0 for '+ResultData[i].Phoenix_Product__r.Name;
                                               console.log('in direct');
                                               isOverrideUnitsavl =true;
                                               break;
                                           }
                                               /*else if (component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Internal_Dead_Net_Price__c < ResultData[i].Phoenix_Lowest_Price_SKU__c && ResultData[i].Phoenix_Internal_Dead_Net_Price__c !=0){
                                                   if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                       qtyError='You cannot submit this Bid for Approval as Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                                       break;
                                                   }
                                                   else {
                                                       break;
                                                   }
                                               }*/
                                       /* For Delegation*/
                                                   /*else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director1__c)))&& bidtype == 'New Product Launch' && ResultData[i].Phoenix_Internal_Dead_Net_Price__c < ResultData[i].Phoenix_Lowest_Price_SKU__c && ResultData[i].Phoenix_Internal_Dead_Net_Price__c !=0){
                                                       if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                           console.log('testing-->')
                                                           qtyError='You cannot submit this Bid for Approval as Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                                           break;
                                                       }
                                                       else {
                                                           break;
                                                       }
                                                   }*/
                                       /*End for Delegation*/
                                       
                                   }
                                   for(var i=0;i<resultlength;i++){
                                       // for ovveride units
                                       if (bidtype != 'New Product Launch' && (ResultData[i].Phoenix_Override_Current_Indirect_Units__c == null && (ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c == 0 || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c == undefined || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c == null))){
                                           isOverrideUnitsavl = true;
                                           break;
                                       }
                                       
                                   }
                                   var modalMessage = isOverrideUnitsavl ? 'The Current Indirect Selling Units is 0. Are you sure you want to submit this bid for approval?' : 'Are you sure you want to submit this bid for approval?';
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