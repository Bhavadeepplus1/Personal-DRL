({
	doInit : function(component, event, helper) {
	  var data=component.get("v.accGroupList");
        var prodName = data.backOrderRecords;
        component.set('v.productName', prodName);
       // console.log('prodName-----'+JSON.stringify(prodName))
        console.log('data-----'+JSON.stringify(data))
        var week1='';
         var week2='';
        var week3='';
        var week4='';
      
                data.backOrderRecords.forEach(function(item){
                 //   console.log('Id---->'+item.Id);
                    if(item.Vision_MoH__c.includes('.')){
                        var temp = parseFloat(item.Vision_MoH__c);
                      component.set('v.MoH',temp.toFixed(2));   
                    }
             
                  //  console.log('moh data-----'+component.get('v.MoH'));
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
         component.set('v.week4',week4);
	},
       closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
      
    },
     openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
      
    },
      handleClick1: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        var data = component.get("v.accGroupList");
        console.log('Data pfName:: '+JSON.stringify(data));
        if(data.pfName == pfName && data != undefined ){
            console.log('shoe pf')
            data.showProdFam = false;
          /*  for(var i=0; i<data.productFamily.length; i++){
                if(data.productFamily.showProdFam){
                 	data.productFamily.showProdFam = false;   
                } else{
                    data.productFamily.showProdFam = true;
                }
           }*/
        }
        component.set("v.accGroupList", data);
        component.set("v.show", false);
    },
    handleClick2: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        var data = component.get("v.accGroupList");
        console.log('Data pfName:: '+JSON.stringify(data));
        if(data.pfName == pfName && data != undefined ){
                 console.log('shoe pf --')       
            data.showProdFam = true;

        }
        component.set("v.accGroupList", data);
        component.set("v.show", true);
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
    sortByskucode: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
      
        helper.sortHelper(component, event, 'Vision_Sku_Code__c ');
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
    }
    
})