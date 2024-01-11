({
    updateProposedPrice : function(component, event, helper) {
        var curVal = parseFloat(component.get("v.wifCurrentValue")).toFixed(2);
        var changeVal = parseFloat(component.get("v.changeVal")).toFixed(2);
        console.log('changeVal --> '+changeVal);
        var proVal = parseFloat((changeVal/100)*(curVal)).toFixed(2);
        console.log('proVal1 --> '+proVal);
        if(proVal < 0)
            proVal = curVal-Math.abs(proVal);
        else
            proVal = Number(curVal)+Number(proVal);
        //proVal = Math.round(curVal+proVal);//parseInt(curVal).toFixed(2)+parseInt(proVal).toFixed(2);
        console.log('proVal2 --> '+proVal);
        component.set("v.wifProposedValue",proVal);
        helper.createCompleteList(component, helper, event, curVal, proVal);
    },
    
    getAffectedItems : function(component, event, helper){
        /*var bidLineData = component.get("v.bidLineData");
        var bidData = component.get("v.bidData");
        component.set("v.wifVariable",'Price Per unit %');
        var wifCurrentValue = bidLineData.Phoenix_Current_Indirect_Price__c;
        var changeVal = component.get("v.changeVal");
        component.set("v.wifCurrentValue",wifCurrentValue);
        
        var proVal = (changeVal/100)*parseInt(wifCurrentValue);
        proVal = parseInt(wifCurrentValue)+parseInt(proVal);
        component.set("v.wifProposedValue",proVal);
        
        if(component.get("v.selectedScenario") == 'Proposed Price Fine Tuning'){
            var affectedItems = [];
            //var eachItem = [{value:'Variable:',isLabel:true},{value:'TPT Cost Per Unit ($)',isLabel:true},{value:'TPT%',isLabel:true},{value:'DRL Deadnet Per Unit ($)',isLabel:true},{value:'Deadnet Sales',isLabel:true}];
            var eachItem = [{value:'Variable:',isLabel:true},{value:'VIP% Per Unit $:',isLabel:true},{value:'CM Fee Per Unit $:',isLabel:true},{value:'Customer Dead Net:',isLabel:true},//{value:'IOD Per Unit $:',isLabel:true},{value:'Sales Out Promotion Per Unit $:',isLabel:true},{value:'Current Rebate %:',isLabel:true},{value:'Proposed Rebate %:',isLabel:true},
                            {value:'Rebate % Per Unit $:',isLabel:true},{value:'Order Analytics Fee Per Unit $:',isLabel:true},{value:'Group VIP Per Unit $:',isLabel:true}];
            affectedItems.push({eachItems:eachItem});
        }
        
        //CURRENT VALUES
        eachItem = [];
        
        var eachTd = {};
        eachTd.isLabel = true;
        eachTd.value = 'Current:';
        eachItem.push(eachTd);
        
        var VipPerUnitCurrent = (bidLineData.Phoenix_Proposed_Est_VIP__c/100)*wifCurrentValue;
        eachTd = {};
        eachTd.value = VipPerUnitCurrent;//'2.10';
        eachTd.isPercent = true;
        eachTd.fieldVar = 'VipPerUnitCurrent';
        eachItem.push(eachTd);
        
        var cmFeePerUnitCurrent = (bidLineData.Phoenix_Contract_Mngment_Fee_Wholesaler__c/100)*wifCurrentValue;
        eachTd = {};
        eachTd.value = cmFeePerUnitCurrent;//'79.56';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'cmFeePerUnitCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = parseInt(wifCurrentValue)-parseInt(VipPerUnitCurrent)-parseInt(cmFeePerUnitCurrent)-parseInt(bidLineData.Phoenix_Customer_Cash_Discount1__c);//'2.64';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'custDeadNetCurrent';
        eachItem.push(eachTd);
        
        //var iodPerUnit = Phoenix_Proposed_Initial_Order_Discount__c;
        eachTd = {};
        eachTd.value = parseInt(bidLineData.Phoenix_Customer_Rebates1__c)*wifCurrentValue;//'198352';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'rebatePercentPerUnitCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = parseInt(bidLineData.Phoenix_Customer_Order_Analytics_Fee__c)*wifCurrentValue;//'198352';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'orderAnalyticsFeePerUnitCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = parseInt(bidData.Phoenix_Group_VIP__c)*wifCurrentValue;//'198352';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'groupVipPerUnitCurrent';
        eachItem.push(eachTd);
        
        
        affectedItems.push({eachItems:eachItem});
        
        //CHANGE VALUES
        eachItem = [];
        
        var eachTd = {};
        eachTd.isLabel = true;
        eachTd.value = 'Change:';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = '-15';
        eachTd.isChangeFactor = true;
        eachTd.isDown = false;
        eachTd.fieldVar = 'DRLdeadnetChange';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = '-5.5';
        eachTd.isChangeFactor = true;
        eachTd.isDown = true;
        eachTd.fieldVar = 'deadNetSalesChange';
        eachItem.push(eachTd);
        
        affectedItems.push({eachItems:eachItem});
        
        
        //PROPOSED VALUES
        eachItem = [];
        
        var eachTd = {};
        eachTd.isLabel = true;
        eachTd.value = 'Proposed:';
        eachItem.push(eachTd);
        
        var VipPerUnitProposed = (bidLineData.Phoenix_Proposed_Est_VIP__c/100)*proVal;
        eachTd = {};
        eachTd.value = VipPerUnitProposed;//'2.10';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'VipPerUnitProposed';
        eachItem.push(eachTd);
        
        var cmFeePerUnitProposed = (bidLineData.Phoenix_Contract_Mngment_Fee_Wholesaler__c/100)*proVal;
        eachTd = {};
        eachTd.value = cmFeePerUnitProposed;//'79.56';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'cmFeePerUnitProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = parseInt(proVal)-parseInt(VipPerUnitProposed)-parseInt(cmFeePerUnitProposed)-parseInt(bidLineData.Phoenix_Customer_Cash_Discount1__c);//'2.64';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'custDeadNetProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = parseInt(bidLineData.Phoenix_Customer_Rebates1__c)*proVal;//'198352';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'rebatePercentPerUnitProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = parseInt(bidLineData.Phoenix_Customer_Order_Analytics_Fee__c)*proVal;//'198352';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'orderAnalyticsFeePerUnitPropose';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = parseInt(bidData.Phoenix_Group_VIP__c)*proVal;//'198352';
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'groupVipPerUnitProposed';
        eachItem.push(eachTd);
        
        affectedItems.push({eachItems:eachItem});
       
        console.log(JSON.stringify(affectedItems));
        component.set("v.affectedItems",affectedItems);*/
    },
    getProposedAffecteItems : function(component, event, helper){
        var bidLineData = component.get("v.bidLineData");
        
        var scenarioList = [];
        console.log('inside getProposedAffecteItems');
        component.set("v.wifVariable",'Price Per unit %');
                

        var wifCurrentValue = (bidLineData.Phoenix_ProposedContractBidPriceMktng__c != null ? bidLineData.Phoenix_ProposedContractBidPriceMktng__c : bidLineData.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? bidLineData.Phoenix_ProposedContract_Bid_Price_Sales__c :bidLineData.Phoenix_Current_Indirect_Price__c!= null ? bidLineData.Phoenix_Current_Indirect_Price__c : 0);//bidLineData.Phoenix_Current_Indirect_Price__c;
        component.set("v.wifCurrentValue",wifCurrentValue);
        
        if(component.get("v.selectedScenario") == 'Proposed Price Fine Tuning'){
            var eachItem = [{value:'',isLabel:true},{value:'Proposed Marketing Price:',isLabel:true},
                            {value:'Change Value:',isLabel:true},
                            {value:'VIP% Per Unit $:',isLabel:true},
                            {value:'CM Fee Per Unit $:',isLabel:true},
                            {value:'Rebate % Per Unit $:',isLabel:true},
                            {value:'Order Analytics Fee Per Unit $:',isLabel:true},
                            {value:'Group VIP Per Unit $:',isLabel:true},
                            {value:'Customer Dead Net:',isLabel:true},
                            {value:'Internal Dead Net:',isLabel:true}];
            scenarioList.push({eachItems:eachItem});
        }
        
        var changePercent = component.get("v.changePercent");
        var initiateNum = 0;
        
        var i = [1,2,3,4,5,6,7,8,9,10];
        i.forEach(function(iVar){
            initiateNum = parseFloat(initiateNum).toFixed(2)-parseFloat(changePercent).toFixed(2);
            console.log('initiateNum value --> '+initiateNum);
            scenarioList.push({eachItems:calcProposed(initiateNum)});
        });
        console.log(JSON.stringify(scenarioList));
        component.set("v.preCalcList",scenarioList);
        component.set("v.showPreCalcs",true);
        function calcProposed(changeVal){
            var proVal = (changeVal/100)*parseFloat(wifCurrentValue);
            proVal = parseFloat(wifCurrentValue)+parseFloat(proVal);
            
            var itemObj = helper.calcAndCreateObj(component, event, helper, proVal);
            eachItem = [];
            
            var eachTd = {};
            eachTd.isradioButton = true;
            eachTd.isSelectedButton = false;
            eachTd.fieldVar = 'radioButton';
            eachItem.push(eachTd);
            
            var eachTd = {};
            eachTd.isCurrency = true;
            eachTd.value = proVal;
            eachTd.fieldVar = 'proposedValue';
            eachTd.showRed = component.get("v.bidLineData.Phoenix_Lowest_Price_SKU__c") > itemObj.IndirectDeadNet ? true : false;
            eachItem.push(eachTd);
            
            var eachTd = {};
            eachTd.isPercent = true;
            eachTd.value = changeVal;
            eachTd.fieldVar = 'changeValuePercent';
            eachItem.push(eachTd);
            
            
            
            //var VipPerUnitProposed = (bidLineData.Phoenix_Proposed_Est_VIP__c != null && bidLineData.Phoenix_Proposed_Est_VIP__c != 0) ? 
            //    (bidLineData.Phoenix_Proposed_Est_VIP__c*proVal) : (bidData.Phoenix_Proposed_Value_Est_VIP__c*proVal);//(bidLineData.Phoenix_Proposed_Est_VIP__c/100)*proVal;
            eachTd = {};
            eachTd.value = itemObj.vipperUnit;//'2.10';
            eachTd.isCurrency = true;
            eachTd.fieldVar = 'VipPerUnitProposed';
            eachItem.push(eachTd);
            
            //var cmFeePerUnitProposed = (bidLineData.Phoenix_Contract_Mngment_Fee_Wholesaler__c/100)*proVal;
            eachTd = {};
            eachTd.value = itemObj.cmFeePerUnit;//cmFeePerUnitProposed;//'79.56';
            eachTd.isCurrency = true;
            eachTd.fieldVar = 'cmFeePerUnitProposed';
            eachItem.push(eachTd);
            
            
            eachTd = {};
            eachTd.value = itemObj.rebatespPerUnit;//parseInt(bidLineData.Phoenix_Customer_Rebates1__c)*proVal;//'198352';
            eachTd.isCurrency = true;
            eachTd.fieldVar = 'rebatePercentPerUnitProposed';
            eachItem.push(eachTd);
            
            eachTd = {};
            eachTd.value = itemObj.orderanlfeeunit;//parseInt(bidLineData.Phoenix_Customer_Order_Analytics_Fee__c)*proVal;//'198352';
            eachTd.isCurrency = true;
            eachTd.fieldVar = 'orderAnalyticsFeePerUnitPropose';
            eachItem.push(eachTd);
            
            eachTd = {};
            eachTd.value = itemObj.grpVIPPerUnit;//parseInt(bidData.Phoenix_Group_VIP__c)*proVal;//'198352';
            eachTd.isCurrency = true;
            eachTd.fieldVar = 'groupVipPerUnitProposed';
            eachItem.push(eachTd);
            
            eachTd = {};
            eachTd.value = itemObj.customerDeadnet;//parseInt(proVal)-parseInt(VipPerUnitProposed)-parseInt(cmFeePerUnitProposed)-parseInt(bidLineData.Phoenix_Customer_Cash_Discount1__c);//'2.64';
            eachTd.isCurrency = true;
            eachTd.fieldVar = 'custDeadNetProposed';
            //eachTd.showRed = component.get("v.bidLineData.Phoenix_Lowest_Price_SKU__c") > itemObj.IndirectDeadNet ? true : false;
            eachItem.push(eachTd);
            
            eachTd = {};
            eachTd.value = itemObj.IndirectDeadNet;//parseInt(bidData.Phoenix_Group_VIP__c)*proVal;//'198352';
            eachTd.isCurrency = true;
            eachTd.fieldVar = 'internalDeadNetProposed';
            eachTd.showRed = component.get("v.bidLineData.Phoenix_Lowest_Price_SKU__c") > itemObj.IndirectDeadNet ? true : false;
            eachItem.push(eachTd);
            
            
            return eachItem;
        }
    },
    createCompleteList : function(component, helper, event, wifCurrentValue, proposedVal){
        console.log('inside createCompleteList');
        var affectedItems = [];
        
        var eachItem = [{value:'Variable:',isLabel:true},
                        {value:'VIP% Per Unit $:',isLabel:true},
                        {value:'CM Fee Per Unit $:',isLabel:true},
                        {value:'Rebate % Per Unit $:',isLabel:true},
                        {value:'Order Analytics Fee Per Unit $:',isLabel:true},
                        {value:'Group VIP Per Unit $:',isLabel:true},
                        {value:'Customer Dead Net:',isLabel:true},
                        {value:'Internal Dead Net:',isLabel:true}];
        affectedItems.push({eachItems:eachItem});
        
        var itemObj = helper.calcAndCreateObj(component, event, helper, wifCurrentValue);
        var proposedItem = helper.calcAndCreateObj(component, event, helper, proposedVal);
        
        eachItem = [];
        
        var eachTd = {};
        eachTd.isLabel = true;
        eachTd.value = 'Current:';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = itemObj.vipperUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'VipPerUnitCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = itemObj.cmFeePerUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'cmFeePerUnitCurrent';
        eachItem.push(eachTd);
        
        
        eachTd = {};
        eachTd.value = itemObj.rebatespPerUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'rebatePercentPerUnitCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = itemObj.orderanlfeeunit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'orderAnalyticsFeePerUnitCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = itemObj.grpVIPPerUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'groupVipPerUnitCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = itemObj.customerDeadnet;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'custDeadNetCurrent';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = itemObj.IndirectDeadNet;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'internalDeadNetCurrent';
        eachItem.push(eachTd);
        affectedItems.push({eachItems:eachItem});
        
        eachItem = [];
        
        var eachTd = {};
        eachTd.isLabel = true;
        eachTd.value = 'Change:';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = ((itemObj.vipperUnit-proposedItem.vipperUnit)/itemObj.vipperUnit)*100;
        eachTd.isChangeFactor = true;
        eachTd.isDown = proposedItem.vipperUnit < itemObj.vipperUnit ? true : false;
        eachTd.fieldVar = 'VipPerUnitChange';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = ((itemObj.cmFeePerUnit-proposedItem.cmFeePerUnit)/itemObj.cmFeePerUnit)*100;
        eachTd.isChangeFactor = true;
        eachTd.isDown = proposedItem.cmFeePerUnit < itemObj.cmFeePerUnit ? true : false;
        eachTd.fieldVar = 'cmFeePerUnitChange';
        eachItem.push(eachTd);
        
        
        eachTd = {};
        eachTd.value = ((itemObj.rebatespPerUnit-proposedItem.rebatespPerUnit)/itemObj.rebatespPerUnit)*100;
        eachTd.isChangeFactor = true;
        eachTd.isDown = proposedItem.rebatespPerUnit < itemObj.rebatespPerUnit ? true : false;
        eachTd.fieldVar = 'rebatePercentPerUnitChange';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = ((itemObj.orderanlfeeunit-proposedItem.orderanlfeeunit)/itemObj.orderanlfeeunit)*100;
        eachTd.isChangeFactor = true;
        eachTd.isDown = proposedItem.orderanlfeeunit < itemObj.orderanlfeeunit ? true : false;
        eachTd.fieldVar = 'orderAnalyticsFeePerUnitChange';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = ((itemObj.grpVIPPerUnit-proposedItem.grpVIPPerUnit)/itemObj.grpVIPPerUnit)*100;
        eachTd.isChangeFactor = true;
        eachTd.isDown = proposedItem.grpVIPPerUnit < itemObj.grpVIPPerUnit ? true : false;
        eachTd.fieldVar = 'groupVipPerUnitChange';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = ((itemObj.customerDeadnet-proposedItem.customerDeadnet)/itemObj.customerDeadnet)*100;
        eachTd.isChangeFactor = true;
        eachTd.isDown = proposedItem.customerDeadnet < itemObj.customerDeadnet ? true : false;
        eachTd.fieldVar = 'custDeadNetChange';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = ((itemObj.IndirectDeadNet-proposedItem.IndirectDeadNet)/itemObj.IndirectDeadNet)*100;
        eachTd.isChangeFactor = true;
        eachTd.isDown = proposedItem.IndirectDeadNet < itemObj.IndirectDeadNet ? true : false;
        eachTd.fieldVar = 'internalDeadNetChange';
        eachItem.push(eachTd);
        affectedItems.push({eachItems:eachItem});
        
        eachItem = [];
        
        var eachTd = {};
        eachTd.isLabel = true;
        eachTd.value = 'Proposed:';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = proposedItem.vipperUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'VipPerUnitProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = proposedItem.cmFeePerUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'cmFeePerUnitProposed';
        eachItem.push(eachTd);
        
        
        eachTd = {};
        eachTd.value = proposedItem.rebatespPerUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'rebatePercentPerUnitProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = proposedItem.orderanlfeeunit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'orderAnalyticsFeePerUnitProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = proposedItem.grpVIPPerUnit;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'groupVipPerUnitProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = proposedItem.customerDeadnet;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'custDeadNetProposed';
        eachItem.push(eachTd);
        
        eachTd = {};
        eachTd.value = proposedItem.IndirectDeadNet;
        eachTd.isCurrency = true;
        eachTd.fieldVar = 'internalDeadNetProposed';
        //eachTd.showRed = component.get("v.bidLineData.Phoenix_Lowest_Price_SKU__c") > proposedItem.IndirectDeadNet ? true : false;
        eachItem.push(eachTd);
        affectedItems.push({eachItems:eachItem});
        
        component.set("v.affectedItems",affectedItems);
    },
    calcAndCreateObj : function(component, event, helper, priceItem){
        var acc = component.get("v.accObj");
        var bidLineData = component.get("v.bidLineData");
        var bidData = component.get("v.bidData");
        priceItem =(priceItem != null && priceItem != undefined) ? priceItem : 0;
        var itemObj = {};
        var salesOutRebate = 0;
        var vipperc = parseFloat((bidLineData.Phoenix_Proposed_Est_VIP__c != null && bidLineData.Phoenix_Proposed_Est_VIP__c != undefined) ? bidLineData.Phoenix_Proposed_Est_VIP__c : 0);
        var rebatePerc = parseFloat(bidLineData.Phoenix_Proposed_Current_Rebate__c != null ? bidLineData.Phoenix_Proposed_Current_Rebate__c : 0);
        var orderAnltFeePerc = parseFloat(acc.Phoenix_Order_Analytics_Fee__c != null ?  acc.Phoenix_Order_Analytics_Fee__c : 0);
        var grpVIPPerc = parseFloat(acc.Phoenix_Wbad_VIR__c != null ? acc.Phoenix_Wbad_VIR__c : 0);
        var cashDiscPerc = parseFloat((bidData.Phoenix_Current_CD__c != null && bidData.Phoenix_Current_CD__c != undefined) ? bidData.Phoenix_Current_CD__c : 0);//parseFloat((bidLineData.Phoenix_Cash_Discount_NPR__c != null && bidLineData.Phoenix_Cash_Discount_NPR__c != undefined) ? bidLineData.Phoenix_Cash_Discount_NPR__c : 0);
        var localVIPPerc = parseFloat(acc.Phoenix_Local_VIP__c != null ? acc.Phoenix_Local_VIP__c : 0);
        var accFeePerc = parseFloat(acc.Phoenix_Fee__c != null ? acc.Phoenix_Fee__c :0);
        
        var IndirectDeadNet = 0;
        var customerDeadnet = 0;
        var cmfeePerc = parseFloat(bidLineData.Phoenix_Contract_Mngment_Fee_Wholesaler__c != 0 ? bidLineData.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0);
        if(vipperc != null && vipperc != 0 && vipperc != undefined){
            itemObj.vipperUnit = parseFloat((priceItem * vipperc) /100);     
        }else{
            itemObj.vipperUnit = 0;  
        }
        if(cmfeePerc != null && cmfeePerc != 0)
            itemObj.cmFeePerUnit = parseFloat(priceItem * (cmfeePerc/100));
        //  if(rebatePerc != null && rebatePerc != 0)
        //      itemObj.rebatespPerUnit =  (priceItem * (rebatePerc /100));
        if(bidLineData.Phoenix_Proposed_Current_Rebate__c == 0){
            itemObj.rebatespPerUnit = parseFloat(priceItem * (bidLineData.Phoenix_Current_Rebate__c/100));
        }else{
            itemObj.rebatespPerUnit = parseFloat(priceItem * (bidLineData.Phoenix_Proposed_Current_Rebate__c/100));            
        }
        if(orderAnltFeePerc != null && orderAnltFeePerc != 0){
            if(priceItem == 0)
                itemObj.orderanlfeeunit = parseFloat((bidLineData.Phoenix_Customer_Order_Analytics_Fee__c/100)* bidLineData.Phoenix_Current_Indirect_Price__c);
            else
                itemObj.orderanlfeeunit = parseFloat((bidLineData.Phoenix_Customer_Order_Analytics_Fee__c/100) * priceItem);
        }
    
        if(bidLineData.Phoenix_Bid__r.Phoenix_Group_VIP__c != null && bidLineData.Phoenix_Bid__r.Phoenix_Group_VIP__c != 0 && bidLineData.Phoenix_Bid__r.Phoenix_Group_VIP__c != undefined){
            if(priceItem == 0)
                itemObj.grpVIPPerUnit = parseFloat((bidLineData.Phoenix_Bid__r.Phoenix_Group_VIP__c/100)* bidLineData.Phoenix_Current_Indirect_Price__c);
            else
                itemObj.grpVIPPerUnit = parseFloat((bidLineData.Phoenix_Bid__r.Phoenix_Group_VIP__c/100)* priceItem);
        }
         /*    itemObj.salesOutRebate = 0;
        if(bidLineData.Phoenix_Bid__r.Phoenix_Proposed_Sales_Out_Promotion__c != null && bidLineData.Phoenix_Bid__r.Phoenix_Proposed_Sales_Out_Promotion__c != 0 && bidLineData.Phoenix_Bid__r.Phoenix_Proposed_Sales_Out_Promotion__c != undefined){
            if(bidLineData.Phoenix_Bid_Template_Refrence__c == 'Indirect'){
                if(bidLineData.Phoenix_Current_Price_Calc__c != null && bidLineData.Phoenix_Current_Price_Calc__c != 0 && bidLineData.Phoenix_Current_Price_Calc__c != undefined)
                    itemObj.salesOutRebate = parseFloat(bidLineData.Phoenix_Current_Price_Calc__c * bidLineData.Phoenix_Bid__r.Phoenix_Proposed_Sales_Out_Promotion__c);
            }
            else if(bidLineData.Phoenix_Final_Approvd_Pricing_Contracts__c == 0){
                if(bidLineData.Phoenix_Current_Direct_Price__c != null && bidLineData.Phoenix_Current_Direct_Price__c != 0 && bidLineData.Phoenix_Current_Direct_Price__c != undefined)
                    itemObj.salesOutRebate =parseFloat(bidLineData.Phoenix_Current_Direct_Price__c*bidLineData.Phoenix_Bid__r.Phoenix_Proposed_Sales_Out_Promotion__c);
            }else if(bidLineData.Phoenix_Final_Approvd_Pricing_Contracts__c != null && bidLineData.Phoenix_Final_Approvd_Pricing_Contracts__c != 0 && bidLineData.Phoenix_Final_Approvd_Pricing_Contracts__c != undefined){
                itemObj.salesOutRebate = parseFloat(bidLineData.Phoenix_Final_Approvd_Pricing_Contracts__c *bidLineData.Phoenix_Bid__r.Phoenix_Proposed_Sales_Out_Promotion__c);
            }else{
                itemObj.salesOutRebate = 0;
            }
        }*/
        // (priceItem * (orderAnltFeePerc /100));
        //  if(grpVIPPerc != null && grpVIPPerc != 0)
        //   itemObj.grpVIPPerUnit = (priceItem * (grpVIPPerc /100));
        if(localVIPPerc != null && localVIPPerc != 0)
            itemObj.localVIPPerUnit = parseFloat((priceItem * localVIPPerc) /100);
        if(cashDiscPerc != null && cashDiscPerc != 0 && cashDiscPerc != undefined)
            itemObj.cashDiscountPerUnit = parseFloat((bidLineData.Phoenix_WAC1__c * cashDiscPerc) /100);   
        else
            itemObj.cashDiscountPerUnit = 0;
        itemObj.customerDeadnet = parseFloat(priceItem - itemObj.vipperUnit - itemObj.cmFeePerUnit  - itemObj.cashDiscountPerUnit).toFixed(2);
        //  itemObj.IndirectDeadNet = (priceItem - itemObj.vipperUnit - itemObj.cmFeePerUnit - itemObj.rebatespPerUnit - itemObj.orderanlfeeunit - itemObj.grpVIPPerUnit  - itemObj.cashDiscountPerUnit).toFixed(2);
    /*  itemObj.IndirectDeadNet = parseFloat(itemObj.customerDeadnet - itemObj.rebatespPerUnit);
                 console.log('IndirectDeadNet===='+itemObj.IndirectDeadNet);

      itemObj.IndirectDeadNet = parseFloat(itemObj.IndirectDeadNet - itemObj.orderanlfeeunit);
         console.log('IndirectDeadNet==='+itemObj.IndirectDeadNet);
              itemObj.IndirectDeadNet = parseFloat(itemObj.IndirectDeadNet - itemObj.grpVIPPerUnit);
*/
      itemObj.IndirectDeadNet = parseFloat(itemObj.customerDeadnet - itemObj.rebatespPerUnit - itemObj.orderanlfeeunit - itemObj.grpVIPPerUnit ).toFixed(2);
        
        /*  var vipperc = acc.Phoenix_VIP__c != null ? acc.Phoenix_VIP__c : 0;
        var rebatePerc = acc.Phoenix_Rebates__c != null ? acc.Phoenix_Rebates__c : 0;
        var orderAnltFeePerc = acc.Phoenix_Order_Analytics_Fee__c != null ?  acc.Phoenix_Order_Analytics_Fee__c : 0;
        var grpVIPPerc = 	acc.Phoenix_Wbad_VIR__c != null ? acc.Phoenix_Wbad_VIR__c : 0;
        var cashDiscPerc = acc.Phoenix_Cash_Discount__c != null ? acc.Phoenix_Cash_Discount__c : 0;
        
        var localVIPPerc = acc.Phoenix_Local_VIP__c != null ? acc.Phoenix_Local_VIP__c : 0;
        var accFeePerc = acc.Phoenix_Fee__c != null ? acc.Phoenix_Fee__c :0;
        
        var IndirectDeadNet = 0;
        var customerDeadnet = 0;
        var cmfeePerc = bidLineData.Phoenix_Contract_Mngment_Fee_Wholesaler__c != 0 ? bidLineData.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0;
        if(vipperc != null && vipperc != 0)
            itemObj.vipperUnit = (priceItem * vipperc) /100;
        if(cmfeePerc != null && cmfeePerc != 0)
            itemObj.cmFeePerUnit = (priceItem * (cmfeePerc/100));
        if(rebatePerc != null && rebatePerc != 0)
            itemObj.rebatespPerUnit =  (priceItem * rebatePerc) /100;
        if(orderAnltFeePerc != null && orderAnltFeePerc != 0)
            itemObj.orderanlfeeunit = (priceItem * orderAnltFeePerc) /100;
        if(grpVIPPerc != null && grpVIPPerc != 0)
            itemObj.grpVIPPerUnit = (priceItem * grpVIPPerc) /100;
        if(localVIPPerc != null && localVIPPerc != 0)
            itemObj.localVIPPerUnit = (priceItem * localVIPPerc) /100;
        if(cashDiscPerc != null && cashDiscPerc != 0)
            itemObj.cashDiscountPerUnit = (bidLineData.Phoenix_WAC1__c * cashDiscPerc) /100;
        itemObj.customerDeadnet = (priceItem - itemObj.vipperUnit - itemObj.cmFeePerUnit  - itemObj.cashDiscountPerUnit).toFixed(2);
        itemObj.IndirectDeadNet = (priceItem - itemObj.vipperUnit - itemObj.cmFeePerUnit - itemObj.rebatespPerUnit - itemObj.orderanlfeeunit - itemObj.grpVIPPerUnit  - itemObj.cashDiscountPerUnit).toFixed(2);
     */
        return itemObj;
    }
})