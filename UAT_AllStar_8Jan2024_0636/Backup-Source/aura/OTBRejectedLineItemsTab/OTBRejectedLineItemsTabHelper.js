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
        var BidTypeVal = component.get("v.BidTypeVal"); 
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
          myMap.set("Minimum Order Quantity","Minimum_Order_Quantity__c");
        if(BidTypeVal != 'Platform OTB'){
        myMap.set("MOQ","Phoenix_MOQ1__c");
        }
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        if(BidTypeVal != 'Platform OTB'){
        myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating1__c");
        }
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        myMap.set("WAC", "Phoenix_WAC__c");
        if(BidTypeVal != 'Platform OTB'){
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        }
        myMap.set("Proposed Direct Units", "Phoenix_Proposed_Direct_Selling_Unit__c");
        myMap.set("Proposed Indirect Units","Phoenix_Proposed_Indirect_Selling_Unit__c");
        if(BidTypeVal != 'One Time Buy Good Dated Shelf Life for New Product Launch' && BidTypeVal != 'Platform OTB'){
            myMap.set("Total SCM Approved Qty","Phoenix_Total_SCM_Approved_Qty__c");
        }
        myMap.set("Guidance Price", "Phoenix_Guidance_Price__c");
         if(BidTypeVal != 'Platform OTB'){
        myMap.set("Sales Price Direct","Phoenix_ProposedContract_Bid_Price_Sales__c");
        myMap.set("Sales Price Indirect", "Phoenix_Wholesaler_Sales_Price__c");
         }
        myMap.set("Proposed Direct Contract Price", "Phoenix_ProposedContractBidPriceMktng__c");
        myMap.set("Proposed Indirect Contract Price", "Phoenix_Wholesaler_Diff_Price_Indirect__c");
        
        myMap.set("Listing Price", "Listing_Price__c");
        myMap.set("Rebate/Fees %", "Phoenix_Proposed_Current_Rebate__c");
        myMap.set("Rebate/Fees $", "Phoenix_Net_Price_after_Rebates_Terms__c");
        myMap.set("PUR $", "Phoenix_Proposed_Per_Unit_Rebate__c");
         if(BidTypeVal != 'Platform OTB'){
        myMap.set("VIP $", "Phoenix_Wholesaler_VIP__c");
        myMap.set("Medicaid only", "Phoenix_Estimated_Medicaid_Returns__c");
         }
        myMap.set("Direct/Indirect CD", "Phoenix_Direct_CD__c");
        myMap.set("Direct Dead net per pack", "Phoenix_Direct_Dead_Net__c");
        myMap.set("Direct TPT $ per pack", "Phoenix_Direct_TP_In__c");
        myMap.set("Direct TPT % per pack", "Phoenix_Direct_TP__c");
        myMap.set("Direct Net Sales", "Proposed_Net_Sales_Direct__c");
        myMap.set("Direct TPT $", "Proposed_TPT_Direct__c");
        myMap.set("Direct TPT %", "Proposed_TPT_Per_Direct__c");
         if(BidTypeVal != 'Platform OTB'){
        myMap.set("RDC %", "Phoenix_RDC_NLC__c");
        myMap.set("RDC $ ", "Phoenix_RDC_NLC_Per_Unit_in__c");
         }
        myMap.set("CM Fees %", "Phoenix_Contract_Mngment_Fee_Wholesaler__c");
        myMap.set("CM Fees $", "Phoenix_Contract_Mngmnt_Fee_Wholesaler__c");
        myMap.set("Indirect Dead Net per pack", "Phoenix_Indirect_Dead_Net__c");
        myMap.set("Indirect TPT $ per pack", "Indirect_TP__c");
        myMap.set("Indirect TPT % per pack", "Phoenix_Indirect_TP__c");
        myMap.set("Indirect Net Sales", "Proposed_Net_Sales_Indirect__c");
        myMap.set("Indirect TPT $", "Proposed_TPT_Indirect__c");
        myMap.set("Indirect TPT %", "Proposed_TPT_Per_Indirect__c");
         if(BidTypeVal != 'Platform OTB'){
        myMap.set("Budgeted ASP","Phoenix_Budgeted_ASP1__c");
        myMap.set("Proposed as % of Budget","Phoenix_Proposed_to_Budget__c");
        myMap.set("Latest Estimate ASP","Phoenix_Latest_Estimate__c");
        myMap.set("Proposed as % of Latest Estimate","Phoenix_Proposed_as_of_Latest_Estimate__c");
         }
        myMap.set("Lowest Price /SKU","Phoenix_Lowest_Price_SKU__c");
         if(BidTypeVal != 'Platform OTB'){
        myMap.set("Approved Lowest Price /SKU","Phoenix_Approved_Lowest_Price_SKU__c");
         }
        if(BidTypeVal != 'One Time Buy Good Dated Shelf Life for New Product Launch' && BidTypeVal != 'Platform OTB'){
            myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
            myMap.set("SCM Rejection Reason","Phoenix_SCM_Rejection_Reason1__c");
            myMap.set("Revisit Date","Phoenix_Revisited_Date__c");
            myMap.set("Estimated Lead Time","Phoenix_Estimated_Lead_Time_Days__c");
            myMap.set("SCM Comments","Phoenix_SCM_Notes__c");
            myMap.set("Sales Notes","Phoenix_Sales_Notes__c");
        }
        myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
        myMap.set("Marketing Notes","Phoenix_Marketing_Notes__c");
        if(bidType == "Good Dated OTB" && BidTypeVal != 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType != "Platforn OTB" ){
            myMap.set("Marketing Lead Rx", "Phoenix_Marketing_Lead_Rx__c");
            myMap.set("Marketing Lead SRx", "Phoenix_Marketing_Lead_SRx__c");
            myMap.set("Marketing Lead OTC", "Phoenix_Marketing_Lead_OTC__c");
            myMap.set("Marketing Lead Comments", "Phoenix_Business_Head_Comments__c");
            myMap.set("Marketing Head Approval", "Phoenix_Approval__c");
            myMap.set("Marketing Head Comments", "Phoenix_Comments__c");   
        }
        myMap.set("Finance Approval","Phoenix_Finance_Approval__c");
        myMap.set("Finance Comments","Phoenix_Finance_Comments__c");       
        if(bidType == "Good Dated OTB" || BidTypeVal == 'One Time Buy Good Dated Shelf Life for New Product Launch'  ){
            myMap.set("Sr Director / VP Finance Approval", "Phoenix_Sr_Director_VP_Finance_Approval__c");
            myMap.set("Sr Director / VP Finance Comments", "Phoenix_Sr_Director_VP_Finance_Comments__c");
        }
        if(BidTypeVal != 'One Time Buy Good Dated Shelf Life for New Product Launch' ){
            
            myMap.set("Batch Number","Phoenix_Batch_Number__c");
            myMap.set("Expiry Date","Phoenix_Expiry_Date__c");    
            myMap.set("Primary Exclusion Customers","Primary_Exclusion_Customers__c"); 
            myMap.set("Secondary/Backup Exclusion Customers","Secondary_Backup_Exclusion_Customers__c"); 
            myMap.set("Final Exclusion Customers list","Final_Exclusion_Customers__c"); 
            if(BidTypeVal != 'Platform OTB'){
            myMap.set("Customer Service Status","Phoenix_Customer_Service_Status__c"); 
            myMap.set("Customer Service Comments","Phoenix_Customer_Service_Comments__c");
        }
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
                                            csvStringResult += '"'+ rounded_tpt +'"';
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }
                                    }
                                        else if(value == 'Phoenix_Direct_Dead_Net__c'){
                                            var deadnetprice=objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                                            //console.log('deadnetprice initialvalue-->'+deadnetprice);
                                            if(deadnetprice != null){
                                                var rounded_price=Math.round(deadnetprice * 100)/100
                                                //console.log('deadnetprice rounded value-->'+rounded_price);
                                                csvStringResult += '"'+ rounded_price +'"';
                                            }
                                            else{
                                                csvStringResult += '"'+''+'"';
                                            }
                                        }
                                            else if(value == 'Phoenix_Indirect_Dead_Net__c'){
                                                var deadnetpriceInd=objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                                                //console.log('deadnetprice initialvalue-->'+deadnetprice);
                                                if(deadnetpriceInd != null){
                                                    var rounded_price=Math.round(deadnetpriceInd * 100)/100
                                                    //console.log('deadnetprice rounded value-->'+rounded_price);
                                                    csvStringResult += '"'+ rounded_price +'"';
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
                                                        csvStringResult += '"'+ rounded_rebateperindl +'"'; 
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
                                                            csvStringResult += '"'+ rounded_adminfeeindl+'"'; 
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
                                                                csvStringResult += '"'+ rounded_vipperunitdl+'"'; 
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
                                                                    csvStringResult += '"'+ rounded_salesoutpmpudl+'"'; 
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
                                                                        csvStringResult += '"'+ rounded_iodperunitindl+'"'; 
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
                                                                            csvStringResult += '"'+ rounded_cdperunitdirect+'"'; 
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
                                                                                csvStringResult += '"'+ rounded_totalrdcnlcper+'"'; 
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
                                                                                    csvStringResult += '"'+ rounded_rdcnlcperunitindl+'"'; 
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
                                                                                        csvStringResult += '"'+ rounded_cmfeeperunit+'"'; 
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
                                                                                            csvStringResult += '"'+ rounded_medicaidretperunit+'"'; 
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
                                                                                                csvStringResult += '"'+ rounded_directdeadnet+'"'; 
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
                                                                                                    csvStringResult += '"'+ rounded_proposedzitd+'"'; 
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
                                                                                                        csvStringResult += '"'+ rounded_indirectdeadnet+'"'; 
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
                                                                                                            csvStringResult += '"'+ rounded_indirectdeadnet+'"'; 
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
                                                                                                                csvStringResult += '"'+ rounded_iodtotalamount+'"'; 
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
                                                                                                                    csvStringResult += '"'+ rounded_drldaednetafteriod+'"'; 
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
                                                                                                                        csvStringResult += '"'+ rounded_drldaednetafteriodwo+'"'; 
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
                                                                                                                            csvStringResult += '"'+ rounded_indirectcdperundl+'"'; 
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
                                                                                                                                csvStringResult += '"'+ rounded_indirectdeadnetmedret+'"'; 
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
                                                                                                                                    csvStringResult += '"'+ rounded_proposednetsalesdirect+'"'; 
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
                                                                                                                                        csvStringResult += '"'+ rounded_proposednetsalesindirect+'"'; 
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
                                                                                                                                            csvStringResult += '"'+ rounded_proposedtpdldirect+'"'; 
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
                                                                                                                                                csvStringResult += '"'+ rounded_proposedtpdlindirect+'"'; 
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
                                                                                                                                                    csvStringResult += '"'+ rounded_latestestimateasp+'"'; 
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
                                                                                                                                                                csvStringResult += '"'+''+'"';
                                                                                                                                                                // console.log('scm approval status is false');
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
    
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        $A.enqueueAction(action);
    }, 
    getCalculations : function(component,event,helper,currentValue,fieldName){  
        // component.set("v.isSpinner",true);
        var LineItem=component.get("v.singleRec");
        var LineItemId=LineItem.Id;
        var action = component.get("c.getCalcs");
        action.setParams({
            LineItem: LineItem,
            LineItemId: LineItemId,
            currentValue: currentValue,
            fieldLabel : fieldName
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()==='SUCCESS'){
                                   console.log('calc response--'+JSON.stringify(response.getReturnValue()));
                                   component.set("v.singleRec",response.getReturnValue());
                                   //component.set("v.isSpinner",false);
                               } else{
                                   //component.set("v.isSpinner",false);
                               }  
                           });      
        $A.enqueueAction(action);
    }
})