({
    initRecords : function(component,event,helper){
        var accountId=component.get("v.recordId");
        //component.set("v.isSpinnerLoad",true);
        var action = component.get("c.getContactScores");
        var searchValue=component.get("v.searchValue");
        action.setParams({
            accountId: accountId,
            searchText:searchValue
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conList = response.getReturnValue();
                console.log('conList>>>>'+JSON.stringify(conList));
                    
                if(conList.length>0){
                    component.set('v.isData',true);
                    component.set("v.isSpinnerLoad",false);
                    component.set('v.isEmpty',false);
                    
                }
                else{
                    component.set("v.isSpinnerLoad",true);
                    component.set('v.isData',false);
                    component.set('v.isEmpty',true);
                    
                }
                if(conList.length==0){
                        component.set("v.isSpinnerLoad",false);
                    component.set('v.isData',false);
                        component.set('v.isEmpty',true);}
                
                //var nameList=[];
                //var roleList=[];
                component.set("v.contactsList",conList);
                /*for(var i=0; i<response.length; i++){
                    nameList.push(response[i].Name);
                    component.set('v.contactNameList',nameList);
                    var na=component.get('v.contactNameList');
                    console.log('response na>>>'+JSON.stringify(na));
                }*/
            }
        });
        $A.enqueueAction(action);
    },
    onsearch: function (component, event, helper) {
        console.log('Hi search')
         console.log('Hi search-----'+component.get("v.searchText"));
        //component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        
         component.set("v.searchValue",searchName);
     
        /*var action = component.get("c.getFilternameRole");
        
        action.setParams({
            searchText : searchName,
         
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('hi search')
                //var responseWrapper = response.getReturnValue();
                  //component.set('v.loaded',false);
                //if(searchName != null && searchName != undefined)
                    //component.set("v.accGroupList", responseWrapper.accList);
                //else
                    //component.set("v.accGroupList", responseWrapper.accList);
            //}  else{
               // console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);*/
        var a=component.get('c.initRecords');
          $A.enqueueAction(a);
        console.log('5');
       
       },
    searchIntExt: function(component, event, helper){
        console.log('uncheck')
        console.log('test->'+component.get("v.isINTChecked"));
        //console.log('testr->'+component.get("v.isRxChecked"));
        var isIntCheck = component.get("v.isINTChecked");
        var trueValue = true;
        var falsevalue = false;
        if(isIntCheck == false){
            component.set("v.isINTChecked",falsevalue);
            console.log('false->'+component.get("v.isINTChecked"));
            //console.log('testr->'+component.get("v.isRxChecked"));
        }
      else{
    	component.set("v.isINTChecked",trueValue);
          console.log('true>'+component.get("v.isINTChecked"));
          //console.log('testr->'+component.get("v.isRxChecked"));
          var a=component.get('c.initRecords');
          $A.enqueueAction(a);
		}
      //helper.getData(component, event, helper);  
    },
        
        
    })