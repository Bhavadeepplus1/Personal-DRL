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
                                   component.set("v.PISUTotal",responseValue[0].proIndUnits);
                                   component.set("v.PDSUTotal",responseValue[0].pdsu);
                                   component.set("v.CISUTotal",responseValue[0].cisu);
                                   component.set("v.CDSUTotal",responseValue[0].cdsu);
                                   component.set("v.TWMACTSTotalTotal",responseValue[0].actSaDir12Months);
                                   component.set("v.IDEADNETTotal",responseValue[0].indirectDeadNet);
                                   component.set("v.netSalesIntTotal",responseValue[0].netsint);
                                   component.set("v.LCostTotal",responseValue[0].lesscost);
                                   component.set("v.ThptMrgnDTotal",responseValue[0].TputMargin);
                                   //component.set("v.ThptMrgnDTotal",responseValue[0].propoTPmargin);
                                   component.set("v.intDeadNetTotal",responseValue[0].intdead);
                                   component.set("v.OverrideUnitsTotal",responseValue[0].OverrideUnits);
                                   component.set("v.overallAmtTotal",responseValue[0].BASETPbeforePS);
                                   component.set("v.scmAPQTYTotal",responseValue[0].scmAPQTY);
                                  var TPMarginper = responseValue[0].netsint != 0 ? (responseValue[0].TputMargin/responseValue[0].netsint)*100 : 0;
									component.set("v.TPTPercTotal",TPMarginper);
                                   /* New Product Launch*/
                                    component.set("v.OpeningOrderTotal",responseValue[0].OpeningOrder);
                                   component.set("v.OpeningOrderNetSalesTotal",responseValue[0].OpeningOrderNetSales);
                                   component.set("v.OpeningOrderTPTTotal",responseValue[0].OpeningOrderTPT);
                                   var opntptPerc = responseValue[0].OpeningOrderNetSales =! 0 ? (responseValue[0].OpeningOrderTPT / responseValue[0].OpeningOrderNetSales)*100 :0;
									component.set("v.OpeningOrderTPTPercTotal",opntptPerc); 
								 /* END New Product Launch*/
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
     fetchPositions : function(component,event,helper,bidCustomer) {
        console.log('bidCustomer---'+bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams
        ({
            customerID: bidCustomer
           // searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   var responseList = response.getReturnValue();
                                   console.log('---responseList---'+responseList.length);
                                   //component.set("v.contratcsList",responseList);
                                   
                                   //below code is for remove seleceted while fetch contracts in table
                                   var slctpositions=component.get('v.selectedPosistions');
                                   var finalPositions= responseList.filter(comparer(slctpositions)); 
                                   function comparer(otherArray){
                                       return function(current){
                                           return otherArray.filter(function(other){
                                               console.log(other);
                                               return other == current.Name 
                                           }).length == 0;
                                       }
                                   }
                                 
                                   for (var i = 0; i < finalPositions.length; i++) {
                                       var row = finalPositions[i];
                                       if(row.Phoenix_Customer__c){
                                           row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                                       }                                      
                                   }
                                    component.set("v.positionsList",finalPositions);
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
        
        var action = component.get("c.getNPRDataABCPharmagen");
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
  convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidType,isReBid,bidrecord){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        console.log('testing result--->'+JSON.stringify(objectRecords))
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
        myMap.set("REMS Programme", "Phoenix_REMS__c");
       //if(bidType != "New Product Launch"){
        myMap.set("ABC Progen Current Position", "Phoenix_Current_MCK_Position__c");
      if(bidType != "New Product Launch"){
        myMap.set("ABC Pharmagen Current Position", "Phoenix_Current_Position__c");
      }
       //}
        myMap.set("ABC Pharmagen Proposed Position", "Phoenix_Proposed_Position__c");
      if(bidType != "New Product Launch"){
      	myMap.set("3 Months Annualized Current Indirect Selling Units(Pharmagen)", "Phoenix_Current_Indirect_Selling_Unit__c");
        myMap.set("Last 12 Months Actuals Current Indirect Selling Units(Pharmagen)", "Phoenix_12_Months_Actual_Sales__c");
        myMap.set("Override Current Indirect selling units(Pharmagen)", "Phoenix_Override_Current_Indirect_Units__c");
       }
      if(bidType != "Price Change" && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate"){
           if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){

        myMap.set("Proposed Indirect Selling Units(Pharmagen)(Current + Increment)", "Phoenix_Proposed_Indirect_Selling_Unit__c");
                }
           else{
                   myMap.set("Proposed Indirect Units(Pharmagen)", "Phoenix_Proposed_Indirect_Selling_Unit__c");
           }
          if(bidType != "New Product Launch"){
           myMap.set("Total SCM Approved Qty","Phoenix_Total_SCM_Approved_Qty__c");
          }
       }
       //if(bidType != "New Product Launch"){
       myMap.set("Current ABC Progen CP", "Phoenix_Current_Wholesaler_Price__c");
       myMap.set("ABC Progen Rebate", "Phoenix_Net_Price_after_RebatesbeforeVIP__c");
       myMap.set("ABC Progen CD", "Phoenix_Direct_CD__c");
       myMap.set("ABC Progen VIR", "Phoenix_Anda_VIP__c");
       myMap.set("ABC Progen Local DN", "Phoenix_Current_McK_RAD_Dead_net__c");
      if(bidType != "New Product Launch"){
       myMap.set("Current ABC Pharmagen CP", "Phoenix_Current_Indirect_Price__c");
       myMap.set("ABC Pharmagen Rebate", "Phoenix_Net_Price_afterRebates_after_VIP__c");
       myMap.set("ABC Pharmagen CD", "Phoenix_WMT_CD_WMT_Indirect__c");
       myMap.set("ABC Pharmagen local DN", "Phoenix_Customer_Dead_Net1__c");
       myMap.set("Diff", "Phoenix_Current_WMT_Direct_Dead_net__c");
      }
      //}
       if(bidType != "Volume Review Only"&& bidType != "Sales Out Rebate"){
        myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
        myMap.set("Proposed Contract Price (Sales)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
       }
       if(bidType != "New Product Launch" && bidType != "Volume Review Only"&& bidType != "Sales Out Rebate"){
           myMap.set("% Reduction", "Phoenix_Reduction__c");
       }
       
           if(bidType == "New Product Launch"){
            //myMap.set("Current Supplier", "Phoenix_Current_Supplier__c");
           myMap.set("Brand WAC", "Brand_WAC__c");
           myMap.set("Brand WAC %", "Phoenix_Brand_WAC_Per__c");
       }
     
       if(bidType != "Volume Review Only"&& bidType != "Sales Out Rebate"){
               myMap.set("Proposed Indirect Contract Price (Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
       }
       //myMap.set("Current Rebate %", "Phoenix_Current_Rebate__c");
       myMap.set("Rebate %", "Phoenix_Proposed_Current_Rebate__c");
       myMap.set("Rebate", "Phoenix_Net_Price_after_Rebates_Terms__c");
       myMap.set("CD", "Phoenix_INDIRECT_CD__c");
      myMap.set("Harmonized Dead Net", "Phoenix_Direct_Dead_Net__c");
      //if(bidType != "New Product Launch"){
       myMap.set("Diff ", "Phoenix_Acquisition_Difference__c");
      //}
        myMap.set("Additional Rebate $", "Phoenix_Additional_Rebate__c");
        myMap.set("DRL Dead Net", "Phoenix_Indirect_Dead_Net__c"); 
      myMap.set("TPT $", "Indirect_TP__c");
       myMap.set("TPT %", "Phoenix_Indirect_TP__c");
       if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch"){
        myMap.set("IOD Per Unit $", "Phoenix_Wholesaler_IOD_per_unit__c");
       myMap.set("Overall Amount $", "Phoenix_Wholesaler_IOD_overall_amount__c");
       }
       myMap.set("Medicaid & Returns  per unit", "Phoenix_Estimated_Medicaid_Returns__c");
       myMap.set("Net Sales","Phoenix_Net_Sales_Internal__c");
       myMap.set("TPT$","Phoenix_Th_Put_Margin__c");
       myMap.set("TPT%","Phoenix_TP_Margin__c");
        if(bidType == "New Product Launch"){
        	myMap.set("Opening Order", "Phoenix_Opening_Order__c");
       		myMap.set("Opening Order Net Sales", "Phoenix_Opening_Order_Net_sales__c");
       		myMap.set("Opening Order TPT $", "Phoenix_Opening_Order_TPT__c");
       		myMap.set("Opening Order TPT %", "Phoenix_Opening_Order_TPT_Per__c");  
       }
       myMap.set("Budgeted ASP","Phoenix_Budgeted_ASP1__c");
       myMap.set("Proposed as % of Budget","Phoenix_Proposed_to_Budget__c");
       myMap.set("Latest Estimate ASP","Phoenix_Latest_Estimate__c");
       myMap.set("Proposed as % of Latest Estimate","Phoenix_Proposed_as_of_Latest_Estimate__c");
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
       /*if(bidType == "RFP Bids" || bidType == "Product Addition"){
        myMap.set("SSA Hit","Phoenix_SSA_Hit__c");
       }*/
       if(bidType == "RFP Bids" || bidType == "Product Addition"||bidType == "New Product Launch"){
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
               
                 else if(value == 'Phoenix_REMS__c' ){
                    var rems_value= objectRecords[i]['Phoenix_REMS__c'];
                    if(rems_value == true){
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
                                       if(component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName")|| (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_ProposedContractBidPriceMktng__c==null && bidtype!='Customer Rebate Change' && bidtype!='Volume Review Only' && bidtype!='Sales Out Rebate'){	
                                           if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                               qtyError='Please Enter Marketing Price';	
                                               console.log('marketing Price');	
                                               break;	  
                                           } 
											else{
                                               break;
                                           }
                                       }
                                       else if(component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && ResultData[i].Phoenix_Proposed_Indirect_Selling_Unit__c==null){
                                           qtyError='Please Enter All Proposed Indirect Selling Units';
                                           console.log('in direct');
                                           break;
                                       }
                                        /*   else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName")|| (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Internal_Dead_Net_Price__c < ResultData[i].Phoenix_Lowest_Price_SKU__c  && ResultData[i].Phoenix_Internal_Dead_Net_Price__c !=0){
                                               if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                   qtyError='You cannot submit this Bid for Approval as Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                                   break;
                                               }
                                               else {
                                                   break;
                                               }
                                           }*/
                                       
                                   }
                                   for(var i=0;i<resultlength;i++){
                                        if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Units__c==null && (ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==null || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==undefined || ResultData[i].Phoenix_Current_Indirect_Selling_Unit__c==0)){                                             
                                           isOverrideUnitsavl =true;
                                               break;
                                           }
                                   }	
                                     var modalMessage = isOverrideUnitsavl ? 'The 3 Months Annualized Current Indirect Selling Units (Pharmagen) is 0. Are you sure you want to submit this bid for approval?' : 'Are you sure you want to submit this bid for approval?';
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