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
        myMap.set("SAP Number", 'Phoenix_Product_Code1__c');
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
        myMap.set("WAC", "Phoenix_WAC__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        if(bidType != "New Product Launch"){
            myMap.set("Current Position", "Phoenix_Current_Position__c");
        }
        myMap.set("Proposed Position", "Phoenix_Proposed_Position__c");
        if(bidType != "New Product Launch"){
            myMap.set("12 Months Actual Sales Unit", "Phoenix_12_Months_Actual_Sales__c");
            myMap.set("Doses", "Phoenix_Doses__c");
            myMap.set("Current Wholesaler Units", "Phoenix_Current_Wholesaler_Units__c");
            myMap.set("Current Anda Units", "Phoenix_Current_Anda_Units__c");
            myMap.set("Current Retail Direct Units", "Phoenix_Current_Retail_Direct_Units__c");
            myMap.set("Current Retail Indirect Units", "Phoenix_Current_Retail_Indirect_Units__c");
            myMap.set("Override Current Direct Units", "Phoenix_Override_Current_Direct_Units__c");
            myMap.set("Override Current Indirect Units", "Phoenix_Override_Current_Indirect_Units__c");
            myMap.set("Total RxSS Direct Selling Units", "Phoenix_Current_Direct_Selling_Unit__c");
            myMap.set("Total RxSS Indirect Selling Units", "Phoenix_Current_Indirect_Selling_Unit__c");
            myMap.set("Total RxSS Selling Units", "Phoenix_Total_Selling_Unit__c");
        }
        if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "Volume Review Only" || bidType == "New Product Launch" ){
            if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){
                myMap.set("Proposed Smith Drug Units (Current + Increment)", "Phoenix_Proposed_Smith_Drug_Units__c");
                myMap.set("Proposed Anda Units (Current + Increment)", "Phoenix_Proposed_Anda_Units__c");
                myMap.set("Proposed Direct Ahold/Delhaize Units (Current + Increment)", "Phoenix_ProposedDirectAholdDelhaizeUnits__c");
                myMap.set("Proposed Direct Gaint Eagle Units (Current + Increment)" , "Phoenix_ProposedDirectGaintEagleUnits__c");
            }
            else{
                myMap.set("Proposed Smith Drug Units", "Phoenix_Proposed_Smith_Drug_Units__c");
                myMap.set("Proposed Anda Units", "Phoenix_Proposed_Anda_Units__c");
                myMap.set("Proposed Direct Ahold/Delhaize Units", "Phoenix_ProposedDirectAholdDelhaizeUnits__c");
                myMap.set("Proposed Direct Gaint Eagle Units", "Phoenix_ProposedDirectGaintEagleUnits__c");
                
            }
            myMap.set("Proposed Total Retail Indirect Units", "Phoenix_ProposedIndirectAholdDelhaizeUni__c");
            myMap.set("Other Direct Units", "Phoenix_Others_Direct__c");
            myMap.set("Other Indirect Units", "Phoenix_Others_Indirect__c");
            myMap.set("Total Direct Selling Units", "Phoenix_Final_Direct_Selling_Units_Calc__c");
            myMap.set("Total Indirect Selling Units", "Phoenix_Final_Indirect_Selling_Units_Cal__c");
            myMap.set("Proposed Total Selling Units", "Phoenix_Final_Total_Selling_Unit__c");
            if(bidType != "New Product Launch"){
                myMap.set("Smith SCM Approved Qty", "Phoenix_IDN_Usage__c");
                myMap.set("Anda SCM Approved Qty", "Phoenix_Days_Notice_Product_Discontinuat__c");
                myMap.set("Direct Ahold/Delhaize SCM Approved Qty", "Phoenix_Day_s_Notice_Product_removal__c");
                myMap.set("Direct Gaint Eagle SCM Approved Qty", "Phoenix_Current_Indirect_Gaint_EagleUnit__c");
                myMap.set("Retail Indirect SCM Approved Qty", "Phoenix_Proposed_IndirectGaintEagleUnits__c");
                myMap.set("Total SCM Approved Qty", "Phoenix_Total_SCM_Approved_Qty__c");
            }
        }
        if(bidType != "New Product Launch"){
            myMap.set("Current Retail Direct Price", "Phoenix_Current_Retail_Direct_Price__c");
            myMap.set("Current Retail Indirect Net", "Phoenix_Current_Retail_Indirect_Net__c");
            myMap.set("Current Retail Indirect Price", "Phoenix_Current_Retail_Indirect_Price__c");
            myMap.set("Current Wholesaler Price", "Phoenix_Current_Wholesaler_Price__c");
            myMap.set("Current Anda Invoice Price", "Phoenix_Current_Anda_Invoice_Price__c");
            myMap.set("Current Anda CP Price", "Phoenix_Current_Anda_CP_Price__c");
            myMap.set("Current Anda Acquisition Costs", "Phoenix_Current_Anda_Acquisition_Costs__c");
        }
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
            myMap.set("Retail Direct Guidance Price(Sales)", "Phoenix_Retail_Direct_Guidance_Price__c");
            myMap.set("Wholesaler Guidance Price(Sales)", "Phoenix_Wholesaler_Guidance_Price__c");
            myMap.set("Retail Direct Sales Price(Sales)", "Phoenix_Retail_Direct_Sales_Price__c");
            myMap.set("Wholesaler Sales Price(Sales)", "Phoenix_Wholesaler_Sales_Price__c");
        }
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate" && bidType != "New Product Launch"){
            myMap.set("Reduction %", "Phoenix_Reduction__c");
        }
        if(bidType == "New Product Launch"){
            //myMap.set("Current Supplier", "Phoenix_Current_Supplier__c");
            myMap.set("Brand WAC", "Brand_WAC__c");
            //myMap.set("Brand WAC %", "Phoenix_Brand_WAC_Per__c");
            myMap.set("Brand WAC % for Retail Direct", "Phoenix_Brand_WAC_Per__c");
            myMap.set("Brand WAC % for Anda", "Phoenix_Invoice_Allowance__c");
            myMap.set("Brand WAC % for Wholesaler", "Phoenix_Sales_Out_Promotion_Proposed__c");
            
        }
        if(bidType != "Volume Review Only" && bidType != "Sales Out Rebate"){
            myMap.set("Retail Direct Marketing Price", "Phoenix_Retail_Direct_Price__c");
            myMap.set("Retail Indirect Net (Marketing)", "Phoenix_Retail_Indirect_Net__c");
            myMap.set("Retail Indirect Marketing Price", "Phoenix_Retail_Indirect_Price__c");
        }
        myMap.set("Wholesaler Price", "Phoenix_Wholesaler_Price_RxSS__c");
        myMap.set("Anda Invoice Price", "Phoenix_Wholesaler_Price_RxSS__c");
        myMap.set("Cash Terms", "Phoenix_Cash_Terms_RxSS__c");
        myMap.set("Anda CP Price", "Phoenix_Retail_Direct_Price__c");
        myMap.set("Anda - New model Acqusition Costs", "Phoenix_Anda_New_Model_Acqusition_Costs__c");
        myMap.set("Direct CD", "Phoenix_Direct_CD__c");
        myMap.set("Retail Direct Admin Fee", "Phoenix_Retail_Direct_Admin_Fee__c");
        myMap.set("Retail Direct VIP", "Phoenix_Retail_Direct_VIP__c");
        myMap.set("Retail Indirect Admin Fees", "Phoenix_Retail_Indirect_Admin_Fees__c");
        myMap.set("Retail Indirect VIP", "Phoenix_Retail_Indirect_VIP__c");
        myMap.set("CD+RDC/NLC Fee %", "Phoenix_RDC_NLC__c");
        myMap.set("Retail Indirect WAC & NLC Fee", "Phoenix_Retail_Indirect_WAC_NLC_Fee__c");
        myMap.set("CM Fee %", "Phoenix_Contract_Mngment_Fee_Wholesaler__c");
        myMap.set("Retail Indirect Wholesaler Fee", "Phoenix_Retail_Indirect_WholesalerFeeRxS__c");
        myMap.set("ANDA Admin Fees", "Phoenix_Anda_Admin_Fees__c");
        myMap.set("ANDA VIP", "Phoenix_Anda_VIP__c");
        myMap.set("Wholesaler CD", "Phoenix_INDIRECT_CD__c");
        myMap.set("Wholesaler Admin Fee", "Phoenix_Wholesaler_Admin_Fee__c");
        myMap.set("Wholesaler VIP", "Phoenix_Wholesaler_VIP__c");
        myMap.set("Retail Direct DRL NET Price", "Phoenix_Direct_Dead_Net__c");
        myMap.set("Retail Indirect DRL Dead Net", "Phoenix_Indirect_Dead_Net__c");
        myMap.set("Wholesaler DRL Net Price", "Phoenix_Wholesaler_DRL_Net_Price__c");
        myMap.set("ANDA DRL Net Price", "Phoenix_Anda_DRL_Net_price__c"); 
        myMap.set("Retail Direct DRL TPT $", "Phoenix_Retail_Direct_DRL_TPT__c");
        myMap.set("Retail Indirect DRL TPT $", "Phoenix_Retail_Indirect_DRL_TPT__c");
        myMap.set("Wholesaler DRL TPT $", "Phoenix_Wholesaler_DRL_TPT__c");
        myMap.set("ANDA DRL TPT $", "Phoenix_Anda_DRL_TPT__c");
        myMap.set("Retail Direct DRL TPT %", "Phoenix_Retail_Direct_DRL_TPT_Percent__c");
        myMap.set("Retail Indirect DRL TPT %", "Phoenix_Retail_Indirect_DRL_TPT_Percent__c");
        myMap.set("Wholesaler DRL TPT %", "Phoenix_Wholesaler_DRL_TPT_Percent__c");
        myMap.set("ANDA DRL TPT %", "Phoenix_Anda_DRL_TPT_Percent__c");
        if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch"){
            myMap.set("Retail IOD Per Unit", "Phoenix_Retail_IOD_per_unit__c");
            myMap.set("ANDA IOD Per Unit", "Phoenix_ANDA_IOD_Per_unit__c");
            myMap.set("Wholesaler IOD Per Unit", "Phoenix_Wholesaler_IOD_per_unit__c");
            myMap.set("IOD %", "Phoenix_Bid__r.Phoenix_Proposed_Initial_Order_Discount__c");
            myMap.set("Retail IOD Overall Amount $", "Phoenix_Retail_IOD_overall_amount__c");
            myMap.set("ANDA IOD Overall Amount $", "Phoenix_ANDA_IOD_Overall_Amount__c");
            myMap.set("Wholesaler IOD Overall Amount $", "Phoenix_Wholesaler_IOD_overall_amount__c");
        }
        myMap.set("Medicaid Returns  Per Unit", "Phoenix_Medicaid_Returns_Per_Unit_in__c");
        myMap.set("Retail Direct Net Sales", "Phoenix_Retail_Direct_Net_sales__c");
        myMap.set("Retail Indirect Net Sales", "Phoenix_Retail_Indirect_Net_Sales__c");
        myMap.set("Anda Net Model Sales", "Phoenix_Anda_Net_Model_Sales__c");
        myMap.set("Wholesaler Net Sales", "Phoenix_Wholesaler_Net_Sales__c");
        myMap.set("Blended ASP Per Pack", "Phoenix_Proposed_ASP_Dose__c");
        myMap.set("DRL Net Sales", "Phoenix_Net_Sales_Internal__c");
        myMap.set("DRL TPT $", "Phoenix_Th_Put_Margin__c");
        myMap.set("DRL TPT %", "Phoenix_TP_Margin__c");
        if(bidType!='New Product Launch'){
            myMap.set("Current Dead Net Price", "Phoenix_Direct_Dead_Net__c");
            myMap.set("Current Sales", "Phoenix_Current_Sales_Finance__c");
            myMap.set("Current Th. Put Margin $$$", "Phoenix_Current_TP_Margin__c");
            myMap.set("Current TP Margin %", "Phoenix_Current_TP_MarginPercent__c");
            myMap.set("Price Variance", "Phoenix_Difference_Price__c");
            myMap.set("Volume Variance", "Phoenix_Difference_Volume__c");
            myMap.set("Difference Sales", "Phoenix_Difference_Sales__c");
            myMap.set("Difference Margin", "Phoenix_Difference_Margin__c");
        }
        if(bidType == "New Product Launch"){
            myMap.set("Opening Order for Retail Direct", "Phoenix_Opening_Order__c");
            myMap.set("Opening Order Net Sales for Retail Direct", "Phoenix_Opening_Order_Net_sales__c");
            myMap.set("Opening Order TPT $ for Retail Direct", "Phoenix_Opening_Order_TPT__c");
            myMap.set("Opening Order TPT % for Retail Direct", "Phoenix_Opening_Order_TPT_Per__c");
            myMap.set("Opening Order for Anda", "Phoenix_Direct_Accerodo__c");
            myMap.set("Opening Order Net Sales for Anda", "Proposed_Net_Sales_Direct__c");
            myMap.set("Opening Order TPT $ for Anda", "Proposed_Net_Sales_Indirect__c");
            myMap.set("Opening Order TPT % for Anda", "Phoenix_Reduc_in_NCP_McK_And_RAD__c");
            myMap.set("Opening Order for Wholesaler", "Phoenix_Current_Anda_Net_Model_Units__c");
            myMap.set("Opening Order Net Sales for Wholesaler", "Phoenix_WMT_Indirect_Net_Sales__c");
            myMap.set("Opening Order TPT $ for Wholesaler", "Phoenix_Costco_TPT__c");
            myMap.set("Opening Order TPT % for Wholesaler", "Phoenix_Costco_TPTPer__c");
        }
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
        myMap.set("% to Budgeted ASP", "Phoenix_Proposed_to_Budget__c");
        myMap.set("Latest Estimate ASP", "Phoenix_Latest_Estimate__c");
        myMap.set("% to Latest Estimate ASP", "Phoenix_Proposed_as_of_Latest_Estimate__c");
        myMap.set("Lowest Price SKU", "Phoenix_Lowest_Price_SKU1__c");
        myMap.set("Approved Lowest Price /SKU", "Phoenix_Approved_Lowest_Price_SKU__c");
        if(bidType != "Price Change" && bidType != "New Product Launch" && bidType != "Sales Out Rebate" && bidType != "Customer Rebate Change"){ 
            myMap.set("Initial Stocking Order Volume", "Phoenix_Initial_Stocking_Order_Volume__c");
            myMap.set("Initial Stocking Order Comments", "Phoenix_Initial_Stocking_Order_Comments__c");
            myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
            myMap.set("SCM Rejection Reason","Phoenix_SCM_Rejection_Reason1__c");
            myMap.set("Revisit Date","Phoenix_Revisited_Date__c");
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("SCM Comments","Phoenix_SCM_Notes__c");
        } 
        else{
            myMap.set("Opening Order Comments", "Phoenix_Initial_Stocking_Order_Comments__c");
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
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
        myMap.set("WAC Check", "Phoenix_WAC_Check__c");
        if(bidType == "RFP Bids" || bidType == "Product Addition" || bidType == "New Product Launch"){
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
                    /*else if(value=='Phoenix_Estimated_Lead_Time_Days__c') {
                    var estleadtime = objectRecords[i]["Phoenix_Estimated_Lead_Time_Days__c"];
                    if(estleadtime != null){
                      csvStringResult += '"'+estleadtime+'"';
                    }
                    else{
                       csvStringResult += '"'+''+'"'; 
                    }
                 
                }*/
                        else if(value=='Phoenix_Bid__r.Phoenix_Proposed_Initial_Order_Discount__c') {
                            /* if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } */
                            // else{
                            csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid__r"]["Phoenix_Proposed_Initial_Order_Discount__c"]+'"';
                            //}
                            
                        }
                            else if(value == 'Proposed_TPT_Per_Direct__c'){
                                var Proposed_tpt=objectRecords[i]['Proposed_TPT_Per_Direct__c'];
                                //console.log('Proposed_tpt direct initialvalue-->'+Proposed_tpt);
                                if(Proposed_tpt != null){
                                    var rounded_tpt = Math.round(Proposed_tpt * 100)/100
                                    //var rounded_tpt=Math.round((Proposed_tpt + Number.EPSILON) * 100) / 100
                                    //console.log('Proposed_tpt direct rounded value-->'+rounded_tpt);
                                    csvStringResult += '"'+ Proposed_tpt +'"';
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
                    
                                                                                                                                            else if(value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' ||value == 'Phoenix_SCM_Approval_Y_N__c'||value == 'Phoenix_SCM_Notes__c'){
                                                                                                                                                if(objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!='N- Not Approved'&& objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!=''){
                                                                                                                                                    // console.log('scm approval status is true');
                                                                                                                                                    if(objectRecords[i][value]==undefined){
                                                                                                                                                        //console.log('Iam in last ELSEE if---->');
                                                                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                                                                    }   
                                                                                                                                                    else{
                                                                                                                                                        csvStringResult += '"'+ objectRecords[i][value]+'"'; 
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
                                                                                                                                                    else if (value == 'Phoenix_Final_Direct_Selling_Units_Calc__c') {
                                                                                                                                                        
                                                                                                                                                        if (objectRecords[i][value] == undefined) {
                                                                                                                                                            //console.log('Iam in last ELSEE if---->');
                                                                                                                                                            csvStringResult += '"' + '' + '"';
                                                                                                                                                        } else {
                                                                                                                                                            var otherDirect=0;
                                                                                                                                                            var direct1=0;
                                                                                                                                                            var direct2=0;
                                                                                                                                                            var directTotalUnits=0;
                                                                                                                                                            if (objectRecords[i]["Phoenix_Others_Direct__c"] != undefined) otherDirect=objectRecords[i]["Phoenix_Others_Direct__c"];
                                                                                                                                                            if (objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"] != undefined) direct1=objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"];
                                                                                                                                                            if (objectRecords[i]["Phoenix_ProposedDirectGaintEagleUnits__c"] != undefined) direct2=objectRecords[i]["Phoenix_ProposedDirectGaintEagleUnits__c"];
                                                                                                                                                            if(otherDirect>0){
                                                                                                                                                                
                                                                                                                                                                directTotalUnits=  otherDirect;
                                                                                                                                                            }
                                                                                                                                                            else{
                                                                                                                                                                directTotalUnits= direct1+direct2;
                                                                                                                                                            }
                                                                                                                                                            csvStringResult += '"' +directTotalUnits + '"';
                                                                                                                                                        }
                                                                                                                                                        
                                                                                                                                                    }
                    
                                                                                                                                                        else if (value == 'Phoenix_Final_Indirect_Selling_Units_Cal__c') {
                                                                                                                                                            
                                                                                                                                                            if (objectRecords[i][value] == undefined) {
                                                                                                                                                                //console.log('Iam in last ELSEE if---->');
                                                                                                                                                                csvStringResult += '"' + '' + '"';
                                                                                                                                                            } else {
                                                                                                                                                                var otherIndirect=0;
                                                                                                                                                                var Indirect1=0;
                                                                                                                                                                var Indirect2=0;
                                                                                                                                                                var Indirect3=0;
                                                                                                                                                                var IndirectTotalUnits=0;
                                                                                                                                                                if (objectRecords[i]["Phoenix_Others_Indirect__c"] != undefined) otherIndirect=objectRecords[i]["Phoenix_Others_Indirect__c"];
                                                                                                                                                                if (objectRecords[i]["Phoenix_Proposed_Anda_Units__c"] != undefined) Indirect1=objectRecords[i]["Phoenix_Proposed_Anda_Units__c"];
                                                                                                                                                                if (objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"] != undefined) Indirect2=objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"];
                                                                                                                                                                if (objectRecords[i]["Phoenix_ProposedIndirectAholdDelhaizeUni__c"] != undefined) Indirect3=objectRecords[i]["Phoenix_ProposedIndirectAholdDelhaizeUni__c"];
                                                                                                                                                                
                                                                                                                                                                
                                                                                                                                                                if(otherIndirect>0){
                                                                                                                                                                    
                                                                                                                                                                    IndirectTotalUnits=  otherIndirect;
                                                                                                                                                                }
                                                                                                                                                                else{
                                                                                                                                                                    IndirectTotalUnits= Indirect1+Indirect2+Indirect3;
                                                                                                                                                                }
                                                                                                                                                                csvStringResult += '"' +IndirectTotalUnits + '"';
                                                                                                                                                            }
                                                                                                                                                            
                                                                                                                                                        }
                                                                                                                                                            else if (value == 'Phoenix_Final_Total_Selling_Unit__c') {
                                                                                                                                                                
                                                                                                                                                                if (objectRecords[i][value] == undefined) {
                                                                                                                                                                    //console.log('Iam in last ELSEE if---->');
                                                                                                                                                                    csvStringResult += '"' + '' + '"';
                                                                                                                                                                } else {
                                                                                                                                                                    var otherIndirect=0;
                                                                                                                                                                    var Indirect1=0;
                                                                                                                                                                    var Indirect2=0;
                                                                                                                                                                    var Indirect3=0;
                                                                                                                                                                    var IndirectTotalUnits=0;
                                                                                                                                                                    
                                                                                                                                                                    var otherDirect=0;
                                                                                                                                                                    var direct1=0;
                                                                                                                                                                    var direct2=0;
                                                                                                                                                                    var directTotalUnits=0;
                                                                                                                                                                    var TotalUnits=0;
                                                                                                                                                                    if (objectRecords[i]["Phoenix_Others_Direct__c"] != undefined) otherDirect=objectRecords[i]["Phoenix_Others_Direct__c"];
                                                                                                                                                                    if (objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"] != undefined) direct1=objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"];
                                                                                                                                                                    if (objectRecords[i]["Phoenix_ProposedDirectGaintEagleUnits__c"] != undefined) direct2=objectRecords[i]["Phoenix_ProposedDirectGaintEagleUnits__c"];
                                                                                                                                                                    if(otherDirect>0){
                                                                                                                                                                        
                                                                                                                                                                        directTotalUnits=  otherDirect;
                                                                                                                                                                    }
                                                                                                                                                                    else{
                                                                                                                                                                        directTotalUnits= direct1+direct2;
                                                                                                                                                                    }
                                                                                                                                                                    
                                                                                                                                                                    if (objectRecords[i]["Phoenix_Others_Indirect__c"] != undefined) otherIndirect=objectRecords[i]["Phoenix_Others_Indirect__c"];
                                                                                                                                                                    if (objectRecords[i]["Phoenix_Proposed_Anda_Units__c"] != undefined) Indirect1=objectRecords[i]["Phoenix_Proposed_Anda_Units__c"];
                                                                                                                                                                    if (objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"] != undefined) Indirect2=objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"];
                                                                                                                                                                    if (objectRecords[i]["Phoenix_ProposedIndirectAholdDelhaizeUni__c"] != undefined) Indirect3=objectRecords[i]["Phoenix_ProposedIndirectAholdDelhaizeUni__c"];
                                                                                                                                                                    
                                                                                                                                                                    
                                                                                                                                                                    if(otherIndirect>0){
                                                                                                                                                                        
                                                                                                                                                                        IndirectTotalUnits=  otherIndirect;
                                                                                                                                                                    }
                                                                                                                                                                    else{
                                                                                                                                                                        IndirectTotalUnits= Indirect1+Indirect2+Indirect3;
                                                                                                                                                                    }
                                                                                                                                                                    
                                                                                                                                                                    TotalUnits=IndirectTotalUnits+directTotalUnits;
                                                                                                                                                                    csvStringResult += '"' +TotalUnits + '"';
                                                                                                                                                                }
                                                                                                                                                                
                                                                                                                                                            }
                                                                                                                                                                else if(key=='Anda CP Price' && value == 'Phoenix_Retail_Direct_Price__c'){
                                                                                                                                                                    
                                                                                                                                                                    
                                                                                                                                                                    var andaCP= (objectRecords[i]["Phoenix_Retail_Direct_Price__c"]!=null && objectRecords[i]["Phoenix_Retail_Direct_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Retail_Direct_Price__c"]:(objectRecords[i]["Phoenix_Retail_Direct_Sales_Price__c"]!=null && objectRecords[i]["Phoenix_Retail_Direct_Sales_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Retail_Direct_Sales_Price__c"]:(objectRecords[i]["Phoenix_Current_Retail_Direct_Price__c"]!=null && objectRecords[i]["Phoenix_Current_Retail_Direct_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Current_Retail_Direct_Price__c"]:0;
                                                                                                                                                                    if(andaCP>0){
                                                                                                                                                                        csvStringResult += '"'+ andaCP+'"';  
                                                                                                                                                                    }
                                                                                                                                                                    
                                                                                                                                                                    else{
                                                                                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                                                                                    }
                                                                                                                                                                    
                                                                                                                                                                    
                                                                                                                                                                }
                    
                                                                                                                                                                    else if(objectRecords[i][value]==undefined){
                                                                                                                                                                        //console.log('Iam in last ELSEE if---->');
                                                                                                                                                                        csvStringResult += '"'+''+'"';
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
                                                                                                                                                                                else if(value == 'Phoenix_Internal_Dead_Net_Price__c'){
                                                                                                                                                                                    var internaldeadnetprice = objectRecords[i]['Phoenix_Internal_Dead_Net_Price__c'];
                                                                                                                                                                                    console.log("internaldeadnetprice--->"+internaldeadnetprice);
                                                                                                                                                                                    if(internaldeadnetprice != null){
                                                                                                                                                                                        var rounde_internaldeadnetprice=Math.round((internaldeadnetprice + Number.EPSILON)* 100) / 100
                                                                                                                                                                                        console.log("rounded internaldeadnetprice--->"+internaldeadnetprice);
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
                                                                                                                                                                                            var rounde_currentdeadnetprice=Math.round((currentdeadnetprice + Number.EPSILON)* 100) / 100
                                                                                                                                                                                            console.log("rounded rounde_currentdeadnetprice--->"+rounde_currentdeadnetprice);
                                                                                                                                                                                            csvStringResult += '"'+rounde_currentdeadnetprice+'"'; 
                                                                                                                                                                                        }
                                                                                                                                                                                        else{
                                                                                                                                                                                            csvStringResult += '"'+''+'"';
                                                                                                                                                                                        }          
                                                                                                                                                                                    }
                                                                                                                                                                                        else if(value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' ||value == 'Phoenix_SCM_Approval_Y_N__c'||value == 'Phoenix_SCM_Notes__c'){
                                                                                                                                                                                            if(objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!='N- Not Approved'&& objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!=''){
                                                                                                                                                                                                // console.log('scm approval status is true');
                                                                                                                                                                                                if(objectRecords[i][value]==undefined){
                                                                                                                                                                                                    //console.log('Iam in last ELSEE if---->');
                                                                                                                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                                                                                                                }   
                                                                                                                                                                                                else{
                                                                                                                                                                                                    csvStringResult += '"'+ objectRecords[i][value]+'"'; 
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