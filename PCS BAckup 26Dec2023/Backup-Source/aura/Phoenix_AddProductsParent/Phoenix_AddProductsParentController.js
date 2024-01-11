({
    doInit: function(component, helper, event) {
        var action = component.get('c.getButtonVisibility'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                let buttonStates = component.get('v.buttonStates');
                let data = a.getReturnValue();
                var buttonList = [];
                // Process data and set buttonVisibilities with the latest boolean values
                for(var i=0; i<data.length;i++){
                    buttonList.push(true);
                }
                component.set('v.buttonStates', buttonList);
            }
        });
        $A.enqueueAction(action);
    }
})