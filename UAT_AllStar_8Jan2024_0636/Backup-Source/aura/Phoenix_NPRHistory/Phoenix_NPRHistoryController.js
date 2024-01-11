({
    // This method is to collect the Bid Histroy--START
    
    doInit:function (component, event, helper) {
        var bidhist=component.get("v.displayProdNPRHist");
        component.set("v.displayProdNPRHist",true);
        helper.onLoad(component,event,helper);
    },
    
    //--END
    
    // This method is to close the NPR Product Hisyory Popup component---START
    
    closeProdNPRHist:function(component,event,helper){
        component.set("v.displayProdNPRHist",false); 
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        
    },
    //---END
    
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        helper.sortData(component,sortBy,sortDirection);
      },
    filerChange : function(component,event,helper){
   helper.onLoadFilter(component,event,helper);  
}
})