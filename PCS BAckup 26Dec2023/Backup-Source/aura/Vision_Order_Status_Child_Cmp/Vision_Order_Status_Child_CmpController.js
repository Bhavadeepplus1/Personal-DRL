({
	doInit : function(component, event, helper) {
        var showItem = component.get("v.showItem");
        if(showItem){
            var data = component.get("v.customerOrdersList");
            console.log('test--->'+JSON.stringify(data));
            var Vision_Requested_Delivery_Date__c = new Date(data.Vision_Requested_Delivery_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
            if(data.Vision_Delivery_Date_Internal_Use__c != null){
                var Vision_Delivery_Date_Internal_Use__c = new Date(data.Vision_Delivery_Date_Internal_Use__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                data.formattedDelCreatedDate = Vision_Delivery_Date_Internal_Use__c;
            }
            else{
                data.formattedDelCreatedDate = '';
            }
            if(data.Vision_GCP_Ship_Date__c != null){
                var Vision_GCP_Ship_Date__c = new Date(data.Vision_GCP_Ship_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
            }
            data.formattedReqDate = Vision_Requested_Delivery_Date__c;
            data.formattedShipDate = Vision_GCP_Ship_Date__c;
            //console.log('Formatted Request Date: '+data.formattedReqDate);
            //console.log('formattedDelCreatedDate: '+data.formattedDelCreatedDate);
            component.set("v.data", data);
        }
    }
})