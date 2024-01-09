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
        myMap.set("Case Pack", "Phoenix_Case_Pack__c");
        myMap.set("MOQ", "Phoenix_MOQ1__c");
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating1__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        myMap.set("WAC", "Phoenix_WAC__c");
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        if(bidType != 'New Product Launch' && bidType != 'New Customer'){
            myMap.set("Current Position", "Phoenix_Current_Position__c");
        }
        myMap.set("Proposed Position", "Phoenix_Proposed_Position__c");
        if(bidType != 'New Product Launch' && bidType != 'New Customer'){
            if (template == 'Direct' || template == "Direct and Indirect") {
                myMap.set("3 Months Annualized Total Direct Selling Units", "Phoenix_Current_Direct_Selling_Unit__c");
            }
            
            if (template == 'Indirect' || template == "Direct and Indirect") {
                myMap.set("3 Months Annualized Total Indirect Selling Units", "Phoenix_Current_Indirect_Selling_Unit__c");
            }
            
            if (template == 'Direct' || template == "Direct and Indirect") {
                myMap.set("Direct Last 12 Months Actuals  Selling Units", "Phoenix_12_Months_Actual_Sales__c");
            }
            
            if (template == 'Indirect' || template == "Direct and Indirect") {
                myMap.set("Indirect Last 12 Months Actuals  Selling Units", "Phoenix_12_Months_IndirectSaleUnit__c");
            }
            if (template == "Direct and Indirect") {
                myMap.set("Total Last 12 Months Actuals Selling Units", "Phoenix_12_Months_IndirectSaleUnit1__c");
            }
            if (template == 'Direct' || template == "Direct and Indirect") {
                myMap.set("Override Direct Selling Units", "Phoenix_Override_Current_Direct_Units__c");
            }
            
            if (template == 'Indirect' || template == "Direct and Indirect") {
                myMap.set("Override Indirect Selling Units", "Phoenix_Override_Current_Indirect_Units__c");
            }
            if (template == "Direct and Indirect") {
                myMap.set("Total Override Selling Units", "Phoenix_Override_Current_Indirect_Units1__c");
            }
            if (template == "Direct and Indirect") {
                myMap.set("Total Selling Units", "Phoenix_Total_Selling_Unit__c");
            }
        }
        if (bidType!= "Price Change" && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate") {
            if (template == 'Direct' || template == "Direct and Indirect") {
                if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){
                    myMap.set("Proposed Direct Selling Units (Current + Increment)", "Phoenix_Proposed_Direct_Selling_Unit__c");
                }
                else{
                    myMap.set("Proposed Direct Selling Units", "Phoenix_Proposed_Direct_Selling_Unit__c");
                }                
            }
        }
        if (bidType!= "Price Change" && bidType != "Customer Rebate Change" && bidType != "Sales Out Rebate") {
            if (template == 'Indirect' || template == "Direct and Indirect") {
                if(bidType == "RFP Bids" || bidType == "Volume Review Only" || bidType == "Product Addition"){
                    myMap.set("Proposed Indirect Selling Units (Current + Increment)", "Phoenix_Proposed_Indirect_Selling_Unit__c");                    
                }
                else{
                    myMap.set("Proposed Indirect Selling Units", "Phoenix_Proposed_Indirect_Selling_Unit__c");
                }
            }
        }
        if(bidType != 'New Product Launch' ){
            if (bidType== "RFP Bids" || bidType == "New Customer" || bidType == "Product Addition" || bidType == "Volume Review Only" ) {
                myMap.set("Total SCM Approved Qty", "Phoenix_Total_SCM_Approved_Qty__c");
            }
        }                                          
        if (template == "Direct and Indirect") {
            myMap.set("Final Total Selling Units", "Phoenix_Final_Total_Selling_Unit__c");
        }
        myMap.set("Final Annual Extended Units", "Phoenix_Final_Annual_Extended_Units__c");
        if(bidType != 'New Product Launch' && bidType != 'New Customer'){
            if (template == 'Direct' || template == "Direct and Indirect") {
                myMap.set("Current Direct Price", "Phoenix_Current_Direct_Price__c");
            }
            myMap.set("Current Per Unit Rebate", "Phoenix_Current_Per_Unit_Rebate__c");
            if (template == 'Indirect' || template == "Direct and Indirect") {
                myMap.set("Current Indirect Price", "Phoenix_Current_Indirect_Price__c");
            }
            
        }
        
        
        
        

        myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
        if(bidType != 'New Product Launch'){
            if(template=='Direct' || template=='Direct and Indirect'){
                myMap.set("Current Direct Price","Phoenix_Current_Direct_Price__c");
            }
            if(template=='Indirect' || template=='Direct and Indirect'){       
                myMap.set("Current Indirect Price", "Phoenix_Current_Indirect_Price__c");
            }
        }
        myMap.set("Proposed Contract Bid Price (Sales)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
        if(bidType!='Volume Review Only'){
            if(template=='Direct and Indirect'){
                myMap.set("Proposed Direct Contract Bid Price (Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
            }else{
                myMap.set("Proposed Contract Bid Price (Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
            }
        }
        if(bidType != 'New Product Launch'){
            if(template=='Direct and Indirect'){
                myMap.set("Proposed Indirect Contract Price (Marketing)", "Phoenix_Wholesaler_Diff_Price_Indirect__c");
            }
        }
        if(template=='Direct and Indirect'){
            myMap.set("Direct Dead Net Price", "Phoenix_Direct_Dead_Net__c");
            myMap.set("Indrect Dead Net Price", "Phoenix_Indirect_Dead_Net__c");
            
        }else{
            myMap.set("Internal Dead Net Price", "Phoenix_Internal_Dead_Net_Price__c");
        }
        myMap.set("Net Sales (Internal)", "Phoenix_Net_Sales_Internal__c");
        myMap.set("Th. Put Margin $$$","Phoenix_Th_Put_Margin__c");
        
        
        myMap.set("TP Margin %","Phoenix_TP_Margin__c");
        
        if(bidType != 'New Product Launch'){
            
            myMap.set("Current Sales", "Phoenix_Current_Sales_Finance__c");
            myMap.set("Current Th. Put Margin $$$", "Phoenix_Current_TP_Margin__c");
            myMap.set("Current TP Margin %", "Phoenix_Current_TP_MarginPercent__c");
            myMap.set("Price Variance", "Phoenix_Difference_Price__c");
            myMap.set("Volume Variance", "Phoenix_Difference_Volume__c");
            myMap.set("Difference Sales", "Phoenix_Difference_Sales__c");
            myMap.set("Difference Margin", "Phoenix_Difference_Margin__c");
        }
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
            myMap.set("Marketing Notes","Phoenix_Marketing_Notes__c");
        }
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
                        else if(value=='Product_Family_Name__c' && objectRecords[i]["Product_Family_Name__c"] == null){
                            csvStringResult += '"'+ objectRecords[i]["Phoenix_Product_Family__c"]+'"';
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
})