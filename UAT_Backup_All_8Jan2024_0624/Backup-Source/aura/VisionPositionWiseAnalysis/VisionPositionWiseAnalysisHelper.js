({
    getData: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var action = component.get("c.getData");
        action.setParams({
            'selectedBids': component.get("v.selectedBids")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var response = response.getReturnValue();
                component.set("v.categoriesList", response);
                var primaryList = response.primaryCategory;
                var primaryLength = []; var backupLength = []; var optyLength = [];
                if(primaryList != null && primaryList.length !=0){
                    var summaryAtPrimaryObj = {};
                    var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
                    var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
                    var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0; var lineItemsCount = 0;
                    var priceVariance = 0; var volumeVariance = 0; var totalVariance = 0;
                    for(var i=0; i<primaryList.length; i++){
                        var bidLineItems = primaryList[i].bidLineItems;
                        lineItemsCount += bidLineItems.length;
                        for(var j=0; j<bidLineItems.length; j++){
                            primaryLength.push(bidLineItems[j].Id);
                            CurrentBusinessQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                            CurrentBusinessSales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                            CurrentBusinessTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                            BidRFPQty += isNaN(bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c;
                            BidRFPSales += isNaN(bidLineItems[j].Phoenix_Proposed_Sales__c)?0: parseFloat(bidLineItems[j].Phoenix_Proposed_Sales__c);
                            BidRFPTPT += isNaN(bidLineItems[j].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[j].Phoenix_Proposed_TP_Margin__c;
                            if(bidLineItems[j].Phoenix_Total_Selling_Unit__c > 0 && bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c > 0) bidLineItems[j].priceVariance = parseInt((((bidLineItems[j].Phoenix_Proposed_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Proposed_ASP_Dose__c: 0) - ((bidLineItems[j].Phoenix_Current_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Current_ASP_Dose__c: 0)) * ((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0));
                            else bidLineItems[j].priceVariance = 0;
                            if(bidLineItems[j].Phoenix_Total_Selling_Unit__c > 0 ) bidLineItems[j].volumeVariance = parseInt((((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0)-((bidLineItems[j].Phoenix_Total_Selling_Unit__c != null)? bidLineItems[j].Phoenix_Total_Selling_Unit__c: 0)) * ((bidLineItems[j].Phoenix_Current_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Current_ASP_Dose__c: 0));
                            else if(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c > 0 ) bidLineItems[j].volumeVariance = parseInt(((bidLineItems[j].Phoenix_Proposed_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Proposed_ASP_Dose__c: 0) * ((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0));
                            else bidLineItems[j].volumeVariance = 0;
                            bidLineItems[j].totalVariance = parseInt(bidLineItems[j].volumeVariance + bidLineItems[j].priceVariance);
                            priceVariance += bidLineItems[j].priceVariance;
                            volumeVariance += bidLineItems[j].volumeVariance;
                            totalVariance += bidLineItems[j].totalVariance;
                            var finalRFPSales = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                            var finalRFPTPTDollar = finalRFPSales - (isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c *  bidLineItems[j].Phoenix_Throughput_cost__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Throughput_cost__c));
                            var finalRFPTPTPercent = 0;
                            if(finalRFPTPTDollar != 0){
                                finalRFPTPTPercent = (finalRFPTPTDollar/finalRFPSales)*100;
                            } else{
                                finalRFPTPTPercent = 0;   
                            }
                            FinalRFPQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                            FinalRFPSales += isNaN(finalRFPSales)?0:finalRFPSales;
                            FinalRFPTPT += isNaN(finalRFPTPTDollar)?0:finalRFPTPTDollar;
                        }
                    }
                    summaryAtPrimaryObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtPrimaryObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtPrimaryObj.CurrentBusinessTPT = CurrentBusinessTPT;
                    summaryAtPrimaryObj.BidRFPQty = BidRFPQty; summaryAtPrimaryObj.BidRFPSales = BidRFPSales; summaryAtPrimaryObj.BidRFPTPT = BidRFPTPT;
                    summaryAtPrimaryObj.FinalRFPQty = FinalRFPQty; summaryAtPrimaryObj.FinalRFPSales = FinalRFPSales; summaryAtPrimaryObj.FinalRFPTPT = FinalRFPTPT;
                    summaryAtPrimaryObj.priceVariance = priceVariance; summaryAtPrimaryObj.volumeVariance = volumeVariance; summaryAtPrimaryObj.totalVariance = totalVariance;
                    if(CurrentBusinessSales != 0){
                        summaryAtPrimaryObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
                    } else{
                        summaryAtPrimaryObj.CurrentBusinessTPTPercent = 0;
                    }
                    if(BidRFPSales != 0){
                        summaryAtPrimaryObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;   
                    } else{
                        summaryAtPrimaryObj.BidRFPTPTPercent = 0;
                    }
                    if(FinalRFPSales != 0){
                        summaryAtPrimaryObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
                    } else{
                        summaryAtPrimaryObj.FinalRFPTPTPercent = 0;
                    }
                    summaryAtPrimaryObj.lineItemsCount = lineItemsCount;
                    component.set("v.summaryAtPrimaryObj", summaryAtPrimaryObj);
                }
                var backupList = response.backupCategory;
                if(backupList != null && backupList.length !=0){
                    var summaryAtBackupObj = {};
                    var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
                    var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
                    var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0; var lineItemsCount = 0;
                    var priceVariance = 0; var volumeVariance = 0; var totalVariance = 0;
                    for(var i=0; i<backupList.length; i++){
                        var bidLineItems = backupList[i].bidLineItems;
                        lineItemsCount += bidLineItems.length;
                        for(var j=0; j<bidLineItems.length; j++){
                            backupLength.push(bidLineItems[j].Id);
                            CurrentBusinessQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                            CurrentBusinessSales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                            CurrentBusinessTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                            BidRFPQty += isNaN(bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c;
                            BidRFPSales += isNaN(bidLineItems[j].Phoenix_Proposed_Sales__c)?0: parseFloat(bidLineItems[j].Phoenix_Proposed_Sales__c);
                            BidRFPTPT += isNaN(bidLineItems[j].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[j].Phoenix_Proposed_TP_Margin__c;
                            if(bidLineItems[j].Phoenix_Total_Selling_Unit__c > 0 && bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c > 0) bidLineItems[j].priceVariance = parseInt((((bidLineItems[j].Phoenix_Proposed_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Proposed_ASP_Dose__c: 0) - ((bidLineItems[j].Phoenix_Current_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Current_ASP_Dose__c: 0)) * ((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0));
                            else bidLineItems[j].priceVariance = 0;
                            if(bidLineItems[j].Phoenix_Total_Selling_Unit__c > 0 ) bidLineItems[j].volumeVariance = parseInt((((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0)-((bidLineItems[j].Phoenix_Total_Selling_Unit__c != null)? bidLineItems[j].Phoenix_Total_Selling_Unit__c: 0)) * ((bidLineItems[j].Phoenix_Current_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Current_ASP_Dose__c: 0));
                            else if(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c > 0 ) bidLineItems[j].volumeVariance = parseInt(((bidLineItems[j].Phoenix_Proposed_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Proposed_ASP_Dose__c: 0) * ((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0));
                            else bidLineItems[j].volumeVariance = 0;
                            bidLineItems[j].totalVariance = parseInt(bidLineItems[j].volumeVariance + bidLineItems[j].priceVariance);
                            priceVariance += bidLineItems[j].priceVariance;
                            volumeVariance += bidLineItems[j].volumeVariance;
                            totalVariance += bidLineItems[j].totalVariance;
                            var finalRFPSales = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                            var finalRFPTPTDollar = finalRFPSales - (isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c *  bidLineItems[j].Phoenix_Throughput_cost__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Throughput_cost__c));
                            var finalRFPTPTPercent = 0;
                            if(finalRFPTPTDollar != 0){
                                finalRFPTPTPercent = (finalRFPTPTDollar/finalRFPSales)*100;
                            } else{
                                finalRFPTPTPercent = 0;   
                            }
                            FinalRFPQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                            FinalRFPSales += isNaN(finalRFPSales)?0:finalRFPSales;
                            FinalRFPTPT += isNaN(finalRFPTPTDollar)?0:finalRFPTPTDollar;
                        }
                    }
                    summaryAtBackupObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtBackupObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtBackupObj.CurrentBusinessTPT = CurrentBusinessTPT;
                    summaryAtBackupObj.BidRFPQty = BidRFPQty; summaryAtBackupObj.BidRFPSales = BidRFPSales; summaryAtBackupObj.BidRFPTPT = BidRFPTPT;
                    summaryAtBackupObj.FinalRFPQty = FinalRFPQty; summaryAtBackupObj.FinalRFPSales = FinalRFPSales; summaryAtBackupObj.FinalRFPTPT = FinalRFPTPT;
                    summaryAtBackupObj.priceVariance = priceVariance; summaryAtBackupObj.volumeVariance = volumeVariance; summaryAtBackupObj.totalVariance = totalVariance;
                    if(CurrentBusinessSales != 0){
                        summaryAtBackupObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
                    } else{
                        summaryAtBackupObj.CurrentBusinessTPTPercent = 0;
                    }
                    if(BidRFPSales != 0){
                        summaryAtBackupObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;   
                    } else{
                        summaryAtBackupObj.BidRFPTPTPercent = 0;
                    }
                    if(FinalRFPSales != 0){
                        summaryAtBackupObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
                    } else{
                        summaryAtBackupObj.FinalRFPTPTPercent = 0;
                    }
                    summaryAtBackupObj.lineItemsCount =lineItemsCount;
                    component.set("v.summaryAtBackupObj", summaryAtBackupObj);
                }
                var optyList = response.optyCategory;
                if(optyList != null && optyList.length !=0){
                    var summaryAtOptyObj = {};
                    var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
                    var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
                    var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0; var lineItemsCount = 0;
                    var priceVariance = 0; var volumeVariance = 0; var totalVariance = 0;
                    var currentBusinessNewPrimaryQty = 0; var currentBusinessNewPrimarySales = 0; var currentBusinessNewPrimaryTPT = 0;
                    var FinalRFPNewPrimaryQty = 0; var FinalRFPNewPrimarySales = 0; var FinalRFPNewPrimaryTPT = 0;
                    var currentBusinessNewBackupQty = 0; var currentBusinessNewBackupSales = 0; var currentBusinessNewBackupTPT = 0;
                    var FinalRFPNewBackupQty = 0; var FinalRFPNewBackupSales = 0; var FinalRFPNewBackupTPT = 0;
                    for(var i=0; i<optyList.length; i++){
                        var bidLineItems = optyList[i].bidLineItems;
                        lineItemsCount += bidLineItems.length;
                        for(var j=0; j<bidLineItems.length; j++){
                            optyLength.push(bidLineItems[j].Id);
                            /*if(optyList[i].category == 'New Opportunity'){
                                bidLineItems[j].Phoenix_Total_Selling_Unit__c = 0;
                                bidLineItems[j].Finance_Current_Sales__c = 0;
                                bidLineItems[j].Phoenix_Current_TP_Margin__c = 0;
                                bidLineItems[j].Phoenix_Current_TP_MarginPercent__c = 0;
                            }*/
                            CurrentBusinessQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                            CurrentBusinessSales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                            CurrentBusinessTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                            BidRFPQty += isNaN(bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c;
                            BidRFPSales += isNaN(bidLineItems[j].Phoenix_Proposed_Sales__c)?0: parseFloat(bidLineItems[j].Phoenix_Proposed_Sales__c);
                            BidRFPTPT += isNaN(bidLineItems[j].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[j].Phoenix_Proposed_TP_Margin__c;
                            if(bidLineItems[j].Phoenix_Total_Selling_Unit__c > 0 && bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c > 0) bidLineItems[j].priceVariance = parseInt((((bidLineItems[j].Phoenix_Proposed_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Proposed_ASP_Dose__c: 0) - ((bidLineItems[j].Phoenix_Current_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Current_ASP_Dose__c: 0)) * ((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0));
                            else bidLineItems[j].priceVariance = 0;
                            if(bidLineItems[j].Phoenix_Total_Selling_Unit__c > 0 ) bidLineItems[j].volumeVariance = parseInt((((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0)-((bidLineItems[j].Phoenix_Total_Selling_Unit__c != null)? bidLineItems[j].Phoenix_Total_Selling_Unit__c: 0)) * ((bidLineItems[j].Phoenix_Current_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Current_ASP_Dose__c: 0));
                            else if(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c > 0 ) bidLineItems[j].volumeVariance = parseInt(((bidLineItems[j].Phoenix_Proposed_ASP_Dose__c != null)? bidLineItems[j].Phoenix_Proposed_ASP_Dose__c: 0) * ((bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c: 0));
                            else bidLineItems[j].volumeVariance = 0;
                            bidLineItems[j].totalVariance = parseInt(bidLineItems[j].volumeVariance + bidLineItems[j].priceVariance);
                            priceVariance += bidLineItems[j].priceVariance;
                            volumeVariance += bidLineItems[j].volumeVariance;
                            totalVariance += bidLineItems[j].totalVariance;
                            var finalRFPSales = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                            var finalRFPTPTDollar = finalRFPSales - isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c *  bidLineItems[j].Phoenix_Throughput_cost__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Throughput_cost__c);
                            var finalRFPTPTPercent = 0;
                            if(finalRFPTPTDollar != 0){
                                finalRFPTPTPercent = (finalRFPTPTDollar/finalRFPSales)*100;
                            } else{
                                finalRFPTPTPercent = 0;   
                            }
                            FinalRFPQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                            FinalRFPSales += isNaN(finalRFPSales)?0:finalRFPSales;
                            FinalRFPTPT += isNaN(finalRFPTPTDollar)?0:finalRFPTPTDollar;
                            if(optyList[i].position == 'New Backup'){
                                var finalRFPSalesOpty = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                                var finalRFPTPTDollarOpty = finalRFPSalesOpty - (isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c *  bidLineItems[j].Phoenix_Throughput_cost__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Throughput_cost__c));
                                var finalRFPTPTPercentOpty = 0;
                                if(finalRFPTPTDollarOpty != 0){
                                    finalRFPTPTPercentOpty = (finalRFPTPTDollarOpty/finalRFPSalesOpty)*100;
                                } else{
                                    finalRFPTPTPercentOpty = 0;   
                                }
                                currentBusinessNewBackupQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                                currentBusinessNewBackupSales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                                currentBusinessNewBackupTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                                FinalRFPNewBackupQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                                FinalRFPNewBackupSales += isNaN(finalRFPSalesOpty)?0:finalRFPSalesOpty;
                                FinalRFPNewBackupTPT += isNaN(finalRFPTPTDollarOpty)?0:finalRFPTPTDollarOpty;
                            } else if(optyList[i].position == 'New Primary'){
                                var finalRFPSalesOpty = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                                console.log("Start");
                                console.log("Product "+bidLineItems[j].Phoenix_Product__r.Name);
                                console.log('Awarded Qty: '+bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c);
                                console.log('Proposed ASP: '+bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                                console.log('finalRFPSalesOpty: '+finalRFPSalesOpty);
                                console.log('End');
                                var finalRFPTPTDollarOpty = finalRFPSalesOpty - (isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c *  bidLineItems[j].Phoenix_Throughput_cost__c)? 0: parseFloat(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Throughput_cost__c));
                                var finalRFPTPTPercentOpty = 0;
                                if(finalRFPTPTDollarOpty != 0){
                                    finalRFPTPTPercentOpty = (finalRFPTPTDollarOpty/finalRFPSalesOpty)*100;
                                } else{
                                    finalRFPTPTPercentOpty = 0;   
                                }
                                currentBusinessNewPrimaryQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                                currentBusinessNewPrimarySales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                                currentBusinessNewPrimaryTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                                FinalRFPNewPrimaryQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                                FinalRFPNewPrimarySales += isNaN(finalRFPSalesOpty)?0:finalRFPSalesOpty;
                                FinalRFPNewPrimaryTPT += isNaN(finalRFPTPTDollarOpty)?0:finalRFPTPTDollarOpty;
                            }
                        }
                    }
                    summaryAtOptyObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtOptyObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtOptyObj.CurrentBusinessTPT = CurrentBusinessTPT;
                    summaryAtOptyObj.BidRFPQty = BidRFPQty; summaryAtOptyObj.BidRFPSales = BidRFPSales; summaryAtOptyObj.BidRFPTPT = BidRFPTPT;
                    summaryAtOptyObj.FinalRFPQty = FinalRFPQty; summaryAtOptyObj.FinalRFPSales = FinalRFPSales; summaryAtOptyObj.FinalRFPTPT = FinalRFPTPT;
                    summaryAtOptyObj.priceVariance = priceVariance; summaryAtOptyObj.volumeVariance = volumeVariance; summaryAtOptyObj.totalVariance = totalVariance;
                    summaryAtOptyObj.currentBusinessNewPrimaryQty = currentBusinessNewPrimaryQty;
                    summaryAtOptyObj.currentBusinessNewPrimarySales = currentBusinessNewPrimarySales;
                    summaryAtOptyObj.currentBusinessNewPrimaryTPT = currentBusinessNewPrimaryTPT;
                    summaryAtOptyObj.currentBusinessNewBackupQty = currentBusinessNewBackupQty;
                    summaryAtOptyObj.currentBusinessNewBackupSales = currentBusinessNewBackupSales;
                    summaryAtOptyObj.currentBusinessNewBackupTPT = currentBusinessNewBackupTPT;
                    
                    summaryAtOptyObj.FinalRFPNewPrimaryQty = FinalRFPNewPrimaryQty;
                    summaryAtOptyObj.FinalRFPNewPrimarySales = FinalRFPNewPrimarySales;
                    summaryAtOptyObj.FinalRFPNewPrimaryTPT = FinalRFPNewPrimaryTPT;
                    summaryAtOptyObj.FinalRFPNewBackupQty = FinalRFPNewBackupQty;
                    summaryAtOptyObj.FinalRFPNewBackupSales = FinalRFPNewBackupSales;
                    summaryAtOptyObj.FinalRFPNewBackupTPT = FinalRFPNewBackupTPT;
                    
                    if(CurrentBusinessSales != 0){
                        summaryAtOptyObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
                    } else{
                        summaryAtOptyObj.CurrentBusinessTPTPercent = 0;
                    }
                    if(BidRFPSales != 0){
                        summaryAtOptyObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;   
                    } else{
                        summaryAtOptyObj.BidRFPTPTPercent = 0;
                    }
                    if(FinalRFPSales != 0){
                        summaryAtOptyObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
                    } else{
                        summaryAtOptyObj.FinalRFPTPTPercent = 0;
                    }
                    
                    if(currentBusinessNewPrimarySales != 0){
                        summaryAtOptyObj.CurrentBusinessNewPrimaryTPTPercent = (currentBusinessNewPrimaryTPT/currentBusinessNewPrimarySales)*100;
                    } else{
                        summaryAtOptyObj.CurrentBusinessNewPrimaryTPTPercent = 0;
                    }
                    if(FinalRFPNewBackupSales != 0){
                        summaryAtOptyObj.FinalRFPNewBackupTPTPercent = (FinalRFPNewBackupTPT/FinalRFPNewBackupSales)*100;
                    } else{
                        summaryAtOptyObj.FinalRFPNewBackupTPTPercent = 0;
                    }
                    
                    if(currentBusinessNewBackupSales != 0){
                        summaryAtOptyObj.CurrentBusinessNewBackupTPTPercent = (currentBusinessNewBackupTPT/currentBusinessNewBackupSales)*100;
                    } else{
                        summaryAtOptyObj.CurrentBusinessNewBackupTPTPercent = 0;
                    }
                    if(FinalRFPNewPrimarySales != 0){
                        summaryAtOptyObj.FinalRFPNewPrimaryTPTPercent = (FinalRFPNewPrimaryTPT/FinalRFPNewPrimarySales)*100;
                    } else{
                        summaryAtOptyObj.FinalRFPNewPrimaryTPTPercent = 0;
                    }
                    
                    summaryAtOptyObj.lineItemsCount = lineItemsCount;
                    component.set("v.summaryAtOptyObj", summaryAtOptyObj);
                }
                component.set("v.primaryList", response.primaryCategory);
                component.set("v.backupList", response.backupCategory);
                component.set("v.optyList", response.optyCategory);
                component.set("v.isSpinnerLoad", false);
                var allLineItems = response.ignoredBidLineItems;
                var otherLineItems = [];
                if(allLineItems != null){
                    for(var i=0; i<allLineItems.length; i++){
                        if(!primaryLength.includes(allLineItems[i].Id)){
                            otherLineItems.push(allLineItems[i]);
                        }
                        if(!backupLength.includes(allLineItems[i].Id)){
                            otherLineItems.push(allLineItems[i]);
                        }
                        if(!optyLength.includes(allLineItems[i].Id)){
                            otherLineItems.push(allLineItems[i]);
                        }
                    }
                }
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
    },
})