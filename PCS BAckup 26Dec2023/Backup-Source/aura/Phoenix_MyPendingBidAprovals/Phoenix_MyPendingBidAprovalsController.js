({
    fetchallItems : function(component, event, helper) {
        console.log("-----doInit---");
        helper.loadModelData(component, helper);
    },
    toggleSection : function(component, event, helper) {
        console.log("----toggleSection----");
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    },
                
    updateSorting : function(component, event, helper) {
          var fieldName = event.getParam('fieldName');
          var sortDirection = event.getParam('sortDirection');
          component.set("v.sortedBy", fieldName);
          component.set("v.sortedDirection", sortDirection);
          helper.sortData(component, fieldName, sortDirection);
    },
    
    fetchIPItems : function(component, event, helper) {
         component.set("v.showSpinner",true);
        //  let recordId = component.get("v.recordId");
        component.set("v.columns", 
                      [
                          { label: 'Record No', fieldName: 'bidUrl', type: 'url', sortable: true,
                           typeAttributes: {
                               label: {
                                   fieldName: 'no',
                                   target: '_self'
                               }
                           }
                          },
                          { label: 'Name', fieldName: 'name', type: 'text', sortable: true},
                          { label: 'Type', fieldName: 'bidType', type: 'text', sortable: true},
                          { label: 'Customer Name', fieldName: 'customerUrl', type: 'url', sortable: true,
                           typeAttributes: {
                               label: {
                                   fieldName: 'customerName',
                                   target: '_self'
                               }
                           }
                          },
                          { label: 'Current Approval Status', fieldName: 'approvalStaus', type: 'text', sortable: true},
                          { label: 'Bid Internal Target Date', fieldName: 'internalTargetDateEST', type: 'text',sortable: true},
                          { label: 'Bid Approval Sent Date', fieldName: 'bidApprovalSentDateEST', type: 'text',sortable: true},
                          { label: 'Bid Last Modified Date', fieldName: 'Last_MDT', type: 'text',sortable: true}//Add code by Rama

                          
                      ])
                          
                          
        //
        var loadModelAction = component.get("c.getPendingApprovals");
        //loadModelAction.setParams({"recordId" : recordId});
        loadModelAction.setCallback(this, function(response) {
             component.set("v.showSpinner",false);
            var status = response.getState();
            console.log("-----------status--------"+status);
            if(status === 'SUCCESS'){
                let model = response.getReturnValue();
                console.log("-------model----"+JSON.stringify(model));
                model.bids.forEach(function(item){
                    item.bidUrl = '/'+item.bidId;
                    item.customerUrl = '/'+item.customerId;
                    if(item.bidUrl == '/undefined'){
                        if(item.customerUrl == '/undefined'){
                            item.bidUrl = "";
                            item.customerUrl = "";
                        } else{
                            item.bidUrl = "";
                        }
                } else{
                    if(item.customerUrl == '/undefined'){
                        item.customerUrl = "";
                    }
                }
               });
                component.set("v.model", model);
            }
            else{
                console.log('----error---'+JSON.stringify(response.getError()));  
            }
        });
        $A.enqueueAction(loadModelAction);   
    }
})