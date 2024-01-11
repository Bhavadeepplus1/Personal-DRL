({
    // This method is to collect the IMS Market Share--START
    
    doInit:function (component, event, helper) {
        var bidhist=component.get("v.displayIMS");
        component.set("v.displayIMS",true);
        helper.onLoad(component,event,helper);
    },
    
    // This method is to close the IMS Market Share Popup component---START
    
    closeIMSMarkShare:function(component,event,helper){
        component.set("v.displayIMS",false); 
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        
    },
    
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
    }
})