({
    bidsreset : function(component, event, helper)
    {
        component.set("v.Bidsdisplaylist",'');
        component.set("v.markeitingbooleantwo",true);//table boolean
    },
    
    
    SCMReset  : function(component, event, helper) {
        
        component.set("v.startDate", '');
        component.set("v.endDate", '');
        component.set("v.totalBidsscm", '');
        component.set("v.totalBidsscmlistforexport",'');
        component.set("v.defaultOption",'');
        component.set("v.loadSpinner", false);
    },
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire();
    },
    SCM : function(component,event,helper){
        // component.set("v.loadSpinner", false);
        var date1 = component.get("v.startDate");
        var date2 = component.get("v.endDate");
        console.log('date1 is '+date1+''+'and date2 is '+date2);
        var optvalues = component.get("v.defaultOption");
        if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == '' )
        {
            component.set("v.loadSpinner", false); 
            var message = 'Please choose both Start Date and End Date';
            helper.showErrorToast(component, event, message);       
        } 
        else 
        {
            var action = component.get("c.getSCM");
            action.setParams({
                'startdate': date1,'enddate' : date2,'types' : optvalues
            });   
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=="SUCCESS")
                {
                    console.log('chistory'+state);
                    var result=response.getReturnValue();
                    console.log(' scm result is '+JSON.stringify(result) + 'result length '+result.length);
                    component.set("v.totalBidsscm", result[0]);
                    component.set("v.totalBidsscmlistforexport", result[0]);
                    
                    component.set("v.twodays", result[0].numbers);
                    component.set("v.threetofivedays", result[0].numbers2);
                    component.set("v.greaterfivedays", result[0].numbers3);
                    component.set("v.scmadditiontotal", result[0].scmtotal);
                    component.set("v.scmpercentagetwo", result[0].scmpercentage2);
                    component.set("v.scmpercentagethree", result[0].scmpercentage3);
                    component.set("v.scmpercentagefive", result[0].scmpercentage5);
                    component.set("v.scmpercentagetotal", result[0].scmpercentagetotal);
                    component.set("v.Remainingscmpercentage", result[0].scmBidsremaining);
                    
                    component.set("v.Exportdatalist", result[0]);
                    
                    
                    
                    
                    component.set("v.twodaystotalBidsscmrcdslist",result[0].twodaysscmbidslistwrapper);
                    component.set("v.threedaystotalBidsscmrcdslist",result[0].threedaysscmbidslistwrapper);
                    component.set("v.fivedaystotalBidsscmrcdslist",result[0].fivedaysscmbidslistwrapper);
                    component.set("v.remainingdaystotalBidsscmrcdslist",result[0].remainingdaysscmbidslistwrapper);
                    component.set("v.totalBidsscmrcdslist",result[0].totaldaysscmbidslistwrapper);
                    component.set("v.loadSpinner", false);  
                }
                else 
                {
                    component.set("v.totalBidsscm", '');
                    component.set("v.totalBidsscmlistforexport",'');
                    component.set("v.Exportdatalist", '');
                    
                    component.set("v.twodaystotalBidsscmrcdslist",'');
                    component.set("v.threedaystotalBidsscmrcdslist",'');
                    component.set("v.fivedaystotalBidsscmrcdslist",'')
                    component.set("v.remainingdaystotalBidsscmrcdslist",'')
                    component.set("v.totalBidsscmrcdslist",'');
                    component.set("v.loadSpinner", false);         
                    console.log('Error is coming');
                }
            })
            $A.enqueueAction(action);
        }
    },
    
    DownloadCSV : function(component, event, helper) {
        var exportdata = component.get("v.totalBidsmarketinglistforexport");
        // call the helper function which "return" the CSV data as a String 
        var csv = this.DownloaddataExport(component);   
        if (csv == null){return;} 
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'Bid Efficiency - Time to Complete'+ '-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    DownloaddataExport : function(component) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        csvStringResult = '' ;
        
        var myMap = new Map();
        //myMap.set("Bids", "Marketingnumbers,Marketingnumbers2,Marketingnumbers3,Marketingtotal"); 
        myMap.set("Overall","headers values");
        myMap.set("SCM(Bids)", "Marketingnumbers2");
        myMap.set("SCM(Percentage)", "Marketingnumbers2");
        myMap.set("Marketing(Bids)", "Marketingnumbers");
        myMap.set("Marketing(Percentage)", "Marketingnumbers3");
        myMap.set("Finance(Bids)", "Marketingnumbers");
        myMap.set("Finance(Percentage)", "Marketingnumbers3");
        myMap.set("Contracts(Bids)", "Marketingnumbers");
        myMap.set("Contracts(Percentage)", "Marketingnumbers3");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        var myMap = new Map();
        //myMap.set("Bids", "Marketingnumbers,Marketingnumbers2,Marketingnumbers3,Marketingtotal"); 
        myMap.set("Efficiency level","headers values");
        myMap.set("SCM(Bids)", "Marketingnumbers2");
        myMap.set("SCM(Percentage)", "Marketingnumbers2");
        myMap.set("Marketing(Bids)", "Marketingnumbers");
        myMap.set("Marketing(Percentage)", "Marketingnumbers3");
        myMap.set("Finance(Bids)", "Marketingnumbers");
        myMap.set("Finance(Percentage)", "Marketingnumbers3");
        myMap.set("Contracts(Bids)", "Marketingnumbers");
        myMap.set("Contracts(Percentage)", "Marketingnumbers3");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        csvStringResult += 'Total Incoming Bids'+columnDivider+ component.get("v.scmadditiontotal")+columnDivider+ component.get("v.scmpercentagetotal")+columnDivider+component.get("v.Marketingadditiontotal")+columnDivider+component.get("v.Marketingpercentagetotal")+columnDivider+component.get("v.Financeadditiontotal")+columnDivider+component.get("v.Financepercentagetotal")+columnDivider+component.get("v.Contractsadditiontotal")+columnDivider+ component.get("v.Contractpercentagetotal");  
        csvStringResult += lineDivider;
        csvStringResult += 'Within 2 days from receipt'+columnDivider+ component.get("v.twodays")+columnDivider+ component.get("v.scmpercentagetwo")+columnDivider+component.get("v.Marketingtwodays")+columnDivider+component.get("v.Marketingpercentagetwo")+columnDivider+component.get("v.Financetwodays")+columnDivider+component.get("v.Financepercentagetwo")+columnDivider+component.get("v.Contractstwodays")+columnDivider+ component.get("v.Contractpercentagetwo");  
        csvStringResult += lineDivider; 
        csvStringResult += 'Within 3-5 days from receipt'+columnDivider+ component.get("v.threetofivedays")+columnDivider+ component.get("v.scmpercentagethree")+columnDivider+component.get("v.Marketingthreetofivedays")+columnDivider+component.get("v.Marketingpercentagethree")+columnDivider+component.get("v.Financethreetofivedays")+columnDivider+component.get("v.Financepercentagethree")+columnDivider+component.get("v.Contractsthreetofivedays")+columnDivider+ component.get("v.Contractpercentagethree");   
        csvStringResult += lineDivider;
        csvStringResult += '>5 days from receipt'+columnDivider+component.get("v.greaterfivedays")+columnDivider+component.get("v.scmpercentagefive")+columnDivider+component.get("v.Marketinggreaterfivedays")+columnDivider+component.get("v.Marketingpercentagefive")+columnDivider+component.get("v.Financegreaterfivedays")+columnDivider+component.get("v.Financepercentagefive")+columnDivider+component.get("v.Contractsgreaterfivedays")+columnDivider+ component.get("v.Contractpercentagefive");   
        csvStringResult += lineDivider; 
        csvStringResult += 'Bids'+columnDivider+component.get("v.Remainingscmpercentage")+columnDivider+'N/A'+columnDivider+component.get("v.RemainingMarketingpercentage")+columnDivider+'N/A'+columnDivider+component.get("v.RemainingFinancepercentage")+columnDivider+'N/A'+columnDivider+component.get("v.RemainingContractpercentage")+columnDivider+'N/A';   
        csvStringResult += lineDivider; 
        return csvStringResult;  
    },
    
    DownloadCSV2 : function(component, event, helper) {
        var biddata = component.get("v.Bidsdisplaylist");
        var csv = this.DownloaddataExport2(component,biddata);   
        if (csv == null){return;} 
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'Bid Efficiency - Time to Complete Detail File'+ '-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    DownloaddataExport2 : function(component,objectRecords) 
    {
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            console.log('returning null'+objectRecords.length);
            return null;
        } 
        
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        csvStringResult = '' ;
        
        var myMap = new Map();
        myMap.set("Bid Number","Name");
        myMap.set("Bid Type","Phoenix_Bid_Type__c");
        myMap.set("Approval Status","Phoenix_Approval_Status__c");
        
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++)
        {  
            counter = 0;
            for (let [key, value] of myMap) {
                console.log(' The key is '+key+' The value is '+value);
                if(counter > 0){ 
                    csvStringResult += columnDivider;
                    console.log('Counter > 0'+csvStringResult);
                } 
           
           if(objectRecords[i][value]==undefined || objectRecords[i][value]==null || objectRecords[i][value]==''){
                //  console.log('Iam in last ELSEE if---->');
                csvStringResult += '"' +''+ '"';
            }
                else{
                    csvStringResult += '"' + objectRecords[i][value]+ '"';
                }   
            counter++;
            }
        csvStringResult += lineDivider;
        // csvStringResult += lineDivider;
         }
    
    return csvStringResult;
},
 
 
 MarketingReset : function(component, event, helper) {
    component.set("v.startDate", '');
    component.set("v.endDate", '');
    component.set("v.totalBidsmarketing",'');
    component.set("v.totalBidsmarketinglistforexport",'');
    component.set("v.defaultOption",'');
    component.set("v.loadSpinner", false);
},
    Marketing : function(component, event, helper) {
        var date1 = component.get("v.startDate");
        var date2 = component.get("v.endDate");
        console.log('date1 is '+date1+''+'and date2 is '+date2);
        var optvalues = component.get("v.defaultOption");
        
        if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == '')
        {
            component.set("v.loadSpinner", false); 
            var message = 'Please choose both Start Date and End Date';
            helper.showErrorToast(component, event, message);      
        }  
        else
        {
            var action = component.get("c.getMarketing");
            action.setParams({
                'startdate': date1,'enddate' : date2,'types' : optvalues
            }); 
            action.setCallback(this,function(response){
                var state=response.getState();
                if(state=="SUCCESS")
                {
                    console.log('chistory'+state);
                    var result=response.getReturnValue();
                    component.set("v.totalBidsmarketing",result[0]);  
                    component.set("v.totalBidsmarketinglistforexport",result[0]); 
                    component.set("v.Marketingtwodays", result[0].Marketingnumbers);
                    component.set("v.Marketingthreetofivedays", result[0].Marketingnumbers2);
                    component.set("v.Marketinggreaterfivedays", result[0].Marketingnumbers3);
                    component.set("v.Marketingadditiontotal", result[0].Marketingtotal);
                    component.set("v.Marketingpercentagetwo", result[0].Marketingpercentage2);
                    component.set("v.Marketingpercentagethree", result[0].Marketingpercentage3);
                    component.set("v.Marketingpercentagefive", result[0].Marketingpercentage5);
                    component.set("v.Marketingpercentagetotal", result[0].Marketingpercentagetotal);  
                    component.set("v.RemainingMarketingpercentage", result[0].MarketingBidsremaining); 
                    
                    /*var martwodys = JSON.stringify(result[0]);  
                    console.log('here the data is '+martwodys);*/
                    var listofrcds = result[0].twodaysmarketingbidslistwrapper;
                    component.set("v.totalBidsmarketingrcdslist",result[0].totaldaysmarketingbidslistwrapper);
                    component.set("v.twodaystotalBidsmarketingrcdslist",result[0].twodaysmarketingbidslistwrapper);
                    component.set("v.threedaystotalBidsmarketingrcdslist",result[0].threedaysmarketingbidslistwrapper);
                    component.set("v.fivedaystotalBidsmarketingrcdslist",result[0].fivedaysmarketingbidslistwrapper);
                    component.set("v.remainingdaystotalBidsmarketingrcdslist",result[0].remainingdaysmarketingbidslistwrapper);
                    component.set("v.loadSpinner", false);   
                    /* var martwodys = component.get("v.twodaystotalBidsmarketingrcdslist");  
                    console.log('here the data is '+martwodys.length);*/
                }
                else 
                {
                    component.set("v.totalBidsmarketing",'');
                    component.set("v.totalBidsmarketinglistforexport",'');
                    component.set("v.Exportdatalist",'');  
                    
                    
                    component.set("v.twodaystotalBidsmarketingrcdslist",'');
                    component.set("v.threedaystotalBidsmarketingrcdslist",'');
                    component.set("v.fivedaystotalBidsmarketingrcdslist",'')
                    component.set("v.remainingdaystotalBidsmarketingrcdslist",'')
                    component.set("v.totalBidsmarketingrcdslist",'');
                    
                    component.set("v.markeitingbooleantwo",true);//table boolean
                    component.set("v.loadSpinner", false);         
                    console.log('Error is coming');
                }
            })
            $A.enqueueAction(action);
        }
    },
        
        FinanceReset : function(component, event, helper) {
            
            component.set("v.startDate", '');
            component.set("v.endDate", '');
            component.set("v.totalBidsfinance", '');
            component.set("v.totalBidsfinancelistforexport",'');
            component.set("v.defaultOption",'');
            component.set("v.loadSpinner", false);
            
        },
            
            
            Finance : function(component, event, helper) {
                var date1 = component.get("v.startDate");
                var date2 = component.get("v.endDate");
                console.log('date1 is '+date1+''+'and date2 is '+date2);
                var optvalues = component.get("v.defaultOption");
                
                var action = component.get("c.getFinance");
                if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == '')
                {
                    component.set("v.loadSpinner", false); 
                    var message = 'Please choose both Start Date and End Date';
                    helper.showErrorToast(component, event, message);      
                }  
                else
                {
                    var action = component.get("c.getFinance");
                    
                    action.setParams({
                        'startdate': date1,'enddate' : date2,'types' : optvalues
                    });   
                    action.setCallback(this,function(response){
                        var state=response.getState();
                        if(state=="SUCCESS")
                        {
                            console.log('chistory'+state);
                            var result=response.getReturnValue();
                            component.set("v.totalBidsfinance", result[0]);
                            component.set("v.totalBidsfinancelistforexport", result[0]); 
                            
                            component.set("v.Financetwodays", result[0].Financenumbers);
                            component.set("v.Financethreetofivedays", result[0].Financenumbers2);
                            component.set("v.Financegreaterfivedays", result[0].Financenumbers3);
                            component.set("v.Financeadditiontotal", result[0].Financetotal);
                            component.set("v.Financepercentagetwo", result[0].Financepercentage2);
                            component.set("v.Financepercentagethree", result[0].Financepercentage3);
                            component.set("v.Financepercentagefive", result[0].Financepercentage5);
                            component.set("v.Financepercentagetotal", result[0].Financepercentagetotal);
                            
                            component.set("v.RemainingFinancepercentage",result[0].FinanceBidsremaining);
                            component.set("v.Exportdatalist",result[0]);  
                            
                            
                            component.set("v.twodaystotalBidsfinancercdslist",result[0].twodaysfinancebidslistwrapper);
                            component.set("v.threedaystotalBidsfinancercdslist",result[0].threedaysfinancebidslistwrapper);
                            component.set("v.fivedaystotalBidsfinancercdslist",result[0].fivedaysfinancebidslistwrapper);
                            component.set("v.remainingdaystotalBidsfinancercdslist",result[0].remainingdaysfinancebidslistwrapper);
                            component.set("v.totalBidsfinancercdslist",result[0].totaldaysfinancebidslistwrapper);
                            component.set("v.loadSpinner", false);         
                        }
                        else 
                        {
                            component.set("v.totalBidsfinance", '');
                            component.set("v.totalBidsfinancelistforexport", '');    
                            component.set("v.Exportdatalist",'');  
                            
                            component.set("v.twodaystotalBidsfinancercdslist",'');
                            component.set("v.threedaystotalBidsfinancercdslist",'');
                            component.set("v.fivedaystotalBidsfinancercdslist",'');
                            component.set("v.remainingdaystotalBidsfinancercdslist",'');
                            component.set("v.totalBidsfinancercdslist",'');
                            component.set("v.loadSpinner", false);         
                            console.log('Error is coming');
                        }
                    })
                    $A.enqueueAction(action);	
                }
                
            },
                ContractReset : function(component, event, helper) {
                    
                    component.set("v.startDate", '');
                    component.set("v.endDate", '');
                    component.set("v.totalBidscontracts", '');
                    component.set("v.totalBidscontractslistforexport", '');
                    component.set("v.defaultOption",null);
                    component.set("v.loadSpinner", false);
                },
                    Contract : function(component, event, helper) {
                        //component.set("v.defaultOption", 'Last_12_Months');
                        var date1 = component.get("v.startDate");
                        var date2 = component.get("v.endDate");
                        console.log('date1 is '+date1+''+'and date2 is '+date2);
                        var optvalues = component.get("v.defaultOption");
                        
                        var action = component.get("c.getContract");
                        if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == '')
                        {
                            component.set("v.loadSpinner", false); 
                            var message = 'Please choose both Start Date and End Date';
                            helper.showErrorToast(component, event, message);      
                        }  
                        else
                        {
                            var action = component.get("c.getContract");
                            action.setParams({
                                'startdate': date1,'enddate' : date2,'types' : optvalues
                            });   
                            action.setCallback(this,function(response){
                                var state=response.getState();
                                if(state=="SUCCESS")
                                {
                                    console.log('chistory'+state);
                                    var result=response.getReturnValue();
                                    component.set("v.totalBidscontracts", result[0]);
                                    component.set("v.totalBidscontractslistforexport", result[0]); 
                                    
                                    component.set("v.Contractstwodays", result[0].Contractnumbers);
                                    component.set("v.Contractsthreetofivedays", result[0].Contractnumbers2);
                                    component.set("v.Contractsgreaterfivedays", result[0].Contractnumbers3);
                                    component.set("v.Contractsadditiontotal", result[0].Contracttotal);
                                    component.set("v.Contractpercentagetwo", result[0].Contractpercentage2);
                                    component.set("v.Contractpercentagethree", result[0].Contractpercentage3);
                                    component.set("v.Contractpercentagefive", result[0].Contractpercentage5);
                                    component.set("v.Contractpercentagetotal", result[0].Contractpercentagetotal);
                                    component.set("v.RemainingContractpercentage",result[0].ContractBidsremaining);
                                    
                                    component.set("v.twodaystotalBidscontractrcdslist",result[0].twodayscontractbidslistwrapper);
                                    component.set("v.threedaystotalBidscontractrcdslist",result[0].threedayscontractbidslistwrapper);
                                    component.set("v.fivedaystotalBidscontractrcdslist",result[0].fivedayscontractbidslistwrapper);
                                    component.set("v.remainingdaystotalBidscontractrcdslist",result[0].remainingdayscontractbidslistwrapper);
                                    component.set("v.totalBidscontractrcdslist",result[0].totaldayscontractbidslistwrapper);
                                    component.set("v.loadSpinner", false);         
                                }
                                else 
                                {
                                    component.set("v.totalBidscontracts", '');
                                    component.set("v.totalBidscontractslistforexport",'');   
                                    component.set("v.twodaystotalBidscontractrcdslist",'');
                                    component.set("v.threedaystotalBidscontractrcdslist",'');
                                    component.set("v.fivedaystotalBidscontractrcdslist",'');
                                    component.set("v.remainingdaystotalBidscontractrcdslist",'');
                                    component.set("v.totalBidscontractrcdslist",'');
                                    component.set("v.loadSpinner", false);         
                                    console.log('Error is coming');
                                }
                            })
                            $A.enqueueAction(action);	
                        }
                    }
})