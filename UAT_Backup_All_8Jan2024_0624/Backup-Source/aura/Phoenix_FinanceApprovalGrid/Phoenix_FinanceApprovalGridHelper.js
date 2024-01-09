({
    getApprovalGrids : function(component, event, helper) {
        var bidId =component.get("v.recordId");
        component.set("v.financeCommentsMap", null);
        component.set("v.financeApprovalMap", null);
        component.set("v.financeBUCommentsMap", null);
        component.set("v.financeBUApprovalMap", null);
        component.set("v.financeSrDirCommentsMap", null);
        component.set("v.financeSrDirApprovalMap", null);
        component.set("v.isSpinnerLoad" , true);
        var action = component.get("c.viewApprovalGrid");
        action.setParams
        ({
            "bidId": bidId
        });
        console.log('bid recoreid-->'+bidId);
        action.setCallback(this, function(response) {
            var state = response.getState();
            var datalist = response.getReturnValue();
            
            if (state === "SUCCESS") {
                component.set("v.gridWrapper", datalist);
                console.log('reposeee-->'+ JSON.stringify(datalist));
               // component.set("v.isSpinnerLoad" , false);
                 window.setTimeout(
            $A.getCallback(function() {
                component.set("v.isSpinnerLoad", false);
            }), 3000
        );
                component.set("v.isOTC" , response.getReturnValue().isOTCBid);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
        
        
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords,template){
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
        csvStringResult = '';
        var selling_unit='1';
        var otc = component.get("v.isOTC");
        var myMap = new Map();
        myMap.set("Product Family", "Phoenix_Product_Family__c");
        myMap.set("Products below Lowest price / SKU", "Phoenix_Is_New_Low__c");
        myMap.set("Annualized TP", "Phoenix_Annualized_TP__c");
        myMap.set("Annualized TP Impact", "Phoenix_Annualized_TP_Impact__c");
        myMap.set("Annualized TP Impact Limit", "Phoenix_Annualized_TP_Impact_Limit__c");
        myMap.set("TP%", "Phoenix_TP__c");
        myMap.set("TP % Limit", "Phoenix_TP_Limit__c");
        myMap.set("Annualized GM", "Phoenix_Annualized_GM__c");
        myMap.set("Annualized GM Impact", "Phoenix_Annualized_GM_Impact__c");
        myMap.set("Annualized GM Impact Limit", "Phoenix_Annualized_GM_Impact_Limit__c");
        myMap.set("Revenue", "Phoenix_Revenue__c");
        myMap.set("Revenue Limit", "Phoenix_Revenue_Limit__c");
        myMap.set("GM%", "Phoenix_GM__c");
        myMap.set("GM% Limit", "Phoenix_GM_Limit__c");
        if(!otc){
            myMap.set("Marketing Lead Rx", "Phoenix_Marketing_Lead_Rx__c");
            myMap.set("Marketing Lead SRx", "Phoenix_Marketing_Lead_SRx__c");
        }
        myMap.set("Marketing Lead OTC", "Phoenix_Marketing_Lead_OTC__c");
        myMap.set("Marketing Lead Comments	", "Phoenix_Business_Head_Comments__c");
        myMap.set("Marketing Head Approval", "Phoenix_Approval__c");
        myMap.set("Marketing Head Comments", "Phoenix_Comments__c");
        myMap.set("Sr Director / VP Finance Approval", "Phoenix_Sr_Director_VP__c");
        myMap.set("Sr Director / VP Finance Comments", "Phoenix_Sr_Director_VP_Finance_Comments__c");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            console.log('test resuls-->'+JSON.stringify(objectRecords));
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                if(value == 'Phoenix_Is_New_Low__c' ){
                    var isNewLow= objectRecords[i]['Phoenix_Is_New_Low__c'];
                    if(isNewLow == true){
                        csvStringResult += '"'+ 'Yes'+'"'; 
                    }
                    else{
                        csvStringResult += '"'+ 'No'+'"'; 
                    }
                }
                else if(value == 'Phoenix_Annualized_GM__c'){
                    var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                    if(partnerproduct == true){
                        if(objectRecords[i]['Phoenix_Annualized_GM__c']==undefined){
                            
                            csvStringResult += '"'+''+'"';
                        }
                        else{
                            var annualizedgm = objectRecords[i]['Phoenix_Annualized_GM__c'];
                            console.log("annualizedgm--->"+annualizedgm);
                            if(annualizedgm != null){
                                var roundedannualizedgm=Math.round(annualizedgm)
                                csvStringResult += '"'+roundedannualizedgm+'"';  
                            }
                            else{
                                csvStringResult += '"'+''+'"';
                            }
                            //csvStringResult += '"'+ objectRecords[i]["Phoenix_Annualized_GM__c"]+'"';
                        }
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                        
                    }
                }
                    else if(value == 'Phoenix_Annualized_GM_Impact__c'){
                        var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                        if(partnerproduct == true){
                            if(objectRecords[i]['Phoenix_Annualized_GM_Impact__c']==undefined){
                                
                                csvStringResult += '"'+''+'"';
                            }
                            else{
                                var annualizedgmimpact = objectRecords[i]['Phoenix_Annualized_GM_Impact__c'];
                                console.log("annualizedgmimpact--->"+annualizedgmimpact);
                                if(annualizedgmimpact != null){
                                    var roundedannualizedgmimpact=Math.round(annualizedgmimpact)
                                    csvStringResult += '"'+roundedannualizedgmimpact+'"';  
                                }
                                else{
                                    csvStringResult += '"'+''+'"';
                                }
                                //csvStringResult += '"'+ objectRecords[i]["Phoenix_Annualized_GM_Impact__c"]+'"';
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                            
                        }
                    }
                        else if(value == 'Phoenix_Annualized_GM_Impact_Limit__c'){
                            var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                            if(partnerproduct == true){
                                if(objectRecords[i]['Phoenix_Annualized_GM_Impact_Limit__c']==undefined){
                                    
                                    csvStringResult += '"'+''+'"';
                                }
                                else{
                                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Annualized_GM_Impact_Limit__c"]+'"';
                                }
                            }
                            else{
                                csvStringResult += '"'+''+'"';
                                
                            }
                        }
                            else if(value == 'Phoenix_GM__c'){
                                var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                                if(partnerproduct == true){
                                    if(objectRecords[i]['Phoenix_GM__c']==undefined){
                                        
                                        csvStringResult += '"'+''+'"';
                                    }
                                    else{
                                        csvStringResult += '"'+ objectRecords[i]["Phoenix_GM__c"]+'"';
                                    }
                                }
                                else{
                                    csvStringResult += '"'+''+'"';
                                    
                                }
                            }
                                else if(value == 'Phoenix_GM_Limit__c'){
                                    var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                                    if(partnerproduct == true){
                                        if(objectRecords[i]['Phoenix_GM_Limit__c']==undefined){
                                            
                                            csvStringResult += '"'+''+'"';
                                        }
                                        else{
                                            csvStringResult += '"'+ objectRecords[i]["Phoenix_GM_Limit__c"]+'"';
                                        }
                                    }
                                    else{
                                        csvStringResult += '"'+''+'"';
                                        
                                    }
                                }
                                    else if(value == 'Phoenix_Annualized_TP__c'){
                                        var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                                        if(partnerproduct == false){
                                            if(objectRecords[i]['Phoenix_Annualized_TP__c']==undefined){
                                                
                                                csvStringResult += '"'+''+'"';
                                            }
                                            else{
                                                csvStringResult += '"'+ objectRecords[i]["Phoenix_Annualized_TP__c"]+'"';
                                            }
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                            
                                        }                     
                                    }
                                        else if(value == 'Phoenix_Annualized_TP_Impact__c'){
                                            var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                                            if(partnerproduct == false){
                                                if(objectRecords[i]['Phoenix_Annualized_TP_Impact__c']==undefined){
                                                    
                                                    csvStringResult += '"'+''+'"';
                                                }else{
                                                    var annualizedtpimpact = objectRecords[i]['Phoenix_Annualized_TP_Impact__c'];
                                                    console.log("annualizedtpimpact--->"+annualizedtpimpact);
                                                    if(annualizedtpimpact != null){
                                                        var roundeannualizedtpimpact=Math.round(annualizedtpimpact)
                                                        csvStringResult += '"'+roundeannualizedtpimpact+'"';  
                                                    }
                                                    else{
                                                        csvStringResult += '"'+''+'"';
                                                    }
                                                }
                                            }
                                            else{
                                                csvStringResult += '"'+''+'"';
                                            }
                                        }
                                            else if(value == 'Phoenix_Annualized_TP_Impact_Limit__c'){
                                                var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                                                if(partnerproduct == false){
                                                    if(objectRecords[i]['Phoenix_Annualized_TP_Impact_Limit__c']==undefined){
                                                        
                                                        csvStringResult += '"'+''+'"';
                                                    }
                                                    else{
                                                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Annualized_TP_Impact_Limit__c"]+'"';
                                                    }
                                                }
                                                else{
                                                    csvStringResult += '"'+''+'"';
                                                    
                                                }                     
                                            }
                                                else if(value == 'Phoenix_TP__c'){
                                                    var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                                                    if(partnerproduct == false){
                                                        if(objectRecords[i]['Phoenix_TP__c']==undefined){
                                                            
                                                            csvStringResult += '"'+''+'"';
                                                        }
                                                        else{
                                                            var tppercentage = objectRecords[i]['Phoenix_TP__c'];
                                                            console.log("tppercentage--->"+tppercentage);
                                                            if(tppercentage != null){
                                                                var roundetppercentage=Math.round(tppercentage*100)/100
                                                                csvStringResult += '"'+roundetppercentage+'"';  
                                                            }
                                                            else{
                                                                csvStringResult += '"'+''+'"';
                                                            }
                                                            
                                                        }
                                                    }
                                                    else{
                                                        csvStringResult += '"'+''+'"';
                                                        
                                                    }                     
                                                }
                                                    else if(value == 'Phoenix_TP_Limit__c'){
                                                        var partnerproduct = objectRecords[i]['Phoenix_Is_partner_product__c']
                                                        if(partnerproduct == false){
                                                            if(objectRecords[i]['Phoenix_TP_Limit__c']==undefined){
                                                                
                                                                csvStringResult += '"'+''+'"';
                                                            }
                                                            else{
                                                                csvStringResult += '"'+ objectRecords[i]["Phoenix_TP_Limit__c"]+'"';
                                                            }
                                                        }
                                                        else{
                                                            csvStringResult += '"'+''+'"';
                                                            
                                                        }                     
                                                    }
                                                        else  if(objectRecords[i][value]==undefined){
                                                            
                                                            csvStringResult += '"'+''+'"';
                                                        }
                                                            else{
                                                                csvStringResult += '"'+ objectRecords[i][value]+'"';
                                                            }
                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        
        return csvStringResult;        
    }
    
})