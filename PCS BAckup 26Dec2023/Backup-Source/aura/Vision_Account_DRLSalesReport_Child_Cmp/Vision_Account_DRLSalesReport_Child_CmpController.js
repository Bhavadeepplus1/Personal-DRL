({
    doInit : function(component, event, helper) {
        
        if(component.get("v.isEXTChecked")){
            var singleRec = []; 
         console.log("isEXTChecked==>"+component.get("v.isEXTChecked"))
         if(component.get("v.singleRec") != undefined && component.get("v.singleRec") != null){
              singleRec = component.get("v.singleRec.childSalesList");  
         }
            //var singleRec = component.get("v.singleRec.childSalesList");
           // console.log("singleRec length==>"+singleRec.length)
                       if(singleRec != undefined && singleRec != null && $A.util.isArray(singleRec) && singleRec.length>0){            

            for(var i=0;i<singleRec.length;i++){   
                   console.log('isSalesLessThanZero  out ==>'+singleRec[i].trendingSales);
                 console.log('salesdl==>'+singleRec[i].salesdl)
                if(singleRec[i].salesdl > singleRec[i].SalesDollarPrev){
                   
                    console.log('SalesDollarPrev==>'+singleRec[i].SalesDollarPrev)
                    component.set("v.classS", 'green');
                    singleRec[i].classS = 'green';
                } else if(singleRec[i].salesdl < singleRec[i].SalesDollarPrev){
                    component.set("v.classS", 'red');
                    singleRec[i].classS = 'red';
                } else{
                    component.set("v.classS", 'yellow');
                    singleRec[i].classS = 'yellow';
                }
                if(singleRec[i].units > singleRec[i].UnitsPrev){
                    console.log('units==>'+singleRec[i].units)
                    console.log('UnitsPrev==>'+singleRec[i].UnitsPrev)
                    component.set("v.classV", 'green');
                    singleRec[i].classV = 'green';
                } else if(singleRec[i].units < singleRec[i].UnitsPrev){
                    console.log('in else units==>'+singleRec[i].units)
                    console.log('in else UnitsPrev==>'+singleRec[i].UnitsPrev)
                    component.set("v.classV", 'red');
                    singleRec[i].classV = 'red';
                } else{
                    component.set("v.classV", 'yellow');
                    singleRec[i].classV = 'yellow';
                }
                if(singleRec[i].tptdollar > singleRec[i].TPTDollarPrev){
                    component.set("v.classT", 'green');
                    singleRec[i].classT = 'green';
                } else if(singleRec[i].tptdollar < singleRec[i].TPTDollarPrev){
                    component.set("v.classT", 'red');
                    singleRec[i].classT = 'red';
                } else{
                    component.set("v.classT", 'yellow');
                    singleRec[i].classT = 'yellow';
                }
                if(singleRec[i].tptpct > singleRec[i].TPTPctPrev){
                    component.set("v.classP", 'green');
                    singleRec[i].classP = 'green';
                } else if(singleRec[i].tptpct < singleRec[i].TPTPctPrev){
                    component.set("v.classP", 'red');
                    singleRec[i].classP = 'red';
                } else{
                    component.set("v.classP", 'yellow');
                    singleRec[i].classP = 'yellow';
                }
                if(singleRec[i].trendingSales < 0){
                                          console.log('isSalesLessThanZero   ==>'+singleRec[i].trendingSales);

                    component.set("v.isSalesLessThanZero", true);
                    singleRec[i].isSalesLessThanZero = true;
                }
                if(singleRec[i].trendingVolume < 0){
                      console.log('isUnitsLessThanZero   ==>'+singleRec[i].trendingVolume);
                    component.set("v.isUnitsLessThanZero", true);
                     singleRec[i].isUnitsLessThanZero = true;
                }
                if(singleRec[i].trendingTPT < 0){
                    component.set("v.isTPTLessThanZero", true);
 				singleRec[i].isTPTLessThanZero = true;       
                }
                if(singleRec[i].trendingTPTPercent < 0){
                    component.set("v.isTPTPercentLessThanZero", true);
                     singleRec[i].isTPTPercentLessThanZero = true;
                }
            }
                       }
                    component.set("v.singleRec.childSalesList",singleRec);

        }
        else{
            var singleRec = component.get("v.singleRec");
            if(singleRec.salesdl > singleRec.SalesDollarPrev){
                component.set("v.classS", 'green');
            } else if(singleRec.salesdl < singleRec.SalesDollarPrev){
                component.set("v.classS", 'red');
            } else{
                component.set("v.classS", 'yellow');
            }
            if(singleRec.units > singleRec.UnitsPrev){
                component.set("v.classV", 'green');
            } else if(singleRec.units < singleRec.UnitsPrev){
                component.set("v.classV", 'red');
            } else{
                component.set("v.classV", 'yellow');
            }
            if(singleRec.tptdollar > singleRec.TPTDollarPrev){
                component.set("v.classT", 'green');
            } else if(singleRec.tptdollar < singleRec.TPTDollarPrev){
                component.set("v.classT", 'red');
            } else{
                component.set("v.classT", 'yellow');
            }
            if(singleRec.tptpct > singleRec.TPTPctPrev){
                component.set("v.classP", 'green');
            } else if(singleRec.tptpct < singleRec.TPTPctPrev){
                component.set("v.classP", 'red');
            } else{
                component.set("v.classP", 'yellow');
            }
            if(singleRec.trendingSales < 0){
                component.set("v.isSalesLessThanZero", true);
            }
            if(singleRec.trendingVolume < 0){
                component.set("v.isUnitsLessThanZero", true);
            }
            if(singleRec.trendingTPT < 0){
                component.set("v.isTPTLessThanZero", true);
            }
            if(singleRec.trendingTPTPercent < 0){
                component.set("v.isTPTPercentLessThanZero", true);
            }
        }
    },
    handleClick: function(component, event, helper){
        console.log('Clicked..');
    },
    callParentMethod : function(component, event, helper) {
        //Call Parent aura method
        var parentComponent = component.get("v.parent");                         
        parentComponent.childToParentMethod(component.get("v.singleRec.custId"), component.get("v.rowIndex"));
    },
    redirectToProducts: function(component, event, helper){
        var selectedComparision = component.get("v.comparison");
        var singleRec = component.get("v.singleRec.childSalesList");
        console.log('singleRec.custId--->'+component.get("v.singleRec.custId"));
        console.log('showtpt-->'+component.get("v.isEXTChecked"));
        console.log('single rec json-->'+JSON.stringify(singleRec));
        console.log('custDesc-->'+singleRec.custName);
        console.log('test--->'+event.getSource().get("v.value"))
        var custDescription = event.getSource().get("v.value");
        // var showTPT = component.get("v.isEXTChecked");
        // console.log('shoe tpt page-->'+showTPT);
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__Vision_DRL_Sales_Products_Report'
            },
            state: {
                c__refAccId: component.get("v.singleRec.custId"),
                c__refAccName: component.get("v.singleRec.custName"),
                c__refAccCode: component.get("v.singleRec.custCode"),
                c__refCustDesc: custDescription,
                c__selectedComparision : selectedComparision,
                c__isRxChecked : component.get("v.isRxChecked"),
                c__isSRxChecked : component.get("v.isSRxChecked"),
                c__isOTCChecked : component.get("v.isOtcChecked"),
                c__showTPT : component.get("v.isEXTChecked"),
                c__ShowINT:component.get("v.ShowINT")
                
                
            }
        };
        console.log('ShowINT-->'+component.get("v.isEXTChecked"));
        component.set("v.pageReference", pageReference);
        const navService = component.find('navService');
        const pageRef = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
            const handleError = (error) => {
            console.log(error);
        };
            navService.generateUrl(pageRef).then(handleUrl, handleError);
        },
      sortByCurrentSales: function(component, event, helper) {
          helper.sortHelper(component, event, 'salesdl');
    },       
        })