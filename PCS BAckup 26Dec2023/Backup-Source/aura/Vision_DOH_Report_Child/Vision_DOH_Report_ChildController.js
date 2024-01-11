({
    doInit: function(component, event, helper){
        var data = component.get("v.accGroupList");
        console.log('data>>'+JSON.stringify(data.GCP_DOH_Trade_Partner_NDC__r));
        //console.log('data.Vision_Segment__c'+data.Vision_Segment__c);
        if(data.Vision_Segment__c=='Rx'){
            component.set('v.minRxDoH',12);
            component.set('v.maxRxDoH',45);
            console.log('maxRXDOh-----'+ component.get('v.maxRxDoH'));
            //component.set('v.minRxSales',45);
        }
        if(data.Vision_Segment__c=='SRx'||data.Vision_Segment__c=='OTC'){
            component.set('v.minSRxDoH',7);
            component.set('v.maxSRxDoH',30);
            console.log('maxSRXDOh-----'+ component.get('v.maxSRxDoH'));
            //component.set('v.minRxSales',45);
            
            
        }
        //console.log('M1-----'+data.sdpfist[0].W1_Day__c);
        //component.set('v.M1String',data.sdpfist[0].W1_Day__c);
        //component.set('v.M2String',data.sdpfist[0].W2_Day__c);
        //component.set('v.M3String',data.sdpfist[0].W3_Day__c);
        //component.set('v.M4String',data.sdpfist[0].W4_Day__c);
    },
    handleClick1: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        component.set("v.productName",pfName);
        
        var data = component.get("v.accGroupList");
        console.log('Data tradepartnerName:: '+JSON.stringify(data));
        if(data.pfName == pfName && data != undefined ){
            console.log('shoe doh')
            data.showPackage = false;
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
          component.set("v.showUserInputs", true);
    },
    handleClick2: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        component.set("v.productName",pfName);
        var data = component.get("v.accGroupList");
        console.log('Data tradepartnerName:: '+JSON.stringify(data));
        if(data.pfName == pfName && data != undefined ){
            console.log('shoe doh --')       
            data.showPackage = true;
            
        }
        component.set("v.accGroupList", data);
        component.set("v.show", true);
       component.set("v.showUserInputs", true);
        
    },
    cancelChanges : function(component, event, helper){
        component.set("v.show", false);
        component.set("v.showUserInputs",false);
    },
    onSave : function(component, event, helper){
        component.set('v.loaded',true);
        var accName = component.get("v.productName");
        var avgSales=component.get("v.avgSalesValue");
        component.set("v.avgSales",avgSales);
        var minRxDoH=component.get("v.minRxDoH");
        var maxRxDoH=component.get("v.maxRxDoH");
        var minSRxDoH=component.get("v.minSRxDoH");
        var maxSRxDoH=component.get("v.maxSRxDoH");
        //var getBidInfoAction = component.get("c.getProdFamData");       
        var selectedId = component.get("v.selectedId");
        component.set("v.minRxDoHValue",minRxDoH);
        component.set("v.maxRxDoHValue",maxRxDoH);
        component.set("v.minSRxDoHValue",minSRxDoH);
        component.set("v.maxSRxDoHValue",maxSRxDoH);
        
        var getBidInfoAction = component.get("c.getProdFamData");
        getBidInfoAction.setParams({          
            tradePartnerName :selectedId,
            Product :accName                               
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded',false);
                component.set("v.show", false);
                component.set("v.showHeader",true);
                component.set("v.showRecords",true);
                var showRecords =   component.get("v.showRecords");
                //event
                var compEvent = component.getEvent("DoHEvent");
                compEvent.setParams({"showRecords" : showRecords });
                compEvent.fire();
                
                var data = component.get("v.accGroupList");
                console.log('Data tradepartnerName:: '+JSON.stringify(data));
                var  pfName= component.get("v.productName");
                if(data.pfName == pfName && data != undefined ){
                    console.log('shoe doh')
                    data.showPackage = false;}
                var responseWrapper=response.getReturnValue();
                
                console.log('response prodfam--->'+JSON.stringify(responseWrapper))
                component.set("v.userProductFamilyDetails", responseWrapper.dohRecords); 
                component.set("v.productFamilyDetails",responseWrapper.dohRecords);
                var resProd=responseWrapper.dohRecords;
                component.set("v.minRxDoHValue",minRxDoH);
                component.set("v.maxRxDoHValue",maxRxDoH);
                console.log('max'+maxRxDoH);
                //code for indicators by srimayee start
                var dohIndicator = false;
                var dohIndicatorEmpty = false;
                var avgSalesIndicator = false;
                if(avgSales == null || avgSales == undefined || avgSales == ''){
                    console.log('avgsales null---- '+avgSales);
                    component.set("v.avgSalesIndicator",false);
                    component.set("v.minAvgSalesdefault",true);
                    component.set("v.avgSales",10000);
                    
                }else{
                    component.set("v.minAvgSalesdefault",false);
                    //component.set("v.avgSalesIndicator",false);
                }
                for(var i=0;i<resProd.length;i++){    
                    console.log('minRxDoH indicator-----'+minRxDoH);
                    console.log('maxRxDoH indicator-----'+maxRxDoH);
                     console.log('segment indicator-----'+resProd[i].segment__c);
                   
					if((resProd[i].segment__c == 'Rx' || resProd[i].segment__c == 'RX') && (resProd[i].W8_DOH__c < minRxDoH || resProd[i].W8_DOH__c > maxRxDoH)){
                     console.log('dohIndicator if Rx ----- '+resProd[i].W8_DOH__c);

                        dohIndicator = true;
                        break;
                    } 
                         if((resProd[i].segment__c == 'SRx' || resProd[i].segment__c == 'OTC' || resProd[i].segment__c == 'SRX' || resProd[i].segment__c == 'otc') && (resProd[i].W8_DOH__c < minSRxDoH || resProd[i].W8_DOH__c > maxSRxDoH)){
                                            console.log('dohIndicator if SRx ----- '+resProd[i].W8_DOH__c);
								dohIndicator = true;
                        break;
                    } 
                     if(resProd[i].W8_DOH__c == null || resProd[i].W8_DOH__c == undefined){
                        dohIndicatorEmpty = true;
                         	dohIndicator = false;
                    }
                }
                for(var i=0;i<resProd.length;i++){    
                    if(resProd[i].Vision_Sum_Average_Sales__c < avgSales){
                        console.log('avgsales inside if-----');
                        avgSalesIndicator = true;
                        break;
                    } 
                }
                component.set("v.dohIndicator",dohIndicator);
                component.set("v.dohIndicatorEmpty",dohIndicatorEmpty);
                component.set("v.avgSalesIndicator",avgSalesIndicator);
                console.log('avgsales eom---- '+component.get("v.avgSales"));
                console.log('avgSalesIndicator onsave====='+avgSalesIndicator);  
                console.log('minAvgSalesdefault onsave====='+component.get("v.minAvgSalesdefault"));
                //code for indicators by srimayee end
            }
            
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    showRecords: function(component, event, helper){
        component.set('v.loaded',true); 
        var getBidInfoAction = component.get("c.getProdFamData");
        var accName = event.getSource().get("v.name");
        var resArray1 = [];
        var resArray2 = [];
        var resArray3 = [];
        var resArray4 = [];
        var resArray5 = [];
        var resArray6 = [];
        var resArray7 = [];
        var resArray8 = [];
        var resArray9 = [];
        var resArray10 = [];
        component.set("v.productName",accName);
        var avgSales=component.get("v.avgSales");
    /*    if(avgSales == undefined || avgSales == null || avgSales == ''){
            avgSales >=0;
            component.set("v.minAvgSalesdefault",true);
            //console.log('avgSales');
            console.log('avgSales310--->'+component.get("v.avgSales"));
        }
        else{
            component.set("v.minAvgSalesdefault",false);
            
        }*/
        /*var qtySold=component.get("v.qtySold");
        if(qtySold == undefined || qtySold == null || qtySold == ''){
           //avgSales >=0;
            component.set("v.qtySolddefault",true);
            //console.log('qtySolddefault');
            console.log('qtySold324--->'+component.get("v.qtySold"));
        }
        else{
            component.set("v.qtySolddefault",false);
            
        }*/
        console.log('accName show records: '+accName);
        var minRxDoH=component.get("v.minRxDoH");
        var maxRxDoH=component.get("v.maxRxDoH");
        var minRxSales=component.get("v.minRxSales");
        var minSRxSales=component.get("v.minSRxSales");
        var maxSRxDoH=component.get("v.maxSRxDoH");
        var minSRxDoH=component.get("v.minSRxDoH");
        var selectedId = component.get("v.selectedId");
        var thresholdMtplr = component.get("v.thresholdMtplr");        
        console.log('selectedId: '+selectedId);
        component.set("v.showHeader",false);
        var avgSales = component.get("v.avgSalesValue");
        
        var getBidInfoAction = component.get("c.getProdFamData");
        console.log('b');
        component.set("v.productFamilyDetails",[]);
        console.log('c');
        
        console.log('d');
        getBidInfoAction.setParams({          
            tradePartnerName :selectedId,
            Product :accName          
        });
        console.log('e');
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('Hi');
            if (actState == 'SUCCESS') {
                component.set("v.showHeader",true);
                
                
                component.set('v.loaded',false);
                //    console.log('Hi');
                var responseWrapper=response.getReturnValue();
                
                console.log('response prodfam--->'+JSON.stringify(responseWrapper))
                component.set("v.productFamilyDetails", responseWrapper.dohRecords); 
                component.set("v.showRecords",true);
                
                var showRecords =   component.get("v.showRecords");
                //event
                var compEvent = component.getEvent("DoHEvent");
                compEvent.setParams({"showRecords" : showRecords });
                compEvent.fire();
                console.log('response prodfam--->'+JSON.stringify(responseWrapper))
                component.set("v.productFamilyDetails", responseWrapper.dohRecords); 
                //    component.set("v.showRecords",true);
                component.set('v.hideIndicators',false);
                var resProd=responseWrapper.dohRecords;
                //  console.log('min->'+resProd[0].W4_DOH__c );
                console.log('min'+minRxDoH);
                console.log('max'+maxRxDoH);
                console.log('resProd'+resProd.length);
                console.log('responseWrapper'+responseWrapper.length);
                console.log('minRX'+minRxDoH);
                console.log('maxRX'+maxRxDoH);
                component.set("v.minRxDoHValue",minRxDoH);
                component.set("v.maxRxDoHValue",maxRxDoH);
                console.log('max'+maxRxDoH);
                component.set("v.minRxDoHValue",component.get("v.minRxDoH"));
                
                console.log('maxSRX'+maxSRxDoH);
                component.set("v.minSRxDoHValue",minSRxDoH);
                component.set("v.maxSRxDoHValue",maxSRxDoH);
                console.log('maxSrX'+maxSRxDoH);
                component.set("v.minSRxDoHValue",component.get("v.minSRxDoH"));
                  var dohIndicator = false;
                var dohIndicatorEmpty = false;
                  var avgSalesIndicator = false
                  if(avgSales == null||avgSales=="undefined"||avgSales==''){
                      component.set("v.minAvgSalesdefault",true);
                  }
                    for(var i=0;i<resProd.length;i++){    
                        console.log('avgsales indicator-----'+avgSales);
                                             console.log('dohIndicator for ----- '+resProd[i].W8_DOH__c);
                                             console.log('dohIndicator minRxDoH ----- '+minRxDoH);
                                             console.log('dohIndicator maxRxDoH ----- '+maxRxDoH);
                                             console.log('dohIndicator minSRxDoH ----- '+minSRxDoH);
                                             console.log('dohIndicator maxSRxDoH ----- '+maxSRxDoH);
                                             console.log('dohIndicator segment ----- '+resProd[i].segment__c);

                    if((resProd[i].segment__c == 'Rx' || resProd[i].segment__c == 'RX') && (resProd[i].W8_DOH__c < minRxDoH || resProd[i].W8_DOH__c > maxRxDoH)){
                     console.log('dohIndicator if Rx ----- '+resProd[i].W8_DOH__c);

                        dohIndicator = true;
                        break;
                    } 
                         if((resProd[i].segment__c == 'SRx' || resProd[i].segment__c == 'OTC' || resProd[i].segment__c == 'SRX' || resProd[i].segment__c == 'otc') && (resProd[i].W8_DOH__c < minSRxDoH || resProd[i].W8_DOH__c > maxSRxDoH)){
                                            console.log('dohIndicator if SRx ----- '+resProd[i].W8_DOH__c);
								dohIndicator = true;
                        break;
                    } 
                         console.log('avgsales if value-----'+resProd[i].Vision_Sum_Average_Sales__c);
                        if(resProd[i].Vision_Sum_Average_Sales__c < avgSales){
                             console.log('avgsales if-----');
                           avgSalesIndicator = true;
                           break;
                           } 
                           if(resProd[i].W8_DOH__c == null || resProd[i].W8_DOH__c == undefined){
                        dohIndicatorEmpty = true;
                         	dohIndicator = false;
                    }
                    }
                component.set("v.dohIndicator",dohIndicator);  
                 component.set("v.dohIndicatorEmpty",dohIndicatorEmpty); 
                component.set("v.avgSalesIndicator",avgSalesIndicator);
                console.log('dohIndicator ----- '+dohIndicator);
                if(resProd.length >0){
                    for(var i=0;i<resProd.length;i++){
                        console.log('min-for>'+resProd[i].W4_DOH__c );
                        /* 
                        if (resProd[i].W4_DOH__c<minRxDoH ||resProd[i].W4_DOH__c<minSRxDoH && resProd[i].W4_DOH__c>maxRxDoH ||resProd[i].W4_DOH__c>maxSRxDoH){
                            component.set("v.minmaxUserDoH",true);
                              component.set("v.minUserDoH",false);
                            component.set("v.minmaxUserDoHValue",component.get("v.minRxDoH"));
                            
                            console.log('minmax')}*/
                        
                        
                        if(resProd[i].W8_DOH__c<=minRxDoH && resProd[i].W8_DOH__c>=maxRxDoH ||resProd[i].W8_DOH__c<=minSRxDoH && resProd[i].W8_DOH__c>=maxSRxDoH){                                                                       
                            //if(resProd[i].W4_DOH__c<=minRxDoH ||resProd[i].W4_DOH__c<=minSRxDoH && resProd[i].W4_DOH__c>=maxRxDoH ||resProd[i].W4_DOH__c>=maxSRxDoH){
                            //component.set("v.minUserDoH",true);
                            //console.log('minUserDoH->'+component.get("v.minUserDoH")) ;
                            console.log('minRxDoH'+ minRxDoH);
                            console.log('max-for>'+resProd[i].W4_DOH__c );
                            resArray1.push(resProd[i]);
                            console.log('resArray1@@@', resArray1);
                            
                        }else{
                            resArray2.push(resProd[i]);
                            console.log('min max')
                            console.log('resArray2@@@', resArray2);
                            
                        }
                        if(resArray2.length >0){
                            component.set("v.minUserDoH",true);
                        }else{
                            component.set("v.minUserDoH",false);
                        }
                        
                        /*if(resProd[i].W4_DOH__c>=maxRxDoH ||resProd[i].W4_DOH__c>=maxSRxDoH ){
                            //component.set("v.minUserDoH",true);
                            console.log('minUserDoH->'+component.get("v.minUserDoH"));
                            
                        resArray3.push(resProd[i]);
                            console.log('resArray3@@@', resArray3);
  
                        }else{
                            resArray4.push(resProd[i]);
                            console.log('resArray4@@@', resArray4);
                            
                        }
                        if(resArray4.length >0){
                            component.set("v.minUserDoH",true);
                        }else{
                             component.set("v.minUserDoH",false);
                        }*/
                        if(avgSales != null){
                            if(resProd[i].Vision_Sum_Average_Sales__c < component.get("v.avgSales")){
                                //component.set("v.minAvgSales",true);
                                console.log('minAvgSales->'+component.get("v.minAvgSales") ) ;
                                resArray7.push(resProd[i]);
                                console.log('resArray7@@@', resArray7);
                                
                            }else{
                                resArray8.push(resProd[i]);
                                console.log('resArray8@@@', resArray8);
                                
                            }
                            if(resArray8.length >0){
                                component.set("v.minAvgSales",true);
                            }else{
                                component.set("v.minAvgSales",false);
                            }
                            if(resProd[i].Vision_Sum_Average_Sales__c > component.get("v.avgSales")){
                                //component.set("v.minAvgSalesdefault",true);  
                                resArray7.push(resProd[i]);
                                console.log('resArray7@@@', resArray7);
                                
                            }else{
                                resArray8.push(resProd[i]);
                                console.log('resArray8@@@@', resArray8);
                                
                            }
                            if(resArray8.length >0){
                                component.set("v.minAvgSalesdefault",true);
                            }else{
                                component.set("v.minAvgSalesdefault",false);
                            } 
                        }
                        
                        if((resProd[i].W1_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W2_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W3_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W4_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W5_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W6_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W7_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W8_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)){
                            //component.set("v.qtySold",false);
                            var qtyCon1 = ((resProd[i].W1_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c))/4)/thresholdMtplr))
                            var qtyCon2 = ((resProd[i].W2_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c))/4)/thresholdMtplr))
                            var qtyCon3 = ((resProd[i].W3_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c))/4)/thresholdMtplr))
                            var qtyCon4 =   ((resProd[i].W4_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c))/4)/thresholdMtplr))
                            console.log('qtyCon1---'+ qtyCon1);
                            console.log('qtyCon2---'+ qtyCon2);
                            console.log('qtyCon3---'+ qtyCon3);
                            console.log('qtyCon4---'+ qtyCon4);
                            console.log('qtySold->'+component.get("v.qtySold") ) ;
                            resArray5.push(resProd[i]);
                            console.log('resArray5@@@', resArray5);
                            component.set("v.qtySold",true);
                            var qtySold=                                                         component.get("v.qtySold");
                            
                            console.log('qtySold'+qtySold);
                            
                            
                        }
                        else if((resProd[i].W1_QTY_Sold__c > (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)||(resProd[i].W2_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)||(resProd[i].W3_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)||(resProd[i].W4_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)||(resProd[i].W5_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)||(resProd[i].W6_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)||(resProd[i].W7_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)||(resProd[i].W8_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))*8)/thresholdMtplr)){
                            component.set("v.qtySold",false);
                            console.log('second');
                            
                            component.set("v.qtySolddefault",true);
                            
                            
                            
                        }
                        /* else{
                                                                                                                 component.set("v.qtySold",true);

                                                         //component.set("v.qtySold",false);
                                                                                    component.set("v.qtySolddefault",false);


                            resArray6.push(resProd[i]);
                            console.log('resArray6@@@', resArray6);
                            
                        }*/
                        /* if(resArray6.length >0){
                            component.set("v.qtySold",false);
                                                        component.set("v.qtySolddefault",false);

                           // qtySolddefault
                        }else{
                             component.set("v.qtySold",true);
                        }*/
                        
                        /* if((resProd[i].W1_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W2_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W3_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr)||(resProd[i].W4_QTY_Sold__c < (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)/thresholdMtplr) &&
                           (resProd[i].W1_QTY_Sold__c >= (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)*thresholdMtplr)||(resProd[i].W2_QTY_Sold__c >= (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)*thresholdMtplr)||(resProd[i].W3_QTY_Sold__c >= (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)*thresholdMtplr)||(resProd[i].W4_QTY_Sold__c >= (((resProd[i].W1_QTY_Sold__c)+(resProd[i].W2_QTY_Sold__c)+(resProd[i].W3_QTY_Sold__c)+(resProd[i].W4_QTY_Sold__c)+(resProd[i].W5_QTY_Sold__c)+(resProd[i].W6_QTY_Sold__c)+(resProd[i].W7_QTY_Sold__c)+(resProd[i].W8_QTY_Sold__c))/8)*thresholdMtplr )){
                          console.log('line 528 ash---');
                            component.set("v.qtySolddefault",false);
                            
                        }else{
                            console.log('line 532- green--');
                            
                            component.set("v.qtySolddefault",true);
                            
                        }  */        
                        
                        
                    }
                }
            }
            
        });
        $A.enqueueAction(getBidInfoAction);
        
        
    },
    hideRecords: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        var data = component.get("v.accGroupList");
        console.log('Data tradepartnerName:: '+JSON.stringify(data));
        if(data.pfName == pfName && data != undefined ){
            console.log('shoe doh --')       
            data.showPackage = true;
            
        }
        component.set("v.accGroupList", data);
        component.set("v.showRecords", false);
        var showRecords =  component.get("v.showRecords");
        var compEvent = component.getEvent("DoHEvent");
        compEvent.setParams({"showRecords" : showRecords });
        compEvent.fire();
        component.set('v.hideIndicators',true);
    },
    
    sortByDOH1: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W1_DOH__c');
    },
    sortByDOH2: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W2_DOH__c');
    },
    sortByDOH3: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W3_DOH__c');
    },
    sortByDOH4: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W4_DOH__c');
    },
    sortByDOH5: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W5_DOH__c');
    },
    sortByDOH6: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W6_DOH__c');
    },
    sortByDOH7: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W7_DOH__c');
    },
    sortByDOH8: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W8_DOH__c');
    },
    sortByQOH1: function(component, event, helper) {
        console.log('inside sortByQOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W1_QOH__c');
    },
    sortByQOH2: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W2_QOH__c');
    },
    sortByQOH3: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W3_QOH__c');
    },
    sortByQOH4: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W4_QOH__c');
    },
    sortByQOH5: function(component, event, helper) {
        console.log('inside sortByQOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W5_QOH__c');
    },
    sortByQOH6: function(component, event, helper) {
        console.log('inside sortByQOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W6_QOH__c');
    },
    sortByQOH7: function(component, event, helper) {
        console.log('inside sortByQOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W7_QOH__c');
    },
    sortByQOH8: function(component, event, helper) {
        console.log('inside sortByQOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'W8_QOH__c');
    },
    sortByDOHredColor: function(component, event, helper) {
        console.log('inside sortByDOh1');
        // component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.onSortRedColor(component, event);
    },
    sortByDOHGreenColor: function(component, event, helper) {
        console.log('inside sortByDOh1');
        // component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.onSortGreenColor(component, event);
    },
    
})