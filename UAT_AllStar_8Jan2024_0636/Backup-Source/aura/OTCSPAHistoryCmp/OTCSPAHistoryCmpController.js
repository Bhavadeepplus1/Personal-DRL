({
     // This method is to collect the Bid Histroy--START
    
    doInit:function (component, event, helper) {
        var bidhist=component.get("v.displayBidHist");
        component.set("v.displayBidHist",true);
        console.log('---------bidhist---------'+bidhist);
       // By Default make sort field is 'FirstName' of contact object
       // call the helper function with pass sortField Name
       helper.onLoad(component,event,helper);
    },
      
    //--END
    
   
     // This method is to close the Bid Hisyory Popup component---START
    
    closeBidHist:function(component,event,helper){
        component.set("v.displayBidHist",false); 
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        
    },
    //---END
    
      //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        console.log('fieldName--->'+sortBy)
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },
    filerChange : function(component,event,helper){
        helper.onLoadFilter(component,event,helper);  
    },
    showAll : function(component,event,helper){
        console.log('showalll--')
        helper.onLoad(component,event,helper);
    },
    showAllSPAData : function(component,event,helper){
        console.log('showalll--')
        helper.onLoad(component,event,helper);
    },
     showAllNPRData : function(component,event,helper){
        console.log('showalll--')
        helper.onLoad(component,event,helper);
    },
    findCustomer: function(component,event,helper){
        console.log('search text-->'+component.get("v.SearchKeyWordPD"))
        helper.onLoadFilter(component,event,helper);
    }
    
})