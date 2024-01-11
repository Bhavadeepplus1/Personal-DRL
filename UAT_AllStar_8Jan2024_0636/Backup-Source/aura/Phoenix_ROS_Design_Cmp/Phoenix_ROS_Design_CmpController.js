({
    collpase  : function(component, event, helper) {
        var LineItemtable = component.find("LineTable");
        $A.util.toggleClass(LineItemtable, "fixedtable");
    },
    hideSubmitModel : function(component, event, helper) { 
        component.set('v.submitModel',false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },
    proceedToSubmit : function(component, event, helper) { 
        if(component.get("v.BidAprrovalStatus")=='Draft'){
            var bidType = component.get("v.BidTypeVal");
            if(component.get("v.syncConfirmed") != 'CONFIRMED' && bidType != 'Customer Rebate Change' && bidType != 'Sales Out Rebate' && bidType != 'Price Change'){
                component.set('v.submitModel',false);
                component.set("v.showSyncPopup",true);
            }
            else{
                component.set("v.showSyncPopup",false);
                component.set('v.submitModel',false);
                var LineItemtable = component.find("LineTable");
                $A.util.addClass(LineItemtable, "maintable");
                helper.getBidInfoForValids(component,event,helper);
            }
        }
    },
    showSummaryPopup: function(component, event, helper){
        component.set("v.showSummaryPopup", !component.get("v.showSummaryPopup"));
    },
    submitFor : function(component, event, helper) { 
         component.set('v.submitModel',false);
        component.set('v.isSpinnerLoad',true);
        var contrcts=component.get('v.selectedCntrcts');
        var bidType=component.get("v.BidTypeVal");
        var bidrecord=component.get("v.bidRecord");
        var isBidNotValid;
        var isOverrideUnitsavl = false;
        console.log('bidrecord.Phoenix_Initial_Order_Discount_Type__c :: -- > '+bidrecord.Phoenix_Initial_Order_Discount_Type__c);
        if(bidrecord.Phoenix_Reference_Contracts__c==null && bidType!='New Customer'){
            isBidNotValid= "Please Select a Contract";          
        }else if(bidType == 'Sales Out Rebate' && (bidrecord.Phoenix_Sales_Out_Promotion_of_Days__c == null || bidrecord.Phoenix_Sales_Out_Promotion_of_Days__c == '' )){
            isBidNotValid= "Please Enter Sales Out Promotion # of Days";
        }else if(bidType == 'Sales Out Rebate' && (bidrecord.Phoenix_Proposed_Sales_Out_Promotion__c == null || bidrecord.Phoenix_Proposed_Sales_Out_Promotion__c == '')){
            isBidNotValid="Please Enter Proposed Sales Out Promotion %";
        }else if((bidType == 'Product Addition'|| bidType == 'Price Change' || bidType == 'New Product Launch') && (bidrecord.Phoenix_Proactive_Reactive__c== null || bidrecord.Phoenix_Proactive_Reactive__c == '')){
            isBidNotValid= "Please Select Proactive/Reactive";
        }else if((bidType == 'Product Addition' || bidType == 'RFP Bids' || bidType == 'New Product Launch') && 
                 (bidrecord.Phoenix_Initial_Order_Discount_Type__c==null || bidrecord.Phoenix_Initial_Order_Discount_Type__c=='')){  
            isBidNotValid= "Please Select Initial Order Discount Type";
        }else if((bidType == 'Product Addition' || bidType == 'RFP Bids' || bidType == 'New Product Launch') && 
                 (bidrecord.Phoenix_Initial_Order_Discount_of_Days__c == null || bidrecord.Phoenix_Initial_Order_Discount_of_Days__c== '' || bidrecord.Phoenix_Initial_Order_Discount_of_Days__c == 0 ) && 
                 bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'None' && bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'Not Applicable'){
            var InitialOrderDays = bidrecord.Phoenix_Initial_Order_Discount_of_Days__c;
            isBidNotValid = InitialOrderDays == 0 ? 'Initial Order Discount # of Days must be greater than 0' : 'Please Enter Initial Order Discount # of Days';
        }else if((bidType == 'Product Addition' || bidType == 'RFP Bids' || bidType == 'New Product Launch') && 
                 (bidrecord.Phoenix_Proposed_Initial_Order_Discount__c == null || bidrecord.Phoenix_Proposed_Initial_Order_Discount__c== '' || bidrecord.Phoenix_Proposed_Initial_Order_Discount__c== 0) && 
                 bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'None' && bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'Not Applicable'){
            isBidNotValid = InitialOrderDays < 1 ? 'Proposed Initial Order Discount % must be greater than 0' : 'Please Enter Proposed Initial Order Discount %';
        }
        if(isBidNotValid){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":isBidNotValid
            });
            toastEvent.fire();
            component.set('v.isSpinnerLoad',false);  
        }           
        else{
            component.set('v.isSpinnerLoad',true);
            var qtyError;
            var templateType=component.get("v.templateType");
            var action = component.get("c.getupdatedforExport");      
            action.setParams
            ({
                bidId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var isBisCanSubmit = false;
                                       console.log("Inside success of getupdatedforExport");
                                       var bidlines =  response.getReturnValue();
                                       component.set("v.ResponseList",bidlines);
                                      
                                       var indirectCons = new Array();
                                       var DirectCons = new Array();
                                       indirectCons=contrcts.filter((contrcts) => contrcts.startsWith("3"));
                                       DirectCons=contrcts.filter((contrcts) => contrcts.startsWith("1"));
                                       console.log("indirectCons---->"+indirectCons.includes("3000000224"));
                                       console.log("indirectCons-type--->"+typeof(indirectCons));
                                       var isCvsIndirect = (indirectCons != null && (indirectCons.includes("3000000485") || 
                                                                                     indirectCons.includes("3000000484") || 
                                                                                     indirectCons.includes("3000000483")));
                                       var isMajor = (indirectCons != null && (indirectCons.includes("3000000753")));
                                       var isCardinal = (indirectCons != null && indirectCons.includes("3000000489"));
                                       var isCvsDirect = (DirectCons != null && DirectCons.includes("1000000449"));
                                       for(var i=0;i<bidlines.length;i++){
                                           console.log('size--->'+bidlines.length);
                                           bidlines[i].Phoenix_Proposed_Position__c = bidlines[i].Phoenix_Proposed_Position__c != null ? bidlines[i].Phoenix_Proposed_Position__c : '';
                                           bidlines[i].Phoenix_Current_Position__c = bidlines[i].Phoenix_Current_Position__c != null ? bidlines[i].Phoenix_Current_Position__c : '';
                                           console.log('bidType---->'+bidType);
                                           console.log('IValue---->'+i);
                                           console.log('Phoenix_Proposed_CVS_DirSellingUnits__c---->'+bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c);
                                           console.log('Phoenix_Proposed_CVS_IndirSellingUnits__c---->'+bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c);
                                           console.log('Phoenix_Proposed_Cardinal_Units__c---->'+bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c);
                                           console.log('Phoenix_Proposed_Major_Units__c---->'+bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c);
                                           
                                           if(bidType!='Price Change' && bidType!='Customer Rebate Change' && bidType !='Sales Out Rebate' && 
                                              (bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c ==null || 
                                               bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c==null || 
                                               bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c ==null || 
                                               bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c == null)){
                                               isBisCanSubmit = true;
                                               console.log('product Name-->'+bidlines[i].Phoenix_Product__r.Name);
                                               break;
                                           }
                                           if(!isBisCanSubmit){
                                               if(bidType!='Price Change' 
                                                  && bidType!='Customer Rebate Change' 
                                                  && bidType !='Sales Out Rebate' 
                                                  && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c == 0 && 
                                                      bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c== 0 && 
                                                      bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c == 0 &&
                                                      bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c == 0)){
                                                   qtyError='All Proposed units can not be 0. Please review again for Product: '+bidlines[i].Phoenix_Product__r.Name;
                                                   console.log('All Proposed units can not be 0. Please review again for Product');
                                                   break;
                                               }
                                               if((bidlines[i].Phoenix_Proposed_Position__c.includes('Primary')
                                                   || bidlines[i].Phoenix_Current_Position__c.includes('Primary'))
                                                  && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c != 40
                                                      || bidlines[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c != 40)){
                                                   qtyError='Primary position line items should have default 40% for rebate percentage for '+bidlines[i].Phoenix_Product__r.Name;
                                                   break;
                                               }
                                               if(bidType!='Price Change' 
                                                  && bidType!='Customer Rebate Change' 
                                                  && bidType !='Sales Out Rebate' 
                                                  && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c ==null )
                                                  && isCvsDirect){
                                                   qtyError='Please Enter The Proposed CVS Direct Units for '+bidlines[i].Phoenix_Product__r.Name;
                                                   console.log('Please Enter The Proposed CVS Direct Units for');
                                                   break;
                                               }
                                               if(bidType!='Price Change' 
                                                  && bidType!='Customer Rebate Change' 
                                                  && bidType !='Sales Out Rebate' 
                                                  && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c ==null )
                                                  && isCvsIndirect){
                                                   qtyError='Please Enter The Proposed CVS Indirect Units for '+bidlines[i].Phoenix_Product__r.Name;
                                                   console.log('Please Enter The Proposed CVS Indirect Units for');
                                                   break;
                                               }
                                               if(bidType!='Price Change' 
                                                  && bidType!='Customer Rebate Change' 
                                                  && bidType !='Sales Out Rebate' 
                                                  && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c ==null )
                                                  && isCardinal){
                                                   qtyError='Please Enter The Proposed Cardinal Units for '+bidlines[i].Phoenix_Product__r.Name;
                                                   break;
                                               }
                                               if(bidType!='Price Change' 
                                                  && bidType!='Customer Rebate Change' 
                                                  && bidType !='Sales Out Rebate' 
                                                  && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c ==null )
                                                  && isMajor){
                                                   qtyError='Please Enter The Proposed Major Units for '+bidlines[i].Phoenix_Product__r.Name;
                                                   break;
                                               }
                                               if(bidlines[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c == null 
                                                  && component.get("v.isMarketingApprovePerson")==component.get("v.loggedInUserName") 
                                                  && (component.get("v.loggedInUserName")== bidlines[i].Phoenix_Product_Director1__c)// ||(delegatedUser != null && delegatedUser.includes(bidlines[i].Phoenix_Product_Director1__c)))////
                                                  && bidType!='Customer Rebate Change' && bidType!='Volume Review Only' 
                                                  && bidType !='Sales Out Rebate'){
                                                   qtyError='Please Enter Proposed Marketing CVS/Cardinal Acquisition Costs';
                                                   console.log('wholesaler Price');
                                                   break;
                                               }
                                            /*   else if (component.get("v.BidAprrovalStatus")=='Draft'&& bidType == 'New Product Launch' && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Customer_Dead_Net1__c < bidlines[i].Phoenix_Lowest_Price_SKU__c && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Customer_Dead_Net1__c !=0){
                                                   if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                       qtyError='You cannot submit this Bid for Approval as Internal Cardinal Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                       break;
                                                   }
                                                   else {
                                                       break;
                                                   }
                                               }
                                                   else if (component.get("v.BidAprrovalStatus")=='Draft'&& bidType == 'New Product Launch' && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c < bidlines[i].Phoenix_Lowest_Price_SKU__c && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c !=0){
                                                       if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                           qtyError='You cannot submit this Bid for Approval as Internal Major Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                           break;
                                                       }
                                                       else {
                                                           break;
                                                       }
                                                   }
                                                       else if (component.get("v.BidAprrovalStatus")=='Draft'&& bidType == 'New Product Launch' && bidlines[i].Phoenix_Direct_Dead_Net__c < bidlines[i].Phoenix_Lowest_Price_SKU__c && bidlines[i].Phoenix_Direct_Dead_Net__c !=0 && ( bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c > bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c
                                                                                                                                                                                                                                                                                      || bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c == bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c)){
                                                           if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                               qtyError='You cannot submit this Bid for Approval as Internal CVS Direct Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                               break;
                                                           }
                                                           else {
                                                               break;
                                                           }
                                                       }
                                                           else if (component.get("v.BidAprrovalStatus")=='Draft'&& bidType == 'New Product Launch' && bidlines[i].Phoenix_Indirect_Dead_Net__c < bidlines[i].Phoenix_Lowest_Price_SKU__c && bidlines[i].Phoenix_Indirect_Dead_Net__c !=0 && ( bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c > bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c
                                                                                                                                                                                                                                                                                              || bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c == bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c)){
                                                               if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                                   qtyError='You cannot submit this Bid for Approval as Internal CVS Indirect Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                                   break;
                                                               }
                                                               else {
                                                                   break;
                                                               }
                                                           }
                                              */
                                               // for ovveride units
                                         /*   else if (bidType != 'New Product Launch' && (bidlines[i].Phoenix_Override_Current_Direct_Units__c == null && (bidlines[i].Phoenix_Current_Retail_Direct_Units__c == 0 || bidlines[i].Phoenix_Current_Retail_Direct_Units__c == undefined || bidlines[i].Phoenix_Current_Retail_Direct_Units__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	//break;
                        					}
                                                else if (bidType != 'New Product Launch' && (bidlines[i].Phoenix_Override_Current_Indirect_Units__c == null && (bidlines[i].Phoenix_Current_Retail_Indirect_Units__c == 0 || bidlines[i].Phoenix_Current_Retail_Indirect_Units__c == undefined || bidlines[i].Phoenix_Current_Retail_Indirect_Units__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	//break;
                        					}
                                                else if (bidType != 'New Product Launch' && (bidlines[i].Phoenix_Override_Current_Units__c == null && (bidlines[i].Phoenix_Current_Wholesaler_Units__c == 0 || bidlines[i].Phoenix_Current_Wholesaler_Units__c == undefined || bidlines[i].Phoenix_Current_Wholesaler_Units__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	//break;
                        					}
                                                else if (bidType != 'New Product Launch' && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c == null && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c == 0 || bidlines[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c == undefined || bidlines[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	//break;
                        					}*/
                                               
                                           // for ovveride units end
                  
                                               /*For Delegation User*/
                                                           /*    else if (component.get("v.BidAprrovalStatus")=='Draft'&& bidType == 'New Product Launch' && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Customer_Dead_Net1__c < bidlines[i].Phoenix_Lowest_Price_SKU__c && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Customer_Dead_Net1__c !=0)// && (delegatedUser != null && delegatedUser.includes(bidlines[i].Phoenix_Product_Director1__c))
                                                               {
                                                                   if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                                       qtyError='You cannot submit this Bid for Approval as Internal Cardinal Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                                       break;
                                                                   }
                                                                   else {
                                                                       break;
                                                                   }
                                                               }
                                                                   else if (component.get("v.BidAprrovalStatus")=='Draft'
                                                                            && bidType == 'New Product Launch' 
                                                                            && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c < bidlines[i].Phoenix_Lowest_Price_SKU__c 
                                                                            && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c !=0// && (delegatedUser != null && delegatedUser.includes(bidlines[i].Phoenix_Product_Director1__c))
                                                                           ){
                                                                       if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                                           qtyError='You cannot submit this Bid for Approval as Internal Major Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                                           break;
                                                                       }
                                                                       else {
                                                                           break;
                                                                       }
                                                                   }
                                                                       else if (component.get("v.BidAprrovalStatus")=='Draft'
                                                                                && bidType == 'New Product Launch'
                                                                                && bidlines[i].Phoenix_Direct_Dead_Net__c < bidlines[i].Phoenix_Lowest_Price_SKU__c 
                                                                                && bidlines[i].Phoenix_Direct_Dead_Net__c !=0 //&& (delegatedUser != null && delegatedUser.includes(bidlines[i].Phoenix_Product_Director1__c))
                                                                                && ( bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c > bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c
                                                                                    || bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c == bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c)){
                                                                           if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                                               qtyError='You cannot submit this Bid for Approval as Internal CVS Direct Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                                               break;
                                                                           }
                                                                           else {
                                                                               break;
                                                                           }
                                                                       }
                                                                           else if (component.get("v.BidAprrovalStatus")=='Draft'
                                                                                    && bidType == 'New Product Launch' 
                                                                                    && bidlines[i].Phoenix_Indirect_Dead_Net__c < bidlines[i].Phoenix_Lowest_Price_SKU__c 
                                                                                    && bidlines[i].Phoenix_Indirect_Dead_Net__c !=0 //&& (delegatedUser != null && delegatedUser.includes(bidlines[i].Phoenix_Product_Director1__c)) 
                                                                                    && ( bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c > bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c
                                                                                        || bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c == bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c)){
                                                                               if (bidlines[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                                                                   qtyError='You cannot submit this Bid for Approval as Internal CVS Indirect Dead Net is less than Lowest Price/SKU: '+bidlines[i].Phoenix_Product__r.Name;
                                                                                   break;
                                                                               }
                                                                               else {
                                                                                   break;
                                                                               }
                                                                           }*/
                                               /*End for Delegation User*/
                                               var keyValue = 0;
                                               var prices = [];
                                               var mapDeadNets = new Map();
                                               if(bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c != null && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c != 0){
                                                   prices.push(bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c);
                                                   mapDeadNets.set('CVS Direct Contract Price',bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c);
                                               }
                                               if(bidlines[i].Phoenix_Wholesaler_Diff_Price_Indirect__c != null && bidlines[i].Phoenix_Wholesaler_Diff_Price_Indirect__c != 0){
                                                   prices.push(bidlines[i].Phoenix_Wholesaler_Diff_Price_Indirect__c);
                                                   mapDeadNets.set('CVS Cardinal Contract Price',bidlines[i].Phoenix_Wholesaler_Diff_Price_Indirect__c);
                                               }
                                               if(bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c != null && bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c != 0){
                                                   prices.push(bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c);
                                                   mapDeadNets.set('CVS Major Contract Price',bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c);
                                               }
                                               
                                               if(prices.length > 0){
                                                   prices.sort(function(a, b){return b-a});
                                                   console.log('prices[0] ::: '+prices[0]);
                                                   console.log('bidlines[i].Phoenix_WAC__c ::: '+bidlines[i].Phoenix_WAC__c);
                                                   
                                                   if(prices[0]>bidlines[i].Phoenix_WAC__c){
                                                       keyValue = prices[0];//getKeyByValue(mapDeadNets, prices[0]);
                                                       
                                                   }
                                               }
                                               if(keyValue != 0){
                                                   if(keyValue === bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c){
                                                       qtyError='Proposed CVS Direct Contract Price can not be Greater than WAC for '+bidlines[i].Phoenix_Product__r.Name;
                                                       break;	
                                                   }
                                                   if(keyValue === bidlines[i].Phoenix_Wholesaler_Diff_Price_Indirect__c){
                                                       qtyError='Proposed Cardinal Contract Price can not be Greater than WAC for '+bidlines[i].Phoenix_Product__r.Name;
                                                       break;	
                                                   }
                                                   if(keyValue === bidlines[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c){
                                                       qtyError='Proposed Major Contract Price can not be Greater than WAC for '+bidlines[i].Phoenix_Product__r.Name;
                                                       break;	
                                                   }
                                               }
                                           }
                                           console.log('IValueEND---->'+i);
                                       }
                                       console.log('isBisCanSubmit--->'+isBisCanSubmit);
                                      // console.log('isOverrideUnitsavl--->'+isOverrideUnitsavl);
                                       
                                       if(isBisCanSubmit){
                                           component.set("v.fieldRequiredModel",true);
                                       }
                                       // var modalMessage = isOverrideUnitsavl ? 'The 3 Months Annualized Selling Units is 0. Are you sure you want to submit this bid for approval?' : 'Are you sure you want to submit this bid for approval?';
                                      // component.set('v.modalMessage',modalMessage);
                                   }
                                   if(qtyError){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Error!",
                                           "type":"error",
                                           "message":qtyError
                                       });
                                       toastEvent.fire();
                                       component.set('v.isSpinnerLoad',false);
                                   }else if(!isBisCanSubmit){
                                       component.set('v.isSpinnerLoad',false);
                                       component.set('v.submitModel',true);
                                       var LineItemtable = component.find("LineTable");
                                       $A.util.removeClass(LineItemtable, "maintable");
                                       console.log(component.get('v.submitModel'));
                                   }
                               });
            $A.enqueueAction(action);
        }
    },
    
    handleCalcEvent :function(component, event, helper) { 
        helper.getAllTotalValues(component,event,helper);
        //helper.handleCalcEventHelper(component, event, helper);
    },
    
    initRecords: function(component, event, helper) { 
        component.set("v.selectedPosistions",[]);//added by satya
        component.find("Tabset").set("v.selectedTabId",'EBLI');   
        component.set("v.isSpecificCustomer",false);
        component.set("v.templateType","");
        component.set('v.isSpinnerLoad',true);
        component.set('v.selectedCntrcts',[]);
        component.set('v.lstSelectedRecords',[]);
        component.set('v.lstSelectedPDRecords',[]);
        component.set('v.showSaveCancelBtn',false);
        component.set('v.isRxChecked',false);
        component.set('v.isSRxChecked',false);
        component.set('v.isOtcChecked',false); 
        component.set('v.RxSrxList',[]); 
        component.set("v.BidTypeVal","");
        console.log('---'+component.find("bidCntrcts"));
        component.set('v.recordId', component.get("v.pageReference").state.c__id);
        console.log('---record--id--from url-'+component.get('v.recordId')); 
        console.log('----featchNPR Param From URL ---'+component.get("v.pageReference").state.c__fetchNprData);
        var action = component.get("c.getRelatedList");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               console.log('response.getState() of getRelatedList --- '+response.getState());
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj =  response.getReturnValue();
                                   var lineItemsList = wrapperObj.lineItemsList;
                                   var columnList = wrapperObj.columnList;
                                   var bidRecord = wrapperObj.bidRecord;
                                   component.set("v.bidRecord",bidRecord);
                                   var loggedinUserName=wrapperObj.loggedInUserName;
                                   var isMarketingApprovePerson=wrapperObj.isMarketingApprovePerson;
                                   var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                   var ismarketingDeligator = wrapperObj.ismarketingDeligator;
                                   var deligatedUserName = wrapperObj.deligatedUserName;
                                   var showProceedBtn=wrapperObj.showProceedBtn;
                                   var hasDirectorLines=wrapperObj.hasDirectorLines;                                   
                                   console.log('isContractsApprovePerson---'+isContractsApprovePerson);
                                   component.set("v.isMarketingApprovePerson",isMarketingApprovePerson); 
                                   component.set("v.isContractsApprovePerson",isContractsApprovePerson); 
                                   component.set("v.showProceedBtn",showProceedBtn);
                                   component.set("v.hasDirectorLines",hasDirectorLines);
                                   component.set("v.ismarketingDeligator", ismarketingDeligator);
                                   component.set("v.deligatedUserName", deligatedUserName);
                                   component.set("v.customerId",bidRecord.Phoenix_Customer__c);
                                   console.log('crnt--vip'+bidRecord.Phoenix_Current_Value_Est_VIP__c);
                                   component.set("v.crntVipVal",bidRecord.Phoenix_Current_Value_Est_VIP__c);
                                   var iodType = bidRecord.Phoenix_Initial_Order_Discount_Type__c != null ? bidRecord.Phoenix_Initial_Order_Discount_Type__c : 'None';
                                   var iodDays = bidRecord.Phoenix_Initial_Order_Discount_of_Days__c != null ? bidRecord.Phoenix_Initial_Order_Discount_of_Days__c : '';
                                   var iodDiscount = bidRecord.Phoenix_Proposed_Initial_Order_Discount__c != null ? bidRecord.Phoenix_Proposed_Initial_Order_Discount__c : '';
                                   
                                   if(iodType != 'None' && iodType != 'Applicable' && iodType != 'Not Applicable'){
                                       iodType = 'None';
                                       iodDays = '';
                                       iodDiscount = '';
                                   }
                                   
                                   component.set("v.IODType",iodType);
                                   component.set("v.iodDays",iodDays);
                                   component.set("v.iodDiscount",iodDiscount);
                                   if(lineItemsList.length == 0 || component.get("v.recordId") == null){
                                       component.set("v.isRelatedLineItemsEmpty", false);
                                   }
                                   
                                   component.set('v.defaultlistOfProductFamily', wrapperObj.productfamilyList);
                                   if( wrapperObj.productDirectorList!=null){
                                       component.set('v.defaultlistOfProductDirectors', wrapperObj.productDirectorList);
                                   }                                  
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set("v.ItemsLength",lineItemsList.length);
                                   component.set('v.isSpinnerLoad',false);                                  
                                   component.set("v.templateType",bidRecord.Phoenix_Customer_Type__c);
                                   component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   console.log('refcontrcts--'+bidRecord.Phoenix_Reference_Contracts__c);
                                   if( bidRecord.Phoenix_Reference_Contracts__c!=null && bidRecord.Phoenix_Reference_Contracts__c!=undefined){
                                       var refContracts=bidRecord.Phoenix_Reference_Contracts__c;
                                       component.set("v.selectedCntrcts",refContracts.split(','));
                                   }
                                   /*Product Position Logic*/
                                   
                                   /* Added by satya*/
                                   if (bidRecord.Phoenix_Bid_Proposed_Position__c != null && bidRecord.Phoenix_Bid_Proposed_Position__c != undefined) {
                                       var refPositions = bidRecord.Phoenix_Bid_Proposed_Position__c;
                                       component.set("v.selectedPosistions", refPositions.split(','));
                                   }
                                   /* Added by satya*/
                                   /*Product Position Logic*/
                                   console.log('bidRecord.Phoenix_Bid_Type__c---'+bidRecord.Phoenix_Bid_Type__c);
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                       component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   console.log('bidRecord.Phoenix_Approval_Status__c---'+bidRecord.Phoenix_Approval_Status__c);
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                       /* if(bidRecord.Phoenix_Approval_Status__c=='Finance'){
                                           component.find("Tabset").set("v.selectedTabId",'FIV'); 
                                       }
                                       if(bidRecord.Phoenix_Approval_Status__c=='Contracts'){
                                           component.find("Tabset").set("v.selectedTabId",'Contracts'); 
                                       } */
                                   }
                                   console.log('loggedinUserName--'+loggedinUserName);
                                   if( loggedinUserName!=null && loggedinUserName!=undefined){
                                       component.set("v.loggedInUserName",loggedinUserName);
                                   }
                                   if( bidRecord.Phoenix_Is_Re_Bid__c!=null && bidRecord.Phoenix_Is_Re_Bid__c!=undefined && bidRecord.Phoenix_Is_Re_Bid__c==true){
                                       component.set("v.isReBid",true);
                                   }else{
                                       component.set("v.isReBid",false);
                                   }
                                   
                                   
                                   var OutDiv = component.find("mainDiv");
                                   if(lineItemsList.length<10){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "noheightClass");
                                   }else{
                                       $A.util.removeClass(OutDiv, "noheightClass");
                                   }
                                   helper.getAllTotalValues(component,event,helper);
                                   var LineItemtable = component.find("LineTable");                                  
                                   component.set("v.tableRef",LineItemtable);    
                                   if(component.get("v.pageReference").state.c__fetchNprData != undefined){
                                       var refContracts=bidRecord.Phoenix_Reference_Contracts__c;
                                       if(refContracts != undefined && refContracts != '' && refContracts != null){
                                           console.log('getting NPR data. INSIDE pageReference of fetch NPR Data.');
                                           helper.getNPRDataOfContracts(component, 
                                                                        event, 
                                                                        helper,
                                                                        refContracts.split(','),
                                                                        bidRecord.Phoenix_Customer_Type__c);
                                       }
                                   }
                               }
                               else{
                                   console.log('THERE IS AN ERROR IN RESPONSE WHILE getRaltedList');
                                   component.set('v.isSpinnerLoad',false);
                               }
                           });
        $A.enqueueAction(action);
        
    }, 
    initFinnaceCmp : function(component, event, helper) {
        var financeCmp = component.find('financeChildCmp');
        financeCmp.financeRefresh();
    },
    initSCMCmp : function(component, event, helper) {
        var SCMCmp = component.find('SCMChildCmp');
        SCMCmp.scmRefresh();
    },    
    initNDCFinanceCmp : function(component, event, helper) {
        var NDCFinance = component.find('NDCFinance');
        NDCFinance.scmRefresh();
    },
    initRejectedStatus : function(component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.rejectedStatusRefresh();
    },
    initContractsView : function(component, event, helper) {
        var rejectedStatus = component.find('ContractsTab');
        rejectedStatus.ContractsViewRefresh();
    },
    initManagementCmp : function(component, event, helper) {
        var NDCFinance = component.find('ApprovalGrid');
        NDCFinance.scmRefresh();
    },
    initNewCustomerView : function(component, event, helper) {
        var rejectedStatus = component.find('CustomersTabNew');
        rejectedStatus.scmRefresh();
    },
    backToBid : function(component, event, helper){
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
        
    },
    handleOnload : function(component, event, helper) {      
        /*var recUi = event.getParam("recordUi");           
        var pVip=recUi.record.fields["Phoenix_Proposed_Value_Est_VIP__c"].value;
        console.log('pVip--'+pVip);
        var crntVip=recUi.record.fields["Phoenix_Current_Value_Est_VIP__c"].value;
        console.log('crntVip--'+crntVip);
        var crntvipvalue;
        if(crntVip != null && crntVip!=undefined){
            crntvipvalue= crntVip;
        }
        console.log('crntvipvalue--'+component.get("v.crntVipVal"));
        if(component.get("v.BidTypeVal")!='New Customer' && (crntvipvalue==0 || crntvipvalue==null)){
            component.set("v.VipReadOnly",true);
        }else{
            component.set("v.VipReadOnly",false);
        }
        console.log('vipreadonly--'+component.get("v.VipReadOnly")); */
    },
    /* iodTypeChange : function(component, event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        if(event.getSource().get("v.value")=='None' || event.getSource().get("v.value")==''){
            component.find("iodDays").set("v.value",null);
            component.find("ProValIniId").set("v.value",null);
            component.find("iodDays").set("v.disabled",true);
            component.find("ProValIniId").set("v.disabled",true);
        }else{
            component.find("iodDays").set("v.disabled",false);
            component.find("ProValIniId").set("v.disabled",false);
        }       
    },*/
    
    iodTypeChange : function(component, event, helper){
        console.log('iod type-----'+component.get("v.IODType"));
        if(event.getSource().get("v.value")=='None' || 
           event.getSource().get("v.value")=='' ||
           event.getSource().get("v.value")=='Not Applicable'){
            component.set("v.iodDays", '');
            component.set("v.iodDiscount", '');
        }  
        component.set("v.showSaveCancelBtn",true);
    },
    
    onRecordSubmit : function(component, event, helper){
        event.preventDefault(); 
        var eventFields = event.getParam("fields");
        var slctCntrcts=component.get("v.selectedCntrcts");
        /* var cntrctstring='';
        for(var i=0;i<slctCntrcts.length;i++){
            if(i==0){
                cntrctstring=slctCntrcts[i].Name;
            }else{
                cntrctstring+=','+slctCntrcts[i].Name;
            }
        }*/
        var bidType = component.get("v.BidTypeVal");
        var IODType = component.get("v.IODType");
        var iodDays = component.get("v.iodDays");
        var iodDiscount = component.get("v.iodDiscount");
        if(IODType!=null && IODType!=undefined && IODType!=''){
            eventFields["Phoenix_Initial_Order_Discount_Type__c"]=IODType;
        }
        if(iodDays!=null && iodDays!=undefined){
            eventFields["Phoenix_Initial_Order_Discount_of_Days__c"]=iodDays;
        }
        if(iodDiscount!=null && iodDiscount!=undefined){
            eventFields["Phoenix_Proposed_Initial_Order_Discount__c"]=iodDiscount;
        }
        console.log('isRFp or Product Addition-->'+(bidType == 'RFP Bids' || bidType == 'Product Addition' || bidType == 'Product Addition'));
        if(slctCntrcts.length==0 && component.get("v.BidTypeVal")!='New Customer'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select a Contract"
            });
            toastEvent.fire();
        }else if(bidType == 'Sales Out Rebate' && (eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == null || eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == '' || eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == 0 )){
            var msg = eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == 0 ? 'Sales Out Promotion # of Days must be greater than 0' :'Please Enter Sales Out Promotion # of Days';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if(bidType == 'Sales Out Rebate' && (eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == null || eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == '' || eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == 0) ){
            var msg = eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == 0 ? 'Proposed Sales Out Promotion % must be greater than 0' :'Please Enter Proposed Sales Out Promotion %';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if((bidType == 'Product Addition' || bidType == 'Price Change' || bidType == 'New Product Launch') && (eventFields["Phoenix_Proactive_Reactive__c"] == null || eventFields["Phoenix_Proactive_Reactive__c"] == '')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select Proactive/Reactive"
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition' || bidType == 'New Product Launch') && (eventFields["Phoenix_Initial_Order_Discount_Type__c"] == null || eventFields["Phoenix_Initial_Order_Discount_Type__c"] == '' || eventFields["Phoenix_Initial_Order_Discount_Type__c"]=='None')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select Initial Order Discount Type"
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition' || bidType == 'New Product Launch') && (eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == null || eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == '' || eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == 0 ) && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'Not Applicable' && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'None'){
            var InitialOrderDays = eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] ;
            var msg;
            if(InitialOrderDays=='' || InitialOrderDays==null){
                msg= 'Please Enter Initial Order Discount # of Days';
            }else{
                msg=InitialOrderDays == 0  ? 'Initial Order Discount # of Days must be greater than 0' : 'Please Enter Initial Order Discount # of Days';
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition' || bidType == 'New Product Launch') && (eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == null || eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == '' || eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == 0) && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'Not Applicable' && eventFields["Phoenix_Initial_Order_Discount_Type__c"]!= 'None'){
            var iodPerc=eventFields["Phoenix_Proposed_Initial_Order_Discount__c"];
            var msg;
            if(iodPerc==null || iodPerc==''){
                msg='Please Enter Proposed Initial Order Discount %';
            }else{
                msg= iodPerc < 1 ? 'Proposed Initial Order Discount % must be greater than 0' : 'Please Enter Proposed Initial Order Discount %';
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }
            else{
                var bid = component.get("v.bidRecord");
                var exstingContracts;
                if(bid !=null){
                    exstingContracts = bid.Phoenix_Reference_Contracts__c;
                    if(exstingContracts != null){
                        exstingContracts = exstingContracts.toString();
                    }
                }
                
                eventFields["Phoenix_Reference_Contracts__c"] =slctCntrcts.toString(); 
                var currentCd = eventFields["Phoenix_Current_CD__c"] ;
                var pvip=eventFields["Phoenix_Proposed_Value_Est_VIP__c"];
                if(pvip==null || pvip==undefined || pvip==''){
                    eventFields["Phoenix_Proposed_Value_Est_VIP__c"]=eventFields["Phoenix_Current_Value_Est_VIP__c"];
                }
                component.find("bidForm").submit(eventFields);
                
            if(component.get("v.BidTypeVal")!='New Customer'){
                helper.getNPRDataOfContracts(component, event, helper,slctCntrcts,component.get("v.templateType"));
            }
        }
    },
    onRecordSuccess : function(component, event, helper) {
        console.log('sucess----'+event.getParam("response").id);
        console.log('after success return');
        component.set('v.isSpinnerLoad',true);
        var rebateHeader , feeHeader, marketingHeader;
        var rebatetype = component.find("headerRebateType");
        if($A.util.isArray(rebatetype)){
            rebatetype=rebatetype[0];
        }
        var feetype = component.find("headerFeeType");
        if($A.util.isArray(feetype)){
            feetype=feetype[0];
        }
        var marketingType = component.find("headerMarketingApproval");
        if($A.util.isArray(marketingType)){
            marketingType=marketingType[0];
        }
        if(rebatetype != null){
            rebateHeader = rebatetype.get("v.value");
        }else{
            rebateHeader= '';
        }
        if(feetype != null){
            feeHeader = feetype.get("v.value");
        }else{
            feeHeader= '';
        }
        if(marketingType != null){
            marketingHeader = marketingType.get("v.value");
        }else{
            marketingHeader= '';
        }
        
        var selectedPositions = (typeof component.get("v.selectedPosistions") != 'undefined' && component.get("v.selectedPosistions") != null) ? component.get("v.selectedPosistions").toString() : '';
        var selectedcardinalPosistions = typeof component.get("v.selectedCardinalPosistions") != 'undefined' ? component.get("v.selectedCardinalPosistions").toString() : '';
        var selectedMajorPosistions = typeof component.get("v.selectedMajorPosistions") != 'undefined' ? component.get("v.selectedMajorPosistions").toString() : '';
        
        if (helper.requiredValidation(component, event)){
            var action = component.get("c.saveLineItems");
            action.setParams({
                'LineItemList': component.get("v.BidLineItemListAll"),
                'LineItemId':component.get("v.recordId"),
                'rebateHeader': rebateHeader,
                'feeHeader': feeHeader,
                'isRebateChanged': component.get("v.isRebateChanged"),
                'isFeeChanged': component.get("v.isFeeChanged"),
                'marketingHeader': marketingHeader,
                'isMarketingChanged': component.get("v.isMarketingChanged"),
                'productPositions': selectedPositions,
                'productCardinalPositions': selectedcardinalPosistions,
                'productMajorPositions': selectedMajorPosistions
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.bidRecord",storeResponse);
                    //component.set("v.BidLineItemListAll", storeResponse);
                    component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                    helper.searchProductFamilyChange(component, event,helper);
                    console.log('after success-return');
                }else{
                    component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                }
                component.set("v.isRebateChanged",false);
            });
            $A.enqueueAction(action);
        }
        helper.getAllTotalValues(component, event, helper);
        // helper.searchProductFamilyChange(component, event,helper);
    },
    Save: function(component, event, helper) {
        // component.find("bidForm").submit();        
    },
    showModel: function(component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---'+LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showModal", true);
        component.set("v.isSpinner", true);
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Phoenix_Contract_Number__c', type: 'text'},
            {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
            {label: 'Internal Description', fieldName: 'Phoenix_Contract_Internal_Description__c', type: 'text'},
            {label: 'External Description', fieldName: 'Phoenix_Contract_External_Description__c', type: 'Text'}
        ]); 
        var searchInput=component.find("cntInput").get("v.value");
        console.log('--searchInput--'+searchInput);
        var bidCustomer=component.get("v.customerId");
        console.log('--bidCustomer--'+bidCustomer);
        if(bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        } else{
            component.set("v.contratcsList",null);
            component.set("v.isSpinner", false);
        }      
    },   
    searchContracts : function(component, event, helper) {
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");            
        var bidCustomer=component.get("v.customerId");
        console.log('--bidCustomer--'+bidCustomer); 
        if(checkToggle==true){
            helper.fetchContratcs(component, event,helper,null,searchInput);
        }
        else{
            if(bidCustomer!=null && bidCustomer!=undefined){
                helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
            }else{
                component.set("v.contratcsList",null);
            }
        }
        /* if(checkToggle==true && bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        }
        else if(checkToggle==true && (bidCustomer==null ||  bidCustomer==undefined)){
            component.set("v.contratcsList",null);
        }else{
            helper.fetchContratcs(component, event,helper,null,searchInput);
        }*/
        
    },    
    saveDetails : function(component, event, helper) {
        var selectrcs=component.find('linesTable').getSelectedRows(); 
        var selectedCntrcts=component.get("v.selectedCntrcts");
        for(var i=0;i<selectrcs.length;i++){
            selectedCntrcts.push(selectrcs[i].Phoenix_Contract_Number__c);
        }    
        component.set("v.selectedCntrcts",selectedCntrcts);
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn",true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    clearCntract :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedCntrcts"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.selectedCntrcts", AllPillsList);
            }  
        } 
        component.set("v.showSaveCancelBtn",true);
    },    
    hideModel: function(component, event, helper) {
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },    
    hidePosModel : function(component, event, helper) {
        component.set("v.showPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    }, 
    hideCardinalPosModel : function(component, event, helper) {
        component.set("v.showCardinalPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    }, 
    hideMajorPosModel : function(component, event, helper) {
        component.set("v.showMajorPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    }, 
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
    },
    showSaveCancel : function(component,event,helper){
        component.set("v.showSaveCancelBtn",true);
    },
    SaveAndNavigate:  function(component,event,helper){
        $A.enqueueAction(component.get('c.onRecordSubmit'));
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);       
    },
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        var message = event.getParam("message");
        var action = component.get("c.getRelatedList");
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               var wrapperObj =  response.getReturnValue();
                               var lineItemsList = wrapperObj.lineItemsList;
                               component.set("v.BidLineItemListAll",lineItemsList);
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
        window.setTimeout(
            $A.getCallback(function() {
                helper.getAllTotalValues(component, event, helper);
            }), 2000
        ); 
    },
    searchProFamilyChange: function(component, event,helper) {
        
        helper.searchProductFamilyChange(component, event,helper);
    },  
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component 
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(component,event,helper){
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );      
    },    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent---'+selectedAccountGetFromEvent);
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    onblurProDir : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        var toggleclass = component.find("zvalue");      
        $A.util.addClass(toggleclass, "zindex"); 
        var toggleclasspkg = component.find("zvaluePkg");      
        $A.util.addClass(toggleclasspkg, "zindexPkg");
        var toggleclassPrd = component.find("zvaluePrd");      
        $A.util.addClass(toggleclassPrd, "zindexPrd");
        component.set("v.listOfSearchPDRecords", null );
        component.set("v.SearchKeyWordPD", '');
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocusProdDir : function(component,event,helper){       
        // show the spinner,show child search result component and call helper function
        /* $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchPDRecords", null ); 
        var forOpen = component.find("searchResPD");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelperProdDir(component,event,getInputkeyWord);*/
    },    
    keyPressControllerProdDir : function(component, event, helper) {
        var toggleclass = component.find("zvalue");      
        $A.util.removeClass(toggleclass, "zindex");
        var toggleclasspkg = component.find("zvaluePkg");      
        $A.util.removeClass(toggleclasspkg, "zindexPkg");
        var toggleclassPrd = component.find("zvaluePrd");      
        $A.util.removeClass(toggleclassPrd, "zindexPrd");
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWordPD");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchResPD");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperProdDir(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchPDRecords", null ); 
            var forclose = component.find("searchResPD");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },    
    // function for clear the Record Selaction 
    clearProdDir :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedPDRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedPDRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWordPD",null);
        component.set("v.listOfSearchPDRecords", null );      
    }, 
    // This function call when the end User Select any record from the result list.   
    handleComponentEventProdDir : function(component, event, helper) {
        component.set("v.SearchKeyWordPD",null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedPDRecords");
        var selectedAccountGetFromEvent = event.getParam("PDrecordByEvent");       
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedPDRecords" , listSelectedItems); 
        
        var forclose = component.find("lookup-pill-PD");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    searchSrxRxOttc : function(component,event,helper){
        var picliList = component.get('v.RxSrxList');        
        if(component.get("v.isRxChecked") && !picliList.includes('Rx')){
            console.log('I am Rx')
            picliList.push('Rx');
        }
        if(component.get("v.isSRxChecked") && !picliList.includes('SRx')){
            picliList.push('SRx');
        }
        if(component.get("v.isOtcChecked") && !picliList.includes('OTC')){
            picliList.push('OTC');
        }
        if(component.get("v.isRxChecked") == false && picliList.includes('Rx')){
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSRxChecked") == false && picliList.includes('SRx')){
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isOtcChecked") == false && picliList.includes('OTC')){
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
        }
        component.set("v.RxSrxList",picliList);
        console.log('picliList----->'+picliList);
    },
    searchSRxOtc : function(component,event,helper){
        if(component.get("v.RxSrxList").length > 0 ){
            var action = component.get("c.findBySrxOtc");
            action.setParams({
                "searchKey": component.get("v.RxSrxList"),
                "lineItemId" : component.get("v.recordId")
            });
            action.setCallback(this, function(a) {
                var lineItemsList =a.getReturnValue();
                component.set("v.BidLineItemListAll", lineItemsList);
                var OutDiv = component.find("mainDiv");
                if(lineItemsList.length<10){
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");
                }else{
                    console.log('---hight---');
                    $A.util.removeClass(OutDiv, "noheightClass");
                }
            });
            $A.enqueueAction(action);
        }else{
            $A.enqueueAction(component.get('c.initRecords'));
        }
    },
    onRebateChange: function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isRebateChanged",true);
    },
    onFeeChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isFeeChanged",true);
    },
    onMarketingChange :function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isMarketingChanged",true);
    },
    downloadCsv : function(component,event,helper){    
        var action = component.get("c.getupdatedforExport");
        action.setParams({
            "bidId" : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            var isReBid=component.get("v.isReBid");
            console.log('isReBid--->'+isReBid);
            var ResultData =a.getReturnValue(); 
            
            /*  ResultData.forEach(function(lineObj){
                console.log('lineObj.Id :: '+lineObj.Id);
                console.log('lineObj.BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c :: '+lineObj.BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c);
                console.log('lineObj.BidLineItemsExtn__r[0].Id :: '+lineObj.BidLineItemsExtn__r[0].Id);
            });*/
            var template=component.get("v.templateType");
            var bidNumber=component.get("v.bidNumber");
            var bidName=component.get("v.bidName");
            var bidType=component.get("v.BidTypeVal");
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template,bidType,isReBid);   
            if (csv == null){return;} 
            
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
            var hiddenElement = document.createElement('a');
            hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
            hiddenElement.target = '_self'; //      
            var date = new Date(); 
            var hours = date.getHours(); 
            var minutes = date.getMinutes(); 
            var newformat = hours >= 12 ? 'PM' : 'AM';  
            hours = hours % 12;  
            hours = hours ? hours : 12;  
            minutes = minutes < 10 ? '0' + minutes : minutes;        
            var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
            hiddenElement.download = 'Input View'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file  */
        });
        $A.enqueueAction(action);
    },
    saveToProceed :function(component,event,helper){
        var isContracts=false;
        helper.submitForProceed(component,event,helper,isContracts);
    },
    saveToProceedContracts : function(component,event,helper){
        var isContracts=true;
        helper.submitForProceed(component,event,helper,isContracts);
    },
    /*Product Position Logic*/
    showProductPositionModel: function (component, event, helper) {
        
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showPositionsModal", true);
        component.set("v.isSpinner",true);
        component.set('v.positionColumns', [
            {
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
                type: 'text'
            },
            {
                label: 'Group Name',
                fieldName: 'Phoenix_Group_Name__c',
                type: 'text'
            },
            {
                label: 'Position Comments',
                fieldName: 'Phoenix_Position_Comments__c',
                type: 'Text'
            }
        ]);
        // var searchInput=component.find("cntInput").get("v.value");
        // console.log('--searchInput--'+searchInput);
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.positionsList", null);
            component.set("v.isSpinner",false);
        }
        
    },
    
    /*Product Position Logic*/
    showCardinalProductPositionModel: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showCardinalPositionsModal", true);
        component.set("v.isSpinner", true);
        component.set('v.positionColumns', [
            {
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
                type: 'text'
            },
            {
                label: 'Group Name',
                fieldName: 'Phoenix_Group_Name__c',
                type: 'text'
            },
            {
                label: 'Position Comments',
                fieldName: 'Phoenix_Position_Comments__c',
                type: 'Text'
            }
        ]);
        // var searchInput=component.find("cntInput").get("v.value");
        // console.log('--searchInput--'+searchInput);
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchCardinalPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.cardinalPositionsList", null);
            component.set("v.isSpinner", false);
        }
    },
    
    /*Product Position Logic*/
    showMajorProductPositionModel: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showMajorPositionsModal", true);
        component.set("v.isSpinner", true);
        component.set('v.positionColumns', [
            {
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
                type: 'text'
            },
            {
                label: 'Group Name',
                fieldName: 'Phoenix_Group_Name__c',
                type: 'text'
            },
            {
                label: 'Position Comments',
                fieldName: 'Phoenix_Position_Comments__c',
                type: 'Text'
            }
        ]);
        // var searchInput=component.find("cntInput").get("v.value");
        // console.log('--searchInput--'+searchInput);
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchMajorPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.majorPositionsList", null);
            component.set("v.isSpinner", false);
        }
    },
    
    clearPosition: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedPosistions");
        
        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedPosistions", AllPillsList);
            }
        }
        component.set("v.showSaveCancelBtn", true);
    },
    clearCardinalPosition: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedCardinalPosistions");
        
        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedCardinalPosistions", AllPillsList);
            }
        }
        component.set("v.showSaveCancelBtn", true);
    },
    clearMajorPosition: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedMajorPosistions");
        
        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedMajorPosistions", AllPillsList);
            }
        }
        component.set("v.showSaveCancelBtn", true);
    },
    savePosDetails: function (component, event, helper) {
        var selectrcs = component.find('PoslinesTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedPosistions");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedPosistions", selectedCntrcts);
        component.set("v.showPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    saveCardinalPosDetails: function (component, event, helper) {
        var selectrcs = component.find('cardinalPoslinesTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedCardinalPosistions");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedCardinalPosistions", selectedCntrcts);
        component.set("v.showCardinalPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    saveMajorPosDetails: function (component, event, helper) {
        var selectrcs = component.find('majorPoslinesTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedMajorPosistions");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedMajorPosistions", selectedCntrcts);
        component.set("v.showMajorPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    updateFields : function (component, event, heplper){
       component.set('v.isSpinnerLoad', true);
        var action = component.get("c.saveLineItemsNewPL");
        action.setParams({
            bidId: component.get("v.recordId"),
           LineItemList: component.get("v.BidLineItemListAll")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
               var storeResponse = response.getReturnValue();
                component.set("v.BidLineItemListAll", storeResponse);
                console.log('updated response-->'+JSON.stringify(storeResponse));
              var callinitrecords = component.get('c.initRecords');
       				 $A.enqueueAction(callinitrecords);
                  var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
       				 "title": "Success!",
        			"message": "WAC and Lowest Price/SKU have been updated successfully.",
                    "type": "success"
    				});
    			toastEvent.fire();
                component.set("v.showSaveCancelBtn", false);
                component.set('v.isSpinnerLoad', false);
            }
            else {
                    component.set("v.showSaveCancelBtn", false);
                    component.set('v.isSpinnerLoad', false);
                }
        });
       $A.enqueueAction(action);
        	
	},
    navigate : function(component, event, helper) 
    {
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:CompetitorInfo",
            componentAttributes: {
                bidId : component.get("v.recordId")
            }
            //You can pass attribute value from Component1 to Component2
            //componentAttributes :{ }
        });
        navigateEvent.fire();
    },
    doInit : function(component, event, helper) {
        var actionfu = component.get("c.fetchUser");
        actionfu.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(actionfu);
    },
    hideRequiredFieldModel : function(component, event, helper) { 
        component.set('v.fieldRequiredModel',false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set('v.isSpinnerLoad',false);
    },
    proceedToRequiredFieldModel : function(component, event, helper) { 
        console.log('in  proceedToRequiredFieldModel')
        var a = component.get('c.submitFor');
        $A.enqueueAction(a);

        var bidType=component.get("v.BidTypeVal");
        console.log('bid type!!!!!!!!!!!!==='+bidType);
        var bidlines = JSON.stringify(component.get("v.ResponseList"));
        console.log('single res==>'+bidlines)
         var isOverrideUnitsavl = false;
        for(var i=0;i<bidlines.length;i++){
             if (bidType != 'New Product Launch' && (bidlines[i].Phoenix_Override_Current_Direct_Units__c == null && (bidlines[i].Phoenix_Current_Retail_Direct_Units__c == 0 || bidlines[i].Phoenix_Current_Retail_Direct_Units__c == undefined || bidlines[i].Phoenix_Current_Retail_Direct_Units__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	break;
                        					}
                                                else if (bidType != 'New Product Launch' && (bidlines[i].Phoenix_Override_Current_Indirect_Units__c == null && (bidlines[i].Phoenix_Current_Retail_Indirect_Units__c == 0 || bidlines[i].Phoenix_Current_Retail_Indirect_Units__c == undefined || bidlines[i].Phoenix_Current_Retail_Indirect_Units__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	break;
                        					}
                                                else if (bidType != 'New Product Launch' && (bidlines[i].Phoenix_Override_Current_Units__c == null && (bidlines[i].Phoenix_Current_Wholesaler_Units__c == 0 || bidlines[i].Phoenix_Current_Wholesaler_Units__c == undefined || bidlines[i].Phoenix_Current_Wholesaler_Units__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	break;
                        					}
                                                else if (bidType != 'New Product Launch' && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c == null && (bidlines[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c == 0 || bidlines[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c == undefined || bidlines[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c == null))){
                            				 isOverrideUnitsavl = true;
                                               	break;
                        					}
            
        }
        var modalMessage = isOverrideUnitsavl ? 'The 3 Months Annualized Selling Units is 0. Are you sure you want to submit this bid for approval?' : 'Are you sure you want to submit this bid for approval?';
                                       component.set('v.modalMessage',modalMessage);
            console.log('model message'+modalMessage);
         component.set('v.submitModel',true);
        component.set('v.fieldRequiredModel',false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        helper.getUpdateLines(component,event,helper);
    }
})