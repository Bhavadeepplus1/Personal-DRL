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
        myMap.set("WAC", "Phoenix_WAC__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        
        
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        if(bidType != "New Product Launch" && bidType != "New Customer" ){
            myMap.set("Current Position", "Phoenix_Current_Position__c");
        }
        myMap.set("Proposed Position", "Phoenix_Proposed_Position__c");
        if(bidType != "New Product Launch" && bidType != "New Customer" ){
            myMap.set("3 Months Annualized Current BASE Selling Units", "Phoenix_Current_Wholesaler_Units__c");
            myMap.set("3 Months Annualized Current DSH Selling Units", "Phoenix_Current_Anda_Units__c");
            myMap.set("3 Months Annualized Current Auto Sub Selling Units", "Phoenix_Current_Retail_Direct_Units__c");
            myMap.set("3 Months Annualized Total Selling Units", "Phoenix_Current_Direct_Selling_Unit__c");
            myMap.set("Last 12 Months Actuals Current BASE Selling Units", "Phoenix_12_Months_IndirectSaleUnit__c");
            myMap.set("Last 12 Months Actuals Current DSH Selling Units", "Phoenix_12_Months_Actual_Sales__c");
            myMap.set("Last 12 Months Actuals Current Auto Sub Selling Units", "Phoenix_ProposedDirectGaintEagleUnits__c");
            myMap.set("Last 12 Months Actuals Total Selling Units", "Phoenix_12_Months_TotalSaleUnits__c");
            myMap.set("Override Current BASE selling Units", "Phoenix_Override_Current_Direct_Units__c");
            myMap.set("Override Current DSH selling Units", "Phoenix_Override_Current_Indirect_Units__c");
            myMap.set("Override Current Auto Sub selling Units", "Phoenix_Override_Current_Units__c");
            myMap.set("Override Total Units", "Phoenix_Override_Total_units__c");
        }
        
        
        if (bidType == 'RFP Bids' || bidType == "Product Addition" || bidType == "Volume Review Only" || bidType == "New Product Launch" || bidType == "New Customer") {
            myMap.set("Proposed BASE Units","Phoenix_Proposed_Smith_Drug_Units__c");
            myMap.set("Proposed DSH Units","Phoenix_Proposed_Anda_Units__c");
            myMap.set("Proposed Auto Sub Units","Phoenix_ProposedDirectAholdDelhaizeUnits__c");
            myMap.set("Proposed Total Selling Units","Phoenix_Final_Total_Selling_Unit__c");
            if(bidType != "New Product Launch"){
                myMap.set("BASE SCM Approved Qty", "Phoenix_IDN_Usage__c");
                myMap.set("DSH SCM Approved Qty", "Phoenix_Days_Notice_Product_Discontinuat__c");
                myMap.set("Auto Sub SCM Approved Qty", "Phoenix_Day_s_Notice_Product_removal__c");
                myMap.set("Total SCM Approved Qty", "Phoenix_Total_SCM_Approved_Qty__c");
            }
        }
        if(bidType != "New Product Launch" && bidType != "New Customer" ){
            myMap.set("Current BASE Contract Price", "Phoenix_Current_Retail_Direct_Price__c");
            myMap.set("Current DSH Contract Price", "Phoenix_Current_Retail_Indirect_Net__c");
            myMap.set("Current Auto Sub Contract Price", "Phoenix_Current_Retail_Indirect_Price__c");
        }
        if (bidType != "Volume Review Only" && bidType != "Sales Out Rebate") {
            myMap.set("Guidance Price", "Phoenix_Retail_Direct_Guidance_Price__c");
            myMap.set("BASE Sales Price", "Phoenix_Retail_Direct_Sales_Price__c");
            myMap.set("DSH Sales Price", "Phoenix_WMT_Indirect_Current_Sales__c");
            myMap.set("Auto Sub Sales Price", "Phoenix_Wholesaler_Sales_Price__c");
        }
        if (bidType != "New Customer" && bidType != "Volume Review Only" && bidType != "Sales Out Rebate" && bidType != "New Product Launch" ) {
            myMap.set("Reduction %", "Phoenix_Reduction__c");
        }
        if (bidType != 'Volume Review Only' && bidType != "Sales Out Rebate") {
            myMap.set("Proposed BASE Contract Price(Marketing)", "Phoenix_Retail_Direct_Price__c");
            myMap.set("Proposed DSH Contract Price(Marketing)","Phoenix_Retail_Indirect_Net__c");
            myMap.set("Proposed AutoSub Contract Price(Marketing)","Phoenix_Retail_Indirect_Price__c");
        }
        myMap.set("BASE DRL Net Price", "Phoenix_Wholesaler_DRL_Net_Price__c");
        myMap.set("BASE Annual Usage", "Phoenix_ProposedIndirectAholdDelhaizeUni__c");
        myMap.set("BASE Annual Net Sales", "Phoenix_Retail_IOD_overall_amount__c");
        myMap.set("BASE COGS", "Phoenix_ANDA_IOD_Overall_Amount__c");
        
        myMap.set("DSH DRL Net Price", "Phoenix_Anda_DRL_Net_price__c");
        myMap.set("DSH Annual Usage", "Phoenix_Current_Retail_Indirect_Units__c");
        myMap.set("DSH Annual Net Sales", "Phoenix_Retail_Direct_Net_sales__c");
        myMap.set("DSH COGS", "Phoenix_Retail_Indirect_Net_Sales__c");
        
        myMap.set("Auto Sub DRL Net Price", "Phoenix_Wholesaler_DRL_TPT__c");
        myMap.set("Auto Sub Annual Usage", "Phoenix_Current_Anda_Net_Model_Units__c");
        myMap.set("Auto Sub Annual Net Sales", "Phoenix_Wholesaler_Net_Sales__c");
        myMap.set("Auto Sub COGS", "Phoenix_Retail_Indirect_WAC_NLC_Fee__c");        
        if (bidType != 'New Product Launch' && bidType != 'New Customer' ) {
            myMap.set("Current Sales", "Phoenix_Current_Sales_Finance__c");
            myMap.set("Current Th. Put Margin $$$", "Phoenix_Current_TP_Margin__c");
            myMap.set("Current TP Margin %", "Phoenix_Current_TP_MarginPercent__c");
            myMap.set("Price Variance", "Phoenix_Difference_Price__c");
            myMap.set("Volume Variance", "Phoenix_Difference_Volume__c");
            myMap.set("Difference Sales", "Phoenix_Difference_Sales__c");
            myMap.set("Difference Margin", "Phoenix_Difference_Margin__c");
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
                                            }                    else if (value == 'Proposed_TPT_Per_Direct__c') {
                        var Proposed_tpt = objectRecords[i]['Proposed_TPT_Per_Direct__c'];
                        //console.log('Proposed_tpt direct initialvalue-->'+Proposed_tpt);
                        if (Proposed_tpt != null) {
                            var rounded_tpt = Math.round(Proposed_tpt * 100) / 100
                            //var rounded_tpt=Math.round((Proposed_tpt + Number.EPSILON) * 100) / 100
                            //console.log('Proposed_tpt direct rounded value-->'+rounded_tpt);
                            csvStringResult += '"' + rounded_tpt + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Proposed_TPT_Per_Indirect__c') {
                        var Proposed_tpt = objectRecords[i]['Proposed_TPT_Per_Indirect__c'];
                        //console.log('Proposed_tpt Indirect initialvalue-->'+Proposed_tpt);
                        if (Proposed_tpt != null) {
                            var rounded_tpt = Math.round(Proposed_tpt * 100) / 100
                            //console.log('Proposed_tpt indirect rounded value-->'+rounded_tpt);
                            csvStringResult += '"' + rounded_tpt + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Internal_Dead_Net_Price__c') {
                        var deadnetprice = objectRecords[i]['Phoenix_Internal_Dead_Net_Price__c'];
                        //console.log('deadnetprice initialvalue-->'+deadnetprice);
                        if (deadnetprice != null) {
                            var rounded_price = Math.round(deadnetprice * 100) / 100
                            //console.log('deadnetprice rounded value-->'+rounded_price);
                            csvStringResult += '"' + rounded_price + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Rebate_Perc_In__c') {
                        var rebateperindl = objectRecords[i]['Phoenix_Rebate_Perc_In__c'];
                        // console.log('rebateperindl-->'+rebateperindl);
                        if (rebateperindl != null) {
                            var rounded_rebateperindl = Math.round(rebateperindl * 100) / 100
                            //console.log('rebateperindl rounded value-->'+rounded_price);
                            csvStringResult += '"' + rounded_rebateperindl + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Admin_Fee_in__c') {
                        var adminfeeindl = objectRecords[i]['Phoenix_Admin_Fee_in__c'];
                        // console.log('adminfeeindl-->'+adminfeeindl);
                        if (adminfeeindl != null) {
                            var rounded_adminfeeindl = Math.round(adminfeeindl * 100) / 100
                            csvStringResult += '"' + rounded_adminfeeindl + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Direct_VIP_Per_Unit__c') {
                        var vipperunitdl = objectRecords[i]['Direct_VIP_Per_Unit__c'];
                        // console.log('vipperunitdl-->'+vipperunitdl);
                        if (vipperunitdl != null) {
                            var rounded_vipperunitdl = Math.round(vipperunitdl * 100) / 100
                            csvStringResult += '"' + rounded_vipperunitdl + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Sales_Out_Promotion_Per_unit_in__c') {
                        var salesoutpmpudl = objectRecords[i]['Phoenix_Sales_Out_Promotion_Per_unit_in__c'];
                        // console.log('salesoutpmpudl-->'+salesoutpmpudl);
                        if (salesoutpmpudl != null) {
                            var rounded_salesoutpmpudl = Math.round(salesoutpmpudl * 100) / 100
                            csvStringResult += '"' + rounded_salesoutpmpudl + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                        
                    } else if (value == 'Phoenix_IOD_Per_Unit_in__c') {
                        var iodperunitindl = objectRecords[i]['Phoenix_IOD_Per_Unit_in__c'];
                        // console.log('iodperunitindl-->'+iodperunitindl);
                        if (iodperunitindl != null) {
                            var rounded_iodperunitindl = Math.round(iodperunitindl * 100) / 100
                            csvStringResult += '"' + rounded_iodperunitindl + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Direct_CD_Per_Unit__c') {
                        var cdperunitdirect = objectRecords[i]['Phoenix_Direct_CD_Per_Unit__c'];
                        // console.log('cdperunitdirect-->'+cdperunitdirect);
                        if (cdperunitdirect != null) {
                            var rounded_cdperunitdirect = Math.round(cdperunitdirect * 100) / 100
                            csvStringResult += '"' + rounded_cdperunitdirect + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_RDC_NLC__c') {
                        var totalrdcnlcper = objectRecords[i]['Phoenix_RDC_NLC__c'];
                        // console.log('totalrdcnlcper-->'+totalrdcnlcper);
                        if (totalrdcnlcper != null) {
                            var rounded_totalrdcnlcper = Math.round(totalrdcnlcper * 100) / 100
                            csvStringResult += '"' + rounded_totalrdcnlcper + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_RDC_NLC_Per_Unit_in__c') {
                        var rdcnlcperunitindl = objectRecords[i]['Phoenix_RDC_NLC_Per_Unit_in__c'];
                        // console.log('rdcnlcperunitindl-->'+rdcnlcperunitindl);
                        if (rdcnlcperunitindl != null) {
                            var rounded_rdcnlcperunitindl = Math.round(rdcnlcperunitindl * 100) / 100
                            csvStringResult += '"' + rounded_rdcnlcperunitindl + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Customer_Fees__c') {
                        var cmfeeperunit = objectRecords[i]['Phoenix_Customer_Fees__c'];
                        // console.log('cmfeeperunit-->'+cmfeeperunit);
                        if (cmfeeperunit != null) {
                            var rounded_cmfeeperunit = Math.round(cmfeeperunit * 100) / 100
                            csvStringResult += '"' + rounded_cmfeeperunit + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Medicaid_Returns_Per_Unit_in__c') {
                        var medicaidretperunit = objectRecords[i]['Phoenix_Medicaid_Returns_Per_Unit_in__c'];
                        // console.log('medicaidretperunit-->'+medicaidretperunit);
                        if (medicaidretperunit != null) {
                            var rounded_medicaidretperunit = Math.round(medicaidretperunit * 100) / 100
                            csvStringResult += '"' + rounded_medicaidretperunit + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Direct_Dead_Net__c') {
                        var directdeadnet = objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                        // console.log('directdeadnet-->'+directdeadnet);
                        if (directdeadnet != null) {
                            var rounded_directdeadnet = Math.round(directdeadnet * 100) / 100
                            csvStringResult += '"' + rounded_directdeadnet + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Proposed_ZITD__c') {
                        var proposedzitd = objectRecords[i]['Phoenix_Proposed_ZITD__c'];
                        // console.log('proposedzitd-->'+proposedzitd);
                        if (proposedzitd != null) {
                            var rounded_proposedzitd = Math.round(proposedzitd * 100) / 100
                            csvStringResult += '"' + rounded_proposedzitd + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Indirect_Dead_Net__c') {
                        var indirectdeadnet = objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                        // console.log('indirectdeadnet-->'+indirectdeadnet);
                        if (indirectdeadnet != null) {
                            var rounded_indirectdeadnet = Math.round(indirectdeadnet * 100) / 100
                            csvStringResult += '"' + rounded_indirectdeadnet + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                        
                    } else if (value == 'Phoenix_Net_Sales_Internal__c') {
                        var netsalesinternal = objectRecords[i]['Phoenix_Net_Sales_Internal__c'];
                        // console.log('netsalesinternal-->'+netsalesinternal);
                        if (netsalesinternal != null) {
                            var rounded_indirectdeadnet = Math.round(netsalesinternal)
                            csvStringResult += '"' + rounded_indirectdeadnet + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                        
                    } else if (value == 'Phoenix_IOD_Total_Amount__c') {
                        var iodtotalamount = objectRecords[i]['Phoenix_IOD_Total_Amount__c'];
                        // console.log('iodtotalamount-->'+iodtotalamount);
                        if (iodtotalamount != null) {
                            var rounded_iodtotalamount = Math.round(iodtotalamount * 100) / 100
                            csvStringResult += '"' + rounded_iodtotalamount + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_DRL_Dead_Net_After_IOD_w_o_MR__c') {
                        var drldaednetafteriod = objectRecords[i]['Phoenix_DRL_Dead_Net_After_IOD_w_o_MR__c'];
                        // console.log('drldaednetafteriod-->'+drldaednetafteriod);
                        if (drldaednetafteriod != null) {
                            var rounded_drldaednetafteriod = Math.round(drldaednetafteriod * 100) / 100
                            csvStringResult += '"' + rounded_drldaednetafteriod + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c') {
                        var drldaednetafteriodwo = objectRecords[i]['Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c'];
                        // console.log('drldaednetafteriodwo-->'+drldaednetafteriodwo);
                        if (drldaednetafteriodwo != null) {
                            var rounded_drldaednetafteriodwo = Math.round(drldaednetafteriodwo * 100) / 100
                            csvStringResult += '"' + rounded_drldaednetafteriodwo + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_INDIRECT_CD__c') {
                        var indirectcdperundl = objectRecords[i]['Phoenix_INDIRECT_CD__c'];
                        // console.log('indirectcdperundl-->'+indirectcdperundl);
                        if (indirectcdperundl != null) {
                            var rounded_indirectcdperundl = Math.round(indirectcdperundl * 100) / 100
                            csvStringResult += '"' + rounded_indirectcdperundl + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c') {
                        var indirectdeadnetmedret = objectRecords[i]['Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c'];
                        // console.log('indirectdeadnetmedret-->'+indirectdeadnetmedret);
                        if (indirectdeadnetmedret != null) {
                            var rounded_indirectdeadnetmedret = Math.round(indirectdeadnetmedret * 100) / 100
                            csvStringResult += '"' + rounded_indirectdeadnetmedret + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Proposed_Net_Sales_Direct__c') {
                        var proposednetsalesdirect = objectRecords[i]['Proposed_Net_Sales_Direct__c'];
                        // console.log('proposednetsalesdirect-->'+proposednetsalesdirect);
                        if (proposednetsalesdirect != null) {
                            var rounded_proposednetsalesdirect = Math.round(proposednetsalesdirect * 100) / 100
                            csvStringResult += '"' + rounded_proposednetsalesdirect + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Proposed_Net_Sales_Indirect__c') {
                        var proposednetsalesindirect = objectRecords[i]['Proposed_Net_Sales_Indirect__c'];
                        // console.log('proposednetsalesindirect-->'+proposednetsalesindirect);
                        if (proposednetsalesindirect != null) {
                            var rounded_proposednetsalesindirect = Math.round(proposednetsalesindirect * 100) / 100
                            csvStringResult += '"' + rounded_proposednetsalesindirect + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Proposed_TPT_Direct__c') {
                        var proposedtpdldirect = objectRecords[i]['Proposed_TPT_Direct__c'];
                        // console.log('proposedtpdldirect-->'+proposedtpdldirect);
                        if (proposedtpdldirect != null) {
                            var rounded_proposedtpdldirect = Math.round(proposedtpdldirect * 100) / 100
                            csvStringResult += '"' + rounded_proposedtpdldirect + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                    } else if (value == 'Proposed_TPT_Indirect__c') {
                        var proposedtpdlindirect = objectRecords[i]['Proposed_TPT_Indirect__c'];
                        // console.log('proposedtpdlindirect-->'+proposedtpdlindirect);
                        if (proposedtpdlindirect != null) {
                            var rounded_proposedtpdlindirect = Math.round(proposedtpdlindirect * 100) / 100
                            csvStringResult += '"' + rounded_proposedtpdlindirect + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                        
                    } else if (value == 'Phoenix_Latest_Estimate__c') {
                        var latestestimateasp = objectRecords[i]['Phoenix_Latest_Estimate__c'];
                        // console.log('latestestimateasp-->'+latestestimateasp);
                        if (latestestimateasp != null) {
                            var rounded_latestestimateasp = Math.round(latestestimateasp * 100) / 100
                            csvStringResult += '"' + rounded_latestestimateasp + '"';
                        } else {
                            csvStringResult += '"' + '' + '"';
                        }
                        
                    } else if (value == 'Phoenix_REMS__c') {
                        var rems_value = objectRecords[i]['Phoenix_REMS__c'];
                        // console.log("remss valuee-->"+rems_value);
                        if (rems_value == true) {
                            // console.log("yesss");
                            csvStringResult += '"' + 'Yes' + '"';
                        } else {
                            csvStringResult += '"' + 'No' + '"';
                        }
                    } else if (value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' || value == 'Phoenix_SCM_Approval_Y_N__c' || value == 'Phoenix_SCM_Notes__c') {
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
                    } else if (value == 'Phoenix_Finance_Approval__c' || value == 'Phoenix_Finance_Comments__c') {
                        if (objectRecords[i]["Phoenix_Final_Finance_Approval__c"] == true) {
                            if (objectRecords[i][value] == undefined) {
                                //console.log('Iam in last ELSEE if---->');
                                csvStringResult += '"' + '' + '"';
                            } else {
                                csvStringResult += '"' + objectRecords[i][value] + '"';
                            }
                        }
                    }
                        else if (value == 'Phoenix_Override_Total_units__c') {
                            
                            if (objectRecords[i][value] == undefined) {
                                //console.log('Iam in last ELSEE if---->');
                                csvStringResult += '"' + '' + '"';
                            } else {
                                var override1=0;
                                var override2=0;
                                var override3=0;
                                if (objectRecords[i]["Phoenix_Override_Current_Direct_Units__c"] != undefined) override1=objectRecords[i]["Phoenix_Override_Current_Direct_Units__c"];
                                if (objectRecords[i]["Phoenix_Override_Current_Indirect_Units__c"] != undefined) override2=objectRecords[i]["Phoenix_Override_Current_Indirect_Units__c"];
                                if (objectRecords[i]["Phoenix_Override_Current_Units__c"] != undefined) override3=objectRecords[i]["Phoenix_Override_Current_Units__c"];
                                
                                var override4=override1+override2+override3;
                                csvStringResult += '"' + override4 + '"';
                            }
                            
                        }
                            else if (value == 'Phoenix_Final_Total_Selling_Unit__c') {
                                
                                if (objectRecords[i][value] == undefined) {
                                    //console.log('Iam in last ELSEE if---->');
                                    csvStringResult += '"' + '' + '"';
                                } else {
                                    var override1=0;
                                    var override2=0;
                                    var override3=0;
                                    if (objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"] != undefined) override1=objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"];
                                    if (objectRecords[i]["Phoenix_Proposed_Anda_Units__c"] != undefined) override2=objectRecords[i]["Phoenix_Proposed_Anda_Units__c"];
                                    if (objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"] != undefined) override3=objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"];
                                    var override4=override1+override2+override3;
                                    csvStringResult += '"' +override4 + '"';
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