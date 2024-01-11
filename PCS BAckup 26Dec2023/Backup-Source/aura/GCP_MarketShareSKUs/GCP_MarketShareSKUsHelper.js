({
	updateNdcItem : function(component, event, helper, ndcList){
        var action=component.get("c.updateNdcLineItem");
        action.setParams({ndcItem:ndcList});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('UPDATED SUCCESSFULLY!');
                component.set("v.ndcList",response.getReturnValue());
            }
            else{
                console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getErrors()));
            }
        });
        $A.enqueueAction(action);
    },
    getUpdatedListWithCP : function(component, event, helper, ndcList){
        var action=component.get("c.updateNdcLineItem");
        action.setParams({ndcItem:ndcList});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var action = component.get("c.getNdcListOfProdFam");
                action.setParams({prodFamilyName:component.get("v.gcpLineItem.GCP_Product_Family__c"),
                                  accId : component.get("v.accObj.Id")});
                action.setCallback(this, function (response) {
                    console.log('State from getNdcListOfProdFam :: '+response.getState());
                    if (response.getState() == "SUCCESS") {
                        var wrapper = response.getReturnValue();
                        var ndcList = wrapper.updateGcpList;
                        if(ndcList.length > 0){
                            var openOrders = wrapper.openOrders;
                            var RxBackOrders = wrapper.RxBackOrders;
                            var SRxBackOrders = wrapper.SRxBackOrders;
                            var OTCBackOrders = wrapper.OTCBackOrders;
                            var isOtcAccount = wrapper.isOtcAccount;
                            component.set("v.isOtcAccount",isOtcAccount);
                            var selectedNdcs = component.get("v.selectedNdcs");
                            if(ndcList.length > 0){
                                for(var i=0; i<ndcList.length; i++){
                                    if(openOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                        ndcList[i].isOpenOrder = true;
                                    } else{
                                        ndcList[i].isOpenOrder = false;
                                    }
                                    if(RxBackOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                        ndcList[i].isRxBackOrder = true;
                                        console.log('Rx: '+JSON.stringify(ndcList[i]));
                                    } else{
                                        ndcList[i].isRxBackOrder = false;
                                    }
                                    if(SRxBackOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                        ndcList[i].isSRxBackOrder = true;
                                    } else{
                                        ndcList[i].isSRxBackOrder = false;
                                    }
                                    if(OTCBackOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                        ndcList[i].isOTCBackOrder = true;
                                    } else{
                                        ndcList[i].isOTCBackOrder = false;
                                    }
                                    if(selectedNdcs != undefined){
                                        if(selectedNdcs.includes(ndcList[i].Vision_Product__c))
                                            ndcList[i].isSelectedPrd = true;
                                        else
                                            ndcList[i].isSelectedPrd = false;
                                    }
                                }
                            }
                            console.log('NDC List: '+JSON.stringify(ndcList));
                        }
                        component.set("v.ndcList",ndcList);
                        component.set("v.isSpinnerLoad",false);
                        component.set("v.showProducts",true);
                    }
                    else {
                        console.log('Error while updating line Item.');
                        console.log("Error "+JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action);
            }
            else{
                console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getErrors()));
            }
        });
        $A.enqueueAction(action);
    }
})