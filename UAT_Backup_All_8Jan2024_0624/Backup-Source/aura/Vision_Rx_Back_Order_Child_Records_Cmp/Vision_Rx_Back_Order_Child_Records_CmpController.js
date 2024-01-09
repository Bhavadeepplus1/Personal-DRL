({
    doInit : function(component, event, helper) {
        var data=component.get("v.accGroupList");
        //console.log('data Records-----'+JSON.stringify(data));	
        if(data.Vision_MoH__c.includes('.')){
            var temp = parseFloat(data.Vision_MoH__c);
            component.set('v.MoH',temp.toFixed(2));
            var tempW1 = parseFloat(data.Vision_Moh_Week1__c);
            component.set('v.MoHW1',tempW1.toFixed(2));
            var tempW2 = parseFloat(data.Vision_Moh_Week2__c);
            component.set('v.MoHW2',tempW2.toFixed(2));
            var tempW3 = parseFloat(data.Vision_Moh_Week3__c);
            component.set('v.MoHW3',tempW3.toFixed(2));
            var tempW4 = parseFloat(data.Vision_Moh_Week4__c);
            component.set('v.MoHW4',tempW4.toFixed(2));
        }
        
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
        
    },
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
        
    },
})