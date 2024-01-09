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
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
        myMap.set("Product Family", "Phoenix_Product_Family__c");
        /* if(isReBid == true){
           myMap.set("Previous Bid", "Phoenix_Previous_Bid__r.Name");
        myMap.set("Previous Bid Line Item", "Phoenix_Previous_LineItem__r.Name");
       }*/
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        if(bidType != "New Product Launch"){
            myMap.set("3 Months Annualized CVS Direct Selling Unit", "Phoenix_Current_Retail_Indirect_Units__c");
            myMap.set("3 Months Annualized CVS Indirect Selling Unit","Phoenix_Current_Retail_Indirect_Units__c");
            myMap.set("3 Months Annualized Cardinal Selling Unit","Phoenix_Current_Wholesaler_Units__c");
            myMap.set("3 Months Annualized Major Selling Unit","BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c");
            myMap.set("Override CVS Direct Units","Phoenix_Override_Current_Direct_Units__c");
            myMap.set("Override CVS Indirect Units","Phoenix_Override_Current_Indirect_Units__c");
            myMap.set("Override Cardinal Units","Phoenix_Override_Current_Units__c");
            myMap.set("Override Major  Units","BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c");
        }
        myMap.set("Proposed CVS Direct Units","Phoenix_Proposed_Direct_Selling_Unit__c");
        myMap.set("Proposed CVS Indirect Units","Phoenix_Proposed_Indirect_Selling_Unit__c");
        myMap.set("Proposed Cardinal Units","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c");
        myMap.set("Proposed Major Units","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c");
        if(bidType != "New Product Launch"){
            myMap.set("Current CVS Direct Contract Price","Phoenix_Current_Direct_Price__c");
            myMap.set("Current Cardinal Contract Price","Phoenix_Current_Wholesaler_Price__c");
            myMap.set("Current Major Contract Price","BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c");
            //myMap.set("Current Major Contract Price","BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c");
            myMap.set("Current CVS Indirect Contract Price","Phoenix_Current_Indirect_Price__c");
        }
        myMap.set("Guidance Price/Acquisition costs","Phoenix_Guidance_Price__c");
        myMap.set("Proposed Sales CVS/Cardinal/Major Acquisition Costs/CVS Deadnet","Phoenix_ProposedContract_Bid_Price_Sales__c");
        //myMap.set("Proposed Cardinal Sales Price","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c");
        // myMap.set("Proposed Major Sales Price","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c");
        myMap.set("Proposed Marketing CVS/Cardinal/Major Acquisition Costs/CVS Deadnet","BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c");
        myMap.set("Proposed CVS Direct  Contract Price","BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c");
        myMap.set("Proposed CVS Indirect Contract Price","Phoenix_ProposedContractBidPriceMktng__c");
        myMap.set("Proposed Cardinal Contract Price","Phoenix_Wholesaler_Diff_Price_Indirect__c");
        myMap.set("Proposed Major Contract Price","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c");
        myMap.set("Internal CVS Direct Dead Net","Phoenix_Direct_Dead_Net__c");
        myMap.set("Internal CVS Indirect Dead Net","Phoenix_Indirect_Dead_Net__c");
        myMap.set("Internal Cardinal Dead Net","Phoenix_Customer_Dead_Net1__c");
        myMap.set("Internal Major Dead Net","BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c");
        myMap.set("CVS Total Net Sales","BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c");
        myMap.set("CVS Total  TPT $","BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c");
        myMap.set("CVS Total  TPT %","BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c");
        myMap.set("Cardinal Net Sales","Phoenix_Wholesaler_Net_Sales__c");
        myMap.set("Cardinal TPT $","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c");
        myMap.set("Cardinal TPT %","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c");
        myMap.set("Major Net Sales","BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c");
        myMap.set("Major TPT $","BidLineItemsExtn__r[0].Phoenix_Major_TPT__c");
        myMap.set("Major TPT %","BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c");
        myMap.set("Total RedOak Net Sales","Phoenix_Net_Sales_Internal__c");
        myMap.set("Total RedOak TPT $","BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c");
        myMap.set("Total RedOak TPT %","BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c");
        /* 
        if(bidType != "New Product Launch"){
        myMap.set("Current Sales", "Phoenix_Current_Sales_Finance__c");
        myMap.set("Current Th. Put Margin $$$", "Phoenix_Current_TP_Margin__c");
        myMap.set("Current TP Margin %", "Phoenix_TP_Margin__c");
        myMap.set("Price Variance", "Phoenix_Difference_Price__c");
        myMap.set("Volume Variance", "Phoenix_Difference_Volume__c");
        myMap.set("Difference Sales", "Phoenix_Difference_Sales__c");
        myMap.set("Difference Margin", "Phoenix_Difference_Margin__c");
        }*/
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
       if(bidType != "Price Change" && bidType != "New Product Launch" && bidType != "Sales Out Rebate" && bidType != "Customer Rebate Change"){ 
            myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
            myMap.set("SCM Rejection Reason","Phoenix_SCM_Rejection_Reason1__c");
            myMap.set("Revisit Date","Phoenix_Revisited_Date__c");
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("SCM Comments","Phoenix_SCM_Notes__c");
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
                    /* Added by satya*/
                            else if(value=='BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c != undefined ) {
                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c+'"';    
                            }
                                else if(value=='BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c != undefined ) {
                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c+'"';    
                                }
                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c != undefined ) {
                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c+'"';    
                                    }
                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != undefined ) {
                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c+'"';    
                                        }
                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != undefined ) {
                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c+'"';    
                                            }
                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c != undefined ) {
                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c+'"';    
                                                }
                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c != undefined ) {
                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c+'"';    
                                                    }
                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Indirect_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Indirect_Price__c != undefined ) {
                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Indirect_Price__c+'"';    
                                                        }
                    /* else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c+'"';    
                    }
                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c+'"';    
                    }*/
                        else if(value=='BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c != undefined ) {
                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c+'"';    
                        }
                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c != undefined ) {
                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c+'"';    
                            }
                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c != undefined ) {
                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c+'"';    
                                }
                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c != undefined ) {
                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c+'"';    
                                    }
                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c != undefined ) {
                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c+'"';    
                                        }
                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c != undefined ) {
                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c+'"';    
                                            }
                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c != undefined ) {
                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c+'"';    
                                                }
                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c != undefined ) {
                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c+'"';    
                                                    }
                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c != undefined ) {
                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c+'"';    
                                                        }
                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c != undefined ) {
                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c+'"';    
                                                            }
                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c != undefined ) {
                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c+'"';    
                                                                }
                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT__c != undefined ) {
                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT__c+'"';    
                                                                    }
                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c != undefined ) {
                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c+'"';    
                                                                        }
                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c != undefined ) {
                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c+'"';    
                                                                            }
                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c != undefined ) {
                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c+'"';    
                                                                                }
                                                                                    else if(value == 'Phoenix_Direct_Dead_Net__c'){
                                                                                        var InCvDirDeadNet = objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                                                                                        if(InCvDirDeadNet != null){
                                                                                            var rounded_val = Math.round((InCvDirDeadNet) * 100) / 100;
                                                                                            csvStringResult += '"'+rounded_val+'"';    
                                                                                        }else{
                                                                                            csvStringResult += '"'+''+'"';    
                                                                                            
                                                                                        }          
                                                                                    }
                    /* End by satya*/
                    
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
                                                                                                            var round_two_digits=Math.round((rebatevalue + Number.EPSILON) * 100) / 100;
                                                                                                            csvStringResult += '"'+round_two_digits+'"';
                                                                                                        }
                                                                                                        else{
                                                                                                            csvStringResult += '"'+''+'"';
                                                                                                        } 
                                                                                                    }
                                                                                                        else if(value == 'Phoenix_Indirect_Dead_Net__c'){
                                                                                                            var internaldeadnetprice = objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                                                                                                            console.log("internaldeadnetprice--->"+internaldeadnetprice);
                                                                                                            if(internaldeadnetprice != null){
                                                                                                                var rounde_internaldeadnetprice=Math.round((internaldeadnetprice)* 100) / 100;
                                                                                                                console.log("rounded internaldeadnetprice--->"+rounde_internaldeadnetprice);
                                                                                                                csvStringResult += '"'+rounde_internaldeadnetprice+'"'; 
                                                                                                            }
                                                                                                            else{
                                                                                                                csvStringResult += '"'+''+'"';
                                                                                                            }      
                                                                                                        }
                                                                                                            else if(value == 'Phoenix_Direct_Dead_Net__c'){
                                                                                                                var currentdeadnetprice = objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                                                                                                                console.log("currentdeadnetprice--->"+currentdeadnetprice);
                                                                                                                if(currentdeadnetprice != null){
                                                                                                                    var rounde_currentdeadnetprice=Math.round((currentdeadnetprice + Number.EPSILON)* 100) / 100;
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
    
})