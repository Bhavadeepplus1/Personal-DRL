({
    doInit : function(component, event, helper) {
       
        var action = component.get("c.basicCannon");
        console.log('pop');
      //   alert("Hi basicCannon");
           $A.enqueueAction(action);
    },
    basicCannon : function(component, event, helper) {
  
        confetti({
            particleCount: 200,
            startVelocity: 60,
            spread: 150,
            origin: {
                y: 0.9
            },
            colors : component.get("v.colors")
        });
          console.log('pop basic');
    },
    
})