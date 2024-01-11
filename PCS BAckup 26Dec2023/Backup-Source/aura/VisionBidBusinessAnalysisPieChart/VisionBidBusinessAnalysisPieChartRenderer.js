({
    rerender : function(component, helper){
        console.log('Renderer Called');
        this.superRerender();
        if(component.get("v.isExportJSLoaded") && component.get("v.needToProcessReRenderLogic")) {
            console.log('ReRender stopped');
            component.set("v.needToProcessReRenderLogic",false); // this will not fire rerender again
        }
    }
})