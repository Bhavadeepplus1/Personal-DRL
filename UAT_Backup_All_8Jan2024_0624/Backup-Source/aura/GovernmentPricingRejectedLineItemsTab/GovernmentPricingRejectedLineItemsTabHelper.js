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
        myMap.set("MOQ","Phoenix_MOQ1__c");        
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating1__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        myMap.set("WAC", "Phoenix_WAC__c");
        //myMap.set("IMS Market Share", "Phoenix_IMS_Market_Share__c");
        myMap.set("REMS Program", "Phoenix_REMS__c");
        if(bidType != "New Product Launch"){
            myMap.set("Current Position", "Phoenix_Current_Position__c");
        }
        myMap.set("Proposed Position", "Phoenix_Proposed_Position__c");
        if(bidType != "New Product Launch"){
            myMap.set("3 Months Annualized Total Selling Units", "Phoenix_Current_Indirect_Selling_Unit__c");
            myMap.set("Last 12 Months Actuals Selling Units", "Phoenix_12_Months_IndirectSaleUnit__c");
            myMap.set("Override Indirect Selling Units", "Phoenix_Override_Current_Units__c");
        }
        if(bidType != "Price Change" && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate"){
            if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){ 
                myMap.set("Proposed Indirect Units(Current + Increment)", "Phoenix_Proposed_Indirect_Selling_Unit__c");
            }
            else{
                myMap.set("Proposed Indirect Units", "Phoenix_Proposed_Indirect_Selling_Unit__c");  
            }
        }
        if(bidType != "Price Change" && bidType != "New Product Launch"  && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate"){
            myMap.set("Total SCM Approved Qty","Phoenix_Total_SCM_Approved_Qty__c");
        }
        if(bidType != "New Product Launch"){
            myMap.set("Current Indirect Contract Price", "Phoenix_Current_Indirect_Price__c");
        }
        myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
        myMap.set("Proposed Indirect Contract Price (Sales Price)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
        if(bidType != "New Product Launch"){
            myMap.set("% Reduction", "Phoenix_Reduction__c");
        }
        if(bidType == "New Product Launch"){
            myMap.set("Brand WAC","Brand_WAC__c");
            myMap.set("Brand WAC %","Phoenix_Brand_WAC_Per__c");
        }
        myMap.set("Proposed Indirect Contract Price (Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
        myMap.set("Indirect CD %", "Phoenix_Indirect_CD_Per__c");
        myMap.set("Indirect CD", "Phoenix_INDIRECT_CD__c");
        myMap.set("RDC %", "Phoenix_RDC_NLC__c");
        myMap.set("RDC", "Phoenix_RDC_NLC_Per_Unit_in__c");
        myMap.set("CM Fees %", "Phoenix_Contract_Mngment_Fee_Wholesaler__c");
        myMap.set("CM Fees", "Phoenix_Contract_Mngmnt_Fee_Wholesaler__c");
        var currentrebate="Phoenix_Proposed_Current_Rebate__c";
        if(currentrebate != null){
            myMap.set("Rebate %", "Phoenix_Proposed_Current_Rebate__c");
        }
        else{
            myMap.set("Rebate %", "Phoenix_Current_Rebate__c");
        }
        myMap.set("Rebate $", "Phoenix_Customer_Rebates1__c");
                myMap.set("Internal Dead Net","Phoenix_Indirect_Dead_Net__c");
        myMap.set("TPT $ Per Pack","Indirect_TP__c");
        myMap.set("TPT % Per Pack","Phoenix_Indirect_TP__c"); 
        myMap.set("Medicaid & Returns Per Unit","Phoenix_Estimated_Medicaid_Returns__c");
        myMap.set("Net Sales","Phoenix_Net_Sales_Internal__c");
        
        myMap.set("Total TPT $","Phoenix_Th_Put_Margin__c");
        myMap.set("Total TPT %","Phoenix_TP_Margin__c");
        //myMap.set("Blended TP Margin %","Phoenix_TP_Margin__c");
        if(bidType == "New Product Launch"){
            myMap.set("Opening Order","Phoenix_Opening_Order__c");
            
            myMap.set("Opening Order Net Sales","Phoenix_Opening_Order_Net_sales__c");
            myMap.set("Opening Order TPT $","Phoenix_Opening_Order_TPT__c");
            myMap.set("Opening Order TPT %","Phoenix_Opening_Order_TPT_Per__c");
            
        }
        if(bidType != "New Product Launch"){
            myMap.set("Current Dead Net Price", "Phoenix_Direct_Dead_Net__c");
            myMap.set("Current Sales", "Phoenix_Current_Sales_Finance__c");
            myMap.set("Current Th. Put Margin $$$", "Phoenix_Current_TP_Margin__c");
            myMap.set("Current TP Margin %", "Phoenix_Current_TP_MarginPercent__c");
            myMap.set("Price Variance", "Phoenix_Difference_Price__c");
            myMap.set("Volume Variance", "Phoenix_Difference_Volume__c");
            myMap.set("Difference Sales", "Phoenix_Difference_Sales__c");
            myMap.set("Difference Margin", "Phoenix_Difference_Margin__c");
        }
        
        myMap.set("Budgeted ASP","Phoenix_Budgeted_ASP1__c");
        //if(template == "ABC Progen"){
        myMap.set("Proposed as % of Budget","Phoenix_Proposed_to_Budget__c");
        myMap.set("Latest Estimate ASP","Phoenix_Latest_Estimate__c");
        myMap.set("Proposed as % of Latest Estimate","Phoenix_Proposed_as_of_Latest_Estimate__c");
        // }
        myMap.set("Lowest Price /SKU","Phoenix_Lowest_Price_SKU1__c");
        myMap.set("Approved Lowest Price /SKU","Phoenix_Approved_Lowest_Price_SKU__c");
        
        if(bidType != "Price Change" && bidType != "New Product Launch" && bidType != "Sales Out Rebate" && bidType != "Customer Rebate Change"){ 
            myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
            myMap.set("SCM Rejection Reason","Phoenix_SCM_Rejection_Reason1__c");
            myMap.set("Revisit Date","Phoenix_Revisited_Date__c");
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("SCM Comments","Phoenix_SCM_Notes__c");
        }
        if(bidType == "New Product Launch"){
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("Opening Order Comments","Phoenix_Initial_Stocking_Order_Comments__c");
        }
        myMap.set("Sales Notes","Phoenix_Sales_Notes__c");
        if(bidType != "Volume Review Only" ){
            myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
        }
        myMap.set("Marketing Notes","Phoenix_Marketing_Notes__c");
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
            myMap.set("Marketing Lead Rx", "Phoenix_Marketing_Lead_Rx__c");
            myMap.set("Marketing Lead SRx", "Phoenix_Marketing_Lead_SRx__c");
            myMap.set("Marketing Lead OTC", "Phoenix_Marketing_Lead_OTC__c");
            myMap.set("Marketing Lead Comments", "Phoenix_Business_Head_Comments__c");
            myMap.set("Marketing Head Approval", "Phoenix_Approval__c");
            myMap.set("Marketing Head Comments", "Phoenix_Comments__c");
        }
        if(bidType != "Volume Review Only" ){
            myMap.set("Finance Approval","Phoenix_Finance_Approval__c");
            myMap.set("Finance Comments","Phoenix_Finance_Comments__c");
        }
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
            myMap.set("Sr Director / VP Finance Approval", "Phoenix_Sr_Director_VP_Finance_Approval__c");
            myMap.set("Sr Director / VP Finance Comments", "Phoenix_Sr_Director_VP_Finance_Comments__c");
        }
        myMap.set("Contract Status","Phoenix_Contract_Approval__c"); 
        myMap.set("Contract Comments","Phoenix_Contract_Comments__c");
        myMap.set("WAC Check","Phoenix_WAC_Check__c");
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
                    } else if(value=='Product_Family_Name__c' && objectRecords[i]["Product_Family_Name__c"] == null){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Product_Family__c"]+'"';
                    } 
                    else if(value == 'Brand_WAC__c'){
                        var cmfeeperunit = objectRecords[i]['Brand_WAC__c'];
                        // console.log("cmfeeperunit--->"+cmfeeperunit);
                        if(cmfeeperunit != null){
                            var roundecmfeeperunit=Math.round((cmfeeperunit ) * 100) / 100
                            csvStringResult += '"'+roundecmfeeperunit+'"';  
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }       
                    }
                        else if(value == 'Phoenix_Brand_WAC_Per__c'){
                            var cmfeeperunit = objectRecords[i]['Phoenix_Brand_WAC_Per__c'];
                            // console.log("cmfeeperunit--->"+cmfeeperunit);
                            if(cmfeeperunit != null){
                                var roundecmfeeperunit=Math.round((cmfeeperunit ) * 100) / 100
                                csvStringResult += '"'+roundecmfeeperunit+'"';  
                            }
                            else{
                                csvStringResult += '"'+''+'"';
                            }       
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
                                        else if(value=='Phoenix_Proposed_Per_Unit_Rebate__c'){
                                            var rebatevalue=objectRecords[i]["Phoenix_Proposed_Per_Unit_Rebate__c"];
                                            if(rebatevalue != null){
                                                var round_two_digits=Math.round((rebatevalue  ) * 100) / 100;
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
                                                    var rounde_internaldeadnetprice=Math.round((internaldeadnetprice  )* 100) / 100
                                                    console.log("rounded internaldeadnetprice--->"+internaldeadnetprice);
                                                    csvStringResult += '"'+rounde_internaldeadnetprice+'"'; 
                                                }
                                                else{
                                                    csvStringResult += '"'+''+'"';
                                                }      
                                            }
                    
                    //by sai krishna
                                                else if(value == 'Phoenix_Override_Current_Indirect_Units__c'){
                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Override_Current_Indirect_Units__c'];
                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                    if(VIPPerUnitdl != null){
                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                        csvStringResult += '"'+roundevipperudl+'"';  
                                                    }
                                                    else{
                                                        csvStringResult += '"'+''+'"';
                                                    }
                                                }
                    
                                                    else if(value == 'Phoenix_Override_Current_Units__c'){
                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_Override_Current_Units__c'];
                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                        if(VIPPerUnitdl != null){
                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                            csvStringResult += '"'+ Math.trunc(roundevipperudl)+'"';  
                                                        }
                                                        else{
                                                            csvStringResult += '"'+''+'"';
                                                        }}
                                                        else if(value == 'Phoenix_Guidance_Price__c'){
                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Guidance_Price__c'];
                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                            if(VIPPerUnitdl != null){
                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                csvStringResult += '"'+roundevipperudl+'"';  
                                                            }
                                                            else{
                                                                csvStringResult += '"'+''+'"';
                                                            }
                                                        } 
                                                            else if(value == 'Phoenix_ProposedContract_Bid_Price_Sales__c'){
                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_ProposedContract_Bid_Price_Sales__c'];
                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                if(VIPPerUnitdl != null){
                                                                    var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                    csvStringResult += '"'+roundevipperudl+'"';  
                                                                }
                                                                else{
                                                                    csvStringResult += '"'+''+'"';
                                                                }}
                                                                else if(value == 'Phoenix_Reduction__c'){
                                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Reduction__c'];
                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                    if(VIPPerUnitdl != null){
                                                                        var roundevipperudl=parseFloat(VIPPerUnitdl).toFixed(2);
                                                                        //var myNumberWithTwoDecimalPlaces=parseFloat(myNumber).toFixed(2);
                                                                        csvStringResult += '"'+roundevipperudl+'"';  
                                                                    }
                                                                    else{
                                                                        csvStringResult += '"'+''+'"';
                                                                    }
                                                                } 
                    
                    
                                                                    else if(value == 'Phoenix_ProposedContractBidPriceMktng__c'){
                                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_ProposedContractBidPriceMktng__c'];
                                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                        if(VIPPerUnitdl != null){
                                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                            csvStringResult += '"'+roundevipperudl+'"';  
                                                                        }
                                                                        else{
                                                                            csvStringResult += '"'+''+'"';
                                                                        }}
                                                                        else if(value == 'Phoenix_Wholesaler_Diff_Price_Indirect__c'){
                                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Wholesaler_Diff_Price_Indirect__c'];
                                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                            if(VIPPerUnitdl != null){
                                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                csvStringResult += '"'+roundevipperudl+'"';  
                                                                            }
                                                                            else{
                                                                                csvStringResult += '"'+''+'"';
                                                                            }
                                                                        } 
                                                                            else if(value == 'Phoenix_Customer_Dead_Net1__c'){
                                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Customer_Dead_Net1__c'];
                                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                if(VIPPerUnitdl != null){
                                                                                    var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                    csvStringResult += '"'+roundevipperudl+'"';  
                                                                                }
                                                                                else{
                                                                                    csvStringResult += '"'+''+'"';
                                                                                }}
                                                                                else if(value == 'Phoenix_Direct_CD_Per_Unit__c'){
                                                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Direct_CD_Per_Unit__c'];
                                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                    if(VIPPerUnitdl != null){
                                                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                        csvStringResult += '"'+roundevipperudl+'"';  
                                                                                    }
                                                                                    else{
                                                                                        csvStringResult += '"'+''+'"';
                                                                                    }
                                                                                } 
                                                                                    else if(value == 'Phoenix_INDIRECT_CD__c'){
                                                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_INDIRECT_CD__c'];
                                                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                        if(VIPPerUnitdl != null){
                                                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                            csvStringResult += '"'+roundevipperudl+'"';  
                                                                                        }
                                                                                        else{
                                                                                            csvStringResult += '"'+''+'"';
                                                                                        }
                                                                                    }
                    
                                                                                        else if(value == 'Phoenix_Contract_Mngmnt_Fee_Wholesaler__c'){
                                                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Contract_Mngmnt_Fee_Wholesaler__c'];
                                                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                            if(VIPPerUnitdl != null){
                                                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                csvStringResult += '"'+roundevipperudl+'"';  
                                                                                            }
                                                                                            else{
                                                                                                csvStringResult += '"'+''+'"';
                                                                                            }}
                                                                                            else if(value == 'Phoenix_Proposed_Per_Unit_Rebate__c'){
                                                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Proposed_Per_Unit_Rebate__c'];
                                                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                if(VIPPerUnitdl != null){
                                                                                                    var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                    csvStringResult += '"'+roundevipperudl+'"';  
                                                                                                }
                                                                                                else{
                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                }}
                                                                                                else if(value == 'Phoenix_Indirect_Dead_Net__c'){
                                                                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                                                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                    if(VIPPerUnitdl != null){
                                                                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                        csvStringResult += '"'+roundevipperudl+'"';  
                                                                                                    }
                                                                                                    else{
                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                    }}
                    
                                                                                                    else if(value == 'Indirect_TP__c'){
                                                                                                        var VIPPerUnitdl = objectRecords[i]['Indirect_TP__c'];
                                                                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                        if(VIPPerUnitdl != null){
                                                                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                            csvStringResult += '"'+ roundevipperudl+'"';  
                                                                                                        }
                                                                                                        else{
                                                                                                            csvStringResult += '"'+''+'"';
                                                                                                        }}
                                                                                                        else if(value == 'Phoenix_Estimated_Medicaid_Returns__c'){
                                                                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Estimated_Medicaid_Returns__c'];
                                                                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                            if(VIPPerUnitdl != null){
                                                                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                                csvStringResult += '"'+ roundevipperudl+'"';  
                                                                                                            }
                                                                                                            else{
                                                                                                                csvStringResult += '"'+''+'"';
                                                                                                            }}
                                                                                                            else if(value == 'Phoenix_Net_Sales_Internal__c'){
                                                                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Net_Sales_Internal__c'];
                                                                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                                if(VIPPerUnitdl != null){
                                                                                                                    var roundevipperudl=Math.round((VIPPerUnitdl) * 100) / 100
                                                                                                                    roundevipperudl.toFixed(2);
                                                                                                                    var b=Math.round(VIPPerUnitdl)
                                                                                                                    csvStringResult += '"'+ Math.trunc(b)+'"';  
                                                                                                                }
                                                                                                                else{
                                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                                }}
                                                                                                                else if(value == 'Phoenix_Wholesaler_Diff_Price_Indirect__c'){
                                                                                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Wholesaler_Diff_Price_Indirect__c'];
                                                                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                                    if(VIPPerUnitdl != null){
                                                                                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                                        csvStringResult += '"'+ roundevipperudl+'"';  
                                                                                                                    }
                                                                                                                    else{
                                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                                    }}
                                                                                                                    else if(value == 'Phoenix_ProposedContractBidPriceMktng__c'){
                                                                                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_ProposedContractBidPriceMktng__c'];
                                                                                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                                        if(VIPPerUnitdl != null){
                                                                                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                                            csvStringResult += '"'+ roundevipperudl+'"';  
                                                                                                                        }
                                                                                                                        else{
                                                                                                                            csvStringResult += '"'+''+'"';
                                                                                                                        }}
                    //upto here
                                                                                                                        else if(value == 'Phoenix_Direct_Dead_Net__c'){
                                                                                                                            var currentdeadnetprice = objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                                                                                                                            console.log("currentdeadnetprice--->"+currentdeadnetprice);
                                                                                                                            if(currentdeadnetprice != null){
                                                                                                                                var rounde_currentdeadnetprice=Math.round((currentdeadnetprice  )* 100) / 100
                                                                                                                                console.log("rounded rounde_currentdeadnetprice--->"+rounde_currentdeadnetprice);
                                                                                                                                csvStringResult += '"'+rounde_currentdeadnetprice+'"'; 
                                                                                                                            }
                                                                                                                            else{
                                                                                                                                csvStringResult += '"'+''+'"';
                                                                                                                            }          
                                                                                                                        }
                        else if(value == 'Phoenix_Latest_Estimate__c'){
                            var latest_estimate=objectRecords[i]['Phoenix_Latest_Estimate__c'];
                            if(latest_estimate != null){
                                var rounded_le=Math.round((latest_estimate  ) * 100) / 100
                                console.log('rounded value-->'+rounded_le);
                                csvStringResult += '"'+ rounded_le +'"';
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
                                else if(value == 'Phoenix_Proposed_TP_Margin__c'){
                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Proposed_TP_Margin__c'];
                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                    if(VIPPerUnitdl != null){
                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                        csvStringResult += '"'+roundevipperudl+'"';  
                                    }
                                    else{
                                        csvStringResult += '"'+''+'"';
                                    }
                                }
                //rebate $, RDC $
                                    else if(value == 'Phoenix_RDC_NLC_Per_Unit_in__c'){
                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_RDC_NLC_Per_Unit_in__c'];
                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                        if(VIPPerUnitdl != null){
                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                            csvStringResult += '"'+roundevipperudl+'"';  
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }
                                    }
                                        else if(value == 'Phoenix_Rebate_Perc_In__c'){
                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Rebate_Perc_In__c'];
                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                            if(VIPPerUnitdl != null){
                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                csvStringResult += '"'+roundevipperudl+'"';  
                                            }
                                            else{
                                                csvStringResult += '"'+''+'"';
                                            }
                                        }
                //
                
                                            else if(value == 'Phoenix_Override_Current_Indirect_Units__c'){
                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Override_Current_Indirect_Units__c'];
                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                if(VIPPerUnitdl != null){
                                                    var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                    csvStringResult += '"'+roundevipperudl+'"';  
                                                }
                                                else{
                                                    csvStringResult += '"'+''+'"';
                                                }
                                            }
                
                                                else if(value == 'Phoenix_Override_Current_Units__c'){
                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_Override_Current_Units__c'];
                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                    if(VIPPerUnitdl != null){
                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                        csvStringResult += '"'+ Math.trunc(roundevipperudl)+'"';  
                                                    }
                                                    else{
                                                        csvStringResult += '"'+''+'"';
                                                    }}
                                                    else if(value == 'Phoenix_Guidance_Price__c'){
                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_Guidance_Price__c'];
                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                        if(VIPPerUnitdl != null){
                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                            csvStringResult += '"'+roundevipperudl+'"';  
                                                        }
                                                        else{
                                                            csvStringResult += '"'+''+'"';
                                                        }
                                                    } 
                                                        else if(value == 'Phoenix_ProposedContract_Bid_Price_Sales__c'){
                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_ProposedContract_Bid_Price_Sales__c'];
                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                            if(VIPPerUnitdl != null){
                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                csvStringResult += '"'+roundevipperudl+'"';  
                                                            }
                                                            else{
                                                                csvStringResult += '"'+''+'"';
                                                            }}
                                                            else if(value == 'Phoenix_Reduction__c'){
                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Reduction__c'];
                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                if(VIPPerUnitdl != null){
                                                                    var roundevipperudl=parseFloat(VIPPerUnitdl).toFixed(2);
                                                                    //var myNumberWithTwoDecimalPlaces=parseFloat(myNumber).toFixed(2);
                                                                    csvStringResult += '"'+roundevipperudl+'"';  
                                                                }
                                                                else{
                                                                    csvStringResult += '"'+''+'"';
                                                                }
                                                            } 
                
                
                                                                else if(value == 'Phoenix_ProposedContractBidPriceMktng__c'){
                                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_ProposedContractBidPriceMktng__c'];
                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                    if(VIPPerUnitdl != null){
                                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                        csvStringResult += '"'+roundevipperudl+'"';  
                                                                    }
                                                                    else{
                                                                        csvStringResult += '"'+''+'"';
                                                                    }}
                                                                    else if(value == 'Phoenix_Wholesaler_Diff_Price_Indirect__c'){
                                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_Wholesaler_Diff_Price_Indirect__c'];
                                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                        if(VIPPerUnitdl != null){
                                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                            csvStringResult += '"'+roundevipperudl+'"';  
                                                                        }
                                                                        else{
                                                                            csvStringResult += '"'+''+'"';
                                                                        }
                                                                    } 
                                                                        else if(value == 'Phoenix_Customer_Dead_Net1__c'){
                                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Customer_Dead_Net1__c'];
                                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                            if(VIPPerUnitdl != null){
                                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                csvStringResult += '"'+roundevipperudl+'"';  
                                                                            }
                                                                            else{
                                                                                csvStringResult += '"'+''+'"';
                                                                            }}
                                                                            else if(value == 'Phoenix_Direct_CD_Per_Unit__c'){
                                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Direct_CD_Per_Unit__c'];
                                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                if(VIPPerUnitdl != null){
                                                                                    var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                    csvStringResult += '"'+roundevipperudl+'"';  
                                                                                }
                                                                                else{
                                                                                    csvStringResult += '"'+''+'"';
                                                                                }
                                                                            } 
                                                                                else if(value == 'Phoenix_INDIRECT_CD__c'){
                                                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_INDIRECT_CD__c'];
                                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                    if(VIPPerUnitdl != null){
                                                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                        csvStringResult += '"'+roundevipperudl+'"';  
                                                                                    }
                                                                                    else{
                                                                                        csvStringResult += '"'+''+'"';
                                                                                    }
                                                                                }
                
                                                                                    else if(value == 'Phoenix_Contract_Mngmnt_Fee_Wholesaler__c'){
                                                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_Contract_Mngmnt_Fee_Wholesaler__c'];
                                                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                        if(VIPPerUnitdl != null){
                                                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                            csvStringResult += '"'+roundevipperudl+'"';  
                                                                                        }
                                                                                        else{
                                                                                            csvStringResult += '"'+''+'"';
                                                                                        }}
                                                                                        else if(value == 'Phoenix_Proposed_Per_Unit_Rebate__c'){
                                                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Proposed_Per_Unit_Rebate__c'];
                                                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                            if(VIPPerUnitdl != null){
                                                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                csvStringResult += '"'+roundevipperudl+'"';  
                                                                                            }
                                                                                            else{
                                                                                                csvStringResult += '"'+''+'"';
                                                                                            }}
                                                                                            else if(value == 'Phoenix_Indirect_Dead_Net__c'){
                                                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                                                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                if(VIPPerUnitdl != null){
                                                                                                    var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                    csvStringResult += '"'+roundevipperudl+'"';  
                                                                                                }
                                                                                                else{
                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                }}
                
                                                                                                else if(value == 'Indirect_TP__c'){
                                                                                                    var VIPPerUnitdl = objectRecords[i]['Indirect_TP__c'];
                                                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                    if(VIPPerUnitdl != null){
                                                                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                        csvStringResult += '"'+ (roundevipperudl)+'"';  
                                                                                                    }
                                                                                                    else{
                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                    }}
                                                                                                    else if(value == 'Phoenix_Estimated_Medicaid_Returns__c'){
                                                                                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_Estimated_Medicaid_Returns__c'];
                                                                                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                        if(VIPPerUnitdl != null){
                                                                                                            var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                            csvStringResult += '"'+ roundevipperudl+'"';  
                                                                                                        }
                                                                                                        else{
                                                                                                            csvStringResult += '"'+''+'"';
                                                                                                        }}
                                                                                                        else if(value == 'Phoenix_Net_Sales_Internal__c'){
                                                                                                            var VIPPerUnitdl = objectRecords[i]['Phoenix_Net_Sales_Internal__c'];
                                                                                                            // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                            if(VIPPerUnitdl != null){
                                                                                                                var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                                csvStringResult += '"'+Math.round (roundevipperudl)+'"';  
                                                                                                            }
                                                                                                            else{
                                                                                                                csvStringResult += '"'+''+'"';
                                                                                                            }}
                
                                                                                                            else if(value == 'Phoenix_Wholesaler_Diff_Price_Indirect__c'){
                                                                                                                var VIPPerUnitdl = objectRecords[i]['Phoenix_Wholesaler_Diff_Price_Indirect__c'];
                                                                                                                // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                                if(VIPPerUnitdl != null){
                                                                                                                    var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                                    csvStringResult += '"'+ roundevipperudl+'"';  
                                                                                                                }
                                                                                                                else{
                                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                                }}
                                                                                                                else if(value == 'Phoenix_ProposedContractBidPriceMktng__c'){
                                                                                                                    var VIPPerUnitdl = objectRecords[i]['Phoenix_ProposedContractBidPriceMktng__c'];
                                                                                                                    // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                                                                                                    if(VIPPerUnitdl != null){
                                                                                                                        var roundevipperudl=Math.round((VIPPerUnitdl  ) * 100) / 100
                                                                                                                        csvStringResult += '"'+ roundevipperudl+'"';  
                                                                                                                    }
                                                                                                                    else{
                                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                                    }}
                
                                                                                                                    else if(value == 'Brand_WAC__c'){
                                                                                                                        var cmfeeperunit = objectRecords[i]['Brand_WAC__c'];
                                                                                                                        // console.log("cmfeeperunit--->"+cmfeeperunit);
                                                                                                                        if(cmfeeperunit != null){
                                                                                                                            var roundecmfeeperunit=Math.round((cmfeeperunit ) * 100) / 100
                                                                                                                            csvStringResult += '"'+roundecmfeeperunit+'"';  
                                                                                                                        }
                                                                                                                        else{
                                                                                                                            csvStringResult += '"'+''+'"';
                                                                                                                        }       
                                                                                                                    }
                                                                                                                        else if(value == 'Phoenix_Brand_WAC_Per__c'){
                                                                                                                            var cmfeeperunit = objectRecords[i]['Phoenix_Brand_WAC_Per__c'];
                                                                                                                            // console.log("cmfeeperunit--->"+cmfeeperunit);
                                                                                                                            if(cmfeeperunit != null){
                                                                                                                                var roundecmfeeperunit=Math.round((cmfeeperunit ) * 100) / 100
                                                                                                                                csvStringResult += '"'+roundecmfeeperunit+'"';  
                                                                                                                            }
                                                                                                                            else{
                                                                                                                                csvStringResult += '"'+''+'"';
                                                                                                                            }       
                                                                                                                        }
                                                                                                                            else if(value == 'Phoenix_Total_SCM_Approved_Qty__c'){
                                                                                                                                if(objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!='N- Not Approved'&& objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!='')
                                                                                                                                {
                                                                                                                                    var cmfeeperunit = objectRecords[i]['Phoenix_Total_SCM_Approved_Qty__c'];
                                                                                                                                    // console.log("cmfeeperunit--->"+cmfeeperunit);
                                                                                                                                    if(cmfeeperunit != null){
                                                                                                                                        var roundecmfeeperunit=Math.round((cmfeeperunit ) * 100) / 100
                                                                                                                                        csvStringResult += '"'+roundecmfeeperunit+'"';  
                                                                                                                                    }
                                                                                                                                    else{
                                                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                                                    }
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
})