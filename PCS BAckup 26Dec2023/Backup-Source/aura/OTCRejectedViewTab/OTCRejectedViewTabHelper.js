({
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
                                               console.log('other---'+JSON.stringify(other));
                                               console.log('current---'+JSON.stringify(current));
                                               return other == current.Name 
                                           }).length == 0;
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
        
        //Export starts.
        myMap.set("NDC", "Phoenix_NDC__c");
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("SAP Number (FG)", "Phoenix_Product_Code1__c");
        myMap.set("Strength", "Phoenix_Current_Supplier__c");
        myMap.set("Case Pack", "Phoenix_Case_Pack__c");
        myMap.set("MOQ", "Phoenix_MOQ1__c");
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("TPT Costs $", "Phoenix_Throughput_Cost1__c");
        if (bidType != 'OTC OTB Good Dated' && bidType != 'OTC OTB Short Dated' && bidType != 'OTC New Product')  {
            myMap.set("Last 12 Months Actuals  Selling Units", "Phoenix_12_Months_Actual_Sales__c");
            myMap.set("Total Current DRL Selling Units", "Phoenix_Current_Direct_Selling_Unit__c");
            myMap.set("Override Total Current DRL Selling Units", "Phoenix_Override_Current_Direct_Units__c");
            myMap.set("Current 52wk", "Phoenix_Current_Retail_Direct_Units__c");
            myMap.set("Current Monthly", "Phoenix_12_Months_TotalSaleUnits__c");
            
        }
        if(bidType != 'OTC Price Change' && bidType != 'OTC Rebate Change'){
            myMap.set("Total Units", "Phoenix_12_Months_IndirectSaleUnit__c");
            myMap.set("Proposed Share %", "Phoenix_Date_Fee__c");
            myMap.set("Proposed Total DRL Units", "Phoenix_Proposed_Direct_Selling_Unit__c");
            myMap.set("Proposed 52wk", "Phoenix_Proposed_Anda_Units__c");
            myMap.set("Proposed Monthly", "Phoenix_Proposed_OS_Units__c");
            if(bidType != 'OTC OTB Good Dated' && bidType != 'OTC OTB Short Dated'){
            myMap.set("SCM Approved DRL Units", "Phoenix_Final_Direct_Selling_Units_Calc__c");
            myMap.set("SCM Approved 52wk", "Phoenix_Others_Direct__c");
            myMap.set("SCM Approved Monthly", "Phoenix_Others_Indirect__c");
            }
        }
        
        if (bidType != 'OTC OTB Good Dated' && bidType != 'OTC OTB Short Dated' && bidType != 'OTC New Product')  {
            myMap.set("Current Sell Price", "Phoenix_Current_Direct_Price__c");
        }
          if (bidType != 'OTC OTB Good Dated' && bidType != 'OTC OTB Short Dated' && bidType != 'OTC New Product')  {
             myMap.set("Current Net Price", "Phoenix_DeadNet_TrckGR__c");
             myMap.set("Current Net Sales", "Phoenix_Current_Sales_Finance__c");
             myMap.set("Current Profit", "Phoenix_Current_TP_Margin__c");
             myMap.set("Current TP%", "Phoenix_Current_TP_MarginPercent__c");
           
        }
        if(bidType != 'OTC Volume Review' && bidType != 'OTC Rebate Change'){
            myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
            myMap.set("Sales Price", "Phoenix_ProposedContract_Bid_Price_Sales__c");
            
        }
        if(bidType != 'OTC Rebate Change'){
             myMap.set("Supply Type", "Phoenix_Supply_Type__c");
        }
         if (bidType != 'OTC Rebate Change'){
        if (bidType != 'OTC OTB Good Dated' && bidType != 'OTC OTB Short Dated' && bidType != 'OTC New Product' && bidType != 'OTC Volume Review')  {
            myMap.set("Sell Price % Change", "Phoenix_Reduc_in_NCP_McK_And_RAD__c");
        }
        if(bidType != 'OTC Volume Review'){
        myMap.set("Proposed Sell Price", "Phoenix_ProposedContractBidPriceMktng__c");
            myMap.set("Proposed PUR $", "Phoenix_Proposed_Per_Unit_Rebate__c");
        }
         }
          if (bidType == 'OTC Rebate Change'){
             myMap.set("Net Price % Change", "Phoenix_Reduction_in_NCP_WMT__c"); 
         }
        myMap.set("Admin Fees %", "Phoenix_Current_Admin_Fee__c");
        myMap.set("Admin Fees Type", "Phoenix_Fee_G_N__c");
        myMap.set("Admin Fees $", "Phoenix_Admin_Fee_in__c");
        
        if (bidType != 'OTC OTB Good Dated' && bidType != 'OTC OTB Short Dated' && bidType != 'OTC New Product')  {
            myMap.set("Current Rebate %", "Phoenix_Current_Rebate__c");
        }
            myMap.set("Proposed Rebate %", "Phoenix_Proposed_Current_Rebate__c");
        
        myMap.set("Rebate Fees Type", "Phoenix_Rebate_G_N__c");
        myMap.set("Rebate Fees $", "Phoenix_Rebate_Perc_In__c");
        myMap.set("Damages %", "Phoenix_Reduction__c");
        myMap.set("Damages $", "Phoenix_Current_Anda_CP_Price__c");
        myMap.set("VIP %", "Phoenix_Proposed_Est_VIP__c");
        myMap.set("VIP $", "Phoenix_Anda_VIP__c");
        myMap.set("Direct CD %", "Phoenix_Cash_Terms__c");
        myMap.set("Direct CD $", "Phoenix_Cash_Terms_RxSS__c");
        myMap.set("Net Price", "Phoenix_Internal_Dead_Net_Price__c");
        myMap.set("TPT $ per pack", "Proposed_TPT_Direct__c");
        myMap.set("TPT % per pack", "Proposed_TPT_Per_Direct__c");
        myMap.set("Gross Sales", "Phoenix_Net_Sales_External__c");
        myMap.set("Net Sales", "Phoenix_Net_Sales_Internal__c");
        myMap.set("Total TPT $", "Phoenix_Th_Put_Margin__c");
        myMap.set("Profit", "Phoenix_Current_Net_Indirect_Price__c");
        myMap.set("Sell Price Per Size", "Phoenix_Sales_Proposed_NCP_McK_And_RAD__c");
        
        
        myMap.set("Brand Retail Price", "Phoenix_Current_Retail_Direct_Price__c");
        myMap.set("SB Retail Price", "Phoenix_Current_Retail_Indirect_Price__c");
        myMap.set("Retail $", "Phoenix_Opening_Order_Net_sales__c");
        myMap.set("RM $", "Phoenix_Opening_Order_TPT__c");
        myMap.set("RM %", "Phoenix_Opening_Order_TPT_Per__c");
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
        myMap.set("Proposed as % of Budget ", "Phoenix_Proposed_to_Budget__c");
        myMap.set(" Latest Estimate ASP", "Phoenix_Latest_Estimate__c");
        myMap.set("Proposed as % of Latest Estimate", "Phoenix_Proposed_as_of_Latest_Estimate__c");
        myMap.set(" Lowest Price / SKU (OTC)", "Phoenix_Lowest_Price_SKU__c");
        
        if (bidType != 'OTC OTB Good Dated' && bidType != 'OTC OTB Short Dated' && bidType != 'OTC New Product' && bidType != 'OTC Rebate Change')  {
            myMap.set("Initial Stocking Order Volume  ", "Phoenix_Initial_Stocking_Order_Volume__c");
            myMap.set("Initial Stocking Order Comments ", "Phoenix_Initial_Stocking_Order_Comments__c");
            myMap.set("Total SCM Approved Qty ", "Phoenix_Total_SCM_Approved_Qty__c");
            myMap.set("Estimated Lead Time ", "Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("SCM Approval (Y/N) ", "Phoenix_SCM_Approval_Y_N__c");
            myMap.set("SCM Comments", "Phoenix_SCM_Notes__c");
            myMap.set("SCM Rejection Reason", "Phoenix_SCM_Rejection_Reason1__c");
            myMap.set("Revisit Date", "Phoenix_Revisited_Date__c");
            
            
        }
        
        myMap.set("Sales Notes", "Phoenix_Sales_Notes__c");
        myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
        myMap.set(" Marketing Notes", "Phoenix_Marketing_Notes__c");
        
        if (bidType == 'OTC Volume Review' || bidType == 'OTC OTB Short Dated' ){ 
            myMap.set("Marketing Lead Approval", "Phoenix_Marketing_Lead_OTC__c");
            myMap.set(" Marketing Lead Comments", "Phoenix_Pricing_Notes__c");
        }
        myMap.set("Customer Approval", "Phoenix_Customer_Approval_OTC__c");
        myMap.set("Customer Comments", "Phoenix_Customer_Service_Comments__c");
        if(bidType != 'OTC Rebate Change'){
            myMap.set("Supply Effective Date", "Phoenix_Supply_Effective_Date__c");
        }
        if(bidType != 'OTC Volume Review'){
            myMap.set("Price Effective Date", "Phoenix_Price_Effective_Date__c");
            if (bidType != 'OTC Volume Review')  {
                myMap.set("Marketing Lead OTC", "Phoenix_Marketing_Lead_OTC__c");
                myMap.set("Marketing Lead Comments", "Phoenix_Business_Head_Comments__c");
                myMap.set("Marketing Head Approval", "Phoenix_Approval__c");
                myMap.set("Marketing Head Comments", "Phoenix_Comments__c");
            }
            myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
            myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
            if (bidType != 'OTC Volume Review')  {
                myMap.set("Sr Director / VP Finance Approval", "Phoenix_Sr_Director_VP_Finance_Approval__c");
                myMap.set("Sr Director / VP Finance Comments", "Phoenix_Sr_Director_VP_Finance_Comments__c");
            }
            myMap.set("Contract Status", "Phoenix_Contract_Approval__c");
            myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        }
        myMap.set("Bid Status", "Phoenix_Bid_Status__c");
        myMap.set("Customer Decline Reasons", "Phoenix_Customer_Decline_Reasons__c");
        //end.
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for(var i=0; i < objectRecords.length; i++){  
                counter = 0;
                for (let [key, value] of myMap) {
                    if(counter > 0){ 
                        csvStringResult += columnDivider; 
                    }
                    console.log('testing result--->'+JSON.stringify(objectRecords[i]));
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
                            else if(value == "Phoenix_Revisited_Date__c"){
                                var revisitDate=objectRecords[i]["Phoenix_Revisited_Date__c"];
                                if(revisitDate != null){
                                    var dt = new Date(revisitDate);
                                    var month = dt.getMonth() + 1;
                                    var day = dt.getDate();
                                    var year = dt.getFullYear();
                                    var formatteddate = month + "/" + day + "/" + year;
                                    csvStringResult += '"'+formatteddate+'"';
                                    console.log('formatteddate--->'+formatteddate);
                                }
                                else{
                                    csvStringResult += '"'+''+'"';
                                } 
                            }
                    //added by vandana
                                else if(value == 'Phoenix_Final_Direct_Selling_Units_Calc__c'){
                                    var scmUnits =objectRecords[i]['Phoenix_SCM_Final_Approval__c'] ==true ?objectRecords[i]['Phoenix_Final_Direct_Selling_Units_Calc__c'] :'' ;
                                    
                                    csvStringResult += '"'+ scmUnits +'"';
                                }
                                    else if(value == 'Phoenix_Others_Direct__c'){
                                        var scmUnits =objectRecords[i]['Phoenix_SCM_Final_Approval__c'] ==true ?objectRecords[i]['Phoenix_Others_Direct__c'] :'' ;
                                        
                                        csvStringResult += '"'+ scmUnits +'"';
                                    }
                                        else if(value == 'Phoenix_Others_Indirect__c'){
                                            var scmUnits =objectRecords[i]['Phoenix_SCM_Final_Approval__c'] ==true ?objectRecords[i]['Phoenix_Others_Indirect__c'] :'' ;
                                            csvStringResult += '"'+ scmUnits +'"';
                                            
                                        }
                //end.  
                          
                                else if(value=='Phoenix_Proposed_Per_Unit_Rebate__c'){
                                    var rebatevalue=objectRecords[i]["Phoenix_Proposed_Per_Unit_Rebate__c"];
                                    if(rebatevalue != null){
                                        var round_two_digits=Math.round((rebatevalue + Number.EPSILON) * 100) / 100;
                                        csvStringResult += '"'+round_two_digits+'"';
                                    }
                                    else{
                                        csvStringResult += '"'+''+'"';
                                    } 
                                }
                                    else if(value == 'Phoenix_Internal_Dead_Net_Price__c'){
                                        var internaldeadnetprice = objectRecords[i]['Phoenix_Internal_Dead_Net_Price__c'];
                                        console.log("internaldeadnetprice--->"+internaldeadnetprice);
                                        if(internaldeadnetprice != null){
                                            var rounde_internaldeadnetprice=Math.round((internaldeadnetprice + Number.EPSILON)* 100) / 100
                                            console.log("rounded internaldeadnetprice--->"+internaldeadnetprice);
                                            csvStringResult += '"'+internaldeadnetprice+'"'; 
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }      
                                    }
                                        else if(value == 'Phoenix_Direct_Dead_Net__c'){
                                            var currentdeadnetprice = objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                                            console.log("currentdeadnetprice--->"+currentdeadnetprice);
                                            if(currentdeadnetprice != null){
                                                var rounde_currentdeadnetprice=Math.round((currentdeadnetprice + Number.EPSILON)* 100) / 100
                                                console.log("rounded rounde_currentdeadnetprice--->"+rounde_currentdeadnetprice);
                                                csvStringResult += '"'+rounde_currentdeadnetprice+'"'; 
                                            }
                                            else{
                                                csvStringResult += '"'+''+'"';
                                            }          
                                        }
                                            else{
                                                if(objectRecords[i][value]==undefined){
                                                    csvStringResult += '"'+''+'"';
                                                }else{
                                                    csvStringResult += '"'+ objectRecords[i][value]+'"';
                                                }
                                            }                
                    counter++;
                }
                csvStringResult += lineDivider;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;        
    },
        getAllTotalValues: function (component, event, helper) {
        var action = component.get("c.getAllTotals");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                var totalsbiPrice = responseValue[0].sbiPrice;
				var totalsellPrice = responseValue[0].sellPrice;
                console.log('totalsellPrice--->'+totalsellPrice)
                console.log('totalsbiPrice--->'+totalsbiPrice)
                if(totalsbiPrice!=null && totalsbiPrice!= undefined && totalsellPrice != null && totalsellPrice!= undefined && totalsbiPrice!=0){
                   component.set("v.RMPercent",((totalsbiPrice-totalsellPrice)/totalsbiPrice))
                  }
                component.set("v.PISUTotal", responseValue[0].pisu);
                component.set("v.PDSUTotal", responseValue[0].pdsu);
                component.set("v.CISUTotal", responseValue[0].cisu);
                component.set("v.CDSUTotal", responseValue[0].cdsu);
                component.set("v.netSalesIntTotal", responseValue[0].netsint);
                component.set("v.grossSalesTotal", responseValue[0].grossSales);
                component.set("v.totalProfit", responseValue[0].profit);
                component.set("v.LCostTotal", responseValue[0].lesscost);
                component.set("v.ThptMrgnDTotal", responseValue[0].thptm);
                component.set("v.intDeadNetTotal", responseValue[0].intdead);
                component.set("v.current52week", responseValue[0].current52wk);
                component.set("v.currentMonthly", responseValue[0].actTotal12Months);
                component.set("v.proposed52wk", responseValue[0].proposed52wk);
                component.set("v.proposedMonthly", responseValue[0].proposedMonthly);
                component.set("v.finalUnitsTotal",responseValue[0].finalUnits);
                component.set("v.finaAnnuallUnits",responseValue[0].finaAnnuallUnits);
                component.set("v.finalMontlyUnits",responseValue[0].finalMontlyUnits);
                component.set("v.currentSalesFinance",responseValue[0].currentSalesFinance);
                component.set("v.currentTPMargin",responseValue[0].currentTPMargin);
                
                var ThptMrgnDTotal=component.get("v.ThptMrgnDTotal");
                var netSalesIntTotal=component.get("v.netSalesIntTotal");
                
                if(netSalesIntTotal>0 ){
                    var TPTPercent=(ThptMrgnDTotal/netSalesIntTotal)*100;
                    component.set("v.TPTPercent",TPTPercent);
                }
                component.set("v.scmAPQTY", responseValue[0].scmAPQTY);
                component.set("v.TotalSellingUnits", responseValue[0].tsu);
                component.set("v.overRideDirectUnits", responseValue[0].overRideDirectUnits);
                component.set("v.overRideIndirectUnits", responseValue[0].overRideIndirectUnits);
                component.set("v.actSaDir12Months", responseValue[0].actSaDir12Months);
                component.set("v.actSalInd12months", responseValue[0].actSalInd12months);
                component.set("v.iodAmountTotal", responseValue[0].iodAmountTotal);
                component.set("v.salesoutAmountTotal", responseValue[0].salesoutAmountTotal);
                
                component.set("v.totalNetSaes", responseValue[0].totalNetSaes);
                component.set("v.IndirNetSales", responseValue[0].IndirNetSales);
                component.set("v.direNetSales", responseValue[0].direNetSales);
                component.set("v.direTPTDollar", responseValue[0].direTPTDollar);
                component.set("v.indirTPTDollar", responseValue[0].indirTPTDollar);
                component.set("v.totalTPTDollar", responseValue[0].totalTPTDollar);
				/* for New Product Launch*/
                component.set("v.OpeningOrderTotal",responseValue[0].OpeningOrder);
                component.set("v.OpeningOrderNetSalesTotal",responseValue[0].OpeningOrderNetSales);
              	component.set("v.OpeningOrderTPTTotal",responseValue[0].OpeningOrderTPT);
                /*var BlendedTPMargin = responseValue[0].netsint =! 0 ? (responseValue[0].TputMargin/responseValue[0].netsint)*100 : 0;
                component.set("v.TPMarginPercent",BlendedTPMargin);*/
                //var opntptPerc = responseValue[0].OpeningOrderNetSales =! 0 ? (responseValue[0].OpeningOrderTPT / responseValue[0].OpeningOrderNetSales)*100 :0;
				//component.set("v.OpeningOrderTPTPercTotal",responseValue[0].OpeningOrderTPTPerc);
                
            } else {
                console.log('totals-errir-');
            }
        });
        $A.enqueueAction(action);
    },
 
})