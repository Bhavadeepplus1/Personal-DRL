({
    
    /*  doInit: function(component, event, helper) {
        
        component.set("v.defaultTab","tab1");
        //console.log('url param is '+component.get("v.pageReference").state.name);
    },*/
    
    
    /*  handleChange: function(cmp) {
        //Display content on the Item Three tab
          let pageReference = component.get("v.pageReference");
       let tabId = pageReference.state.c__tabId;
        //console.log('recordId =='+recordId);
       // var selected = cmp.get("v.tabId");
        cmp.find("tabs").set("v.selectedTabId", tabId);
    },*/
    doInit: function(cmp, evt, helper) {
        
        /*  var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('?'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        console.log('sURLVariables'+sURLVariables);
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.

            if (sParameterName[0] === 'firstName') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        console.log('Param name'+sParameterName[0]);
        console.log('Param value'+sParameterName[1]);*/
     
        var myPageRef = cmp.get("v.pageReference");
        console.log('myPageRef=='+JSON.stringify(myPageRef));
        var value = myPageRef.state.c__tabId;
        var recordId = myPageRef.state.c__recordId;
        console.log('recordId=='+recordId);
        console.log('value=='+value);
        if(value != null && value != undefined){
            cmp.set("v.selectedTabId", value);  
            cmp.set("v.recordId", recordId);  
            cmp.set("v.newScreen", false);  
            
        }
       //cmp.set("v.selectedTabId", "1");  
        //console.log('selectedTabId=='+cmp.get("v.selectedTabId"));
        
    },
   handleLocationChange : function (component, event, helper) {
       var newURL = window.location.href.toString();
       console.log('newurl type is '+ typeof newURL);
       console.log('locatio changed'+JSON.stringify(newURL));
        if (newURL.includes("SRxAchievementTracker")) {
            console.log('func called inside this func');
            helper.setDefaultTab(component, event, helper);
        }
      /*  console.log('render event called');
       var myPageRef = component.get("v.pageReference");
        console.log('myPageRef=='+JSON.stringify(myPageRef));
        var proceedValue = myPageRef.state.c__tab;
       if(proceedValue == "proceed"){
       component.set("v.selectedTabId", "1");  
       }else{
           var selectedTabId = event.getSource().get('v.id');
           console.log('selectedTabId==>'+selectedTabId);
          component.set("v.selectedTabId", selectedTabId);  
       }
       proceedValue = "test";*/
    },
    /*
    afterRender: function(component, helper) {
        this.superAfterRender(); 
        
		console.log('afterRender func is called');        
        var state = window.location.href; // Retrieve the URL
        // Parse the URL or extract parameters if needed
        console.log('Current URL:', state);
        // Perform actions or logic as required
    }*/
})