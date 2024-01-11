({
	getRollupData : function(component, event, helper) {
		component.set("v.isClicked", false);
        component.set("v.isSpinnerLoad", true); 
        component.set("v.financeApprovalMap",null);
        component.set("v.financeCommentsMap",null);
        var action = component.get("c.getProductFamlilyRollups");
        action.setParams({
            bidId : component.get("v.recordId")
        });
        console.log('recordId---->'+component.get("v.recordId"))
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var dataList = response.getReturnValue();
                if(dataList.length>0){
                    component.set("v.isFinanceApprovePerson",dataList[0].isFinanceApprovePerson);
                    let totalsList = new Array();
                    dataList[0].dataList.forEach(function(eachValue){
                        totalsList.push(0);
                    });
                    dataList.forEach(function(eachWrapper){
                        var i= 0;
                        eachWrapper.dataList.forEach(function(eachValue){
                            if(eachValue != null || eachValue != 'undefined' || eachValue != undefined)
                            	totalsList[i++] +=parseFloat(eachValue);
                        });
                    });
                    component.set("v.TotalsList",totalsList)
                }
                
                component.set("v.rollupData", dataList);
                console.log('dataList-->'+JSON.stringify(dataList));
                component.set("v.isSpinnerLoad", false);
                component.set("v.isFinanceApproved", false);
            }
        })
        $A.enqueueAction(action);
		
	},
    convertArrayOfObjectsToCSV : function(component,objectRecords,template){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        console.log('testing result--->'+JSON.stringify(objectRecords));
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
         // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var selling_unit='1';
        var myMap = new Map();
        myMap.set("Product Family", "productFamilyName");
        myMap.set("Current Bottles", "objectRecords.dataList[0]");
        //myMap.set("Current Doses", "objectRecords.dataList[1]");
        myMap.set("Current Sales", "objectRecords.dataList[2]");
        myMap.set("Current TP Margin $$$", "objectRecords.dataList[3]");
        myMap.set("Current TP Margin %", "objectRecords.dataList[4]");
        myMap.set("Current ASP", "objectRecords.dataList[5]");
        myMap.set("Proposed Bottles", "objectRecords.dataList[6]");
       // myMap.set("Proposed Doses", "objectRecords.dataList[7]");
        myMap.set("Proposed Sales", "objectRecords.dataList[8]");
        myMap.set("Proposed TP Margin $$$", "objectRecords.dataList[9]");
        myMap.set("Proposed TP Margin %", "objectRecords.dataList[10]");
        myMap.set("Proposed ASP", "objectRecords.dataList[11]");
       // myMap.set("Proposed Budget ASP", "objectRecords.dataList[12]");
      //  myMap.set("Proposed % to Budget", "objectRecords.dataList[13]");
        myMap.set("Difference Bottles", "objectRecords.dataList[14]");
       // myMap.set("Difference Doses", "objectRecords.dataList[15]");
        myMap.set("Volume Variance", "objectRecords.dataList[16]");
        myMap.set("Price Variance", "objectRecords.dataList[17]");
        myMap.set("Difference Sales", "objectRecords.dataList[18]");
        myMap.set("Difference Margin", "objectRecords.dataList[19]");
        myMap.set("Difference ASP % Change", "objectRecords.dataList[20]");
        myMap.set("Finance Approval", "financeApproval");
        myMap.set("Finance Comments", "financeComments");
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                //console.log("current test-->"+objectRecords[i]["dataList"][0]);
                if(value=='objectRecords.dataList[0]'){
                    csvStringResult +=  '"'+objectRecords[i]["dataList"][0]+'"';
                   // console.log( "first iffff------->"+csvStringResult);
                }
                else if(value=='objectRecords.dataList[1]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][1]+'"';
                    //console.log( "second iffff------->"+csvStringResult);
                }
                else if(value=='objectRecords.dataList[2]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][2]+'"';
                }
                else if(value=='objectRecords.dataList[3]'){
                    var proposedtpmgdl = objectRecords[i]["dataList"][3];
                   //console.log("proposedtpmgdl--->"+proposedtpmgdl);
                    if(proposedtpmgdl != null){
                    var roundeptpmdl=Math.round(proposedtpmgdl)
                    //console.log("roundeptpmdl--->"+roundeptpmdl);
                    csvStringResult += '"'+roundeptpmdl+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                    //csvStringResult += '"'+ objectRecords[i]["dataList"][3]+'"';
                }
                else if(value=='objectRecords.dataList[4]'){
                    var num=objectRecords[i]["dataList"][4];
                    //console.log("ist round-->"+num);
                    //var round_value=Math.round((num + Number.EPSILON) * 100) / 100
                    var round_value=Math.round(num*100)/100;
                    //console.log("rounded1-->"+round_value);
                    csvStringResult += '"'+round_value+'"';
                }
                else if(value=='objectRecords.dataList[5]'){
                    var num=objectRecords[i]["dataList"][5];
                    //console.log("2nd round-->"+num);
                    //var rounded_value=Math.round((num + Number.EPSILON) * 100) / 100
                   	var rounded_value=Math.round(num*100)/100;
                    //console.log("rounded2-->"+rounded_value);
                    csvStringResult += '"'+rounded_value+'"';
                }
                else if(value=='objectRecords.dataList[6]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][6]+'"';
                }
                else if(value=='objectRecords.dataList[7]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][7]+'"';
                }
                else if(value=='objectRecords.dataList[8]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][8]+'"'
                }
                else if(value=='objectRecords.dataList[9]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][9]+'"';
                }
                else if(value=='objectRecords.dataList[10]'){
                   var proposedmarginper = objectRecords[i]["dataList"][10];
                   //console.log("proposedmarginper--->"+proposedmarginper);
                    if(proposedmarginper != null){
                    var roundeptpmp=Math.round(proposedmarginper*100)/100
                    //console.log("roundeptpmp--->"+roundeptpmp);
                    csvStringResult += '"'+roundeptpmp+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                    //csvStringResult += '"'+ objectRecords[i]["dataList"][10]+'"';
                }
                else if(value=='objectRecords.dataList[11]'){
                    var proposedaspsllu = objectRecords[i]["dataList"][11];
                   console.log("proposedaspsllu--->"+proposedaspsllu);
                    if(proposedaspsllu != null){
                    var roundeproposedaspsllu=Math.round(proposedaspsllu*100)/100
                    console.log("roundeproposedaspsllu--->"+roundeproposedaspsllu);
                    csvStringResult += '"'+roundeproposedaspsllu+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                    //csvStringResult += '"'+ objectRecords[i]["dataList"][11]+'"';
                }
                else if(value=='objectRecords.dataList[12]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][12]+'"';
                }
                else if(value=='objectRecords.dataList[13]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][13]+'"';
                }
                else if(value=='objectRecords.dataList[14]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][14]+'"';
                }
                else if(value=='objectRecords.dataList[15]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][15]+'"';
                }
                else if(value=='objectRecords.dataList[16]'){
                    var volumevariance = objectRecords[i]["dataList"][16];
                   //console.log("volumevariance--->"+volumevariance);
                    if(volumevariance != null){
                    var roundevolumevariance=Math.round(volumevariance)
                    console.log("roundevolumevariance--->"+roundevolumevariance);
                    csvStringResult += '"'+roundevolumevariance+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }

                   // csvStringResult += '"'+ objectRecords[i]["dataList"][16]+'"';
                }
                else if(value=='objectRecords.dataList[17]'){
                    var pricevariance = objectRecords[i]["dataList"][17];
                   //console.log("pricevariance--->"+pricevariance);
                    if(pricevariance != null){
                    var roundepricevariance=Math.round(pricevariance)
                    console.log("roundepricevariance--->"+roundepricevariance);
                    csvStringResult += '"'+roundepricevariance+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }

                   // csvStringResult += '"'+ objectRecords[i]["dataList"][17]+'"';
                }
                else if(value=='objectRecords.dataList[18]'){
                    csvStringResult += '"'+ objectRecords[i]["dataList"][18]+'"';
                }
                else if(value=='objectRecords.dataList[19]'){
                    var differencemargin = objectRecords[i]["dataList"][19];
                   //console.log("differencemargin--->"+differencemargin);
                    if(differencemargin != null){
                    var roundediffmargin=Math.round(differencemargin)
                    console.log("roundediffmargin--->"+roundediffmargin);
                    csvStringResult += '"'+roundediffmargin+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }

                    //csvStringResult += '"'+ objectRecords[i]["dataList"][19]+'"';
                }
                else if(value=='objectRecords.dataList[20]'){
                    var differenceaspper = objectRecords[i]["dataList"][20];
                   //console.log("differenceaspper--->"+differenceaspper);
                    if(differenceaspper != null){
                    var roundediffaspper=Math.round(differenceaspper*100)/100
                    //console.log("roundediffaspper--->"+roundediffaspper);
                    csvStringResult += '"'+roundediffaspper+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                   // csvStringResult += '"'+ objectRecords[i]["dataList"][20]+'"';
                }
                /*if(value=='Phoenix_Proposed_Direct_Selling_Unit__c'){
                    csvStringResult += '"'+selling_unit+'"';
                }*/
                else{
                    if(objectRecords[i][value]==undefined){
                        csvStringResult += '"'+''+'"';
                    }else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                }                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
         
        return csvStringResult;     
    }
})