({
	doInit : function(component, event, helper) {
		var data = component.get("v.recentAwardsProdAdditionList");
        console.log('Do Init called');
        if(!data.family){
            component.set("v.noData", true);
            console.log('No Data');
        } else{
            console.log('Data');
            component.set("v.noData", false);
        }
	},
    handleClick1: function(component, event, helper){
        var family = event.getSource().get("v.name");
        console.log('family: '+family);
        var data = component.get("v.recentAwardsProdAdditionList");
        console.log('Data family:: '+JSON.stringify(data));
        if(data.family == family){
            for(var i=0; i<data.dataList.length; i++){
                if(data.dataList[i].showItem){
                 	data.dataList[i].showItem = false;   
                } else{
                    data.dataList[i].showItem = true;
                }
            }
        }
        component.set("v.recentAwardsProdAdditionList", data);
        component.set("v.show", false);
    },
    handleClick2: function(component, event, helper){
        var family = event.getSource().get("v.name");
        console.log('family: '+family);
        var data = component.get("v.recentAwardsProdAdditionList");
        console.log('Data family:: '+JSON.stringify(data));
        if(data.family == family){
            for(var i=0; i<data.dataList.length; i++){
                if(data.dataList[i].showItem){
                 	data.dataList[i].showItem = false;   
                } else{
                    data.dataList[i].showItem = true;
                }
            }
        }
        component.set("v.recentAwardsProdAdditionList", data);
        component.set("v.show", true);
    }
})