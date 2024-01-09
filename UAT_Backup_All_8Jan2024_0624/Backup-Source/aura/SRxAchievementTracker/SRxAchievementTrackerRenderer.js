({
    afterRender: function(component,helper){
        this.superAfterRender();
        console.log('afterRender event handler is running now');
        console.log('in the after Render func')
        var myPageRef = component.get("v.pageReference");
        console.log('myPageRef=='+JSON.stringify(myPageRef));
        var attribute1 = myPageRef.state.c__tabId;
        console.log('attribute1=='+attribute1);
        component.set("v.selectedTabId", attribute1);
    }
})