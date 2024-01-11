({
	getCustomerDetails : function(component, event, helper, accId) {
        component.set('v.loaded',true);
        var action = component.get("c.getAccountGroups");
        action.setParams({accId : accId});
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var wrapObj = response.getReturnValue();
                var currentOwner = wrapObj.currentUser;
                var accObj = wrapObj.accObj;
                
                var totalCxOpty = '';
                var drlCurrentSales = '';
                var drlOpptySales = '';
                var drlTotEstActSales = '';
                var drlShareOfWallet = '';
                var drlShareOfWalletVol = '';
                
                function roundUpNumber(num){
                    var roundedNum = '';
                    if(num > 0){
                        if(num > 1000000000){
                            roundedNum = ''+Math.round((num/1000000000) * 100) / 100+'B';
                        }
                        else if(num > 1000000){
                            roundedNum = ''+Math.round((num/1000000) * 100) / 100+'M';
                        }
                            else if(num > 1000){
                                roundedNum = ''+Math.round((num/1000) * 100) / 100+'K';
                            }
                                else{
                                    roundedNum = num != undefined ? ''+Math.round((num) * 100) / 100 : '0';
                                }
                    }
                    else{
                        if(num < -1000000000){
                            roundedNum = ''+Math.round((num/1000000000) * 100) / 100+'B';
                        }
                        else if(num < -1000000){
                            roundedNum = ''+Math.round((num/1000000) * 100) / 100+'M';
                        }
                            else if(num < -1000){
                                roundedNum = ''+Math.round((num/1000) * 100) / 100+'K';
                            }
                                else{
                                    roundedNum = num != undefined ? ''+Math.round((num) * 100) / 100 : '0';
                                }
                    }
                    return roundedNum;
                }
                
                totalCxOpty = roundUpNumber(accObj.Phoenix_Total_Customer_Opportunity__c);
                drlCurrentSales = roundUpNumber(accObj.Phoenix_DRL_Current_Sales__c);
                drlOpptySales = roundUpNumber(accObj.Phoenix_DRL_Opportunity_Sales__c);
                drlTotEstActSales = roundUpNumber(accObj.Phoenix_DRL_Total_Est_Account_Sales__c);
                drlShareOfWallet = roundUpNumber(accObj.Phoenix_DRL_Share_of_Wallet__c);
                drlShareOfWalletVol = roundUpNumber(accObj.Phoenix_DRL_Share_of_Wallet_Vol__c);
                
                component.set("v.totalCxOpty", totalCxOpty);
                component.set("v.drlCurrentSales", drlCurrentSales);
                component.set("v.drlOpptySales", drlOpptySales);
                component.set("v.drlTotEstActSales", drlTotEstActSales);
                component.set("v.drlShareOfWallet", drlShareOfWallet);
                component.set("v.drlShareOfWalletVol", drlShareOfWalletVol);
                
                component.set("v.currentOwner",currentOwner);
                component.set("v.accObj",accObj);
                component.set("v.customerLkp",accObj.Id);
                component.set('v.loaded',false);
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set('v.loaded',false);
            }
        });
        $A.enqueueAction(action);
	}
})