({
	proposedUnitValidation: function (component, helper, isCheck) {
        console.log('proposedUnitValidation called');
        console.log('isCheck '+isCheck);
        var retdata = {
            'isCallMsg': false,
            'prdName': null
        };
        if(isCheck){
            var data = component.get("v.QLlist");
            console.log('data : '+JSON.stringify(data));
            if(data.length > 0){
                for (var i = 0; i < data.length; i++) {
                    if (data[i].proposedUnitsVal) {
                        retdata['isCallMsg'] = false;
                        retdata['prdName'] = data[i].prdlist.Name;
                    }
                    else{
                        retdata['isCallMsg'] = true;
                        retdata['prdName'] = data[i].prdlist.Name;
                        break;
                    }
                }
            }
        }
        else{
            var data = component.get("v.QLlistSaved");
            console.log('data : '+JSON.stringify(data));
            if(data.length > 0){
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Vision_Proposed_Units__c) {
						retdata['isCallMsg'] = false;
                        retdata['prdName'] = data[i].Product__r.Name;
                    }
                    else{
                        retdata['isCallMsg'] = true;
                        retdata['prdName'] = data[i].Product__r.Name;
                        break;
                    }
                }
            } 
        }
        return retdata;
    }
})