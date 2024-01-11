({
    //----code by Rama -------
    doInit : function(component, event, helper) {
        var actionfu = component.get("c.fetchUser");
        actionfu.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(actionfu);
    },
    customerName : function(component, event, helper) {
        var actioncn = component.get("c.fetchBidCustomerName");
         actioncn.setParams({
            "bidCustName" : component.get("v.bidId")
        });
        actioncn.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.AccountName", storeResponse);
            }
        });
        $A.enqueueAction(actioncn);
    },
    navigate : function(component, event, helper) 
    {
        //#####################calling apex methid for  verify Competitor_Info__c records count ###########################################  
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        /////////////////////////////////////////////////////////
        var action1 = component.get('c.CollectCompetitorInfoRec');
        //alert('-===-=-=-bidIdfrom other com'+component.get("v.bidId"))
        action1.setParams({
            "bidid" : component.get("v.bidId")
        });
        action1.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                if(result.length>0)
                {
                    component.set("v.viewCompetitorInfo",true);
                    var actioncominfoview = component.get('c.competitoinfoview');
                    $A.enqueueAction(actioncominfoview);
                    //Display the Commpetitor Values
                    var actioncm = component.get("c.getCompetitorName");
                    actioncm.setCallback(this, function(response){
                        var result =response.getReturnValue();
                        console.log(result);
                        component.set("v.Compts",result);
                    });
                    $A.enqueueAction(actioncm);
                    //component.get('c.competitoinfoview');
                    component.set("v.navigate",false);
                }
                if(result.length===0)
                {
                    component.set("v.viewCompetitorInfo",false);
                    component.set("v.navigate",true);
                }
                
            }
        });
        $A.enqueueAction(action1);
        
        
        //#####################calling apex CompetitorMethod for ProductFamilyNames for drop down #############################
        var actionp = component.get('c.collectProductFamilyNames');
        actionp.setParams({
            "bidid" : component.get("v.bidId")
        });
        actionp.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set('v.ProductFamilyNames', response.getReturnValue());
            }
        });      
        //#####################calling apex CompetitorMethod for ProductFamilyNames for viwe page  for drop down #############################
		var actionv = component.get('c.collectProductFamilyNamesview');
        actionv.setParams({
            "bidid" : component.get("v.bidId")
        });
        actionv.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set('v.ProductFamilyNamesView', response.getReturnValue());
            }
        });  
        //#####################call apex class method for records############################################################
        var action = component.get('c.CompetitorInfoMethod');
        action.setParams({
            "bidid" : component.get("v.bidId")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set('v.CompetitorInfowrapper', response.getReturnValue());
                var result=response.getReturnValue();            
            }
        });     
        $A.enqueueAction(actionp);
        $A.enqueueAction(actionv);
        $A.enqueueAction(action);       
    },
    CompetitorCancel: function(component, event, helper) 
    {
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
        window.history.back();
      //  component.set("v.navigate",false);
       // if(component.get("v.viewCompetitorInfo") === true)
        //    component.set("v.viewCompetitorInfo",false);
        
      /*  var navigateurl='https://drreddysnag--project1.lightning.force.com/lightning/n/Walgreens_View?c__id='+component.get("v.bidId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({             
            "url": navigateurl         
        });         
        urlEvent.fire();*/
        
    },
    CompetitorinfoSave: function(component, event, helper) 
    {
        let journal = [];
        var ProductNames= component.find('ProductNameauarid');
        var BidLineItemNos=component.find('BidLineItemNoauraid');
        var Ndcs=component.find('Ndcauarid');
        var Productfamilies=component.find('productfamilyauarid');
        var IncumbentCompetitornames=component.find('Competitorauraid');
        var IncumbentPriceRanges=component.find('IncumbentPriceRangeauraid'); 
        
        var IncumbentCompetitornames2=component.find('Competitorauraid2');// Adding Incumbent Competitor & Price Range Values
        var IncumbentPriceRanges2=component.find('IncumbentPriceRangeauraid2'); 
        var IncumbentCompetitornames3=component.find('Competitorauraid3');
        var IncumbentPriceRanges3=component.find('IncumbentPriceRangeauraid3'); 
        var IncumbentCompetitornames4=component.find('Competitorauraid4');
        var IncumbentPriceRanges4=component.find('IncumbentPriceRangeauraid4'); 
        var IncumbentCompetitornames5=component.find('Competitorauraid5');
        var IncumbentPriceRanges5=component.find('IncumbentPriceRangeauraid5');
        if(ProductNames.length>=2 || component.find('ChooseProductFamilyid').get('v.value')!='ChooseProductFamily')
        {
            //alert('Product Name--------'+ProductNames.length)
            var newincoms;
            for(var i=0; i<ProductNames.length; i++) 
            {
                //   alert('----------helo:'+ProductNames.length);
                journal.push(
                    {
                        BidNos:component.get("v.bidId") ,
                        // BidLineItemNos: BidLineItemNos[i].get("v.value"),
                        ProductNames: ProductNames[i].get("v.value"),
                        BidLineItemNos: BidLineItemNos[i].get("v.value"),
                        Ndcs: Ndcs[i].get("v.value"),
                        Productfamilies: Productfamilies[i].get("v.value"),
                        IncumbentCompetitornames: IncumbentCompetitornames[i].get("v.value"),
                        IncumbentPriceRanges: IncumbentPriceRanges[i].get("v.value"),
                        IncumbentCompetitornames2: IncumbentCompetitornames2[i].get("v.value"),
                        IncumbentPriceRanges2: IncumbentPriceRanges2[i].get("v.value"),
                        IncumbentCompetitornames3: IncumbentCompetitornames3[i].get("v.value"),
                        IncumbentPriceRanges3: IncumbentPriceRanges3[i].get("v.value"),
                        IncumbentCompetitornames4: IncumbentCompetitornames4[i].get("v.value"),
                        IncumbentPriceRanges4: IncumbentPriceRanges4[i].get("v.value"),
                        IncumbentCompetitornames5: IncumbentCompetitornames5[i].get("v.value"),
                        IncumbentPriceRanges5: IncumbentPriceRanges5[i].get("v.value"),
                    }
                );             
            }
        }       
        else
        {            
            //alert(component.find('ProductNameauarid').get("v.value"));
            journal.push(
                { 
                    BidNos:component.get("v.bidId") ,
                    ProductNames: component.find('ProductNameauarid').get("v.value"),
                    BidLineItemNos: component.find('BidLineItemNoauraid').get("v.value"),
                    Ndcs: component.find('Ndcauarid').get("v.value"),
                    Productfamilies: component.find('productfamilyauarid').get("v.value"),
                    IncumbentCompetitornames: component.find('Competitorauraid').get("v.value"),
                    IncumbentPriceRanges: component.find('IncumbentPriceRangeauraid').get("v.value"),
                    IncumbentCompetitornames2: component.find('Competitorauraid2').get("v.value"),
                    IncumbentPriceRanges2: component.find('IncumbentPriceRangeauraid2').get("v.value"),
                    IncumbentCompetitornames3: component.find('Competitorauraid3').get("v.value"),
                    IncumbentPriceRanges3: component.find('IncumbentPriceRangeauraid3').get("v.value"),
                    IncumbentCompetitornames4: component.find('Competitorauraid4').get("v.value"),
                    IncumbentPriceRanges4:component.find('IncumbentPriceRangeauraid4').get("v.value"),
                    IncumbentCompetitornames5:component.find('Competitorauraid5').get("v.value"),
                    IncumbentPriceRanges5:component.find('IncumbentPriceRangeauraid5').get("v.value"),
                }
            );       
        }
        //------calling apex method to save records 
        var action = component.get('c.CompetitorInfoMethodsave');
        action.setParams({
            "resultobjs" : journal,
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.navigate",false);
                // alert('Success records r imported successfully ') 
                /* var navigateurl='https://drreddysnag--project1.lightning.force.com/lightning/n/Walgreens_View?c__id='+component.get("v.bidId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({             
            "url": navigateurl         
        });         
        urlEvent.fire();*/
                
                
                 window.history.back();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "The records has been Created successfully."
                });
                toastEvent.fire();
               
                /* var getcodata = response.getReturnValue();
                //alert(getcodata)
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "related"
                });
                navEvt.fire();   */             
            }
            else if(state === "ERROR")
            {
                var errors = action.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        alert(errors[0].message);
                    }
                }
            }
                else if (status === "INCOMPLETE") 
                {
                    alert('No response from server or client is offline.');
                }  
        });
        $A.enqueueAction(action);
        
    },
    onChange:function(component, event, helper)  
    {
        var ProductFamilyid=component.find('ChooseProductFamilyid').get('v.value');
        //alert('-----'+ProductFamilyid)
        //-------
        var actionp = component.get('c.CompetitorInfoPF');
        actionp.setParams({
            "bidid" : component.get("v.bidId"),
            "pf" : ProductFamilyid
        });
        actionp.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                
                component.set('v.CompetitorInfowrapper', response.getReturnValue());
            }
        });
        $A.enqueueAction(actionp);
    },
    onChangeview:function(component, event, helper)  
    {
        var ProductFamilyid=component.find('ChooseProductFamilyidview').get('v.value');
        
        var actionp = component.get('c.CompetitorInfoPFv');
        actionp.setParams({
            "bidid" : component.get("v.bidId"),
            "pf" : ProductFamilyid
        });
        actionp.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                
                component.set('v.CompetitorInfoViewRec', response.getReturnValue());
            }
        });
        $A.enqueueAction(actionp);
    },
    
    
    
    competitoinfoview : function(component,event, helper) 
    {
        //alert("Competitor Info View") 
        var currentBidID=component.get("v.bidId");    
        ///**********calling apex method for get Competitor_Info__c records based on bid id *******
        var action = component.get('c.CollectCompetitorInfoRec');
        action.setParams({
            "bidid" : currentBidID
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                //var mySet1 = new Set();
                //for(var i in result)
               // {
                    //alert('view bid Name'+result[i].Product_Family__c)
                    //mySet1.add(result[i].Product_Family__c);
               // }
               // component.set('v.ProductFamilyNamesView', mySet1);
                component.set("v.viewCompetitorInfo",true);
                component.set('v.CompetitorInfoViewRec', response.getReturnValue());
                 //for(var i in component.get('v.ProductFamilyNamesView'))
                //alert('$$$$$$$$$$--'+component.get('v.ProductFamilyNamesView').length)
            }
        });
        $A.enqueueAction(action);
        
        //***************  calling GetCompetitorNames method for get all GCompetitor Names
        var actioncn = component.get('c.GetCompetitorNames');
        actioncn.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                component.set('v.CompetitorNames',result);
                //for(var i in result)
                //alert(result[i])
            }
        });
        $A.enqueueAction(actioncn);
        
    } ,
    IncumbentCompetitorNameEdit : function(component,event, helper) 
    {
        //component.set("v.IncumbentCompetitorNameEdit",true);
        // alert(event.getSource().get("v.value"));//-------if of record
        component.set('v.IncumbentCompetitorid',event.getSource().get("v.value"));
        component.set("v.IncumbentCompetitorNameEdit",true);
        // alert( event.getSource().get("v.alternativeText"))// ----- record index 
        component.set('v.indexofeditrecord',event.getSource().get("v.alternativeText"));
    },
    CICompetitorinfoSave: function(component,event, helper)
    {
        var CompetitorInfowRec= component.get("v.CompetitorInfoViewRec");
        var compNames=component.find('CIComName');
        var compNames2=component.find('CIComName2');
        var compNames3=component.find('CIComName3');
        var compNames4=component.find('CIComName4');
        var compNames5=component.find('CIComName5');
        
        //var compNames=component.find('CIComName');ChooseProductFamilyidview
        if(CompetitorInfowRec.length >=2 || component.find('ChooseProductFamilyidview').get('v.value')!='ChooseProductFamily')
        {
            for(var i=0; i<CompetitorInfowRec.length; i++) 
            {
                
                CompetitorInfowRec[i].Incumbent_Competitor_Name__c=compNames[i].get("v.value");
                //alert(CompetitorInfowRec[i].Incumbent_Competitor_Name__c)
                CompetitorInfowRec[i].Incumbent_Competitor_Name_2__c=compNames2[i].get("v.value");
                CompetitorInfowRec[i].Incumbent_Competitor_Name_3__c=compNames3[i].get("v.value");
                CompetitorInfowRec[i].Incumbent_Competitor_Name_4__c=compNames4[i].get("v.value");
                CompetitorInfowRec[i].Incumbent_Competitor_Name_5__c=compNames5[i].get("v.value");
            }
        }
        else
        {
            //alert(component.find('CIComName').get("v.value"))
            CompetitorInfowRec[0].Incumbent_Competitor_Name__c=component.find('CIComName').get("v.value");
            CompetitorInfowRec[0].Incumbent_Competitor_Name_2__c=component.find('CIComName2').get("v.value");
            CompetitorInfowRec[0].Incumbent_Competitor_Name_3__c=component.find('CIComName3').get("v.value");
            CompetitorInfowRec[0].Incumbent_Competitor_Name_4__c=component.find('CIComName4').get("v.value");
            CompetitorInfowRec[0].Incumbent_Competitor_Name_5__c=component.find('CIComName5').get("v.value");
        }
        
        //-===-=-=- calling apex method for update the vales 
        var actionp = component.get('c.updatecominforec');
        
        actionp.setParams({
            "comlist" : component.get("v.CompetitorInfoViewRec")        
        });
        
        actionp.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            //    alert(state)
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                if(component.get("v.viewCompetitorInfo") === true)
                    component.set("v.viewCompetitorInfo",false);
                
                // $A.get('e.force:refreshView').fire();
                
                
               /* var navigateurl='https://drreddysnag--project1.lightning.force.com/lightning/n/Walgreens_View?c__id='+component.get("v.bidId");
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({             
                    "url": navigateurl         
                });         
                urlEvent.fire();*/
                
                 window.history.back();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "The records has been Updated successfully."
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(actionp);
        
        
    },
    scriptsLoaded : function(component, event, helper)
    {
        // console.log('load successfully');
        
        // active/call select2 plugin function after load jQuery and select2 plugin successfully    
        $(".select2Class").select2({
            placeholder: "Choose Competitor"
        });
    },
    saveEditRecord  : function(component, event, helper)
    {
        if(component.get("v.IncumbentCompetitorNameEdit") === true)
            component.set("v.IncumbentCompetitorNameEdit",false);
        
        var CompetitorInfowRec= component.get("v.CompetitorInfoViewRec");
        var index=component.get('v.indexofeditrecord');
        //  alert(index)
        var selectedvalues = $('[id$=picklist]').select2("val");
        //alert('--aaaa---'+selectedvalues)
        if(selectedvalues != null)
        {
            var myJSON = JSON. stringify(selectedvalues);
            var string1=myJSON.replace("[", "");
            var string2=string1.replace("]", "");
            var string3 = string2.split('"').join('');
            //  alert('-----bbbbb----'+string3)
            var compNames=component.find('CIComName');
            var compNames2=component.find('CIComName2');
            var compNames3=component.find('CIComName3');
            var compNames4=component.find('CIComName4');
            var compNames5=component.find('CIComName5');
            //   alert('------cccca---'+compNames)
            // compNames[index].set("v.value",string3);
            //CompetitorInfowRec[index].Incumbent_Competitor_Name_New__c=component.find('CIComName123').get("v.value")+','+string3;
            
        }
        
        /* CompetitorInfowRec[index].Incumbent_Competitor_Name__r.Name=string3;
        CompetitorInfowRec[index].Incumbent_Competitor_Name_2__r.Name=string3;
        CompetitorInfowRec[index].Incumbent_Competitor_Name_3__r.Name=string3;
        CompetitorInfowRec[index].Incumbent_Competitor_Name_4__r.Name=string3;
        CompetitorInfowRec[index].Incumbent_Competitor_Name_5__r.Name=string3;*/
        
        //CompetitorInfowRec[index].Incumbent_Price_Range__c=component.find("editPricerange").get("v.value");
        
        component.set("v.CompetitorInfoViewRec",CompetitorInfowRec);
        
    },
    EditRecord: function(component, event, helper)
    {
        if(component.get("v.IncumbentCompetitorNameEdit") === true)
            component.set("v.IncumbentCompetitorNameEdit",false);
    },
    handleSuccess: function(component, event, helper){
        component.set("v.viewCompetitorInfo",true);
    },
    SelectIncumCompName: function(component, event, helper)
    {
        component.set("v.selectedindex",'');
        var inde=event.getSource().get("v.alternativeText");
        component.set("v.selectedindex",inde);
        // alert(inde)
        component.set("v.openModal",true);
        //***************  calling GetCompetitorNames method for get all GCompetitor Names
        var actioncn = component.get('c.GetCompetitorNames');
        actioncn.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                component.set('v.CompetitorNames',result);
                //for(var i in result)
                //alert(result[i])
            }
        });
        $A.enqueueAction(actioncn);
    },
    handleCloseModal: function(component, event, helper)
    {
        component.set("v.openModal",false);
    },
    SelectedCompName: function(component, event, helper)
    {
        var indexofrec=component.get("v.selectedindex");
        var selectedvalues = $('[id$=picklistval]').select2("val");
        if(selectedvalues != null)
        {
            //alert("1");
            var myJSON = JSON. stringify(selectedvalues);
            var string1=myJSON.replace("[", "");
            var string2=string1.replace("]", "");
            var string3 = string2.split('"').join('');
            var compNames=component.find('Competitorauraid');        
            compNames[indexofrec].set("v.value",string3);
        }
        var IncumbentPriceRange=component.find('IncumbentPriceRangeauraid'); 
        IncumbentPriceRange[indexofrec].set("v.value",component.find('increcprice').get("v.value"));
        component.set("v.openModal",false);
    },
    NumSplCharsCheck: function(component, event, helper){
        var specialKeys = new Array();
        specialKeys.push(8); //Backspace
        specialKeys.push(9); //Tab
        specialKeys.push(32); //Tab
        specialKeys.push(46); //Delete
        specialKeys.push(36); //Home
        specialKeys.push(35); //End
        specialKeys.push(37); //Left
        specialKeys.push(39); //Right
        var keyCode = event.keyCode == 0 ? event.charCode : event.keyCode;
        if ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122) || (specialKeys.indexOf(event.keyCode) != -1 && event.charCode != event.keyCode)){
            alert("Price Range accepts only numbers and special characters. \r\n e.g: +10%, 52.5 - 56.5");
            if (event.preventDefault) {
                event.preventDefault();
            } else { 
                event.returnValue = false;
            } 
        }
    }
    //----code by Rama end  -------
})