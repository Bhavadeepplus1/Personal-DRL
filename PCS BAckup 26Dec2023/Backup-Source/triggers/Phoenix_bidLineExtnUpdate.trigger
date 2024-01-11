trigger Phoenix_bidLineExtnUpdate on Phoenix_BidLineItemExtn__c (before insert, after insert, before update, after update) {
    if(trigger.isBefore && !Phoenix_Util.blnAlreadyDone){  
        if(trigger.isUpdate || trigger.isInsert){
            String bidType;
            Phoenix_Bid__c bidRec;
            Map <Id, Phoenix_Bid_Line_Item__c> bliMap = new Map<Id, Phoenix_Bid_Line_Item__c>(); // we will be adding bli Id and that child to this map to reference in the cals below.
            List<Phoenix_Bid_Line_Item__c> bidLineItemUpdateList = new List<Phoenix_Bid_Line_Item__c>();
            system.debug('*** CHILD TRIGGER FIRED ****');
            String query = '';
            String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
            Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            List<String> strFields = new List<String>();
            for (String fieldName: fieldMap.keyset()) {
                strFields.add(fieldName);
            }
            
            Set<Id> bidLineItemId = new Set<Id>();//trigger.newMap.keySet();
            for(Phoenix_BidLineItemExtn__c bliExtObj : trigger.New){
                bidLineItemId.add(bliExtObj.Phoenix_Bid_Line_Item__c);
            }
            query = 'SELECT Phoenix_Product__r.Phoenix_Limited_Distribution__c, '+String.join(strFields,' , ')+' FROM '+SobjectApiName+' WHERE Id IN: bidLineItemId';
            List<Phoenix_Bid_Line_Item__c> bidLineItemList = Database.query(query);
            system.debug('bidLineItemList.size() ** :: '+bidLineItemList.size());
            String bidId = '';
            if(bidLineItemList.size()>0){
                for(Phoenix_Bid_Line_Item__c obj : bidLineItemList){
                    bidId = obj.Phoenix_Bid__c;
                    bliMap.put(obj.Id, obj);
                }
            }
            system.debug('Bid record Id :: '+bidId);
            bidRec = [SELECT Id, Phoenix_Customer_Type__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Current_CD__c,Phoenix_Approval_Status__c, Phoenix_Bid_Proposed_Position__c, 
                      Phoenix_Custom_type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c,
                      Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid_Type__c, Phoenix_AdditionalRebateCardinalMajor__c, 
                      Phoenix_Rebate__c, Phoenix_REMS_Program_Fee__c,Phoenix_Controlled_Substance__c,Phoenix_Required_Cold_Storage__c,Phoenix_Proposed_SSA_No_of_Days__c,
                      Phoenix_Controlled_Distribution__c
                      FROM Phoenix_Bid__c 
                      WHERE Id =: bidId];
            bidType = bidRec.Phoenix_Bid_Type__c;
            Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
            
            Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
            Decimal additionalRebate = bidRec.Phoenix_AdditionalRebateCardinalMajor__c != null? bidRec.Phoenix_AdditionalRebateCardinalMajor__c : 0 ;
            Decimal rebatePer = bidRec.Phoenix_Rebate__c != null? bidRec.Phoenix_Rebate__c : 0 ;
            
            
            //List<Phoenix_Bid_Line_Item__c> bliUpdateList = [SELECT Id, Name FROM Phoenix_Bid_Line_Item__c WHERE Id IN: bliIdsList];
            //update bliUpdateList;
            for(Phoenix_BidLineItemExtn__c bliExtObj : trigger.New){
                try{
                    Phoenix_Bid_Line_Item__c blItem = new Phoenix_Bid_Line_Item__c();
                    if(bliMap.containskey(bliExtObj.Phoenix_Bid_Line_Item__c)){
                        system.debug('================INSIDE ROS IF CONDITION bidLineItem Extn trigger==================');
                        blItem = bliMap.get(bliExtObj.Phoenix_Bid_Line_Item__c);
                        
                        Decimal proDirUnits = bliExtObj.Phoenix_Proposed_CVS_DirSellingUnits__c != null? bliExtObj.Phoenix_Proposed_CVS_DirSellingUnits__c : 0;
                        Decimal proIndirUnits = bliExtObj.Phoenix_Proposed_CVS_IndirSellingUnits__c != null? bliExtObj.Phoenix_Proposed_CVS_IndirSellingUnits__c : 0;
                        Decimal proCardinalUnits = bliExtObj.Phoenix_Proposed_Cardinal_Units__c != null? bliExtObj.Phoenix_Proposed_Cardinal_Units__c : 0;
                        Decimal proMajorUnits = bliExtObj.Phoenix_Proposed_Major_Units__c != null? bliExtObj.Phoenix_Proposed_Major_Units__c : 0;
                        
                        Decimal overrideCurrentDir  = blItem.Phoenix_Override_Current_Direct_Units__c != null? blItem.Phoenix_Override_Current_Direct_Units__c : 0;
                        Decimal overrideCurrentIndir = blItem.Phoenix_Override_Current_Indirect_Units__c != null? blItem.Phoenix_Override_Current_Indirect_Units__c : 0;
                        Decimal overrideMajor = bliExtObj.Phoenix_OverrideMajorUnits__c != null? bliExtObj.Phoenix_OverrideMajorUnits__c : 0;
                        Decimal overrideCard = blItem.Phoenix_Override_Current_Units__c != null? blItem.Phoenix_Override_Current_Units__c : 0;
                        Decimal overrideIndirectUnits = overrideCurrentIndir + overrideMajor + overrideCard;
                        Decimal overrideTotalUnits = overrideCurrentDir + overrideIndirectUnits;
                        blItem.Phoenix_Override_Total_units__c = overrideTotalUnits;
                        
                        Decimal retailDirUnits = blItem.Phoenix_Current_Retail_Direct_Units__c != null ? blItem.Phoenix_Current_Retail_Direct_Units__c : 0;
                        Decimal retailIndirUnits = blItem.Phoenix_Current_Retail_Indirect_Units__c != null ? blItem.Phoenix_Current_Retail_Indirect_Units__c : 0;
                        Decimal wholesaleUnits = blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c : 0;
                        Decimal anual3MonMajorUnits = bliExtObj.Phoenix_3MonAnnualMajorSellingUnits__c != null ? bliExtObj.Phoenix_3MonAnnualMajorSellingUnits__c : 0;
                        
                        blItem.Phoenix_Current_Direct_Selling_Unit__c = retailDirUnits;
                        blItem.Phoenix_Current_Indirect_Selling_Unit__c = retailIndirUnits + wholesaleUnits + anual3MonMajorUnits;
                        Decimal currentTotalUnits = retailDirUnits + retailIndirUnits + wholesaleUnits + anual3MonMajorUnits;
                        bliExtObj.Phoenix_Total3MonAnnualSellingUnits__c = currentTotalUnits;//Total 3 Months Annualized Selling Units
                        
                        Decimal actual12Month = blItem.Phoenix_12_Months_Actual_Sales__c != null ? blItem.Phoenix_12_Months_Actual_Sales__c : 0;
                        Decimal actual12MonthIndUnits = blItem.Phoenix_12_Months_IndirectSaleUnit__c != null ? blItem.Phoenix_12_Months_IndirectSaleUnit__c : 0;
                        Decimal actual12MonthCardUnits = bliExtObj.Phoenix_Actual12MonCardinalSelUnits__c != null ? bliExtObj.Phoenix_Actual12MonCardinalSelUnits__c : 0;
                        Decimal actual12MonthMajorUnits = bliExtObj.Phoenix_Actual12MonMajorSelUnit__c != null ? bliExtObj.Phoenix_Actual12MonMajorSelUnit__c : 0;
                        //Actual 12 Months Total  Sales Units
                        bliExtObj.Phoenix_Actual12MonTotalSaleUnits__c = actual12Month + actual12MonthIndUnits + actual12MonthCardUnits + actual12MonthMajorUnits;
                        
                        Decimal proIndirTotalUnits = proIndirUnits + proCardinalUnits + proMajorUnits; 
                        blItem.Phoenix_Proposed_Direct_Selling_Unit__c = proDirUnits;
                        blItem.Phoenix_Proposed_Indirect_Selling_Unit__c = proIndirTotalUnits;
                        
                        Decimal totalUnits = 0;
                        Decimal proposedTotalUnits = proDirUnits + proIndirTotalUnits;
                        Decimal totalCurrentUnits = overrideTotalUnits != 0 ? overrideTotalUnits : currentTotalUnits;
                        totalUnits = proposedTotalUnits != 0 ? proposedTotalUnits : totalCurrentUnits;
                        //blItem.Phoenix_Final_Total_Selling_Unit__c = totalUnits;
                        
                        Decimal scmApprovedDirUnits = 0;
                        Decimal scmApprovedIndirUnits = 0;
                        Decimal scmCardinalUnits = 0;
                        Decimal scmMajorUnits = 0;
                        Decimal finalCalcedScmQuantity = 0;
                        
                        if (blItem.Phoenix_SCM_Final_Approval__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) {
                            if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved') {
                                scmApprovedDirUnits = overrideCurrentDir != 0 ? overrideCurrentDir : retailDirUnits;
                                scmApprovedIndirUnits = overrideCurrentIndir != 0 ? overrideCurrentIndir : retailIndirUnits;
                                scmCardinalUnits = overrideCard != 0 ? overrideCard : wholesaleUnits;
                                scmMajorUnits = overrideMajor !=0 ? overrideMajor : anual3MonMajorUnits;
                            }
                            else if(blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved'){
                                finalCalcedScmQuantity = ((totalCurrentUnits/12)+((blItem.Phoenix_SCM_Approved_Quantity__c/100)*((proposedTotalUnits/12)-(totalCurrentUnits/12))))*12;
                                scmApprovedDirUnits = totalUnits != 0 ? ((proDirUnits / totalUnits) * finalCalcedScmQuantity) : 0;
                                scmApprovedIndirUnits = totalUnits != 0 ? ((proIndirUnits / totalUnits) * finalCalcedScmQuantity) : 0;
                                scmCardinalUnits = totalUnits != 0 ? ((proCardinalUnits / totalUnits) * finalCalcedScmQuantity) : 0;
                                scmMajorUnits = totalUnits != 0 ? ((proMajorUnits / totalUnits) * finalCalcedScmQuantity) : 0;
                            }
                            blItem.Phoenix_Current_Anda_Units__c = scmApprovedDirUnits;
                            blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c = scmApprovedIndirUnits;
                            blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c = scmCardinalUnits;
                            blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c = scmMajorUnits;
                        }
                        
                        Decimal directOverallUnits = 0;
                        Decimal indirectOverallUnits = 0;
                        Decimal cardinalOverallUnits = 0;
                        Decimal majorOverallUnits = 0;
                        
                        //if(finalCalcedScmQuantity != 0){    
                        if (blItem.Phoenix_SCM_Final_Approval__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) {
                            directOverallUnits = scmApprovedDirUnits;
                            
                            indirectOverallUnits = scmApprovedIndirUnits;
                            cardinalOverallUnits = scmCardinalUnits;
                            majorOverallUnits = scmMajorUnits;
                        }
                        else if(proposedTotalUnits > 0){
                            directOverallUnits = proDirUnits;
                            
                            indirectOverallUnits = proIndirUnits;
                            cardinalOverallUnits = proCardinalUnits;
                            majorOverallUnits = proMajorUnits;
                        }
                        else if(overrideTotalUnits > 0){
                            directOverallUnits = overrideCurrentDir;
                            
                            indirectOverallUnits = overrideCurrentIndir;
                            cardinalOverallUnits = overrideCard;
                            majorOverallUnits = overrideMajor;
                        }
                        else{
                            directOverallUnits = retailDirUnits;
                            
                            indirectOverallUnits = retailIndirUnits;
                            cardinalOverallUnits = wholesaleUnits;
                            majorOverallUnits = anual3MonMajorUnits;
                        }
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = directOverallUnits;
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c  = indirectOverallUnits + cardinalOverallUnits + majorOverallUnits;
                        
                        /*else{    
Decimal dirUnits = proposedTotalUnits != 0 ? proDirUnits : overrideTotalUnits != 0 ? overrideCurrentDir : retailDirUnits;
Decimal inDirUnits = proposedTotalUnits != 0 ? proIndirTotalUnits : overrideTotalUnits != 0 ? overrideIndirectUnits : blItem.Phoenix_Current_Indirect_Selling_Unit__c;
blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = dirUnits;//proDirUnits != 0 ? proDirUnits : overrideCurrentDir != 0 ? overrideCurrentDir : retailDirUnits;
blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c  = inDirUnits;//proIndirTotalUnits != 0 ? proIndirTotalUnits : overrideIndirectUnits != 0 ? overrideIndirectUnits : blItem.Phoenix_Current_Indirect_Selling_Unit__c;
}*/
                        Decimal curDirPrice = blItem.Phoenix_Current_Direct_Price__c != null ? blItem.Phoenix_Current_Direct_Price__c : 0;
                        Decimal wholeSalePrice = blItem.Phoenix_Current_Wholesaler_Price__c != null ? blItem.Phoenix_Current_Wholesaler_Price__c : 0;
                        bidRec.Phoenix_Current_CD__c = bidRec.Phoenix_Current_CD__c != null ? bidRec.Phoenix_Current_CD__c : 0;
                        bidRec.Phoenix_Proposed_Value_Admin_Fee__c = bidRec.Phoenix_Proposed_Value_Admin_Fee__c != null ? bidRec.Phoenix_Proposed_Value_Admin_Fee__c : 0 ;
                        bliExtObj.Phoenix_CVS_Cash_Terms__c = curDirPrice*(bidRec.Phoenix_Current_CD__c/100);// *2%
                        bliExtObj.Phoenix_CVS_Fees__c = curDirPrice*(bidRec.Phoenix_Proposed_Value_Admin_Fee__c/100);// *1.5%
                        bliExtObj.Phoenix_Cardinal_Cash_Terms__c = (bidRec.Phoenix_Current_CD__c/100)*blItem.Phoenix_WAC__c;
                        Decimal cardinalRebateFromNpr = blItem.Phoenix_Current_Rebate__c != null ? blItem.Phoenix_Current_Rebate__c : 0 ;
                        bliExtObj.Phoenix_Cardinal_Rebates__c = wholeSalePrice * (cardinalRebateFromNpr/100);
                        bliExtObj.Phoenix_Major_Cash_Terms__c = (bidRec.Phoenix_Current_CD__c/100)*blItem.Phoenix_WAC__c;
                        Decimal proposedSalesPrice = blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? 
                            blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : 0;
                        bliExtObj.Phoenix_Proposed_Cardinal_Sales_Price__c = proposedSalesPrice;
                        bliExtObj.Phoenix_Proposed_Major_Sales_Price__c = proposedSalesPrice;
                        
                        Decimal currMajorConPrice = bliExtObj.Phoenix_Current_Major_Contract_Price__c != null ? bliExtObj.Phoenix_Current_Major_Contract_Price__c : 0;
                        
                        Decimal majorRebateFromNpr = blItem.Phoenix_Proposed_Current_Rebate__c != null ? blItem.Phoenix_Proposed_Current_Rebate__c : 0 ;
                        bliExtObj.Phoenix_Major_Rebates__c = currMajorConPrice != 0 ? (currMajorConPrice * (majorRebateFromNpr/100)) : 0;
                        Decimal acquisitionCost = curDirPrice - bliExtObj.Phoenix_CVS_Cash_Terms__c- bliExtObj.Phoenix_CVS_Fees__c;
                        blItem.Phoenix_Current_Anda_Acquisition_Costs__c = acquisitionCost != 0 ? acquisitionCost : 0;
                        Decimal oldAcuisitionCost = wholeSalePrice - bliExtObj.Phoenix_Cardinal_Cash_Terms__c- bliExtObj.Phoenix_Cardinal_Rebates__c;
                        blItem.Phoenix_Anda_Old_Acqusition_Costs__c = oldAcuisitionCost > 0 ? oldAcuisitionCost: 0 ;
                        Decimal majorAquicitionCost = currMajorConPrice - bliExtObj.Phoenix_Major_Cash_Terms__c - bliExtObj.Phoenix_Major_Rebates__c;
                        bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c = majorAquicitionCost > 0 ? majorAquicitionCost : 0;
                        Decimal preCardRebatePercent = bliExtObj.Phoenix_Preferred_Cardinal_Rebate_per__c != null ? (bliExtObj.Phoenix_Preferred_Cardinal_Rebate_per__c/100) : 0;
                        Decimal preMajorRebatePercent = bliExtObj.Phoenix_Major_Rebate_per__c != null ? (bliExtObj.Phoenix_Major_Rebate_per__c/100) : 0;
                        Decimal indirCD = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                        Decimal propCsvDirPrice = 0;
                        Decimal propCardinalPrice = 0;
                        Decimal propMajorPrice = 0;
                        Decimal calValue = 1-(bidRec.Phoenix_Current_CD__c/100)-(bidRec.Phoenix_Proposed_Value_Admin_Fee__c/100);
                        Decimal divVariable = 1 - preCardRebatePercent;
                        Decimal divVariable2 = 1 - preMajorRebatePercent;
                        
                        Decimal proposedCvsAquisition = bliExtObj.Phoenix_PropMarktCvsCardinalAcquisitCost__c != null ? bliExtObj.Phoenix_PropMarktCvsCardinalAcquisitCost__c : 0;
                        
                        if(proposedCvsAquisition != 0){
                            if(proposedTotalUnits > 0){
                                if(proDirUnits >0)
                                    propCsvDirPrice = calValue >0 ? proposedCvsAquisition/calValue : 0;// /(1-2%-1.5%);
                                // Proposed Cardinal Contract Price 
                                if(proCardinalUnits >0)
                                    propCardinalPrice = divVariable > 0 ? (proposedCvsAquisition + indirCD)/divVariable : 0;
                                // Proposed Major Contract Price 
                                if(proMajorUnits >0)
                                    propMajorPrice = divVariable2 > 0 ? (proposedCvsAquisition + indirCD )/divVariable2 : 0;
                            }
                            else{
                                if(curDirPrice != 0)
                                    propCsvDirPrice = calValue >0 ? proposedCvsAquisition/calValue : 0;// /(1-2%-1.5%);
                                if(wholeSalePrice != 0)
                                    propCardinalPrice = divVariable > 0 ? (proposedCvsAquisition + indirCD)/divVariable : 0;
                                if(currMajorConPrice != 0)
                                    propMajorPrice = divVariable2 > 0 ? (proposedCvsAquisition + indirCD )/divVariable2 : 0;
                            }
                        }
                        else if(proposedSalesPrice != 0){
                            if(proposedTotalUnits > 0){
                                if(proDirUnits >0)
                                    propCsvDirPrice = calValue >0 ? proposedSalesPrice/calValue : 0;// /(1-2%-1.5%);
                                // Proposed Cardinal Contract Price 
                                if(proCardinalUnits >0)
                                    propCardinalPrice = divVariable > 0 ? (proposedSalesPrice + indirCD)/divVariable : 0;
                                // Proposed Major Contract Price 
                                if(proMajorUnits >0)
                                    propMajorPrice = divVariable2 > 0 ? (proposedSalesPrice + indirCD )/divVariable2 : 0;
                            }
                            else{
                                if(curDirPrice != 0)
                                    propCsvDirPrice = calValue >0 ? proposedSalesPrice/calValue : 0;// /(1-2%-1.5%);
                                if(wholeSalePrice != 0)
                                    propCardinalPrice = divVariable > 0 ? (proposedSalesPrice + indirCD)/divVariable : 0;
                                if(currMajorConPrice != 0)
                                    propMajorPrice = divVariable2 > 0 ? (proposedSalesPrice + indirCD )/divVariable2 : 0;
                            }
                        }
                        else if(blItem.Phoenix_Current_Anda_Acquisition_Costs__c != null && blItem.Phoenix_Current_Anda_Acquisition_Costs__c != 0){
                            if(proposedTotalUnits > 0){
                                if(proDirUnits >0)
                                    propCsvDirPrice = calValue >0 ? blItem.Phoenix_Current_Anda_Acquisition_Costs__c/calValue : 0;// /(1-2%-1.5%);
                                // Proposed Cardinal Contract Price 
                                if(proCardinalUnits >0)
                                    propCardinalPrice = divVariable > 0 ? (blItem.Phoenix_Current_Anda_Acquisition_Costs__c + indirCD)/divVariable : 0;
                                // Proposed Major Contract Price 
                                if(proMajorUnits >0)
                                    propMajorPrice = divVariable2 > 0 ? (blItem.Phoenix_Current_Anda_Acquisition_Costs__c + indirCD )/divVariable2 : 0;
                            }
                            else{
                                if(curDirPrice != 0)
                                    propCsvDirPrice = calValue >0 ? blItem.Phoenix_Current_Anda_Acquisition_Costs__c/calValue : 0;// /(1-2%-1.5%);
                                if(wholeSalePrice != 0)
                                    propCardinalPrice = divVariable > 0 ? (blItem.Phoenix_Current_Anda_Acquisition_Costs__c + indirCD)/divVariable : 0;
                                if(currMajorConPrice != 0)
                                    propMajorPrice = divVariable2 > 0 ? (blItem.Phoenix_Current_Anda_Acquisition_Costs__c + indirCD )/divVariable2 : 0;
                            }
                        }
                        else if(blItem.Phoenix_Anda_Old_Acqusition_Costs__c != null && blItem.Phoenix_Anda_Old_Acqusition_Costs__c != 0){
                            if(proposedTotalUnits > 0){
                                if(proDirUnits >0)
                                    propCsvDirPrice = calValue >0 ? blItem.Phoenix_Anda_Old_Acqusition_Costs__c/calValue : 0;// /(1-2%-1.5%);
                                // Proposed Cardinal Contract Price 
                                if(proCardinalUnits >0)
                                    propCardinalPrice = divVariable > 0 ? (blItem.Phoenix_Anda_Old_Acqusition_Costs__c + indirCD)/divVariable : 0;
                                // Proposed Major Contract Price 
                                if(proMajorUnits >0)
                                    propMajorPrice = divVariable2 > 0 ? (blItem.Phoenix_Anda_Old_Acqusition_Costs__c + indirCD )/divVariable2 : 0;
                            }
                            else{
                                if(curDirPrice != 0)
                                    propCsvDirPrice = calValue >0 ? blItem.Phoenix_Anda_Old_Acqusition_Costs__c/calValue : 0;// /(1-2%-1.5%);
                                if(wholeSalePrice != 0)
                                    propCardinalPrice = divVariable > 0 ? (blItem.Phoenix_Anda_Old_Acqusition_Costs__c + indirCD)/divVariable : 0;
                                if(currMajorConPrice != 0)
                                    propMajorPrice = divVariable2 > 0 ? (blItem.Phoenix_Anda_Old_Acqusition_Costs__c + indirCD )/divVariable2 : 0;
                            }
                        }
                        else if(bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c != null && bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c != 0){
                            if(proposedTotalUnits > 0){
                                if(proDirUnits >0)
                                    propCsvDirPrice = calValue >0 ? bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c/calValue : 0;// /(1-2%-1.5%);
                                // Proposed Cardinal Contract Price 
                                if(proCardinalUnits >0)
                                    propCardinalPrice = divVariable > 0 ? (bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c + indirCD)/divVariable : 0;
                                // Proposed Major Contract Price 
                                if(proMajorUnits >0)
                                    propMajorPrice = divVariable2 > 0 ? (bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c + indirCD )/divVariable2 : 0;
                            }
                            else{
                                if(curDirPrice != 0)
                                    propCsvDirPrice = calValue >0 ? bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c/calValue : 0;// /(1-2%-1.5%);
                                if(wholeSalePrice != 0)
                                    propCardinalPrice = divVariable > 0 ? (bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c + indirCD)/divVariable : 0;
                                if(currMajorConPrice != 0)
                                    propMajorPrice = divVariable2 > 0 ? (bliExtObj.Phoenix_Current_Major_Acquisition_Costs__c + indirCD )/divVariable2 : 0;
                            }
                        }
                        
                        //else{
                        bliExtObj.Phoenix_Proposed_CvsDirectContractPrice__c = propCsvDirPrice;
                        blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c = propCardinalPrice;
                        bliExtObj.Phoenix_Proposed_Major_Contract_Price__c = propMajorPrice;
                        //}
                        
                        //Reduction
                        // Decimal reduction = (acquisitionCost > 0 && proposedCvsAquisition > 0) ? ((proposedCvsAquisition/acquisitionCost)-1)*100 : 0;
                        /*Added by satya*/
                        Decimal newproposedCvsAquisition = proposedCvsAquisition != 0 ? proposedCvsAquisition : proposedSalesPrice;
                        Decimal belowDecimal = acquisitionCost > 0 ? acquisitionCost : oldAcuisitionCost > 0 ? oldAcuisitionCost : majorAquicitionCost > 0 ? majorAquicitionCost : 0 ;
                        Decimal reduction = (belowDecimal > 0 && newproposedCvsAquisition > 0) ? (newproposedCvsAquisition/belowDecimal -1)*100 : 0;
                        /*End by satya*/
                        blItem.Phoenix_Reduction__c = reduction;
                        //Cash Discount
                        blItem.Phoenix_Direct_CD__c = propCsvDirPrice*(bidRec.Phoenix_Current_CD__c/100); // *2%
                        //Service Fee (1.5%)
                        bliExtObj.Phoenix_Service_Fee__c = propCsvDirPrice*(bidRec.Phoenix_Proposed_Value_Admin_Fee__c/100); // *1.5%
                        //Internal CVS Direct Dead Net
                        Decimal dirDeadNet = propCsvDirPrice - blItem.Phoenix_Direct_CD__c - bliExtObj.Phoenix_Service_Fee__c;
                        blItem.Phoenix_Direct_Dead_Net__c = dirDeadNet > 0 ? dirDeadNet : 0;
                        
                        Decimal propBidPricing = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? 
                            blItem.Phoenix_ProposedContractBidPriceMktng__c :  blItem.Phoenix_Current_Indirect_Price__c != null ? 
                                blItem.Phoenix_Current_Indirect_Price__c : 0; //bliExtObj.Phoenix_Proposed_CvsDirectContractPrice__c != null ? 
                        //bliExtObj.Phoenix_Proposed_CvsDirectContractPrice__c :
                        
                        Decimal conMngFeeWholePer = blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c != null ? blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0 ;
                        
                        //ZITD
                        Decimal zitd = propBidPricing - propCsvDirPrice;
                        bliExtObj.Phoenix_ZITD__c = propCsvDirPrice > 0 ? (zitd > 0 ? zitd : 0):0;
                        //RDC Fees
                        Decimal rdc = blItem.Phoenix_RDC_NLC__c != null ? blItem.Phoenix_RDC_NLC__c : 0;//blItem.Phoenix_WAC__c*(1/100); // *1%
                        //CM Fees
                        blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = propBidPricing*(conMngFeeWholePer/100); // *9.26%
                        //Internal CVS Indirect Dead Net
                        //check if Phoenix_ProposedContractBidPriceMktng__c is not NULL or 0
                        Decimal cvsIndirectDeadNet = propBidPricing - bliExtObj.Phoenix_ZITD__c - indirCD - blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c- rdc;
                        blItem.Phoenix_Indirect_Dead_Net__c = cvsIndirectDeadNet > 0 ? cvsIndirectDeadNet: 0;	
                        //CVS Indirect TPT $
                        // NOT WRITABLE FIELD    blItem.Indirect_TP__c = blItem.Phoenix_Indirect_Dead_Net__c - blItem.Phoenix_Throughput_cost__c;
                        //CVS Indirect TPT % 
                        // NOT WRITABLE FIELD  Phoenix_Indirect_TP__c = blItem.Indirect_TP__c / cvsIndirectDeadNet;
                        Decimal wholeSaleDiffIndir = blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : 0;
                        //Cash Discount on WAC
                        // NOT WRITABLE FIELD    blItem.Phoenix_INDIRECT_CD__c = blItem.Phoenix_WAC__c; //*2%
                        //Cardinal Preferred Rebate $
                        blItem.Phoenix_Net_Price_after_Rebates_Terms__c = preCardRebatePercent*propCardinalPrice;
                        // NLC Fees 
                        //bliExtObj.Phoenix_NLC_Fees__c = blItem.Phoenix_WAC__c;// *0.27%
                        // Cardinal additional Rebate $ 
                        // WE ARE NOT USING THIS FIELD blItem.Phoenix_Net_Price_afterRebates_after_VIP__c = propCardinalPrice*(1/100); //*1%
                        bliExtObj.Phoenix_CardinalAdditionalRebate__c = propCardinalPrice * (additionalRebate/100);
                        Decimal nlcFee = blItem.Phoenix_NLC__c != null ? blItem.Phoenix_NLC__c : 0;
                        // Internal Cardinal Dead Net 
                        // check if Phoenix_Wholesaler_Diff_Price_Indirect__c is not null
                        Decimal custDeadNet = propCardinalPrice - indirCD - blItem.Phoenix_Net_Price_after_Rebates_Terms__c - nlcFee - bliExtObj.Phoenix_CardinalAdditionalRebate__c;
                        blItem.Phoenix_Customer_Dead_Net1__c = custDeadNet > 0 ? custDeadNet : 0 ;
                        Decimal thrPutCost = blItem.Phoenix_Throughput_cost__c != null ? blItem.Phoenix_Throughput_cost__c : 0 ;
                        // Cardinal TPT $ 
                        Decimal cardinalTptPer = blItem.Phoenix_Customer_Dead_Net1__c > 0 ? blItem.Phoenix_Customer_Dead_Net1__c - thrPutCost : 0;
                        bliExtObj.Phoenix_Cardinal_TPT_perUnit__c = cardinalTptPer;
                        // Cardinal TPT % 
                        bliExtObj.Phoenix_Cardinal_TPT_Per_perUnit__c = blItem.Phoenix_Customer_Dead_Net1__c != 0 ? (bliExtObj.Phoenix_Cardinal_TPT_perUnit__c/blItem.Phoenix_Customer_Dead_Net1__c)*100 : 0;
                        
                        Decimal proMajorConPrice = bliExtObj.Phoenix_Proposed_Major_Contract_Price__c != null ? bliExtObj.Phoenix_Proposed_Major_Contract_Price__c : 0;
                        Decimal majorRebatPer = bliExtObj.Phoenix_Major_Rebate_per__c != null ? bliExtObj.Phoenix_Major_Rebate_per__c/100 : 0;
                        //Major Preferred Rebate $
                        blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c = propMajorPrice * majorRebatPer;
                        // Major Additional Rebate $ 
                        bliExtObj.Phoenix_Major_Additional_Rebate__c = propMajorPrice * (additionalRebate/100); //*1%
                        // Internal Major Dead Net 
                        // check Phoenix_Proposed_Major_Contract_Price__c is not null
                        Decimal majorDeadNet = propMajorPrice - indirCD - blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c - bliExtObj.Phoenix_Major_Additional_Rebate__c;
                        bliExtObj.Phoenix_Internal_Major_Dead_Net__c = majorDeadNet > 0 ? majorDeadNet : 0;
                        // Major TPT $ 
                        decimal majorTptPer = bliExtObj.Phoenix_Internal_Major_Dead_Net__c > 0 ? bliExtObj.Phoenix_Internal_Major_Dead_Net__c - thrPutCost : 0;
                        bliExtObj.Phoenix_Major_TPT_perUnit__c = majorTptPer;
                        // Major TPT % 
                        bliExtObj.Phoenix_Major_TPT_Per_perUnit__c = bliExtObj.Phoenix_Internal_Major_Dead_Net__c != 0 ? (bliExtObj.Phoenix_Major_TPT_perUnit__c/bliExtObj.Phoenix_Internal_Major_Dead_Net__c)*100 : 0;
                        // Cardinal IoD per unit
                        blItem.Phoenix_Retail_IOD_per_unit__c = blItem.Phoenix_WAC__c * (initialOrderDisc/100); //*5% propCardinalPrice
                        // Major IoD per unit 
                        blItem.Phoenix_Wholesaler_IOD_per_unit__c = blItem.Phoenix_WAC__c * (initialOrderDisc/100); //*5%  //Bid IOD percent propMajorPrice
                        // Cardinal IoD overall amount $ 
                        blItem.Phoenix_IOD_Total_Amount__c = (cardinalOverallUnits/360)*blItem.Phoenix_Retail_IOD_per_unit__c*initialOrderDays; // from BID initial order days
                        //  Major IoD overall amount $ 
                        blItem.Phoenix_Wholesaler_IOD_overall_amount__c = (majorOverallUnits/360)*blItem.Phoenix_Wholesaler_IOD_per_unit__c*initialOrderDays;
                        //  Medicaid & Returns  per unit 
                        Decimal estimateMedic = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0 ;
                        // iS NOT WRITEABLE blItem.Phoenix_Estimated_Medicaid_Returns__c = 0.75;
                        // CVS Direct Net Sales 
                        Decimal netSaleDirect = blItem.Phoenix_Direct_Dead_Net__c > 0 ? (blItem.Phoenix_Direct_Dead_Net__c*directOverallUnits)-(estimateMedic*directOverallUnits) : 0;
                        blItem.Proposed_Net_Sales_Direct__c = netSaleDirect;
                        // CVS Indirect Net Sales 
                        Decimal netSaleIndirect = blItem.Phoenix_Indirect_Dead_Net__c > 0 ? (blItem.Phoenix_Indirect_Dead_Net__c*indirectOverallUnits)-
                            (estimateMedic*indirectOverallUnits) : 0;
                        blItem.Proposed_Net_Sales_Indirect__c = netSaleIndirect;
                        //  CVS Total Net Sales 
                        bliExtObj.Phoenix_CVS_Total_Net_Sales__c = blItem.Proposed_Net_Sales_Direct__c + netSaleIndirect;
                        //  CVS Direct TPT $ 
                        Decimal cvsDirTpt = blItem.Phoenix_Direct_Dead_Net__c > 0 ? blItem.Proposed_Net_Sales_Direct__c - (directOverallUnits*thrPutCost) : 0;
                        bliExtObj.Phoenix_CVS_Direct_TPT__c = cvsDirTpt;
                        //  CVS Indirect TPT $ 
                        Decimal cvsIndirectTpt = blItem.Phoenix_Indirect_Dead_Net__c > 0 ? netSaleIndirect - (indirectOverallUnits*thrPutCost) : 0;
                        bliExtObj.Phoenix_CVS_Indirect_TPT__c = cvsIndirectTpt;
                        // CVS Total  TPT $ 
                        bliExtObj.Phoenix_CVS_Total_TPT__c = bliExtObj.Phoenix_CVS_Direct_TPT__c + bliExtObj.Phoenix_CVS_Indirect_TPT__c;
                        //  CVS Direct TPT % 
                        bliExtObj.Phoenix_CVS_Direct_TPT_Per__c =  blItem.Proposed_Net_Sales_Direct__c > 0 ? 
                            (bliExtObj.Phoenix_CVS_Direct_TPT__c/blItem.Proposed_Net_Sales_Direct__c)*100 : 0;
                        // CVS Indirect TPT % 
                        bliExtObj.Phoenix_CVS_Indirect_TPT_Per__c =  netSaleIndirect > 0 ? 
                            (bliExtObj.Phoenix_CVS_Indirect_TPT__c/netSaleIndirect)*100 : 0;
                        // CVS Total  TPT % 
                        bliExtObj.Phoenix_CVS_Total_TPT_Per__c = bliExtObj.Phoenix_CVS_Total_Net_Sales__c > 0 ? 
                            (bliExtObj.Phoenix_CVS_Total_TPT__c / bliExtObj.Phoenix_CVS_Total_Net_Sales__c)*100 : 0;
                        //  Cardinal Net Sales 
                        Decimal wholeSalerNetSale = blItem.Phoenix_Customer_Dead_Net1__c > 0 ? (cardinalOverallUnits*blItem.Phoenix_Customer_Dead_Net1__c)-
                            blItem.Phoenix_IOD_Total_Amount__c-
                            (cardinalOverallUnits*blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c) : 0;
                        blItem.Phoenix_Wholesaler_Net_Sales__c = wholeSalerNetSale;
                        // Cardinal TPT $ 
                        Decimal cardinalTpt = blItem.Phoenix_Customer_Dead_Net1__c > 0 ? blItem.Phoenix_Wholesaler_Net_Sales__c - (cardinalOverallUnits * thrPutCost) : 0;
                        bliExtObj.Phoenix_Cardinal_TPT__c = cardinalTpt;
                        //  Cardinal TPT % 
                        bliExtObj.Phoenix_Cardinal_TPT_Per__c = blItem.Phoenix_Wholesaler_Net_Sales__c != 0 ? (bliExtObj.Phoenix_Cardinal_TPT__c/blItem.Phoenix_Wholesaler_Net_Sales__c)*100 : 0;
                        // Major Net Sales 
                        Decimal majorTpt = bliExtObj.Phoenix_Internal_Major_Dead_Net__c > 0 ? (bliExtObj.Phoenix_Internal_Major_Dead_Net__c*majorOverallUnits)-
                            blItem.Phoenix_Wholesaler_IOD_overall_amount__c-
                            (majorOverallUnits*blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c) : 0;
                        bliExtObj.Phoenix_Major_Net_Sales__c = majorTpt;
                        // Major TPT $ 
                        bliExtObj.Phoenix_Major_TPT__c = bliExtObj.Phoenix_Internal_Major_Dead_Net__c > 0 ? bliExtObj.Phoenix_Major_Net_Sales__c-(majorOverallUnits * thrPutCost) : 0;
                        // Major TPT % 
                        bliExtObj.Phoenix_Major_TPT_Per__c = bliExtObj.Phoenix_Major_Net_Sales__c != 0 ? (bliExtObj.Phoenix_Major_TPT__c/bliExtObj.Phoenix_Major_Net_Sales__c)*100 : 0;
                        // Total RedOak Net Sales 
                        blItem.Phoenix_Net_Sales_Internal__c = bliExtObj.Phoenix_Major_Net_Sales__c + 
                            blItem.Phoenix_Wholesaler_Net_Sales__c + bliExtObj.Phoenix_CVS_Total_Net_Sales__c;
                        // Total RedOak TPT $ 	 
                        bliExtObj.Phoenix_Total_RedOak_TPT__c = bliExtObj.Phoenix_CVS_Total_TPT__c + 
                            bliExtObj.Phoenix_Cardinal_TPT__c + bliExtObj.Phoenix_Major_TPT__c;
                        // Total RedOak TPT % 
                        bliExtObj.Phoenix_Total_RedOak_TPT_Per__c = blItem.Phoenix_Net_Sales_Internal__c != 0 ? (bliExtObj.Phoenix_Total_RedOak_TPT__c/blItem.Phoenix_Net_Sales_Internal__c)*100 : 0;
                        //% Brand WAC for CVS
                        Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                        Decimal cvsDeadNet = blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c :0;
                        bliExtObj.Phoenix_CVS_Brand_WAC_Perc__c = brandwac!= null && brandwac != 0 ? (cvsDeadNet /brandwac)*100 : 0 ;
                        //% Brand WAC for Cardinal
                        Decimal cardinalDeadNet = blItem.Phoenix_Customer_Dead_Net1__c != null ? blItem.Phoenix_Customer_Dead_Net1__c :0;
                        blItem.Phoenix_Brand_WAC_Per__c = brandwac!= null && brandwac != 0 ? (cardinalDeadNet /brandwac)*100 : 0 ;
                        //% Brand WAC for Major
                        Decimal internalMajorDeadNet = bliExtObj.Phoenix_Internal_Major_Dead_Net__c != null && bliExtObj.Phoenix_Internal_Major_Dead_Net__c != 0 ? bliExtObj.Phoenix_Internal_Major_Dead_Net__c : 0;
                        bliExtObj.Phoenix_Major_Brand_WAC_Per__c = brandwac != null && brandwac != 0 ? (internalMajorDeadNet / brandwac)*100 : 0;
                        Decimal openingOrder = blItem.Phoenix_Opening_Order__c !=null &&  blItem.Phoenix_Opening_Order__c != 0 ? blItem.Phoenix_Opening_Order__c : 0 ;
                        //FOR Cardinal iod total Amount
                        Decimal cardinaliodtotalAmount = blItem.Phoenix_IOD_Total_Amount__c != null && blItem.Phoenix_IOD_Total_Amount__c != 0 ? blItem.Phoenix_IOD_Total_Amount__c :0;
                        Decimal medicaidreturnsPerUnit = (blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null && blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != 0) ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0;
                        Decimal throughputCost =  blItem.Phoenix_Throughput_cost__c != null &&  blItem.Phoenix_Throughput_cost__c != 0 ?  blItem.Phoenix_Throughput_cost__c :0;
                        // Opening Order CVS CALCULATIONS//
                        Decimal  cvsdirDeadnet = blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0;
                        Decimal opngOrderCVS = bliExtObj.Opening_Order_CVS__c !=null &&  bliExtObj.Opening_Order_CVS__c != 0 ? bliExtObj.Opening_Order_CVS__c : 0;
                        Decimal cvsorderNetSales = (opngOrderCVS * cvsdirDeadnet) - (opngOrderCVS * medicaidreturnsPerUnit);
                        bliExtObj.Opening_Order_Net_Sales_for_CVS__c = opngOrderCVS > 0 && cvsdirDeadnet > 0 ? cvsorderNetSales :0;
                        Decimal orderTPTCVS =   cvsorderNetSales - (opngOrderCVS * throughputCost) ;
                        bliExtObj.Opening_Order_TPT_for_CVS__c = opngOrderCVS > 0 && cvsdirDeadnet > 0 ? orderTPTCVS : 0 ;
                        bliExtObj.Opening_Order_TPT_Perc_for_CVS__c = (opngOrderCVS > 0 && cvsdirDeadnet > 0 && cvsorderNetSales > 0) ? (orderTPTCVS / cvsorderNetSales)*100 : 0;
                        // END Opening Order CVS CALCULATIONS//
                        // Opening Order Net Sales for Cardinal 
                        Decimal orderNetSales =  (openingOrder * cardinalDeadNet) - cardinaliodtotalAmount - ( openingOrder * medicaidreturnsPerUnit)  ;
                        blItem.Phoenix_Opening_Order_Net_sales__c = (openingOrder > 0 && cardinalDeadNet > 0) ? orderNetSales : 0 ;
                        // Opening Order TPT $ for Cardinal 
                        Decimal orderTPT =   orderNetSales - (openingOrder * throughputCost) ;
                        blItem.Phoenix_Opening_Order_TPT__c = (openingOrder > 0 && cardinalDeadNet > 0) ? orderTPT : 0 ;
                        // Opening Order TPT % for Cardinal 
                        blItem.Phoenix_Opening_Order_TPT_Per__c = (openingOrder > 0 && cardinalDeadNet > 0 && orderNetSales > 0) ? (orderTPT / orderNetSales)*100 : 0;
                        
                        Decimal openingOrderMajor = bliExtObj.Phoenix_Opening_Order_Major__c !=null && bliExtObj.Phoenix_Opening_Order_Major__c !=0 ? bliExtObj.Phoenix_Opening_Order_Major__c : 0;
                        bliExtObj.Phoenix_Opening_Order_Major__c = openingOrderMajor;
                        Decimal majorTotalIod = blItem.Phoenix_Wholesaler_IOD_overall_amount__c != null && blItem.Phoenix_Wholesaler_IOD_overall_amount__c != 0 ? blItem.Phoenix_Wholesaler_IOD_overall_amount__c : 0;
                        //  Opening Order Net Sales for Major 
                        Decimal orderMajorNetSales = (openingOrderMajor * internalMajorDeadNet) - majorTotalIod - (openingOrderMajor * medicaidreturnsPerUnit);
                        bliExtObj.Phoenix_Opening_Order_Major_Net_sales__c = (openingOrderMajor > 0 && internalMajorDeadNet > 0) ? orderMajorNetSales : 0 ;
                        // Opening Order TPT $ for Major 
                        Decimal orderMajorTPT = orderMajorNetSales - (openingOrderMajor * throughputCost);
                        bliExtObj.Phoenix_Opening_Order_Major_TPT__c = (openingOrderMajor > 0 && internalMajorDeadNet > 0) ? orderMajorTPT : 0 ;
                        // Opening Order TPT % for Major 
                        bliExtObj.Phoenix_Opening_Order_Major_TPT_Per__c = (openingOrderMajor > 0 && internalMajorDeadNet > 0 && orderMajorNetSales > 0) ? (orderMajorTPT /orderMajorNetSales)*100 : 0;
                        Decimal currentCVSDirectSales = ((blItem.Current_CVS_DeadNet__c != null ? blItem.Current_CVS_DeadNet__c: 0)* (overrideCurrentDir> 0 ? overrideCurrentDir:retailDirUnits) - (overrideCurrentDir> 0 ? overrideCurrentDir:retailDirUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                        Decimal currentCVSIndirectSales = ((blItem.Current_CVS_Indirect_DeadNet__c != null ? blItem.Current_CVS_Indirect_DeadNet__c: 0)* (overrideCurrentIndir> 0 ? overrideCurrentIndir:retailIndirUnits) - (overrideCurrentIndir> 0 ? overrideCurrentIndir:retailIndirUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                        Decimal currentCardinalSales = ((blItem.Current_Cardinal_DeadNet__c != null ? blItem.Current_Cardinal_DeadNet__c: 0)* (overrideCard> 0 ? overrideCard:wholesaleUnits) - (overrideCard> 0 ? overrideCard:wholesaleUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                        Decimal currentMajorSales = ((blItem.Current_Major_DeadNet__c != null ? blItem.Current_Major_DeadNet__c: 0)* (overrideMajor> 0 ? overrideMajor:anual3MonMajorUnits) - (overrideMajor> 0 ? overrideMajor:anual3MonMajorUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                        blItem.Finance_Current_Sales__c = currentCVSDirectSales+currentCVSIndirectSales+currentCardinalSales+currentMajorSales;
                        
                        Map<String,Decimal> counts = new Map<String,Decimal>();
                        counts.put('finalTotalDirectUnits',directOverallUnits);
                        counts.put('indirUnits',indirectOverallUnits);
                        counts.put('cardinalUnits',cardinalOverallUnits);
                        counts.put('majorUnits',majorOverallUnits);
                        /*Decimal finalTotalDirectUnits = proDirUnits != 0 ?
proDirUnits : overrideCurrentDir != 0 ?
overrideCurrentDir : retailDirUnits != 0 ?
retailDirUnits : 0 ;
counts.put('finalTotalDirectUnits',finalTotalDirectUnits);

Decimal indirUnits = proIndirUnits != 0 ? 
proIndirUnits : overrideCurrentIndir !=0 ? 
overrideCurrentIndir : retailIndirUnits != 0 ? 
retailIndirUnits : 0;
counts.put('indirUnits',indirUnits);

Decimal cardinalUnits = proCardinalUnits != 0 ? 
proCardinalUnits : overrideCard !=0 ? 
overrideCard : wholesaleUnits != 0 ? 
wholesaleUnits : 0;
counts.put('cardinalUnits',cardinalUnits);

Decimal majorUnits = proMajorUnits != 0 ? 
proMajorUnits : overrideMajor !=0 ? 
overrideMajor : anual3MonMajorUnits != 0 ? 
anual3MonMajorUnits : 0;
counts.put('majorUnits',majorUnits);*/
                        
                        Decimal finalTotalUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c + blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;//finalTotalDirectUnits + indirUnits + cardinalUnits + majorUnits;
                        
                        String maxKey = counts.isEmpty()?null:new List<String>(counts.keyset())[0];
                        for(String s1:counts.keySet()) {
                            maxKey = counts.get(s1) > counts.get(maxKey) ? s1 : maxKey;
                        }
                        
                        if(maxKey == 'finalTotalDirectUnits')
                            blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Direct_Dead_Net__c;
                        else if(maxKey == 'indirUnits')
                            blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Indirect_Dead_Net__c;
                        else if(maxKey == 'cardinalUnits')
                            blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Customer_Dead_Net1__c;
                        else if(maxKey == 'majorUnits')
                            blItem.Phoenix_Internal_Dead_Net_Price__c = bliExtObj.Phoenix_Internal_Major_Dead_Net__c;
                        blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0) * (finalTotalUnits);
                        
                        bidLineItemUpdateList.add(blItem);
                    } 
                } 
                Catch(Exception e) {
                    system.debug('EXCEPTION IN ROS ExtnUpdate trigger:: '+e.getMessage()+' :: LINE NUMBER :: '+e.getLineNumber());
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                    insert exp;
                }
            }
            system.debug('bidLineItemUpdateList.size() :: '+bidLineItemUpdateList.size());
            if(bidLineItemUpdateList.size() != 0){
                Phoenix_Util.blnAlreadyDone = true;
                //RecurssionCheckForBidLineAndChild.firstRun = false;
                update bidLineItemUpdateList;
            }
        }
    }
}