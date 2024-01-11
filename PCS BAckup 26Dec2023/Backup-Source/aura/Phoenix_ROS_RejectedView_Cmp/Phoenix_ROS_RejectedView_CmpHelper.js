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
        myMap.set("NDC","Phoenix_NDC__c");
        myMap.set("SAP Number","Phoenix_Product_Code1__c");
        myMap.set("Product Family","Product_Family_Name__c");
        myMap.set("Pkg Size","Phoenix_Pkg_Size__c");
        myMap.set("Product Name","Phoenix_Product__r.Name");
        if(isReBid == true){
            myMap.set("Previous Bid", "Phoenix_Previous_Bid__r.Name");
            myMap.set("Previous Bid Line Item", "Phoenix_Previous_LineItem__r.Name");
        }
        myMap.set("Case Pack","Phoenix_Case_Pack__c");
        myMap.set("MOQ","Phoenix_MOQ1__c");
        myMap.set("Compared to (Brand Name)","Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director","Phoenix_Product_Director__c");
        myMap.set("Orange Book rating","Phoenix_Orange_Book_Rating1__c");
        myMap.set("Throughput Cost","Phoenix_Throughput_cost__c");
        myMap.set("WAC","Phoenix_WAC__c");
        myMap.set("REMS Program","Phoenix_REMS__c");
        if(bidType != 'New Product Launch'){
            myMap.set("Current CVS/Cardinal/Major Postion","Phoenix_Current_Position__c");
        }
        myMap.set("Proposed CVS/Cardinal/Major Position","Phoenix_Proposed_Position__c");
        //myMap.set("Proposed Cardinal Position","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c");
        //myMap.set("Proposed Major Position","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c");
        if(bidType != 'New Product Launch'){
            myMap.set("3 Months Annualized CVS Direct Selling Unit","Phoenix_Current_Retail_Direct_Units__c");
            myMap.set("3 Months Annualized CVS Indirect Selling Unit","Phoenix_Current_Retail_Indirect_Units__c");
            myMap.set("3 Months Annualized Cardinal Selling Unit","Phoenix_Current_Wholesaler_Units__c");
            myMap.set("3 Months Annualized Major Selling Unit","BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c");
            myMap.set("Total 3 Months Annualized Selling Units","BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c");
            myMap.set("Actual 12 Months CVS Direct Selling Unit","Phoenix_12_Months_Actual_Sales__c");
            myMap.set("Actual 12 Months  CVS Indirect Selling Unit","Phoenix_12_Months_IndirectSaleUnit__c");
            myMap.set("Actual 12 Months  Cardinal Selling Unit","BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c");
            myMap.set("Actual 12 Months  Major Selling Unit","BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c");
            myMap.set("Actual 12 Months Total  Sales Units","BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c");
            myMap.set("Override CVS Direct  Units","Phoenix_Override_Current_Direct_Units__c");
            myMap.set("Override CVS Indirect  Units","Phoenix_Override_Current_Indirect_Units__c");
            myMap.set("Override Cardinal  Units","Phoenix_Override_Current_Units__c");
            myMap.set("Override Major  Units","BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c");
            myMap.set("Override Total Units","Phoenix_Override_Total_units__c");
            myMap.set("Doses","Phoenix_Doses__c");
        }
        if(bidType != 'Price Change' && bidType != 'Sales Out Rebate' && bidType != 'Customer Rebate Change'){
            myMap.set("Proposed CVS Direct Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c");
            myMap.set("Proposed CVS Indirect Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c");
            myMap.set("Proposed Cardinal Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c");
            myMap.set("Proposed Major Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c");
            myMap.set("Proposed Total Selling Units(Current + Increment)","Phoenix_Total_Selling_Unit__c");
            myMap.set("Final Direct Selling Units","Phoenix_Final_Direct_Selling_Units_Calc__c");
            myMap.set("Final Indirect Selling Units","Phoenix_Final_Indirect_Selling_Units_Cal__c");
            myMap.set("Final Total Selling Units","Phoenix_Final_Total_Selling_Unit__c");
            if(bidType != 'New Product Launch'){
                if(objectRecords[0].Phoenix_SCM_Final_Approval__c === true){
                    myMap.set("SCM Approved CVS Direct Units","Phoenix_Current_Anda_Units__c");
                    myMap.set("SCM Approved CVS Indirect Units","Phoenix_Current_Indirect_Gaint_EagleUnit__c");
                    myMap.set("SCM Approved Cardinal Units","Phoenix_ProposedIndirectAholdDelhaizeUni__c");
                    myMap.set("SCM Approved Major Units","Phoenix_Proposed_IndirectGaintEagleUnits__c");
                    myMap.set(" Total SCM Approved Qty","Phoenix_Total_SCM_Approved_Qty__c");
                }
                else{
                    myMap.set("SCM Approved CVS Direct Units","");
                    myMap.set("SCM Approved CVS Indirect Units","");
                    myMap.set("SCM Approved Cardinal Units","");
                    myMap.set("SCM Approved Major Units","");
                    myMap.set(" Total SCM Approved Qty","");
                }
            }
        }
        if(bidType != 'New Product Launch'){
            myMap.set("Current CVS Direct Contract Price","Phoenix_Current_Direct_Price__c");
            myMap.set("CVS Cash Terms","BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c");
            myMap.set("CVS Fees","BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c");
            myMap.set("Current Cardinal Contract Price","Phoenix_Current_Wholesaler_Price__c");
            myMap.set("Cardinal Cash Terms","BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c");
            myMap.set("Current Cardinal Rebates %","Phoenix_Current_Rebate__c");
            myMap.set("Cardinal Rebates","BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c");
            myMap.set("Current Major Contract Price","BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c");
            myMap.set("Major Cash Terms","BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c");
            myMap.set("Current Major Rebates %","Phoenix_Proposed_Current_Rebate__c");
            myMap.set("Major Rebates","BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c");
            myMap.set("Current CVS Direct Acquisition Costs","Phoenix_Current_Anda_Acquisition_Costs__c");
            myMap.set("Current Cardinal Acquisition Costs","Phoenix_Anda_Old_Acqusition_Costs__c");
            myMap.set("Current Major Acquisition Costs","BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c");
            myMap.set("Current CVS Indirect Contract Price","Phoenix_Current_Indirect_Price__c");
        }
        if(bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate'){
            myMap.set("Guidance Price/Acquisition costs","Phoenix_Guidance_Price__c");
            myMap.set("Proposed Sales CVS/Cardinal/Major Acquisition Costs/CVS Deadnet","Phoenix_ProposedContract_Bid_Price_Sales__c");
            //myMap.set("Proposed Cardinal Sales Price","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c");
            //myMap.set("Proposed Major Sales Price","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c");
        }
        if(bidType != 'New Product Launch' && bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate'){
            myMap.set("% Reduction for Acquisition Costs","Phoenix_Reduction__c");
        }//myMap.set("Proposed Marketing Price","");
        if(bidType == 'New Product Launch'){
            //myMap.set("Current Supplier for Cardinal","Phoenix_Current_Supplier__c");
            //myMap.set("Current Supplier for Major","BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c");
            myMap.set("Brand WAC","Brand_WAC__c");
            myMap.set("% Brand WAC for CVS","BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c");
            myMap.set("% Brand WAC for Cardinal","Phoenix_Brand_WAC_Per__c");
            myMap.set("% Brand WAC for Major","BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c");
        }
        if(bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate'){
            myMap.set("Proposed Marketing CVS/Cardinal/Major Acquisition Costs/CVS Deadnet","BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c");
            myMap.set("Proposed CVS Direct  Contract Price","BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c");
            myMap.set("Proposed CVS Indirect Contract Price","Phoenix_ProposedContractBidPriceMktng__c");
            myMap.set("Proposed Cardinal Contract Price ","Phoenix_Wholesaler_Diff_Price_Indirect__c");
            myMap.set("Preferred Cardinal Rebate %","BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c");
            myMap.set("Proposed Major Contract Price ","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c");
            myMap.set("Preferred Major Rebate %","BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c");
        }
        myMap.set("Cash Discount","Phoenix_Direct_CD__c");
        myMap.set("Service Fee (1.5%)","BidLineItemsExtn__r[0].Phoenix_Service_Fee__c");
        myMap.set("Internal CVS Direct Dead Net","Phoenix_Direct_Dead_Net__c");
        myMap.set("CVS Direct TPT $","Phoenix_Direct_TP_In__c");
        myMap.set("CVS Direct TPT %","Phoenix_Direct_TP__c");
        myMap.set("ZITD","BidLineItemsExtn__r[0].Phoenix_ZITD__c");
        myMap.set("CD","Phoenix_INDIRECT_CD__c");
        myMap.set("RDC Fees","Phoenix_RDC_NLC__c");
        myMap.set("CM Fees","Phoenix_Contract_Mngmnt_Fee_Wholesaler__c");
        myMap.set("Internal CVS Indirect Dead Net","Phoenix_Indirect_Dead_Net__c");
        myMap.set("CVS Indirect TPT $","Indirect_TP__c");
        myMap.set("CVS Indirect TPT %","Phoenix_Indirect_TP__c");
        myMap.set("Cash Discount on WAC","Phoenix_INDIRECT_CD__c");
        myMap.set("Cardinal Preferred Rebate $","Phoenix_Net_Price_after_Rebates_Terms__c");
        myMap.set(" NLC Fees ","Phoenix_NLC__c");
        myMap.set(" Cardinal Additional Rebate $ ","BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c");
        myMap.set(" Internal Cardinal Dead Net ","Phoenix_Customer_Dead_Net1__c");
        myMap.set(" Cardinal TPT $ ","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c");
        myMap.set(" Cardinal TPT % ","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c");
        myMap.set("Major Preferred Rebate $","Phoenix_Net_Price_after_RebatesbeforeVIP__c");
        myMap.set(" Major Additional Rebate $ ","BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c");
        myMap.set(" Internal Major Dead Net ","BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c");
        myMap.set(" Major TPT $ ","BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c");
        myMap.set(" Major TPT % ","BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c");
        if(bidType == 'RFP Bids' ||bidType == 'New Product Launch'|| bidType == 'Product Addition'){
            myMap.set(" Cardinal IOD per unit ","Phoenix_Retail_IOD_per_unit__c");
            myMap.set(" Major IOD per unit ","Phoenix_Wholesaler_IOD_per_unit__c");
            myMap.set(" Cardinal IOD overall amount $ ","Phoenix_IOD_Total_Amount__c");
            myMap.set(" Major IOD overall amount $ ","Phoenix_Wholesaler_IOD_overall_amount__c");
        }
        myMap.set(" Medicaid & Returns  per unit ","Phoenix_Estimated_Medicaid_Returns__c");
        myMap.set(" CVS Direct Net Sales ","Proposed_Net_Sales_Direct__c");
        myMap.set(" CVS Indirect Net Sales ","Proposed_Net_Sales_Indirect__c");
        myMap.set(" CVS Total Net Sales ","BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c");
        myMap.set(" CVS Direct TPT $ ","BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c");
        myMap.set(" CVS Indirect TPT $ ","BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c");
        myMap.set(" CVS Total  TPT $ ","BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c");
        myMap.set(" CVS Direct TPT % ","BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c");
        myMap.set(" CVS Indirect TPT % ","BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c");
        myMap.set(" CVS Total  TPT % ","BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c");
        if(bidType == 'New Product Launch'){
            myMap.set(" Opening Order for CVS ","BidLineItemsExtn__r[0].Opening_Order_CVS__c");
            myMap.set(" Opening Order Net Sales for CVS ","BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c");
            myMap.set(" Opening Order TPT $ for CVS ","BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c");
            myMap.set(" Opening Order TPT % for CVS ","BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c");
        }
        myMap.set(" Cardinal Net Sales ","Phoenix_Wholesaler_Net_Sales__c");
        myMap.set("Cardinal TPT $","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c");
        myMap.set("Cardinal TPT %","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c");
        if(bidType == 'New Product Launch'){
            myMap.set(" Opening Order for Cardinal ","Phoenix_Opening_Order__c");
            myMap.set(" Opening Order Net Sales for Cardinal ","Phoenix_Opening_Order_Net_sales__c");
            myMap.set(" Opening Order TPT $ for Cardinal ","Phoenix_Opening_Order_TPT__c");
            myMap.set(" Opening Order TPT % for Cardinal ","Phoenix_Opening_Order_TPT_Per__c");
        }
        myMap.set(" Major Net Sales ","BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c");
        myMap.set("Major TPT $","BidLineItemsExtn__r[0].Phoenix_Major_TPT__c");
        myMap.set("Major TPT %","BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c");
        if(bidType == 'New Product Launch'){
            myMap.set(" Opening Order for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c");
            myMap.set(" Opening Order Net Sales for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c");
            myMap.set(" Opening Order TPT $ for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c");
            myMap.set(" Opening Order TPT % for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c");
        }
        myMap.set(" Total RedOak Net Sales ","Phoenix_Net_Sales_Internal__c");
        myMap.set(" Total RedOak TPT $ ","BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c");
        myMap.set(" Total RedOak TPT % ","BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c");
        myMap.set(" Budgeted ASP ","Phoenix_Budgeted_ASP1__c");
        myMap.set(" Proposed as % of Budget ","Phoenix_Proposed_to_Budget__c");
        myMap.set(" Latest Estimate ASP ","Phoenix_Latest_Estimate__c");
        myMap.set(" Proposed as % of Latest Estimate ","Phoenix_Proposed_as_of_Latest_Estimate__c");
        myMap.set(" Lowest Price / SKU ","Phoenix_Lowest_Price_SKU__c");
        myMap.set("Approved Lowest Price /SKU","Phoenix_Approved_Lowest_Price_SKU__c");
        if(bidType != "Price Change" && bidType != "New Product Launch" && bidType != "Sales Out Rebate" && bidType != "Customer Rebate Change"){ 
            myMap.set("Initial Stocking Order Volume", "Phoenix_Initial_Stocking_Order_Volume__c");
            myMap.set("Initial Stocking Order Comments", "Phoenix_Initial_Stocking_Order_Comments__c");
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
        myMap.set(" WAC Check ","Phoenix_WAC_Check__c");
        if(bidType == 'RFP Bids' || bidType == 'New Product Launch'|| bidType == 'Product Addition'){
            myMap.set(" IOD Quantity (Runded to MOQ) ","Phoenix_IOD_Qty__c");
        }
        myMap.set("Bid Status","Phoenix_Bid_Status__c"); 
        myMap.set("Customer Decline Reasons","Phoenix_Customer_Decline_Reasons__c");
        
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
                //console.log('proposed cardinal uinits--->'+JSON.stringify(objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c))
                if(value=='Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                }
                //objectRecords[i].BidLineItemsExtn__r[0][Phoenix_Proposed_Major_Units__c]
                
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
                        else if(value=='Phoenix_Proposed_Current_Rebate__c'){
                            csvStringResult += '"'+objectRecords[i]["Phoenix_Proposed_Current_Rebate__c"]+'"';   
                        }
                            else if(value=='Phoenix_Current_Rebate__c'){
                                csvStringResult += '"'+objectRecords[i]["Phoenix_Current_Rebate__c"]+'"';   
                            }
                                else if(value=='Phoenix_Final_Direct_Selling_Units_Calc__c'){
                                    var dirunits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c != undefined ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c : 0;
                                    csvStringResult += '"'+dirunits+'"';    
                                }
                                    else if(value=='Phoenix_Final_Indirect_Selling_Units_Cal__c'){
                                        var indirUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != undefined ? 
                                            objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c : 0;
                                        var cardinalUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != undefined ? 
                                            objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c : 0;
                                        var majorUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c != undefined ? 
                                            objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c : 0;
                                        var indireTotalUnits = indirUnits + cardinalUnits + majorUnits;
                                        csvStringResult += '"'+indireTotalUnits+'"';    
                                    }
                                        else if(value=='Phoenix_Final_Total_Selling_Unit__c'){
                                            var dirunits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c != undefined ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c : 0;
                                            var indirUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != undefined ? 
                                                objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c : 0;
                                            var cardinalUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != undefined ? 
                                                objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c : 0;
                                            var majorUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c != undefined ? 
                                                objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c : 0;
                                            var totalUnits = dirunits + indirUnits + cardinalUnits + majorUnits;
                                            csvStringResult += '"'+totalUnits+'"';   
                                        }
                /*Added by Satya*/
                
                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c != undefined ) {
                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c+'"';    
                                            }
                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c != undefined) {
                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c+'"';    
                                                }
                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c != undefined) {
                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c+'"';    
                                                    }
                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c != undefined) {
                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c+'"';    
                                                        }
                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c !=undefined) {
                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c+'"';    
                                                            }
                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c != undefined) {
                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c+'"';    
                                                                }
                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c != undefined) {
                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c+'"';    
                                                                    }
                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c != undefined) {
                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c+'"';    
                                                                        }
                
                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != undefined) {
                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c+'"';    
                                                                            }
                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c != undefined) {
                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c+'"';    
                                                                                }
                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != undefined) {
                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c+'"';    
                                                                                    }
                
                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c !=undefined) {
                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c+'"';    
                                                                                        }
                                                                                            else if(value=='Phoenix_Total_Selling_Unit__c') {
                                                                                                var totalSellingUnits = (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c !=null ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c : 0) + (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != null ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c : 0) + (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != null ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c : 0) + (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c != null? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c :0);
                                                                                                csvStringResult += '"'+totalSellingUnits+'"';    
                                                                                            }
                
                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c != undefined) {
                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c+'"';    
                                                                                                }
                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c != undefined) {
                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c+'"';    
                                                                                                    }
                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c != undefined) {
                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c+'"';    
                                                                                                        }
                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c !=undefined) {
                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c+'"';    
                                                                                                            }
                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c != undefined) {
                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c+'"';    
                                                                                                                }
                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c != undefined) {
                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c+'"';    
                                                                                                                    }
                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c != undefined) {
                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c+'"';    
                                                                                                                        }
                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c != undefined) {
                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c+'"';    
                                                                                                                            }
                /*  else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c+'"';    
                    }*/
                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c != undefined) {
                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c+'"';    
                                                                                                                                }
                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c != undefined) {
                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c+'"';    
                                                                                                                                    }
                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c != undefined) {
                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c+'"';    
                                                                                                                                        }
                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c != undefined) {
                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c+'"';    
                                                                                                                                            }
                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c != undefined) {
                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c+'"';    
                                                                                                                                                }
                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c != undefined) {
                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c+'"';    
                                                                                                                                                    }
                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c != undefined) {
                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c+'"';    
                                                                                                                                                        }
                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c != undefined) {
                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c+'"';    
                                                                                                                                                            }
                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Service_Fee__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Service_Fee__c != undefined) {
                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Service_Fee__c+'"';    
                                                                                                                                                                }
                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_ZITD__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_ZITD__c != undefined) {
                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_ZITD__c+'"';    
                                                                                                                                                                    }
                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c != undefined) {
                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c+'"';    
                                                                                                                                                                        }
                                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c != undefined) {
                                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c+'"';    
                                                                                                                                                                            }
                                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c != undefined) {
                                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c+'"';    
                                                                                                                                                                                }
                                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c != undefined) {
                                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c+'"';    
                                                                                                                                                                                    }
                                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c != undefined ) {
                                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c+'"';    
                                                                                                                                                                                        }
                                                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c != undefined) {
                                                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c+'"';    
                                                                                                                                                                                            }
                                                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c != undefined) {
                                                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c+'"';    
                                                                                                                                                                                                }
                                                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c != undefined) {
                                                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c+'"';    
                                                                                                                                                                                                    }
                                                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c != undefined ) {
                                                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c+'"';    
                                                                                                                                                                                                        }
                                                                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c != undefined) {
                                                                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c+'"';    
                                                                                                                                                                                                            }
                                                                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c !=undefined ) {
                                                                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c+'"';    
                                                                                                                                                                                                                }
                                                                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c != undefined) {
                                                                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c+'"';    
                                                                                                                                                                                                                    }
                                                                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c != undefined) {
                                                                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c+'"';    
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c != undefined) {
                                                                                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c+'"';    
                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Opening_Order_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_CVS__c != undefined) {
                                                                                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_CVS__c+'"';    
                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c != undefined) {
                                                                                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c+'"';    
                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c != undefined) {
                                                                                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c+'"';    
                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c != undefined) {
                                                                                                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c+'"';    
                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c != undefined ) {
                                                                                                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c+'"';    
                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c != undefined) {
                                                                                                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c+'"';    
                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c != undefined) {
                                                                                                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c+'"';    
                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT__c != undefined) {
                                                                                                                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT__c+'"';    
                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c != undefined) {
                                                                                                                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c+'"';    
                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c != undefined ) {
                                                                                                                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c+'"';    
                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c != undefined) {
                                                                                                                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c+'"';    
                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                                            else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c != undefined) {
                                                                                                                                                                                                                                                                                csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c+'"';    
                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c != undefined) {
                                                                                                                                                                                                                                                                                    csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c+'"';    
                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                    else if(value=='BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c != undefined) {
                                                                                                                                                                                                                                                                                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c+'"';    
                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                                        else if(value=='BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c != undefined ) {
                                                                                                                                                                                                                                                                                            csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c+'"';    
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
                /* else if(value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' ||value == 'Phoenix_SCM_Approval_Y_N__c'||value == 'Phoenix_SCM_Notes__c'){
                  if(objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!='N- Not Approved'&& objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!=''){
                      console.log('scm approval status is true');
                      if(objectRecords[i][value]==undefined){
       
                       	csvStringResult += '"'+''+'"';
                    	}   
                      else{
                          csvStringResult += '"'+ objectRecords[i][value]+'"'; 
                      }
                  }
                   
                    else {
                        csvStringResult += '"'+''+'"';
                        console.log('scm approval status is false');
                    }                    
                 }*/
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
                
                /* else if(objectRecords[i].BidLineItemsExtn__r[0][value]==undefined){
                        console.log('boom');
                     	console.log('tes-->'+objectRecords[i].BidLineItemsExtn__r[0][value])
                        csvStringResult += '"'+''+'"';
                    }*/
                            else if(objectRecords[i][value]==undefined){
                                console.log('Iam in last ELSEE if---->');
                                csvStringResult += '"'+''+'"';
                            }
                
                                else{
                                    csvStringResult += '"'+ objectRecords[i][value]+'"';
                                }
                /*End by Satya*/
                
                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;     
    },
    
})