({
    getData: function(component, pageNumber, pageSize){
        var action = component.get("c.getExistingDeleRecords");
        action.setParams({
            
            'userId': component.get("v.userLkp"),
            'deleUserId':component.get("v.deleUserLkp"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
            
        });  
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('1');
                                   var responseWrapper = response.getReturnValue();
                                   component.set("v.excistingDeleList", responseWrapper.deleUsersList);
                                   component.set("v.PageNumber", responseWrapper.pageNumber);
                                   component.set("v.TotalRecords", responseWrapper.totalRecords);
                                   component.set("v.RecordStart", responseWrapper.recordStart);
                                   component.set("v.RecordEnd", responseWrapper.recordEnd);
                                   component.set("v.TotalPages", Math.ceil(responseWrapper.totalRecords / pageSize));
                                   component.set("v.showFilterPopup", false);
                               }else{
                                   console.log("Error "+JSON.stringify(response.getError()));
                               }
                           });
        $A.enqueueAction(action);
        component.set("v.loadSpinner", false);
    },
    fetchIPItems : function(component, event, helper, selectedUser) {
        component.set("v.loadSpinner",true);
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
        console.log('userId: '+component.get("v.userLkp"));
        loadModelAction.setParams({"userId" : selectedUser});
        loadModelAction.setCallback(this, function(response) {
            component.set("v.loadSpinner",false);
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
    },
    sortData: function(component, fieldName, sortDirection) {
        var data=component.get("v.model.bids");
        var reverse=sortDirection !== 'asc';
        if( fieldName === 'customerUrl'){
            fieldName = 'customerName';
        }
        data.sort(this.sortBy(fieldName, reverse));
        component.set("v.model.bids", data);
    },
    sortBy: function (field, reverse) {
        var key =  function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        if(field === 'bidUrl'){
            return function (a, b) {
                return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a>b) - (b>a));
            }
        } else{
            return function (a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            }
        }
    }
})