({
    doInit : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getCustomers");
        component.set('v.loaded',true);
        
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.accGroupList",responseWrapper.accList);
                                component.set("v.isProcessed",responseWrapper.isProcessed); 
                console.log('accGroupList-----'+JSON.stringify(responseWrapper));
                component.set('v.loaded',false);
                var pickList =  [];
                var picklistValues = responseWrapper.accgrpList;
                //   console.log('picklistValues-----'+picklistValues[0]);
                if(picklistValues.length>0 && picklistValues[0] != undefined){
                    component.set('v.selectedId',picklistValues[0]); 
                    //component.set('v.selectedI
                }
                
                var i = 1;
                var newLine = 1;
                picklistValues.forEach(function(user){
                    var isNewLine = false;
                    if(newLine == 5){
                        isNewLine = true;
                        newLine =1;
                    }
                    pickList.push({userId:''+user,isSelected: i==1?true:false,isNewLine:isNewLine});
                    i++;
                    newLine++;
                });
                //  console.log('picklist-----'+JSON.stringify(pickList));
                component.set("v.pickList",pickList);
                component.set("v.noofRecords",responseWrapper.noOfRecords);
                var records=component.get("v.noofRecords");
                console.log('noofRecords>>>'+records);
                 component.set("v.responseWrapper",responseWrapper);
                component.set("v.ProdFamList",responseWrapper.prodFamList);
                component.set("v.dateList",responseWrapper.sdRecords);
                component.set("v.visionUpdateDate",responseWrapper.visionUpdateDate);
                 console.log('do inir showall->'+component.get("v.showAll"));
                console.log('dateList',+JSON.stringify(component.get("v.dateList")));
                 
        var prodName = responseWrapper.accList.backOrderRecords;
      
        console.log('prodName do init-----'+JSON.stringify(prodName))
    //    console.log('prodName-----'+JSON.stringify(prodName))
      /*  var week1='';
         var week2='';
        var week3='';
        var week4='';
      
                prodName.forEach(function(item){
                    console.log('Id---->'+item.Id);
                    if(item.Vision_MoH__c.includes('.')){
                        var temp = parseFloat(item.Vision_MoH__c);
                      component.set('v.MoH',temp.toFixed(2));   
                    }
             
                    console.log('moh data-----'+component.get('v.MoH'));
                    component.set('v.currentMonth',item.Vision_current_month__c);
                    component.set('v.lastMonth',item.Vision_last_month__c);
                  
                    var substr1Week1=item.Vision_Week_1__c.substr(5,11);
                    var substr2Week1=item.Vision_Week_1__c.substr(21,25);
                    var W1='';
                    week1=W1.concat(substr1Week1,substr2Week1);
                     var substr1Week2=item.Vision_Week_2__c.substr(5,11);
                    var substr2Week2=item.Vision_Week_2__c.substr(21,25);
                    var W2='';
                    week2=W2.concat(substr1Week2,substr2Week2);
                    var substr1Week3=item.Vision_Week_3__c.substr(5,11);
                    var substr2Week3=item.Vision_Week_3__c.substr(21,25);
                    var W3='';
                    week3=W3.concat(substr1Week3,substr2Week3);
                     var substr1Week4=item.Vision_Week_4__c.substr(5,11);
                    var substr2Week4=item.Vision_Week_4__c.substr(21,25);
                    var W4='';
                    week4=W4.concat(substr1Week4,substr2Week4);
                });	
         component.set('v.week1',week1);
           component.set('v.week2',week2);
         component.set('v.week3',week3);
         component.set('v.week4',week4);*/
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    }, 
   
  handleComponentEvent : function(component, event, helper) {
        var valueFromChild = event.getParam("accGroupList");
      //console.log('accGroupList@@@'+ accGroupList);
      var isAsc =event.getParam("isAsc");
     //   alert(JSON.stringify(valueFromChild));
        console.log('isAsc event'+isAsc);
        component.set("v.accGroupList", valueFromChild);
          component.set("v.isAsc", isAsc);
    },

 
    onSelectUser : function(component, event, helper){
        //console.log('Id Name---'+event.getSource().get("v.name"));
        var picliList = component.get('v.RxSrxList');
        console.log('picliList---'+picliList);
        component.set('v.loaded', true);
        component.set('v.showRecords', false);
        //var selectedId =  event.currentTarget.dataset.id;
        var selectedId =  component.get('v.selectedId');
        //event.getSource().get("v.name");
           console.log('Id Name---'+selectedId);
        component.set('v.selectedId',selectedId);
        var listOfusers = component.get("v.pickList");
        listOfusers.forEach(function(user){
            if(user.userId == selectedId){
                user.isSelected = true;
            }
            else{
                user.isSelected = false;
            }
        });
        component.set("v.pickList",listOfusers);
        var getBidInfoAction = component.get("c.getbackOrder");
        
        getBidInfoAction.setParams({
            showAll : component.get("v.showAll"),
            customer : component.get("v.selectedId")
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded', false);
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper onselect-----'+JSON.stringify(responseWrapper.accList));
                component.set("v.accGroupList",responseWrapper.accList);

                /*  component.set("v.accGroupList",responseWrapper.accList);
                component.set("v.shortDateList",responseWrapper.gcpShortDates);  */
                component.set("v.ProdFamList",responseWrapper.prodFamList);
               // console.log('dohSummary-----'+JSON.stringify(responseWrapper.prodFamList))
                  component.set("v.noofRecords",responseWrapper.noOfRecords);
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction); 
    },
       onsearch: function (component, event, helper) {
        console.log('Hi search')
        console.log('Hi search-----'+component.get("v.searchText"))
        component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        component.set('v.loaded',true);
        
        var action = component.get("c.getFilterBackOrder");
        console.log('Hi search method-----'+component.get("v.selectedId"))
        action.setParams({
            searchText : searchName,
            customer : component.get("v.selectedId"),
            showAll : component.get("v.showAll")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
             console.log('hi res'+state);
            if (state === "SUCCESS") {
                console.log('hi search');
                var responseWrapper = response.getReturnValue();
                component.set('v.loaded',false);
                if(searchName != null && searchName != undefined){
                  component.set("v.accGroupList", responseWrapper.accList);
                  component.set("v.noofRecords",responseWrapper.noOfRecords);   
                }
                   
                else{
                    component.set("v.accGroupList", responseWrapper.accList);
                  component.set("v.noofRecords",responseWrapper.noOfRecords);  
                }
                  
            }  else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
 
     showAllRecords : function(component,event,helper){  
       var version = component.get("v.showAll");
        console.log('test->'+component.get("v.showAll"));
        var isCheck = component.get("v.showAll");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){
            component.set("v.showAll",falsevalue);
        }
        else{
            component.set("v.showAll",trueValue); 
        }
         console.log('test123->'+component.get("v.showAll"));
     component.set('v.loaded',true);
         component.set('v.searchText',null);
  var getBidInfoAction = component.get("c.getbackOrder");
        
        getBidInfoAction.setParams({
            showAll : component.get("v.showAll"),
            customer : component.get("v.selectedId")
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded', false);
                console.log('showRecords----onselct----'+component.get("v.showRecords")); 
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper onselect-----'+JSON.stringify(responseWrapper));
                                component.set("v.accGroupList",responseWrapper.accList);

                /*  component.set("v.accGroupList",responseWrapper.accList);
                component.set("v.shortDateList",responseWrapper.gcpShortDates);  */
                component.set("v.ProdFamList",responseWrapper.prodFamList);
                console.log('dohSummary-----'+JSON.stringify(responseWrapper.prodFamList))
                  component.set("v.noofRecords",responseWrapper.noOfRecords);
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction); 
   },
       sortByItem: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
      
        helper.sortHelper(component, event, 'Vision_Product__r.Name');
    },
    sortByCurrentOrderQty: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
      
        helper.sortHelper(component, event, 'Vision_Current_Order_Qty__c');
    },
    sortByOrderValue: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
      
        helper.sortHelper(component, event, 'Vision_Order_Value__c');
    },
    sortByBackOrderQty: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
      
        helper.sortHelper(component, event, 'Vision_Backorder_Qty__c');
    },
    sortByBackOrderValue: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
      
        helper.sortHelper(component, event, 'Vision_Back_Order_Value__c');
    },
    sortByTotalOpenOrderQty: function(component, event, helper) {
        console.log('inside sortByTotalOpenOrderQty');
         component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
      
        helper.sortHelper(component, event, 'Vision_Total_Open_Order_Qty__c');
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