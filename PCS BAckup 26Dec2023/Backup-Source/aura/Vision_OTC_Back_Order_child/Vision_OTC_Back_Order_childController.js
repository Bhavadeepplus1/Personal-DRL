({
    doInit : function(component, event, helper) {
        
         
    },
	 closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
      
    },
     openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
      
    },
     closeDropshipModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isDropshipModalOpen", false);
      
    },
     openDropshipModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isDropshipModalOpen", true);
      
    }
    
})