({
    getMarketShareData : function(component, event, helper, record) {
        var action = component.get("c.getIMSMarketShare");
        var summaryObj = component.get("v.record");
        var relatedList = component.get("v.relatedList");
        action.setParams({
            'LineItemId' : record.Id,
            'recordId':record.Phoenix_Bid__c
        });
        action.setCallback(this, function(response) {
            let model = response.getReturnValue();
            //console.log('Model: '+JSON.stringify(model));
            if(model!=undefined || model!=null){
                model.forEach(function(item){
                    item.custMarkShare=(item.custVol/item.overallMark);
                    item.drlMarkShare=item.drlMarkShare/100;
                    for(var i=0; i<relatedList.length; i++){
                        if(relatedList[i].Phoenix_NDC_Without_Dashes__c == item.ndc){
                            relatedList[i].overallMark = item.overallMark;
                            relatedList[i].drlMarkShare = item.drlMarkShare;
                            relatedList[i].custMarkShare = item.custMarkShare;
                            relatedList[i].custVol = item.custVol;
                            /*summaryObj.overallMark += item.overallMark;
                            summaryObj.custVol += item.custVol;*/
                        }
                    }
                });
                component.set("v.record", summaryObj);
                //marketShareList.push(model);
            }
            
            component.set("v.model", model);
            component.set("v.imsMarketShareRec",response.getReturnValue());
            if(response.getReturnValue()!=null){
                component.set("v.prodId",response.getReturnValue()[0].prodId);
                component.set("v.prodName",response.getReturnValue()[0].prodName);
                component.set("v.ndc",response.getReturnValue()[0].ndc);
            }
        });
        $A.enqueueAction(action);
	}
})