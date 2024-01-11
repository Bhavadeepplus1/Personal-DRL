({
	fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get('c.getselectOptions');
        action.setParams({
            "objObject": component.get('v.objInfoForPicklistValues'),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('allValues:'+allValues);
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchSecondPickListVal: function(component, event, helper) {
        helper.fetchPickListVal(component, 'Phoenix_Customer_Decline_Reasons__c', 'customerDecPicklistOpts');
    },
    
    closeBS: function (component, event, helper) {
        component.set("v.BSEditMode", false);
        var bidStatus = component.find('inputBSId').get('v.value');
        console.log('bidStatus'+bidStatus);
        var labelClass = component.find("inputBSId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        //var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
        
        if(bidStatus == 'Awarded' || bidStatus == 'Pending') {
            if(records[labelClass-1].Phoenix_Customer_Response_Date__c!=null && records[labelClass-1].Phoenix_Lead_Time_Days__c!=null){
                var customerDate=new Date(records[labelClass-1].Phoenix_Customer_Response_Date__c);
                customerDate.setDate(customerDate.getDate() + parseInt(records[labelClass-1].Phoenix_Lead_Time_Days__c));
                var dd = customerDate.getDate();            
                var mm = customerDate.getMonth()+1; 
                var yyyy = customerDate.getFullYear();
                if(dd<10){dd='0'+dd;} 
                if(mm<10){mm='0'+mm;} 
                customerDate = yyyy+'-'+mm+'-'+dd;                
                records[labelClass-1].Phoenix_Supply_Effective_Date__c=customerDate;  
            }     
           records[labelClass-1].Phoenix_Awarded_Quantity__c = records[labelClass-1].Phoenix_Final_Total_Selling_Unit__c;
           
            component.set("v.showErrorClassCDR",false);
            component.set("v.showErrorClassBS",false);
            records[labelClass-1].Phoenix_Customer_Decline_Reasons__c = '';
            component.set('v.CRLineItemListAll',records);
            if(records[labelClass-1].Phoenix_Awarded_Quantity__c == null || (records[labelClass-1].Phoenix_Awarded_Quantity__c == '' && records[labelClass-1].Phoenix_Awarded_Quantity__c != 0))
                component.set("v.showErrorClassAQ",true);
            if(records[labelClass-1].Phoenix_Award_Position__c == null || records[labelClass-1].Phoenix_Award_Position__c == '')
                component.set("v.showErrorClassAP",true);
            if(records[labelClass-1].Phoenix_Supply_Effective_Date__c == null && component.get("v.BidTypeVal")!='Price Change' && component.get("v.BidTypeVal")!='Sales Out Rebate' && component.get("v.BidTypeVal")!='Customer Rebate Change')
                component.set("v.showErrorClassSED",true);
            if(records[labelClass-1].Phoenix_Price_Effective_Date__c == null && component.get("v.BidTypeVal")!='Volume Review Only'){
                component.set("v.showErrorClassPED",true);
            }
        }
        else if(bidStatus == '') {
            component.set("v.LineselectedPosistions",null);
            records[labelClass-1].Phoenix_Customer_Decline_Reasons__c = '';
            records[labelClass-1].Phoenix_Awarded_Quantity__c = null;
            records[labelClass-1].Phoenix_Award_Position__c = null;
            records[labelClass-1].Phoenix_Supply_Effective_Date__c = null;
            records[labelClass-1].Phoenix_Price_Effective_Date__c = null;
            component.set('v.CRLineItemListAll',records);
            component.set("v.showErrorClassBS",true);
            component.set("v.showErrorClassCDR",false);
            component.set("v.showErrorClassAQ",false);
            component.set("v.showErrorClassAP",false);
            component.set("v.showErrorClassSED",false);
            component.set("v.showErrorClassPED",false);
        }
        else{
            console.log('Phoenix_Customer_Decline_Reasons__c'+records[labelClass-1].Phoenix_Customer_Decline_Reasons__c);
            if(records[labelClass-1].Phoenix_Customer_Decline_Reasons__c == null || records[labelClass-1].Phoenix_Customer_Decline_Reasons__c == '')
                component.set("v.showErrorClassCDR",true);
            component.set("v.showErrorClassAQ",false);
            component.set("v.showErrorClassBS",false);
            component.set("v.showErrorClassAP",false);
            component.set("v.showErrorClassSED",false);
            component.set("v.showErrorClassPED",false);
            component.set("v.LineselectedPosistions",null);
            records[labelClass-1].Phoenix_Awarded_Quantity__c = null;
            records[labelClass-1].Phoenix_Award_Position__c = null;
            records[labelClass-1].Phoenix_Supply_Effective_Date__c = null;
            records[labelClass-1].Phoenix_Price_Effective_Date__c = null;
            component.set('v.CRLineItemListAll',records);
            /*component.set("v.APEditMode",false);
            component.set("v.AQEditMode",false);
            component.set("v.PEDEditMode",false);
            component.set("v.SEDEditMode",false);*/
        }
    },
    getCustomer : function(component, event, helper) {
        var action = component.get("c.getCustomerInfo");
        action.setParams
        ({
            crId: component.get("v.crRecordId")
            // searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   component.set("v.customerId",response.getReturnValue());
                               }
                           });
        $A.enqueueAction(action);  
    },
    getChildLineItemRec : function(component, event, helper) {
        var action = component.get("c.getBlItemChildRec");
        action.setParams
        ({
            crLineId: component.get("v.singleRec.Id")
        }); 
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                component.set("v.childRec",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);  
    },
    checkAwardedQuantityRecords : function(component, event, helper) {
        var action = component.get("c.awardedQuantityRecCheck");
        action.setParams
        ({
            crLineId: component.get("v.singleRec.Id")
        }); 
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                component.set("v.isAwardedQuantityExist",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);  
    },
    getPositions :function(component, event, helper,customerRecId) {      
        var action = component.get("c.getPositions");
        action.setParams
        ({
            customerID: customerRecId
           // searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   var responseList = response.getReturnValue();
                                   console.log('---responseList---'+responseList.length);
                                   //component.set("v.contratcsList",responseList);
                                   
                                   //below code is for remove seleceted while fetch contracts in table
                                   var slctpositions;
                                   if(component.get('v.singleRec.Phoenix_Award_Position__c')!=null){
                                       slctpositions=component.get('v.singleRec.Phoenix_Award_Position__c').split(',');
                                       component.set("v.LineselectedPosistions",slctpositions);
                                       console.log('slctpositions--'+slctpositions);                                  
                                      /* var finalPositions= responseList.filter(comparer(slctpositions)); 
                                       function comparer(otherArray){
                                           return function(current){
                                               return otherArray.filter(function(other){
                                                   console.log(other);
                                                   return other == current.Name 
                                               }).length == 0;
                                           }
                                       }*/
                                   }
                                       for (var i = 0; i < responseList.length; i++) {
                                           var row = responseList[i];
                                           if(row.Phoenix_Customer__c){
                                               row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                                           }                                      
                                       }
                                       component.set("v.LinepositionsList",responseList);
                                   //}
                               }
                                
                               
                           });
        $A.enqueueAction(action);  
    },
    getPositionsMck :function(component, event, helper,customerRecId) {      
        var action = component.get("c.getPositions");
        action.setParams
        ({
            customerID: customerRecId
           // searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   var responseList = response.getReturnValue();
                                   console.log('---responseList---'+responseList.length);
                                   //component.set("v.contratcsList",responseList);
                                   
                                   //below code is for remove seleceted while fetch contracts in table
                                   var slctpositions;
                                   if(component.get('v.singleRec.Phoenix_Mck_Proposed_Position__c')!=null){
                                       slctpositions=component.get('v.singleRec.Phoenix_Mck_Proposed_Position__c').split(',');
                                       component.set("v.LineselectedPosistionsMck",slctpositions);
                                       console.log('slctpositions--'+slctpositions);                                  
                                      /* var finalPositions= responseList.filter(comparer(slctpositions)); 
                                       function comparer(otherArray){
                                           return function(current){
                                               return otherArray.filter(function(other){
                                                   console.log(other);
                                                   return other == current.Name 
                                               }).length == 0;
                                           }
                                       }*/
                                   }
                                       for (var i = 0; i < responseList.length; i++) {
                                           var row = responseList[i];
                                           if(row.Phoenix_Customer__c){
                                               row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                                           }                                      
                                       }
                                       component.set("v.LinepositionsListMck",responseList);
                                   //}
                               }
                                
                               
                           });
        $A.enqueueAction(action);  
    }

})