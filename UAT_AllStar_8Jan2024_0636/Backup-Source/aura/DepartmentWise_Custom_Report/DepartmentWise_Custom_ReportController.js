({
    doInit : function(component, event, helper) {
       component.set("v.loadSpinner", true);
        component.set("v.loadSpinner", false);
        component.set("v.Bidsdisplaylist",'');
                component.set("v.markeitingbooleantwo",true);//for displaying make false
    },
    rundata : function(component, event, helper) {
        component.set("v.loadSpinner", true);
        component.set("v.Bidsdisplaylist",'');
                component.set("v.markeitingbooleantwo",true);
       helper.SCM(component,event, helper);
       helper.Marketing(component, event, helper);
        helper.Finance(component, event, helper);
       helper.Contract(component, event, helper);
        //component.set("v.markeitingbooleantwo",true);//for displaying make false

        //component.set("v.loadSpinner", false);
    },
     handleChange  : function(component, event, helper) {
        //component.set("v.loadSpinner", true);
        var selectedOptionValue = event.getParam("value");
        component.set("v.defaultOption", selectedOptionValue);
       // helper.SCMFilterData(component,event, helper,val);
    },
    Reset: function (component, event, helper) {
        component.set("v.loadSpinner", true);
        helper.SCMReset(component,event,helper);
        helper.MarketingReset(component, event, helper);
        helper.FinanceReset(component, event, helper);
        helper.ContractReset(component, event, helper);
        helper.bidsreset(component,event,helper);
    },
    
    //Marketing starts here
    Marketingtwodaysbidsfunction: function(component, event, helper) {
        var marketingtwodays = component.get("v.twodaystotalBidsmarketingrcdslist");  
        console.log('here the dataaa is '+marketingtwodays.length);
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",marketingtwodays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    Marketingthreedaysbidsfunction: function(component, event, helper) {
        var marketingthreedays = component.get("v.threedaystotalBidsmarketingrcdslist"); 
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",marketingthreedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    Marketingfivedaysbidsfunction: function(component, event, helper) {
        var marketingfivedays = component.get("v.fivedaystotalBidsmarketingrcdslist"); 
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",marketingfivedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    Marketingremainingdaysbidsfunction: function(component, event, helper) {
        var marketingremainingdays = component.get("v.remainingdaystotalBidsmarketingrcdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",marketingremainingdays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    Marketingdaysbidssumfunction: function(component, event, helper) {
        var overallmarketing = component.get("v.totalBidsmarketingrcdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",overallmarketing);
        component.set("v.markeitingbooleantwo",false);//for displaying make false  
    },
    //Marketing complete here
    
    //finance starts here
    financetwodaysbidsfunction: function(component, event, helper) {
        var financetwodays = component.get("v.twodaystotalBidsfinancercdslist");  
        console.log('here the dataaa is '+financetwodays.length);
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",financetwodays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    financethreedaysbidsfunction: function(component, event, helper) {
        var financethreedays = component.get("v.threedaystotalBidsfinancercdslist"); 
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",financethreedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    financefivedaysbidsfunction: function(component, event, helper) {
        var financefivedays = component.get("v.fivedaystotalBidsfinancercdslist"); 
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",financefivedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    financeremainingdaysbidsfunction: function(component, event, helper) {
        var financeremainingdays = component.get("v.remainingdaystotalBidsfinancercdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",financeremainingdays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    financedaysbidssumfunction: function(component, event, helper) {
        var overallfinance = component.get("v.totalBidsfinancercdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",overallfinance);
        component.set("v.markeitingbooleantwo",false);//for displaying make false  
    },
    //finance complete here
    
    //scm starts here
    scmtwodaysbidsfunction: function(component, event, helper) {
        var scmtwodays = component.get("v.twodaystotalBidsscmrcdslist");  
        console.log('here the dataaa is '+scmtwodays.length);
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",scmtwodays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    scmthreedaysbidsfunction: function(component, event, helper) {
        var scmthreedays = component.get("v.threedaystotalBidsscmrcdslist"); 
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",scmthreedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    scmfivedaysbidsfunction: function(component, event, helper) {
        var scmfivedays = component.get("v.fivedaystotalBidsscmrcdslist"); 
        //alert(scmfivedays.length);
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",scmfivedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    scmremainingdaysbidsfunction: function(component, event, helper) {
        var scmremainingdays = component.get("v.remainingdaystotalBidsscmrcdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",scmremainingdays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    scmdaysbidssumfunction: function(component, event, helper) {
        var overallscm = component.get("v.totalBidsscmrcdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",overallscm);
        component.set("v.markeitingbooleantwo",false);//for displaying make false  
    },
    //scm complete here
    
    
    //contract starts here
    contracttwodaysbidsfunction: function(component, event, helper) {
        var contracttwodays = component.get("v.twodaystotalBidscontractrcdslist");  
        console.log('here the dataaa is '+contracttwodays.length);
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",contracttwodays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    contractthreedaysbidsfunction: function(component, event, helper) {
        var contractthreedays = component.get("v.threedaystotalBidscontractrcdslist"); 
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",contractthreedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    contractfivedaysbidsfunction: function(component, event, helper) {
        var contractfivedays = component.get("v.fivedaystotalBidscontractrcdslist"); 
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",contractfivedays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
        
    },
    contractremainingdaysbidsfunction: function(component, event, helper) {
        var contractremainingdays = component.get("v.remainingdaystotalBidscontractrcdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",contractremainingdays);
        component.set("v.markeitingbooleantwo",false);//for displaying make false
    },
    contractdaysbidssumfunction: function(component, event, helper) {
        var overallcontract = component.get("v.totalBidscontractrcdslist");   
        component.set("v.Bidsdisplaylist",'');
        component.set("v.Bidsdisplaylist",overallcontract);
        component.set("v.markeitingbooleantwo",false);//for displaying make false  
    },
    //contract complete here
    
    
    downloadCsv : function (component, event, helper) {
        helper.DownloadCSV(component, event, helper);
    },
    
     downloadCsv2 : function (component, event, helper) {
        helper.DownloadCSV2(component, event, helper);
    }
})