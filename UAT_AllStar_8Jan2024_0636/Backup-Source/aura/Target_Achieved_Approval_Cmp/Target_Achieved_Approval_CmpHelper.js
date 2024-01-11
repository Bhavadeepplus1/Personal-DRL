({
    approveRejectTarget: function (component, event, helper,comment,status,fieldName) { 
        console.log('helper called--'+status);
        var action = component.get("c.updatestatus");
        action.setParams({
            recordId : component.get("v.recordId"),
            fieldName : fieldName,
            status : status,
            comment : comment
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                console.log('Response-->>' + JSON.stringify(responseWrapper));
                console.log('updatestatus=='+responseWrapper);
                 component.set("v.targetApprovalObj",responseWrapper.targetApp);
               /* var targetApp =response.getReturnValue().targetApp;
                helper.getTargetAppData(component, event, helper,targetApp);
                console.log('status-->'+JSON.stringify(responseWrapper)); 
                
                var daveActivity =response.getReturnValue().daveActivity;
                component.set('v.daveActivity',daveActivity);
                console.log('daveActivity--->>'+daveActivity);
               
                var ericActivity =response.getReturnValue().ericActivity;
                component.set('v.ericActivity',ericActivity);
                console.log('ericActivity--->>'+ericActivity);
               
                var srimayeeActivity =response.getReturnValue().srimayeeActivity;
                console.log('srimayeeActivity--->>'+srimayeeActivity);
                component.set('v.srimayeeActivity',srimayeeActivity);
               
                var milanActivity =response.getReturnValue().milanActivity;
                 component.set('v.milanActivity',milanActivity);
                console.log('milanActivity--->>'+milanActivity);*/
                
                if(status == 'Completed'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message":'Target has been successfully approved.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinnerLoad", false);   
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message":'Target has been successfully rejected.'
                    });
                    toastEvent.fire(); 
                }
                
            }
              else{
                
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
    },
    
    preparePaginationAccepted: function (component, acRecs,historyRecs,pendingRecs) {
        let countTotalPage = Math.ceil(acRecs.length / component.get("v.pageSize"));
        console.log('countTotalPage-->>',countTotalPage);
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        console.log('totalPages-->>',totalPage);
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        component.set("v.totalRecords", acRecs.length);
        this.setPaginateAcceptedData(component);
        
         let countTotalPage2 = Math.ceil(historyRecs.length / component.get("v.pageSize2"));
        let totalPage2 = countTotalPage2 > 0 ? countTotalPage2 : 1;
        component.set("v.totalPages2", totalPage2);
        console.log('totalPages2-->>',totalPage2);
        component.set("v.currentPageNumber2", 1);
        component.set("v.totalRecords2", historyRecs.length);
        this.setPaginateHistoryData(component);
        
         let countTotalPage3 = Math.ceil(pendingRecs.length / component.get("v.pageSize3"));
        let totalPage3 = countTotalPage3 > 0 ? countTotalPage3 : 1;
        component.set("v.totalPages3", totalPage3);
        console.log('totalPages3-->>',totalPage3);
        component.set("v.currentPageNumber3", 1);
        component.set("v.totalRecords3", pendingRecs.length);
        this.setPaginatePendingData(component);
        
        
    },
    setPaginateAcceptedData: function(component){
        let acceptedData = [];
        let pageNumber = component.get("v.currentPageNumber");
        console.log('pageNumber----',pageNumber);
        let pageSize = component.get("v.pageSize");
        console.log('pageSize----',pageSize);
        let accountData = component.get('v.acceptedRecs');
        component.set("v.totalRecs1", accountData.length);
        let currentPageCount = 0;
        let x = (pageNumber - 1) * pageSize;
        console.log('x----',x);
        component.set("v.startIndex1", x+1);
        console.log('startIndex1-->', x+1);
        currentPageCount = x;
        
        for(let j = 0 ; j< accountData.length;j++)
        {
            accountData[j].sno = j+1;
        }
        for (; x < (pageNumber -1) * pageSize +5; x++){
            if (accountData[x]) {
                acceptedData.push(accountData[x]);
                currentPageCount++;
            }
        }
        console.log('currentPageCount----',currentPageCount);
        component.set("v.endIndex1", currentPageCount);
        component.set("v.pagedLineItemsAccepted", acceptedData);
        component.set("v.currentPageRecords", currentPageCount);
    },
    setPaginateHistoryData: function(component){
        let data = [];
        let pageNumber2 = component.get("v.currentPageNumber2");
        let pageSize2 = component.get("v.pageSize2");
        let historyRecs = component.get('v.historyRecs');
        component.set("v.totalRecs3", historyRecs.length);
        let currentPageCount2 = 0;
        let x = (pageNumber2 - 1) * pageSize2;
        component.set("v.startIndex3", x+1);
        currentPageCount2 = x;
        
        for(let j = 0 ; j< historyRecs.length;j++)
        {
            historyRecs[j].sno = j+1;
        }
        for (; x < (pageNumber2 -1) * pageSize2 +5; x++){
            if (historyRecs[x]) {
                data.push(historyRecs[x]);
                currentPageCount2++;
            }
        }
        component.set("v.endIndex3", currentPageCount2);
        component.set("v.pagedLineItemsHistory", data);
        component.set("v.currentPageRecords2", currentPageCount2);
    },
    setPaginatePendingData: function(component){
        let pendingData = [];
        let pageNumber3 = component.get("v.currentPageNumber3");
        console.log('pageNumber3--',pageNumber3);
        let pageSize3 = component.get("v.pageSize3");
         console.log('pageSize3--',pageSize3);
        let pendingRecs = component.get('v.pendingRecs');
        component.set("v.totalRecs4", pendingRecs.length);
        let currentPageCount3 = 0;
        let x = (pageNumber3 - 1) * pageSize3;
        component.set("v.startIndex4", x+1);
        currentPageCount3 = x;
        
        for(let j = 0 ; j< pendingRecs.length;j++)
        {
            pendingRecs[j].sno = j+1;
        }
        
        for (; x < (pageNumber3 -1) * pageSize3 +5; x++){
            if (pendingRecs[x]) {
                pendingData.push(pendingRecs[x]);
                currentPageCount3++;
            }
        }
        console.log('currentPageCount3--',currentPageCount3);
        component.set("v.endIndex4", currentPageCount3);
        component.set("v.pagedLineItemsPending", pendingData);
        component.set("v.currentPageRecords3", currentPageCount3);
    },
    redirectToTarget: function (component, event, helper,accrecordId) {
        var rsmApprover = $A.get("$Label.c.RSM_Head_Approver_Email");
        const rsmEmails = rsmApprover.split(",");
        console.log(rsmEmails);
        console.log('accrecordId---',accrecordId);
        var action = component.get("c.viewTarget");
        action.setParams({
            recordId : accrecordId
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set("v.newScreen",false);
                
                var d =  new Date();
                console.log('current month==>'+Math.floor(d.getMonth()+1))
                var currentMonth = Math.floor(d.getMonth()+1);
                var quarter1 = [4,5,6];
                var quarter2 = [7,8,9];
                var quarter3 = [10,11,12];
                var quarter4 = [1,2,3];
                if(quarter1.includes(currentMonth)){
                    component.set("v.eastQuarter4", true);
                    component.set("v.westQuarter4", true);
                    component.set("v.Q1_in_Progress",true);
                    
                }
                else if(quarter2.includes(currentMonth)){
                    component.set("v.eastQuarter1", true);
                    component.set("v.westQuarter1", true);
                    component.set("v.Q2_in_Progress",true);
                }
                    else if(quarter3.includes(currentMonth)){
                        component.set("v.eastQuarter2", true);
                        component.set("v.westQuarter2", true);
                        component.set("v.Q1_in_Progress",true);
                    }
                        else if(quarter4.includes(currentMonth)){
                            component.set("v.eastQuarter3", true);
                            component.set("v.westQuarter3", true);
                            component.set("v.Q4_in_Progress",true);
                        }
                var responseWrapper=response.getReturnValue();
                 console.log('responseWrapper-->'+JSON.stringify(responseWrapper));
                var eastlistData = responseWrapper.eastlist;
                var westlistData = responseWrapper.westlist;
                
                
                console.log('eastlist-->'+JSON.stringify(eastlistData));
                console.log('westlist-->'+JSON.stringify(westlistData));
                var Q1Total = eastlistData.reduce((sum, record) => sum + (record.quarter_one_Achieved || 0), 0);
                 var Q1Target = eastlistData.reduce((sum, record) => sum + (record.quarter_one_Target || 0), 0);
                 var Q1percentage = (Q1Total != null && Q1Total != 0 && Q1Target != null && Q1Target != 0)? Math.round((parseInt(Q1Total) / parseInt(Q1Target) )*100) :0;
                 
                 var Q2Total = eastlistData.reduce((sum, record) => sum + (record.quarter_two_Achieved || 0), 0);
                 var Q2Target = eastlistData.reduce((sum, record) => sum + (record.quarter_Two_Target || 0), 0);
                 var Q2percentage = (Q2Total != null && Q2Total != 0 && Q2Target != null && Q2Target != 0)? Math.round((parseInt(Q2Total) / parseInt(Q2Target) )*100) :0;
                 
                 
                 var Q3Total = eastlistData.reduce((sum, record) => sum + (record.quarter_three_Achieved || 0), 0);
                 var Q3Target = eastlistData.reduce((sum, record) => sum + (record.quarter_Three_Target || 0), 0);
                 var Q3percentage = (Q3Total != null && Q3Total != 0 && Q3Target != null && Q3Target != 0) ? Math.round((parseInt(Q3Total) / parseInt(Q3Target) )*100) :0;
                 
                 
                 var Q4Total = eastlistData.reduce((sum, record) => sum + (record.quarter_four_Achieved || 0), 0);
                 var Q4Target = eastlistData.reduce((sum, record) => sum + (record.quarter_Four_Target || 0), 0);
                 var Q4percentage = (Q4Total != null && Q4Total != 0 && Q4Target != null && Q4Target != 0)? Math.round((parseInt(Q4Total) / parseInt(Q4Target) )*100) :0;
                 
               
                                  var eric = {
                     
                     Quarter1 : helper.formatRevenue(Q1Total),
                     Quarter2 : helper.formatRevenue(Q2Total),
                     Quarter3 : helper.formatRevenue(Q3Total),
                     Quarter4 : helper.formatRevenue(Q4Total),
                     Target1 : helper.formatRevenue(Q1Target),
                     Target2 : helper.formatRevenue(Q2Target),
                     Target3 : helper.formatRevenue(Q3Target),
                     Target4 : helper.formatRevenue(Q4Target),
                     percentage1 : Q1percentage,
                     percentage2 : Q2percentage,
                     percentage3 : Q3percentage,
                     percentage4 : Q4percentage,
                     
                     
                 };
				  component.set("v.EricSutherland",eric);
                 
                 //console.log('dave smith data is ---> '+JSON.stringify(dave));
                 //console.log('dave smith data is ---> '+component.get("v.DaveSmith"));
                 
                 var customFieldList = eastlistData.map(function(record) {
                     var Q1formatRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                     var Q2formatRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                     var Q3formatRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                     var Q4formatRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                     var AnnualRevenue = helper.formatRevenue(record.annual_Achieved);
                     var T1_formatAchieved = helper.formatRevenue(record.quarter_one_Target);
                     var T2_formatAchieved = helper.formatRevenue(record.quarter_Two_Target);
                     var T3_formatAchieved = helper.formatRevenue(record.quarter_Three_Target);
                     var T4_formatAchieved = helper.formatRevenue(record.quarter_Four_Target);
                     var annualtarget = helper.formatRevenue(record.annual_Target);
                     var Q1percentage = (record.quarter_one_Achieved != null && record.quarter_one_Achieved != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.quarter_one_Achieved) / parseInt(record.quarter_one_Target) )*100) :0;
                     var Q2percentage = (record.quarter_two_Achieved != null && record.quarter_two_Achieved != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.quarter_two_Achieved) / parseInt(record.quarter_Two_Target) )*100) :0;
                     var Q3percentage = (record.quarter_three_Achieved != null && record.quarter_three_Achieved != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target != 0)? Math.round((parseInt(record.quarter_three_Achieved) / parseInt(record.quarter_Three_Target) )*100) :0;
                     var Q4percentage = (record.quarter_four_Achieved != null && record.quarter_four_Achieved != 0 && record.quarter_four_Target != null && record.quarter_four_Target != 0)? Math.round((parseInt(record.quarter_four_Achieved) / parseInt(record.quarter_four_Target) )*100) :0;
                     var annualPercentage = (record.annual_Achieved != null && record.annual_Achieved != 0 && record.annual_Target != null && record.annual_Target != 0) ? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) : 0;
                     var classQ ;
                     if(Q1percentage > 90) classQ = '#579857';
                     else if(Q1percentage >= 50 && Q1percentage < 90) classQ = '#5072F1';
                     else if(Q1percentage < 50) classQ = '#EB4747';
                     else classQ = 'black';
                     console.log('classQ=='+classQ);
                     var color = classQ.replaceAll("^\"|\"$", "");
                     console.log('color=='+color);
                     return {
                         Name : record.salesRepName,
                         Target1: T1_formatAchieved,
                         Target2: T2_formatAchieved,
                         Target3: T3_formatAchieved,
                         Target4: T4_formatAchieved,
                         Q1_Achieved: Q1formatRevenue,
                         Q2_Achieved: Q2formatRevenue,
                         Q3_Achieved: Q3formatRevenue,
                         Q4_Achieved: Q4formatRevenue,
                         percentage_for_Q1 : Q1percentage,
                         percentage_for_Q2 : Q2percentage,
                         percentage_for_Q3 : Q3percentage,
                         percentage_for_Q4 : Q4percentage,
                         annualPercent : annualPercentage,
                         Annual : AnnualRevenue,
                         annualTarget : annualtarget,
                         class1 : '#EB4747',
                         class2 : '#EB4747',
                         class3 : '#EB4747',
                         class4 : '#EB4747',
                         class5 : '#EB4747',
                     };
                 });
                 console.log('test=='+JSON.stringify(customFieldList));
                if(component.get('v.eastQuarter1')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q1 - a.percentage_for_Q1;
                    });
                }
                if(component.get('v.eastQuarter2')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q2 - a.percentage_for_Q2;
                    });
                }
                if(component.get('v.eastQuarter3')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q3 - a.percentage_for_Q3;
                    });
                }
                if(component.get('v.eastQuarter4')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q4 - a.percentage_for_Q4;
                    });
                }
                 component.set("v.EastSalesRepData",customFieldList)
                 var q1_total = 0;
                 for(var i=0;i<westlistData.length; i++){
                     
                     q1_total += i.quarter_one_Achieved;
                 }
                 component.set("v.q1_total",q1_total);
                 console.log('EastSalesRepData==>'+JSON.stringify(component.get("v.EastSalesRepData")))
                 var isasc = component.get("v.isAscAnnual");
                 component.set("v.sortField",'annualPercent');
                 console.log('result in sort by test1'+JSON.stringify(component.get("v.EastSalesRepData")))
                 var region = "West";
                 //lper.initsortBy(component,'annualPercent', helper,isasc,region);
                
                
                 ////***** west Sales Data *///
                 var Q1Total = westlistData.reduce((sum, record) => sum + (record.quarter_one_Achieved || 0), 0);
                 var Q1Target = westlistData.reduce((sum, record) => sum + (record.quarter_one_Target || 0), 0);
                 var Q1percentage = (Q1Total != null && Q1Total != 0 && Q1Target != null && Q1Target != 0)? Math.round((parseInt(Q1Total) / parseInt(Q1Target) )*100) :0;
                 
                 var Q2Total = westlistData.reduce((sum, record) => sum + (record.quarter_two_Achieved || 0), 0);
                 var Q2Target = westlistData.reduce((sum, record) => sum + (record.quarter_Two_Target || 0), 0);
                 var Q2percentage = (Q2Total != null && Q2Total != 0 && Q2Target != null && Q2Target != 0)? Math.round((parseInt(Q2Total) / parseInt(Q2Target) )*100) :0;
                 
                 
                 var Q3Total = westlistData.reduce((sum, record) => sum + (record.quarter_three_Achieved || 0), 0);
                 var Q3Target = westlistData.reduce((sum, record) => sum + (record.quarter_Three_Target || 0), 0);
                 var Q3percentage = (Q3Total != null && Q3Total != 0 && Q3Target != null && Q3Target != 0) ? Math.round((parseInt(Q3Total) / parseInt(Q3Target) )*100) :0;
                 
                 
                 var Q4Total = westlistData.reduce((sum, record) => sum + (record.quarter_four_Achieved || 0), 0);
                 var Q4Target = westlistData.reduce((sum, record) => sum + (record.quarter_Four_Target || 0), 0);
                 var Q4percentage = (Q4Total != null && Q4Total != 0 && Q4Target != null && Q4Target != 0)? Math.round((parseInt(Q4Total) / parseInt(Q4Target) )*100) :0;
                 

                 var dave = {
                     
                     Quarter1 : helper.formatRevenue(Q1Total),
                     Quarter2 : helper.formatRevenue(Q2Total),
                     Quarter3 : helper.formatRevenue(Q3Total),
                     Quarter4 : helper.formatRevenue(Q4Total),
                     Target1 : helper.formatRevenue(Q1Target),
                     Target2 : helper.formatRevenue(Q2Target),
                     Target3 : helper.formatRevenue(Q3Target),
                     Target4 : helper.formatRevenue(Q4Target),
                     percentage1 : Q1percentage,
                     percentage2 : Q2percentage,
                     percentage3 : Q3percentage,
                     percentage4 : Q4percentage,
                     
                    //nnualAchieved : helper.formatRevenue(AnnualTotal),
                   //TargetAchieved : helper.formatRevenue(AnnualTarget),
                    //nnualpercentage : Annualpercentage
                     
                     
                 };
                 component.set("v.DaveSmith",dave);
                 
                 //console.log('dave smith data is ---> '+JSON.stringify(dave));
                 //console.log('dave smith data is ---> '+component.get("v.DaveSmith"));
                 
                 var customFieldList = westlistData.map(function(record) {
                     var Q1formatRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                     var Q2formatRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                     var Q3formatRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                     var Q4formatRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                     var AnnualRevenue = helper.formatRevenue(record.annual_Achieved);
                     var T1_formatAchieved = helper.formatRevenue(record.quarter_one_Target);
                     var T2_formatAchieved = helper.formatRevenue(record.quarter_Two_Target);
                     var T3_formatAchieved = helper.formatRevenue(record.quarter_Three_Target);
                     var T4_formatAchieved = helper.formatRevenue(record.quarter_Four_Target);
                     var annualtarget = helper.formatRevenue(record.annual_Target);
                     var Q1percentage = (record.quarter_one_Achieved != null && record.quarter_one_Achieved != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.quarter_one_Achieved) / parseInt(record.quarter_one_Target) )*100) :0;
                     var Q2percentage = (record.quarter_two_Achieved != null && record.quarter_two_Achieved != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.quarter_two_Achieved) / parseInt(record.quarter_Two_Target) )*100) :0;
                     var Q3percentage = (record.quarter_three_Achieved != null && record.quarter_three_Achieved != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target != 0)? Math.round((parseInt(record.quarter_three_Achieved) / parseInt(record.quarter_Three_Target) )*100) :0;
                     var Q4percentage = (record.quarter_four_Achieved != null && record.quarter_four_Achieved != 0 && record.quarter_four_Target != null && record.quarter_four_Target != 0)? Math.round((parseInt(record.quarter_four_Achieved) / parseInt(record.quarter_four_Target) )*100) :0;
                     var annualPercentage = (record.annual_Achieved != null && record.annual_Achieved != 0 && record.annual_Target != null && record.annual_Target != 0) ? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) : 0;
                     var classQ ;
                     if(Q1percentage > 90) classQ = '#579857';
                     else if(Q1percentage >= 50 && Q1percentage < 90) classQ = '#5072F1';
                     else if(Q1percentage < 50) classQ = '#EB4747';
                     else classQ = 'black';
                     console.log('classQ=='+classQ);
                     var color = classQ.replaceAll("^\"|\"$", "");
                     console.log('color=='+color);
                     return {
                         Name : record.salesRepName,
                         Target1: T1_formatAchieved,
                         Target2: T2_formatAchieved,
                         Target3: T3_formatAchieved,
                         Target4: T4_formatAchieved,
                         Q1_Achieved: Q1formatRevenue,
                         Q2_Achieved: Q2formatRevenue,
                         Q3_Achieved: Q3formatRevenue,
                         Q4_Achieved: Q4formatRevenue,
                         percentage_for_Q1 : Q1percentage,
                         percentage_for_Q2 : Q2percentage,
                         percentage_for_Q3 : Q3percentage,
                         percentage_for_Q4 : Q4percentage,
                         annualPercent : annualPercentage,
                         Annual : AnnualRevenue,
                         annualTarget : annualtarget,
                         class1 : '#EB4747',
                         class2 : '#EB4747',
                         class3 : '#EB4747',
                         class4 : '#EB4747',
                         class5 : '#EB4747',
                     };
                 });
                 console.log('test=='+JSON.stringify(customFieldList));
                  if(component.get('v.westQuarter1')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q1 - a.percentage_for_Q1;
                    });
                }
                if(component.get('v.westQuarter2')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q2 - a.percentage_for_Q2;
                    });
                }
                if(component.get('v.westQuarter3')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q3 - a.percentage_for_Q3;
                    });
                }
                if(component.get('v.westQuarter4')==true){
                    customFieldList.sort(function(a, b) {
                        return b.percentage_for_Q4 - a.percentage_for_Q4;
                    });
                }
                 component.set("v.WestSalesRepData",customFieldList)
                 var q1_total = 0;
                 for(var i=0;i<westlistData.length; i++){
                     
                     q1_total += i.quarter_one_Achieved;
                 }
                 component.set("v.q1_total",q1_total);
                 console.log('WestSalesRepData==>'+JSON.stringify(component.get("v.WestSalesRepData")))
                 var isasc = component.get("v.isAscAnnual");
                 component.set("v.sortField",'annualPercent');
                 console.log('result in sort by test1'+JSON.stringify(component.get("v.EastSalesRepData")))
                 var region = "West";
                //elper.initsortBy(component,'annualPercent', helper,isasc,region);
                
                
                component.set("v.recordId",responseWrapper.targetApp.Id);
                var targetApp =response.getReturnValue().targetApp;
                helper.getTargetAppData(component, event, helper,targetApp);
               
                if(responseWrapper.targetApp.Initiator_Status__c == 'Completed'){
                    component.set("v.targetSubmitted",true);    
                     component.set("v.afterSubmitHideTrName",false); 
                    //component.set("v.disableSubmitButton",true);
                }
                if(responseWrapper.targetApp.Initiator_Status__c == 'In Process'){
                    component.set("v.inProcessBackBtn",true); 
                    component.set("v.afterSubmitHideTrName",true); 
                    component.set("v.disableSubmitButton",false);
                    component.set("v.disableHeadIcon", false);
                    if(targetApp.Head_Target__c > 0){
                        component.set("v.disableIcon", false);
                    }
                    if(targetApp.East_Region_Target__c > 0 ){
                        component.set('v.disableIconEastChild',false);     
                    }
                    if(targetApp.West_Region_Target__c > 0 ){
                        component.set('v.disableIconWestChild',false);     
                    }
                }
                component.set("v.targetScreen",true);
            }
            else{
                console.log('error---'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getTargetAppData: function(component, event, helper,targetApp){
      /*  console.log('targetApp==>'+JSON.stringify(targetApp))
        var testList = [];
        testList.push(targetApp);
        var customFieldList = testList.map(function(record) {
            return {
                Id : record.Id,
                 Head_Target__c : record.Head_Target__c,
                East_Region_Target__c : record.East_Region_Target__c,
                West_Region_Target__c : record.West_Region_Target__c,
                Financial_Year__c : record.Financial_Year__c,
                
                Initiator_Approval_Completed_Time_String__c : record.Initiator_Approval_Completed_Time_String__c,
                Initiator_Approval_Sent_Time_String__c : record.Initiator_Approval_Sent_Time_String__c,
                Initiator_Status__c : record.Initiator_Status__c,
                Intial_Approver__c : record.Intial_Approver__c,
                Initiator_Head_Comments__c : record.Initiator_Head_Comments__c,
               
                Marketing_Head_Approval_Completed_Str__c : record.Marketing_Head_Approval_Completed_Str__c,
                Marketing_Head_Approval_Sent_Time_String__c : record.Marketing_Head_Approval_Sent_Time_String__c,
                Marketing_Head_Comments__c : record.Marketing_Head_Comments__c,
                Marketing_Head_Status__c : record.Marketing_Head_Status__c,
                Marketing_Approver__c : record.Marketing_Approver__c,
               
                Name : record.Name,
                Re_Target__c : record.Re_Target__c,
                
                SRx_Head_Approval_Completed_Time_String__c : record.SRx_Head_Approval_Completed_Time_String__c,
                SRx_Head_Approval_Sent_Time_String__c : record.SRx_Head_Approval_Sent_Time_String__c,
                SRx_Head_Comments__c : record.SRx_Head_Comments__c,
                SRx_Head_Status__c : record.SRx_Head_Status__c,
                SRx_Approver__c : record.SRx_Approver__c,
                
                RSM_Head_Approval_Completed_Time_String__c : record.RSM_Head_Approval_Completed_Time_String__c,
                RSM_Head_Approval_Sent_Time_String__c : record.RSM_Head_Approval_Sent_Time_String__c,
                RSM_Head_Comments__c : record.RSM_Head_Comments__c,
                RSM_Head_Status__c : record.RSM_Head_Status__c,
                RSM_Approver__c : record.RSM_Approver__c,
                
                RSM_West_Approval_Completed_Time_String__c : record.RSM_West_Approval_Completed_Time_String__c,
                RSM_West_Approval_Sent_Time_String__c : record.RSM_West_Approval_Sent_Time_String__c,
                RSM_West_Head_Comments__c : record.RSM_West_Head_Comments__c,
                RSM_West_Head_Status__c : record.RSM_West_Head_Status__c,
                RSM_West_Approver__c : record.RSM_West_Approver__c
                
            };
        });*/
       var daveSmithNm = $A.get("$Label.c.Eric_Sutherland");
        if(targetApp.Intial_Approver__c == daveSmithNm){
            component.set('v.rsmApprover', $A.get("$Label.c.West_Region_email"));
        }else{
            component.set('v.rsmApprover',$A.get("$Label.c.East_region_Email"));  
        }
        console.log('rsmApprover-->'+component.get("v.rsmApprover"));
        component.set("v.targetApprovalObj",targetApp);   
       // console.log('customFieldList-->'+JSON.stringify(component.get("v.targetApprovalObj")));
          component.set("v.isSpinnerLoad", false);
    },
    getEastSalesData: function(component, event, helper,eastSalesData){
        //component.set('v.disableIconEastChild',false);
        var customFieldList = eastSalesData.map(function(record) {
            var Annual__c;
            if(record.Annual__c !=  undefined && record.Annual__c != null){
                Annual__c =helper.formatRevenue(record.Annual__c);
            }
            
            var Quarter_1__c;
            if(record.Quarter_1__c !=  undefined && record.Quarter_1__c != null){
                Quarter_1__c = helper.formatRevenue(record.Quarter_1__c);
            }
            var Quarter_2__c;
            if(record.Quarter_2__c !=  undefined && record.Quarter_2__c != null){
                Quarter_2__c  = helper.formatRevenue(record.Quarter_2__c );
            }
            var Quarter_3__c;
            if(record.Quarter_3__c !=  undefined && record.Quarter_3__c != null){
                Quarter_3__c  = helper.formatRevenue(record.Quarter_3__c );
            }
            var Quarter_4__c;
            if(record.Quarter_4__c !=  undefined && record.Quarter_4__c != null){
                Quarter_4__c  = helper.formatRevenue(record.Quarter_4__c );
            }
            return {
                Id : record.Id,
                Financial_Year__c : record.Financial_Year__c,
                Regional_Manager__c : record.Regional_Manager__c,
                Region__c : record.Region__c,
                SRx_Target__c : record.SRx_Target__c,
                User_Name__c  : record.User_Name__c,
                Quarter_1__str  : Quarter_1__c,
                Quarter_2__str  : Quarter_2__c,
                Quarter_3__str  : Quarter_3__c,
                Quarter_4__str  : Quarter_4__c,
                Quarter_1__c  : record.Quarter_1__c,
                Quarter_2__c  : record.Quarter_2__c,
                Quarter_3__c  : record.Quarter_3__c,
                Quarter_4__c  : record.Quarter_4__c,
                Annual__str  : Annual__c,
                Annual__c  : record.Annual__c
            };
        });
        component.set("v.eastSalesData",customFieldList);   
        console.log('customFieldList-->'+JSON.stringify(component.get("v.eastSalesData"))); 
    },
    getWestSalesData: function(component, event, helper,westSalesData){
        
        var customFieldList = westSalesData.map(function(record) {
            var Annual__c;
            if(record.Annual__c !=  undefined && record.Annual__c != null){
                Annual__c =helper.formatRevenue(record.Annual__c);
            }
            
            var Quarter_1__c;
            if(record.Quarter_1__c !=  undefined && record.Quarter_1__c != null){
                Quarter_1__c = helper.formatRevenue(record.Quarter_1__c);
            }
            var Quarter_2__c;
            if(record.Quarter_2__c !=  undefined && record.Quarter_2__c != null){
                Quarter_2__c  = helper.formatRevenue(record.Quarter_2__c );
            }
            var Quarter_3__c;
            if(record.Quarter_3__c !=  undefined && record.Quarter_3__c != null){
                Quarter_3__c  = helper.formatRevenue(record.Quarter_3__c );
            }
            var Quarter_4__c;
            if(record.Quarter_4__c !=  undefined && record.Quarter_4__c != null){
                Quarter_4__c  = helper.formatRevenue(record.Quarter_4__c );
            }
            return {
                Id : record.Id,
                Financial_Year__c : record.Financial_Year__c,
                Regional_Manager__c : record.Regional_Manager__c,
                Region__c : record.Region__c,
                SRx_Target__c : record.SRx_Target__c,
                User_Name__c  : record.User_Name__c,
                Quarter_1__str  : Quarter_1__c,
                Quarter_2__str  : Quarter_2__c,
                Quarter_3__str  : Quarter_3__c,
                Quarter_4__str  : Quarter_4__c,
                Quarter_1__c  : record.Quarter_1__c,
                Quarter_2__c  : record.Quarter_2__c,
                Quarter_3__c  : record.Quarter_3__c,
                Quarter_4__c  : record.Quarter_4__c,
                Annual__str  : Annual__c,
                Annual__c  : record.Annual__c
                
            };
        });
        component.set("v.westSalesData",customFieldList);   
        console.log('customFieldList-->'+JSON.stringify(component.get("v.westSalesData"))); 
    },
  
    
    formatRevenue: function(annualRevenue) {
        if (annualRevenue >= 1000000) {
            return (annualRevenue / 1000000).toFixed(1) + 'M';
        } else if (annualRevenue >= 1000) {
            return (annualRevenue / 1000).toFixed(1) + 'k';
        } else {
            return annualRevenue;
        }
    },
    updateTableData: function (component, event, helper) {
        component.set("v.isSpinnerLoad", true);
        var action = component.get("c.getRecords");
        action.setCallback(this, function (response) {
            console.log('Response--'+JSON.stringify(response.getReturnValue()));
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                
                var acRecs = response.getReturnValue().acceptedRecs;
                console.log('accRecsList--->>'+JSON.stringify(acRecs));
                for (let i = 0; i < acRecs.length; i++){
                    console.log('50-->>'+acRecs[i].LastModifiedDate);
                    var dateTime = acRecs[i].LastModifiedDate;
                    var dateObject = new Date(dateTime);
                    var utcDate = new Date(dateObject.getUTCFullYear(), dateObject.getUTCMonth(), dateObject.getUTCDate(), 
                                           dateObject.getUTCHours(), dateObject.getUTCMinutes());
                    
                    
                    var formattedDate = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate).replace(/,/g, '');
                    formattedDate += ' EST';
                    
                    console.log('StringTime-->>'+formattedDate);
                    acRecs[i].LastModifiedDate = formattedDate;
                    console.log('acRecs[i].LastModifiedDate-->>'+acRecs[i].LastModifiedDate);
                    
                }
                component.set("v.acceptedRecs",acRecs);
                
                var historyRecs = response.getReturnValue().historyRecs;
                console.log('historyRecs--'+JSON.stringify(historyRecs));
                for (let i = 0; i < historyRecs.length; i++){
                    var dateTime1 = historyRecs[i].LastModifiedDate;
                    var dateObject1 = new Date(dateTime1);
                    var utcDate1 = new Date(dateObject1.getUTCFullYear(), dateObject1.getUTCMonth(), dateObject1.getUTCDate(), 
                                            dateObject1.getUTCHours(), dateObject1.getUTCMinutes());
                    
                    var formattedDate1 = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate1).replace(/,/g, '');
                    formattedDate1 += ' EST';
                    historyRecs[i].LastModifiedDate = formattedDate1;
                }
                
                var draftRecs = response.getReturnValue().draftRecs;
                
                for (let i = 0; i < draftRecs.length; i++){
                    var dateTime2 = draftRecs[i].LastModifiedDate;
                    var dateObject2 = new Date(dateTime2);
                    var utcDate2 = new Date(dateObject2.getUTCFullYear(), dateObject2.getUTCMonth(), dateObject2.getUTCDate(), 
                                            dateObject2.getUTCHours(), dateObject2.getUTCMinutes());
                    
                    
                    var formattedDate2 = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate2).replace(/,/g, '');
                    formattedDate2 += ' EST';
                    console.log('StringTime-->>'+formattedDate2);
                    draftRecs[i].LastModifiedDate = formattedDate2;
                    console.log('acRecs[i].LastModifiedDate-->>'+draftRecs[i].LastModifiedDate);
                }
                
                var pendingRecs = response.getReturnValue().pendingRecs;
                for (let i = 0; i < pendingRecs.length; i++){
                    var dateTime3 = pendingRecs[i].LastModifiedDate;
                    var dateObject3 = new Date(dateTime3);
                    var utcDate3 = new Date(dateObject3.getUTCFullYear(), dateObject3.getUTCMonth(), dateObject3.getUTCDate(), 
                                            dateObject3.getUTCHours(), dateObject3.getUTCMinutes());
                    
                    
                    var formattedDate3 = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate3).replace(/,/g, '');
                    formattedDate3 += ' EST';
                    pendingRecs[i].LastModifiedDate = formattedDate3;
                }
                component.set("v.historyRecs",historyRecs);
                component.set("v.draftRecs",draftRecs);
                component.set("v.pendingRecs",pendingRecs);
                component.set("v.isSpinnerLoad", false);
                helper.preparePaginationAccepted(component, acRecs, historyRecs, pendingRecs);
            }
        });
        $A.enqueueAction(action);
    },
   convertArrayOfObjectsToCSV: function (component, objectRecords) {
        // declare variables
        console.log('convertArrayOfObjectsToCSV called');
        var targetApprovalObj = component.get("v.targetApprovalObj");
        var EricSutherland = component.get("v.EricSutherland");
       var DaveSmith = component.get("v.DaveSmith");
       var EastSalesRepData = component.get("v.EastSalesRepData");
       console.log('EricSutherland=='+JSON.stringify(EricSutherland));
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
       /* if (objectRecords == null || !objectRecords.length) {
            return null;
        }*/
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider = '\n';

        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
       var myMap = new Map();
       myMap.set("Name", "Name");
       myMap.set("Target", "Target2");
       myMap.set("Achieved", "Q2_Achieved");
       myMap.set("%", "percentage_for_Q2");
       

       csvStringResult += Array.from(myMap.keys()).join(columnDivider);
       csvStringResult += lineDivider;
       csvStringResult = 'S.No';
       csvStringResult += columnDivider+'Submission Status'+columnDivider+'Approver'+columnDivider+'Approval Sent Time'+columnDivider+'Approval Completed Time'+columnDivider+'Comments'+lineDivider
       +'1'+columnDivider+'Initial Submission'+columnDivider+'Automatic Bright'+columnDivider+targetApprovalObj.Initiator_Approval_Sent_Time_String__c+columnDivider+targetApprovalObj.Initiator_Approval_Completed_Time_String__c+columnDivider+targetApprovalObj.Initiator_Head_Comments__c+lineDivider
       +'2'+columnDivider+'East RSM'+columnDivider+targetApprovalObj.RSM_Approver__c+columnDivider+targetApprovalObj.RSM_Head_Approval_Sent_Time_String__c+columnDivider+targetApprovalObj.RSM_Head_Approval_Completed_Time_String__c+columnDivider+targetApprovalObj.RSM_Head_Comments__c+lineDivider
       +'3'+columnDivider+'West RSM'+columnDivider+targetApprovalObj.RSM_West_Approver__c+columnDivider+targetApprovalObj.RSM_West_Approval_Sent_Time_String__c+columnDivider+targetApprovalObj.RSM_West_Approval_Completed_Time_String__c+columnDivider+targetApprovalObj.RSM_West_Head_Comments__c+lineDivider
       +'4'+columnDivider+'SRx Head'+columnDivider+targetApprovalObj.SRx_Approver__c+columnDivider+targetApprovalObj.SRx_Head_Approval_Sent_Time_String__c+columnDivider+targetApprovalObj.SRx_Head_Approval_Completed_Time_String__c+columnDivider+targetApprovalObj.SRx_Head_Comments__c+lineDivider
       +'5'+columnDivider+'Marketing Head'+columnDivider+targetApprovalObj.Marketing_Approver__c+columnDivider+targetApprovalObj.Marketing_Head_Approval_Sent_Time_String__c+columnDivider+targetApprovalObj.Marketing_Head_Approval_Completed_Str__c+columnDivider+targetApprovalObj.Marketing_Head_Comments__c+lineDivider+lineDivider+lineDivider+lineDivider+lineDivider
       +'Achievement Summary'+lineDivider
       +'East'+columnDivider+'Target'+columnDivider+'Achieved'+columnDivider+'%'+columnDivider+columnDivider+'West'+columnDivider+'Target'+columnDivider+'Achieved'+columnDivider+'%'+lineDivider
       +'Eric Sutherland'+columnDivider+EricSutherland[0].Target2+columnDivider+EricSutherland[0].Quarter2+columnDivider+EricSutherland[0].percentage2+'%'+columnDivider+columnDivider+'Dave Smith'+columnDivider+DaveSmith[0].Target2+columnDivider+DaveSmith[0].Quarter2+columnDivider+DaveSmith[0].percentage2+lineDivider
       ;
        //new logic start 
           for (var i = 0; i < EastSalesRepData.length; i++) {
                counter = 0;
                for (let [key, value] of myMap) {
                    if (counter > 0) {
                        csvStringResult += columnDivider;
                    }
                    if (EastSalesRepData[i][value] == undefined) {
                        csvStringResult += '"' + '' + '"';
                    } else {
                        csvStringResult += '"' + EastSalesRepData[i][value] + '"';
                    }
                    
                    counter++;
                }
                csvStringResult += lineDivider;
            }   
       console.log('csvStringResult=='+csvStringResult);
        return csvStringResult;
    },

})