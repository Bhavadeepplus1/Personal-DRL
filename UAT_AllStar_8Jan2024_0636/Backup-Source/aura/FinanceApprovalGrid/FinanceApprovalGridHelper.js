/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 30-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   30-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({
    getScmData: function (component, event, helper) {
        var action = component.get("c.getScmData");
        component.set("v.SCMApprovalMap", null);
        component.set("v.SCMApprovalQtyMap", null);
        component.set("v.EstimatedDaysMap", null);
        component.set("v.SCMReJMap", null);
        component.set("v.SCMCommentsMap", null);
        component.set("v.initailOrderVolumeMap", null);
        component.set("v.initailOrderVolumeMap", null);
        component.set("v.isClicked", false);
        component.set("v.isSpinnerLoad", true);
        //component.set("v.isSCMQtyDisadble", true);
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {

                var scmDataList = response.getReturnValue();
                if (scmDataList.length > 0) {
                    component.set("v.isSCMApprovePerson", scmDataList[0].isSCMApprovePerson);
                    /*let scmApprovalIds = component.find("scmApprovalselect");
                    let auraIds = component.find('comment');
                    console.log("scmDataList--->"+JSON.stringify(scmApprovalIds));
                    if(scmApprovalIds != null && scmApprovalIds != 'undefined'){
                        scmApprovalIds.forEach(function(eachInput){
                            console.log('scmAPprovalvalues-->'+JSON.stringify(eachInput))
                            if(auraIds != null && auraIds != 'undefined' &&  eachInput.get("v.value") == 'Y- Only Current Monthly Demand Approved'){
                                auraIds.forEach(function(scmQty){
                                    console.log('scmQTYvalues-->'+scmQty.get("v.value"))
                                    if(scmQty.get("v.name") == eachInput.get("v.name")){
                                        
                                       scmQty.set("v.disabled", true); 
                                    }
                                });
                            }
                        });
                        
                    } */
                }
                component.set("v.scmData", scmDataList);
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);


    },
    convertArrayOfObjectsToCSV: function (component, objectRecords, template) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        console.log('testing result--->' + JSON.stringify(objectRecords));
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider = '\n';
        csvStringResult = '';
        var selling_unit = '1';
        var myMap = new Map();
        myMap.set("SAP Number", "sapNumber");
        myMap.set("Product", "productName");
        myMap.set("Molecule", "productFamily");
        myMap.set("Pkg Size", "casePack");
        myMap.set("Monthly Demand", "monthlyDemand");
        myMap.set("Additonal Requirement", "additionalReq");
        myMap.set("Total Revised Requirement", "totalRevisedReq");
        myMap.set("Dollar Value", "dollarValue");
        myMap.set("SCM Approval (Y/N)", "scmApproval");
        myMap.set("SCM Approved - % of Incremental", "scmAprQtyPercent");
        myMap.set("SCM Approved Qty", "scmAprQty");
        myMap.set("Estimated Lead Time", "estimatedTime");
        myMap.set("SCM Rejection Reason", "scmrejectionReason");
        myMap.set("SCM Comments", "scmcomments");
        myMap.set("Initial Stocking Order Volume", "initialStockingOrderVolume");
        myMap.set("Initial Stocking Order Comments", "initialStockingOrderComments");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                //console.log(JSON.stringify(objectRecords[i]));
                if (value == 'Phoenix_Product__r.Name') {
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Name"] + '"';
                }
                if (value == 'Phoenix_Proposed_Direct_Selling_Unit__c') {
                    csvStringResult += '"' + selling_unit + '"';
                } else {
                    if (objectRecords[i][value] == undefined) {
                        csvStringResult += '"' + '' + '"';
                    } else {
                        csvStringResult += '"' + objectRecords[i][value] + '"';
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