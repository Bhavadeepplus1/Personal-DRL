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
        myMap.set("MOQ", "Phoenix_MOQ1__c");
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating1__c");
        myMap.set("TPT Costs $", "Phoenix_Throughput_cost__c");
        myMap.set("WAC", "Phoenix_WAC__c");
        myMap.set("IMS Market Share", "Phoenix_IMS_Market_Share__c");
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        if(bidType != 'New Product Launch'){
            myMap.set("Current Position", "Phoenix_Current_Position__c");
        }
        myMap.set("Proposed Position", "Phoenix_Proposed_Position__c");
        if(bidType != 'New Product Launch'){
            myMap.set("3 months Annualized Total Selling Units", "Phoenix_Current_Indirect_Selling_Unit__c");
            myMap.set("Last 12 months Actuals  Selling Units", "Phoenix_12_Months_IndirectSaleUnit__c");
            myMap.set("Override Indirect Selling Units", "Phoenix_Override_Current_Indirect_Units__c");
        }
        if(bidType != 'Price Change'){
            myMap.set("Proposed Indirect Units", "Phoenix_Proposed_Indirect_Selling_Unit__c");
            if(bidType != 'New Product Launch'){
                myMap.set("Total SCM Approved Qty", "Phoenix_Total_SCM_Approved_Qty__c");
            }
        }
        
        if(bidType != 'New Product Launch'){
            if(template == 'Humana Indirect CII'){ 
                myMap.set("Current Direct Contract Price", "Phoenix_Current_Direct_Price__c");
                myMap.set("Current Indirect Contract Price", "Phoenix_Current_Indirect_Price__c");
            }
        }
        if(bidType != 'Volume Review Only'){
            myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
            myMap.set("Sales Price", "Phoenix_ProposedContract_Bid_Price_Sales__c");
            if(bidType != 'New Product Launch'){
                myMap.set("% Reduction", "Phoenix_Reduction__c");
            }
        }
        
        
        if(bidType == "New Product Launch"){
            myMap.set("Brand WAC", "Brand_WAC__c");
            myMap.set("Brand WAC %", "Phoenix_Brand_WAC_Per__c");
        }
        
        
        if(bidType != 'Volume Review Only'){
            if(template == 'Humana Indirect CII'){ 
                myMap.set("Proposed Direct Contract Price", "Phoenix_ProposedContractBidPriceMktng__c");
            }
            myMap.set("Proposed Indirect Contract Price", "Phoenix_Wholesaler_Diff_Price_Indirect__c");
        }
        if(template == 'Humana Indirect CII'){
            myMap.set("Indirect to Direct Rebate", "Phoenix_Net_Price_afterRebates_after_VIP__c");
        }
        myMap.set("CM Fees %", "Phoenix_Contract_Mngment_Fee_Wholesaler__c");
        myMap.set("CM Fees $", "Phoenix_CM_FEE__c");
        myMap.set("Indirect CD %", "Phoenix_Indirect_CD_Per__c");
        myMap.set("Indirect CD $", "Phoenix_INDIRECT_CD__c");
        myMap.set("Internal Dead Net", "Phoenix_Internal_Dead_Net_Price__c");
        myMap.set("TPT $ per pack", "Proposed_TPT_Direct__c");
        myMap.set("TPT % per pack", "Proposed_TPT_Per_Direct__c");
        myMap.set("Medicaid & Returns  per unit", "Phoenix_Medicaid_Returns_Per_Unit_in__c");
        myMap.set("Net Sales", "Phoenix_Net_Sales_Internal__c");
        myMap.set("Total TPT $", "Phoenix_Th_Put_Margin__c");
        myMap.set("TPT %", "Phoenix_TP_Margin__c");
        if(bidType == "New Product Launch"){
            myMap.set("Opening Order", "Phoenix_Opening_Order__c");
            myMap.set("Opening Order Net Sales", "Phoenix_Opening_Order_Net_sales__c");
            myMap.set("Opening Order TPT $", "Phoenix_Opening_Order_TPT__c");
            myMap.set("Opening Order TPT %", "Phoenix_Opening_Order_TPT_Per__c");  
        }
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
        myMap.set("Proposed as % of Budget", "Phoenix_Proposed_to_Budget__c");
        myMap.set("Latest Estimate ASP", "Phoenix_Latest_Estimate__c");
        myMap.set("Proposed as % of Latest Estimate", "Phoenix_Proposed_as_of_Latest_Estimate__c");
        myMap.set("Lowest Price /SKU", "Phoenix_Lowest_Price_SKU__c");
        myMap.set("Approved Lowest Price /SKU", "Phoenix_Approved_Lowest_Price_SKU__c");
        if(bidType != 'New Product Launch'){
            myMap.set("Total DRL Share", "Phoenix_Total_DRL_Share__c");
            myMap.set("DRL Margin %", "Phoenix_DRL_Margin_DRL__c");   
        }
        if ( bidType != 'Sales Out Rebate' && bidType != "Customer Rebate Change" && bidType != "Price Change") {
            if(bidType == "New Product Launch"){
                myMap.set("Initial Stocking Order Volume", "Phoenix_Initial_Stocking_Order_Volume__c");
                myMap.set("Initial Stocking Order Comments", "Phoenix_Initial_Stocking_Order_Comments__c");
                
                myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
                myMap.set("SCM Rejection Reason","Phoenix_SCM_Rejection_Reason1__c");
                myMap.set("Revisit Date","Phoenix_Revisited_Date__c");
                myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
                myMap.set("SCM Comments","Phoenix_SCM_Notes__c");
            }
        }
        
        myMap.set("Sales Notes", "Phoenix_Sales_Notes__c");
        if(bidType != 'Volume Review Only'){
            myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
            myMap.set("Marketing Notes", "Phoenix_Marketing_Notes__c");
            myMap.set("Marketing Lead Rx", "Phoenix_Marketing_Lead_Rx__c");
            myMap.set("Marketing Lead SRx", "Phoenix_Marketing_Lead_SRx__c");
            myMap.set("Marketing Lead OTC", "Phoenix_Marketing_Lead_OTC__c");
            myMap.set("Marketing Lead Comments", "Phoenix_Business_Head_Comments__c");
            myMap.set("Marketing Head Approval", "Phoenix_Approval__c");
            myMap.set("Marketing Head Comments", "Phoenix_Comments__c");
            
            myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
            myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
        }
        if(bidType != 'Volume Review Only'){
            myMap.set("Sr Director / VP Finance Approval", "Phoenix_Sr_Director_VP_Finance_Approval__c");
            myMap.set("Sr Director / VP Finance Comments", "Phoenix_Sr_Director_VP_Finance_Comments__c");
        }
        myMap.set("Contract Status", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        myMap.set("WAC Check", "Phoenix_WAC_Check__c");
        if(bidType == 'RFP Bids' || bidType == 'Product Addition'){
            myMap.set("IOD Qty (Rounded To MOQ)", "Phoenix_IOD_Qty__c");
        }
        myMap.set("Bid Status","Phoenix_Bid_Status__c"); 
        myMap.set("Customer Decline Reasons","Phoenix_Customer_Decline_Reasons__c");     
        
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
                    /* else if(value=='Phoenix_Estimated_Lead_Time_Days__c') {
                    var estleadtime = objectRecords[i]["Phoenix_Estimated_Lead_Time_Days__c"];
                    if(estleadtime != null){
                      csvStringResult += '"'+estleadtime+'"';
                    }
                    else{
                       csvStringResult += '"'+''+'"'; 
                    }
                 
                }*/
                        else if(value == 'Phoenix_Override_Current_Indirect_Units1__c'){
                            if(key = 'Total Override Selling Units'){
                                
                                var overRideDirect =objectRecords[i]['Phoenix_Override_Current_Indirect_Units__c'] != null ?objectRecords[i]['Phoenix_Override_Current_Direct_Units__c'] :0 ;
                                var overRideIndirect =objectRecords[i]['Phoenix_Override_Current_Direct_Units__c'] != null ?objectRecords[i]['Phoenix_Override_Current_Direct_Units__c'] :0 ;
                                
                                
                                var finalUnits = overRideDirect + overRideIndirect ;
                                
                                csvStringResult += '"'+ finalUnits +'"';
                            }
                        }
                            else if(value == 'Phoenix_12_Months_IndirectSaleUnit1__c'){
                                if(key = 'Total Last 12 Months Actuals Selling Units'){
                                    
                                    var overRideDirect =objectRecords[i]['Phoenix_12_Months_Actual_Sales__c'] != null ?objectRecords[i]['Phoenix_12_Months_Actual_Sales__c'] :0 ;
                                    var overRideIndirect =objectRecords[i]['Phoenix_12_Months_IndirectSaleUnit__c'] != null ?objectRecords[i]['Phoenix_12_Months_IndirectSaleUnit__c'] :0 ;
                                    
                                    
                                    var finalUnits = overRideDirect + overRideIndirect ;
                                    
                                    csvStringResult += '"'+ finalUnits +'"';
                                }
                            }
                                else if(value=='Phoenix_Bid__r.Phoenix_Proposed_Initial_Order_Discount__c') {
                                    if (objectRecords[i][value] == undefined) {
                                        //console.log('Iam in last ELSEE if---->');
                                        csvStringResult += '"' + '' + '"';
                                    } 
                                    else{
                                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid__r"]["Phoenix_Proposed_Initial_Order_Discount__c"]+'"';
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
                                                                                                                                        csvStringResult += '"'+ proposednetsalesindirect+'"'; 
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
                                                                                                                                            csvStringResult += '"'+ proposedtpdldirect+'"'; 
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
                                                                                                                                                csvStringResult += '"'+ proposedtpdlindirect+'"'; 
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
                                                                                                                                                    csvStringResult += '"'+ latestestimateasp+'"'; 
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
                                   component.set("v.actSalInd12months",responseValue[0].actSalInd12months);
                                   component.set("v.overRideIndirectUnits",responseValue[0].OverrideInDirUnits);
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
                                   
                                   //added by vandana.
                                   component.set("v.OpeningOrderTotal",responseValue[0].OpeningOrder);
                                   component.set("v.OpeningOrderNetSalesTotal",responseValue[0].OpeningOrderNetSales);
                                   component.set("v.OpeningOrderTPTTotal",responseValue[0].OpeningOrderTPT);
                                   /*var BlendedTPMargin = responseValue[0].netsint =! 0 ? (responseValue[0].TputMargin/responseValue[0].netsint)*100 : 0;
                component.set("v.TPMarginPercent",BlendedTPMargin);*/
                                   var opntptPerc = responseValue[0].OpeningOrderNetSales =! 0 ? (responseValue[0].OpeningOrderTPT / responseValue[0].OpeningOrderNetSales)*100 :0;
                                   component.set("v.OpeningOrderTPTPercTotal",opntptPerc);
                                   
                                   component.set("v.CurrenSalesTotal",responseValue[0].csf);
                                   component.set("v.CurrentTPMarginTotal",responseValue[0].ctpm);
                                   component.set("v.TotalDRLShareTotal",responseValue[0].tdrlsh);
                                   component.set("v.PriceVarianceTotal",responseValue[0].prv);
                                   component.set("v.VolumeVarianceTotal",responseValue[0].vlmv);
                                   component.set("v.DifferenceSalesTotal",responseValue[0].dffs);
                                   component.set("v.DifferenceMarginTotal",responseValue[0].dffm);
                                   var totalDRlMargin = responseValue[0].totalDrlShare != null ? responseValue[0].totalDrlShare : 0;
                                   console.log("totalDRlMargin---->"+totalDRlMargin)
                                   var totalASP =  responseValue[0].totalProposedASp != null ? responseValue[0].totalProposedASp : 0;
                                   console.log("totalASP---->"+totalASP)
                                   var toalMargin = totalASP > 0 ? (totalDRlMargin/totalASP)*100 : 0 ;
                                   component.set("v.totalDRlMargin",toalMargin);
                                   
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
    }
    
})