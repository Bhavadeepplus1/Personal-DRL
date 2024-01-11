({
	getData : function(component, event, helper) {
        console.log('Selected Contract: ' +component.get("v.selectedContract"));
        var selectedContractId = component.get("v.selectedContract");
        component.set("v.loaded", true);
        if(selectedContractId != null){
            var action = component.get("c.getIntitalOrders");
            action.setParams({
                'contractId': selectedContractId,
                'accountId': component.get("v.recordId"),
                'isAsc': component.get("v.isAsc"),
                'sortField': component.get("v.sortField")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    component.set("v.noInitialOrderData", null);
                    component.set("v.initialOrderData", null);
                    component.set("v.contractType", '');
                    component.set("v.loaded", false);
                    var contractResp = response.getReturnValue().contract;
                    if(contractResp.Phoenix_Contract_Number__c.toString().startsWith("1")){
                        component.set("v.contractType", 'Direct');
                    } else{
                        component.set("v.contractType", 'Indirect'); 
                    }
                    component.set("v.contractStartDate", new Date(contractResp.Phoenix_Contract_Start_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" }));
                    component.set("v.contractEndDate", new Date(contractResp.Phoenix_Contract_End_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" }));
                    var resp = response.getReturnValue().nonInitialOrderList;
                    
                    if(resp.length > 0){
                        for(var i=0; i<resp.length; i++){
                            if(resp[i].Customer_Response_Line__r){
                                var time_difference1 = new Date().getTime() - new Date(resp[i].Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c).getTime();  
                                //calculate days difference by dividing total milliseconds in a day  
                                var days_difference1 = time_difference1 / (1000 * 60 * 60 * 24);
                                resp[i].pastDays = days_difference1; 
                                var supplyDate = new Date(resp[i].Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                                if(supplyDate != 'Invalid Date'){
                                    resp[i].Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c = supplyDate;
                                }
                            }
                            var time_difference2 = new Date(resp[i].Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c).getTime()-new Date().getTime();  
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference2 = time_difference2 / (1000 * 60 * 60 * 24);
                            resp[i].remainingDays = days_difference2;
                            resp[i].Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c = new Date(resp[i].Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        }
                        component.set("v.selectedContractName", resp[0].Vision_Contract__r.Name);
                    }
                    component.set("v.noInitialOrderData", resp);
                    var resp1 = response.getReturnValue().initialOrderList;
                    if(resp1.length > 0){
                        for(var i=0; i<resp1.length; i++){
                            if(resp1[i].Customer_Response_Line__r){
                                var time_difference1 = new Date().getTime() - new Date(resp1[i].Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c).getTime();  
                                //calculate days difference by dividing total milliseconds in a day  
                                var days_difference1 = time_difference1 / (1000 * 60 * 60 * 24);
                                resp1[i].pastDays = days_difference1;
                                var supplyDate = new Date(resp1[i].Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                                if(supplyDate != 'Invalid Date'){
                                    resp1[i].Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c = supplyDate;
                                }
                            }
                            var time_difference2 = new Date(resp1[i].Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c).getTime()-new Date().getTime();  
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference2 = time_difference2 / (1000 * 60 * 60 * 24);
                            resp1[i].remainingDays = days_difference2;
                            resp1[i].Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c = new Date(resp1[i].Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        }
                        component.set("v.selectedContractName", resp1[0].Vision_Contract__r.Name);
                    }
                    component.set("v.initialOrderData", resp1);
                    component.set("v.totalCount", resp.length + resp1.length);
                } else{
                    component.set("v.loaded", false);
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action); 
        } else{
            component.set("v.loaded", false);
        }
	}
})