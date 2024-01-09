({
	fetchCompInfoChanges : function(component, helper, val) {
		var listOfCompetitors = component.get("v.listOfCompetitors");
        var retdata = {
            'Id': null,
            'Name': null
        };
        for(var i=0; i<listOfCompetitors.length; i++){
            if(listOfCompetitors[i].Id == val){
                retdata['Id'] = listOfCompetitors[i].Id;
                retdata['Name'] = listOfCompetitors[i].Name;
                break;                
            }
        }
        return retdata;
	}
})