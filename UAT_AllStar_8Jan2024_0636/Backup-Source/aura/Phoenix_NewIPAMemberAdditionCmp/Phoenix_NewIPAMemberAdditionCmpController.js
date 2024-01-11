({
    initRecords : function(component, event, helper) {
        component.set('v.showSpinner',true);
         component.set("v.duplicateMsg",false);
         component.set("v.showDraftView",true);
        component.set('v.recordId', component.get("v.pageReference").state.c__recordId);
        var action = component.get("c.getIPAMemberList");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj =  response.getReturnValue();
                                   var memberList = wrapperObj.memberList;
                                   var bidRecord = wrapperObj.bidRecord;
                                   var parentIPA=wrapperObj.parentIPA;
                                   var rcItemList=wrapperObj.rcItemList;
                                   var accountList=wrapperObj.accountList;
                                   component.set("v.rcItemList",rcItemList);
                                     component.set("v.accountList",accountList);
                                   component.set("v.rcaMemberList",memberList);
                                   component.set('v.showSpinner',false);
                                   component.set('v.bidRecord',bidRecord);
                                    component.set('v.ipaAccountId',bidRecord.Phoenix_Customer__c);
                                   
                                    console.log('bidRecord.Phoenix_Approval_Status__c'+bidRecord.Phoenix_Approval_Status__c);
                                    if(bidRecord.Phoenix_Approval_Status__c != 'Draft') {
                        component.set('v.showDraftView',false);
                    }
                                   
                               }
                               else{
                                   component.set('v.showSpinner',false);
                               }
                           });
        $A.enqueueAction(action);	
    },
    
    handleEvent: function(component, event, helper) {
        
        
        var message = event.getParam("message");
       var AllRowsList = component.get("v.rcaMemberList");
        for (let i = 0; i < AllRowsList.length; i++) {
            var index = message-1;
            if (index > -1) {
                console.log('index---'+index);
                
                AllRowsList.splice(index, 1);  
                break;
            }
            
        }
        component.set("v.rcaMemberList",AllRowsList); 
    },
    
    
   
    processNewRCALine: function (component, event, helper) {
        component.set("v.showSpinner",true);
         component.set("v.duplicateMsg",false);
        var rcaUpdateList=component.get("v.rcaMemberList");
        var getProductsAction = component.get("c.processIPAMember");
        getProductsAction.setParams({"bidId":component.get("v.recordId")});
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var resposeData = response.getReturnValue();
                rcaUpdateList.push(resposeData);
                console.log('resposeData--------'+resposeData);
                component.set("v.rcaMemberList",rcaUpdateList);
                /*var OutDiv = component.find("mainDiv");
                                   if(rcaUpdateList.length>4){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "heightClass");
                                   }*/
                
            }
            
        });
        $A.enqueueAction(getProductsAction);
        
    },
    insertRCALines: function (component, event, helper) {
         component.set("v.showDraftView",true);
          component.set("v.duplicateMsg",false);
        
        var countDEA=0;
        var countGPO=0;
        var countWholesaler=0;
        
        var rcaLines=component.get("v.rcaMemberList");
         rcaLines.forEach(function(line){
             console.log('Phoenix_New_GPO__c-----'+line['Phoenix_New_GPO__c']);
             if((line['Phoenix_GLN__c']!=null && line['Phoenix_GLN__c']!=undefined && line['Phoenix_GLN__c']!='')|| (line['Phoenix_HIN__c']!=null && line['Phoenix_HIN__c']!=undefined && line['Phoenix_HIN__c']!='') || (line['Phoenix_DEA__c']!=null && line['Phoenix_DEA__c']!=undefined && line['Phoenix_DEA__c']!='')  ){
                //component.set("v.showDEAMsg",false); 
             }
             else{
                 countDEA++;
                 //component.set("v.showDEAMsg",true);  
             }
             if((line['Phoenix_New_GPO__c']==null || line['Phoenix_New_GPO__c']==undefined || line['Phoenix_New_GPO__c']=='' || line['Phoenix_New_GPO__c']=='-None-' || line['Phoenix_New_GPO__c']==' '||line['Phoenix_New_GPO__c']==" " )){
                  //component.set("v.showGPOMsg",true); 
                  countGPO++;
                 console.log('hi in GPO');
             }
             
             if((line['Phoenix_Wholesaler__c']==null || line['Phoenix_Wholesaler__c']==undefined || line['Phoenix_Wholesaler__c']=='' || line['Phoenix_Wholesaler__c']=='--- None ---')){
                  //component.set("v.showWholesalerMsg",true); 
                  countWholesaler++;
             } 
              if(line['Phoenix_Wholesaler_Location__c']==null || line['Phoenix_Wholesaler_Location__c']==undefined || line['Phoenix_Wholesaler_Location__c']=='' || line['Phoenix_Wholesaler_Location__c']=='--- None ---'){
                //countWholesaler++; 
             }
            
             
             
 });
        if(countDEA>0){
          component.set("v.showDEAMsg",true);   
        }
        else{
          component.set("v.showDEAMsg",false);      
        }
        if(countGPO>0){
          component.set("v.showGPOMsg",true);   
        }
        else{
          component.set("v.showGPOMsg",false);      
        }
        if(countWholesaler>0){
          component.set("v.showWholesalerMsg",true);   
        }
        else{
          component.set("v.showWholesalerMsg",false);      
        }
        
         var IPACustomers=[];
        
        var accountList=component.get("v.rcItemList");
         var Allaccounts=component.get("v.accountList");
         console.log('accountList---------------'+JSON.stringify(accountList));
        console.log('Allaccounts---------------'+JSON.stringify(Allaccounts));
        var accountMap=new Map();
        if(Allaccounts!=null && Allaccounts!=undefined && Allaccounts!=''){
        for(var i=0;i<Allaccounts.length;i++){
            if((Allaccounts[i].Id!=null &&Allaccounts[i].Id!=''&&Allaccounts[i].Id!=undefined )&&(Allaccounts[i].Name!=null &&Allaccounts[i].Name!=''&&Allaccounts[i].Name!=undefined)){
             accountMap.set(Allaccounts[i].Id,Allaccounts[i].Name);
            }
        }
        }
         console.log('existingMap-----');
        //var existingCustomers=[];
        var duplicateExistingcustomers=[];
        var existingMap=new Map();
        if(accountList!=null && accountList!=undefined && accountList!=''){
             console.log('existingMap1-----');
         for(var i=0;i<accountList.length;i++){
         //existingCustomers.push(accountList[i].Phoenix_Customer__c); 
         console.log('accountList[i].Phoenix_Customer__c'+accountList[i].Phoenix_Customer__c);
              //console.log('accountList[i].Phoenix_Customer__r.Name'+accountList[i].Phoenix_Customer__r.Name);
             if(accountList[i].Phoenix_Customer__c!=null && accountList[i].Phoenix_Customer__c!=undefined && accountList[i].Phoenix_Customer__c!='undefined' && accountList[i].Phoenix_Customer__c!=''){
                             if((accountList[i].Phoenix_Customer__r.Name!=null &&accountList[i].Phoenix_Customer__r.Name!=''&&accountList[i].Phoenix_Customer__r.Name!=undefined)){

             existingMap.set(accountList[i].Phoenix_Customer__c,accountList[i].Phoenix_Customer__r.Name);
                             }
             }
             
        }
        }
        var duplicateList=[]
        console.log('existingMap-----'+existingMap);
        var rcaItems=[];
        console.log('accountList-----'+JSON.stringify(accountList));
         rcaLines.forEach(function(line){
             console.log('rcaItems------'+JSON.stringify(rcaItems));
              console.log('rcaItems--includes----'+IPACustomers.includes(line['Phoenix_Customer__c']));
             if(accountList!=''&& accountList!=undefined && accountList!=null && (existingMap.has(line['Phoenix_Customer__c']))){
                    if(line['Phoenix_Customer__c']!=null && line['Phoenix_Customer__c']!=''&&line['Phoenix_Customer__c']!=undefined){
               console.log('Hi in Duplicate');
                 duplicateExistingcustomers.push(existingMap.get(line['Phoenix_Customer__c']));
                 component.set("v.duplicateMsg",true);
                    }
             }
             else if (IPACustomers!=null && IPACustomers!=''&& IPACustomers!=undefined && (existingMap.has(line['Phoenix_Customer__c'])==false)&& IPACustomers.includes(line['Phoenix_Customer__c'])){
                 console.log('Hi rcaItems in Duplicate');
                 //var accountRec=accountMap.get(line['Phoenix_Customer__c']);
                    if(line['Phoenix_Customer__c']!=null && line['Phoenix_Customer__c']!=''&&line['Phoenix_Customer__c']!=undefined){
                 duplicateList.push(accountMap.get(line['Phoenix_Customer__c']));
              component.set("v.duplicateMsg",true);
                    }
             }
            IPACustomers.push(line['Phoenix_Customer__c']);
 });
                                                  
              var showDEAMsg=component.get("v.showDEAMsg");
          var showGPOMsg=component.get("v.showGPOMsg");
         var showWholesalerMsg=component.get("v.showWholesalerMsg");
          var duplicateMsg=component.get("v.duplicateMsg");
        
        if(showDEAMsg){
          var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Please enter a value for DEA or HIN or GLN"
                });
                toastEvent.fire();  
        }
        else if(showGPOMsg){
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Please select GPO"
                });
                toastEvent.fire(); 
        }
            else if(showWholesalerMsg){
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Please select Wholesaler Name"
                });
                toastEvent.fire(); 
            }                                     
             else if( duplicateMsg){
                   if(duplicateExistingcustomers.length>0){
                 for(var i=0;i<duplicateExistingcustomers.length;i++){
                 console.log('Hi');
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Duplicates are found for "+ duplicateExistingcustomers[i] +" .Please remove the duplicates"
                });
                toastEvent.fire();
             }
                   }
                   if(duplicateList.length>0){
                 for(var i=0;i<duplicateList.length;i++){
                 console.log('Hi');
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Duplicates are found for "+ duplicateList[i] +" .Please remove the duplicates"
                });
                toastEvent.fire();
             }
                   }    
                 
             }    
                                                
                                              
        if(component.get("v.duplicateMsg")==false && showDEAMsg==false && showGPOMsg==false && showWholesalerMsg==false){   
        component.set("v.showSpinner",true);
        var getProductsAction = component.get("c.saveIPAMembers");
        var Items=component.get("v.rcaMemberList");
        console.log('Items------'+JSON.stringify(Items));
        getProductsAction.setParams({"memberList":component.get("v.rcaMemberList"),
                                     "bidRecord":component.get("v.bidRecord")});
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var resposeData = response.getReturnValue();
               component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
                
                
            }
            
        });
        $A.enqueueAction(getProductsAction);
        }
    },
     backToBid : function(component, event, helper){
          component.set("v.showDraftView",true);
          component.set("v.duplicateMsg",false);
         component.set("v.rcaMemberList",'');
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
     },
})