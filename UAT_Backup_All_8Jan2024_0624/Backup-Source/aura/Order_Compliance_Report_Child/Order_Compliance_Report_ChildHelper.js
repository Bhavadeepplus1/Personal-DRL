({
	  getCommentsHelper : function(component, event, helper){
        
        component.set("v.loaded",true);
        //console.log('set showSpinnerInCommentPop');
        
        component.set("v.showComments",true);
        console.log('set showComments');
        //var gcpLineItem = component.get("v.gcpLineItem");
        var action = component.get("c.getProdBidLineItemComments");
        action.setParams({
            ProductId : component.get("v.ProdIdForComment"),
            AccountId : component.get("v.recordId")
           // selectedLineId : component.get("v.singlerec.Id")

        });
        action.setCallback(this, function (response) {
            console.log('response.getState() from getProdBidLineItemComments :: '+response.getState());
            if (response.getState() === "SUCCESS") {
                var doesCmntsExist = false;
                var responseList = response.getReturnValue();
                var cmnts = [];
                var brightCmnts = [];
                console.log('Response comments-----'+JSON.stringify(responseList));
                responseList.forEach(function(cmntObj){
                    console.log('cmntObj.cmntCat ::: '+cmntObj.cmntCat);
                    if(cmntObj.cmntCat == 'Panorama Comments')
                        doesCmntsExist = true;
                    if(cmntObj.cmntCat == 'Vision Comments')
                        doesCmntsExist = true;
                    if(cmntObj.cmntCat == 'Bright Comments'){
                        for(var key in cmntObj.cmntWrapMap){
                            if(cmntObj.cmntWrapMap[key] != undefined && cmntObj.cmntWrapMap[key].length > 0){
                                brightCmnts.push({key:key,value:cmntObj.cmntWrapMap[key], bidId:cmntObj.cmntWrapMap[key][0].bidId});
                            }
                        }
                    }
                });
                if(brightCmnts.length > 0)
                    doesCmntsExist = true;
                component.set("v.doesCmntsExist",doesCmntsExist);
                component.set("v.brightCmnts",brightCmnts);
                component.set("v.listOfCmnts", responseList);//cmnts);
                component.set("v.loaded",false);
            }
            else{
                console.log('ERROR --- > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
})