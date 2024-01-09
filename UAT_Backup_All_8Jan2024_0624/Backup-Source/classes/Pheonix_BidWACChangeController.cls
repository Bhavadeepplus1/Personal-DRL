/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
public class Pheonix_BidWACChangeController {
    public static Phoenix_Bid__c bid;

    static {
        bid = new Phoenix_Bid__c();
    }

    public Pheonix_BidWACChangeController() {

    }

    @AuraEnabled
    public static Phoenix_BidWACCreatorCtrl.BidWrapper getBidInfo(String bidId) {
        return Phoenix_BidWACCreatorCtrl.getbidInfo(bidId);
    }
    @AuraEnabled
    public static List < Phoenix_BidWACCreatorCtrl.wrapperClass > getproductsrelatedtoBid(Phoenix_BidWACCreatorCtrl.BidWrapper quotewrap) {
        return Phoenix_BidWACCreatorCtrl.getproductsrelatedtoBid(quotewrap);
    }

    @AuraEnabled
    public static list < Phoenix_BidWACCreatorCtrl.wrapperClass > getSearch(List < Phoenix_BidWACCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, Phoenix_BidWACCreatorCtrl.BidWrapper quotewrap) {
        return Phoenix_BidWACCreatorCtrl.getSearch(pItem, SearchKeyWordPD, search, family, RxSrxList, quotewrap);
    }
    @AuraEnabled
    public static list < Phoenix_BidWACCreatorCtrl.wrapperClass > getsearchDirectorResult(List < Phoenix_BidWACCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string Family, string searchName, list < string > RxSrxList, Phoenix_BidWACCreatorCtrl.BidWrapper quotewrap) {
        return Phoenix_BidWACCreatorCtrl.getsearchDirectorResult(pItem, SearchKeyWordPD, Family, searchName, RxSrxList, quotewrap);
    }

    @AuraEnabled
    public static list < Phoenix_BidWACCreatorCtrl.wrapperClass > getSearchFamily(List < Phoenix_BidWACCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string searchName, list < string > RxSrxList, Phoenix_BidWACCreatorCtrl.BidWrapper quotewrap) {
        return Phoenix_BidWACCreatorCtrl.getSearchFamily(pItem, SearchKeyWordPD, search, searchName, RxSrxList, quotewrap);
    }

    @AuraEnabled
    public static List < Phoenix_BidWACCreatorCtrl.wrapperClass > getproducts1(Phoenix_BidWACCreatorCtrl.BidWrapper quotewrap) {
        return Phoenix_BidWACCreatorCtrl.getproducts1(quotewrap);
    }
    @AuraEnabled
    public static List < Phoenix_BidWACCreatorCtrl.wrapperClass > showselectedProducts(string bidId) {
        return Phoenix_BidWACCreatorCtrl.showselectedProducts(bidId);
    }
    @AuraEnabled
    public static List < string > getProductDirectorList(Phoenix_BidWACCreatorCtrl.BidWrapper bidwrap) {
        return Phoenix_BidWACCreatorCtrl.getProductDirectorList(bidwrap);
    }

    @AuraEnabled
    public static list < Phoenix_BidWACCreatorCtrl.wrapperClass > fetchSortResults(string sortField, boolean isAsc, List < Phoenix_BidWACCreatorCtrl.wrapperClass > productList) {
        return Phoenix_BidWACCreatorCtrl.fetchSortResults(sortField, isAsc, productList);
    }

    @AuraEnabled
    public static list < Phoenix_BidWACCreatorCtrl.wrapperClass > findBySrxOtc(list < string > searchKey, list < string > SearchKeyWordPD, string searchName, string family, List < Phoenix_BidWACCreatorCtrl.wrapperClass > productList, Phoenix_BidWACCreatorCtrl.BidWrapper quotewrap) {
        return Phoenix_BidWACCreatorCtrl.findBySrxOtc(searchKey, SearchKeyWordPD, searchName, family, productList, quotewrap);
    }

    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > saveQuoteItems(list < Phoenix_BidWACCreatorCtrl.wrapperClass > saveitems, Phoenix_BidWACCreatorCtrl.BidWrapper bidWrapper) {
        return Phoenix_BidWACCreatorCtrl.saveQuoteItems(saveitems, bidWrapper);
    }

    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > editQuoteItems(list < Phoenix_BidWACCreatorCtrl.wrapperClass > saveitems, Phoenix_BidWACCreatorCtrl.BidWrapper bidWrapper, Date effDt) {
        return Phoenix_BidWACCreatorCtrl.editQuoteItems(saveitems, bidWrapper, effDt);
    }
    @AuraEnabled
    public static void deleteLineItems(String LineItemId){
        if (LineItemId != null) {
            Phoenix_Bid_Line_Item__c deletedLineItem = [SELECT Id, Phoenix_Bid__c FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    @AuraEnabled
    public static List < ContentDocumentLink > getDocs(String bidId) {
        Phoenix_Bid__c bidRec = [select Id FROM Phoenix_Bid__c where id =: bidId];
        return [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidRec.Id];
    }
    @AuraEnabled
    public static void deleteAttachments(String LineItemId, String bidId) {
        List < ContentDocument > contentDocumentIds = [select Id from ContentDocument WHERE Id =: LineItemId];
        delete contentDocumentIds;

    }

    @AuraEnabled
    public static void makeApprovalsBusiness(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if (stepMap.get(stepNo) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo, adededSteps);
            } else {
                stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            String stepName = step.Phoenix_Approver_Team__c;
            System.debug('-----------stepName------' + stepName);
            if (stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            stepnameNoMap.put(stepName, stepNo);
        }
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(3);
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = stepMap.get(4);
        List < Phoenix_Bid_Process_Steps__c > nextSteps3 = stepMap.get(5);
        List < Phoenix_Bid_Process_Steps__c > nextSteps4 = stepMap.get(6);
        if (financeAppStatus == 'Approved') {
            System.debug('----------financeAppStatus---------'+financeAppStatus);
            if (currentStep != null) {
                System.debug('-------updateProcessStep.Phoenix_Status__c-' + currentStep.Phoenix_Status__c);
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
                System.debug('----------financeAppStatus--------2-'+financeAppStatus);
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Country Head';
            update bidCurrent;
        } else if (financeAppStatus == 'Not Approved') {
            
            System.debug('----------financeAppStatus-------3--'+financeAppStatus);
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                System.debug('----------financeAppStatus-----4----'+financeAppStatus);
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps2) {
                System.debug('----------financeAppStatus---5------'+financeAppStatus);
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps3) {
                System.debug('----------financeAppStatus-----6----'+financeAppStatus);
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps4) {
                System.debug('----------financeAppStatus---7------'+financeAppStatus);
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            if (!nextSteps3.isEmpty()) {
                update nextSteps3;
            }
            if (!nextSteps4.isEmpty()) {
                update nextSteps4;
            }
            
            bidCurrent.Phoenix_Approval_Status__c = 'Business Head Rejected';
            update bidCurrent;
            
        } else {
            
        }
    }
    
    @AuraEnabled
    public static void makeApprovalsCountry(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if (stepMap.get(stepNo) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo, adededSteps);
            } else {
                stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            String stepName = step.Phoenix_Approver_Team__c;
            System.debug('-----------stepName------' + stepName);
            if (stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            stepnameNoMap.put(stepName, stepNo);
        }
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(4);
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = stepMap.get(5);
        List < Phoenix_Bid_Process_Steps__c > nextSteps3 = stepMap.get(6);
        if (financeAppStatus == 'Approved') {
            if (currentStep != null) {
                System.debug('-------updateProcessStep.Phoenix_Status__c-' + currentStep.Phoenix_Status__c);
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Finance';
            update bidCurrent;
        } else if (financeAppStatus == 'Not Approved') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps2) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps3) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            if (!nextSteps3.isEmpty()) {
                update nextSteps3;
            }
            
            
            bidCurrent.Phoenix_Approval_Status__c = 'Country Head Rejected';
            update bidCurrent;
            
        } else {
            
        }
    }
    
    
    
    @AuraEnabled
    public static void makeApprovalsFinance(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if (stepMap.get(stepNo) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo, adededSteps);
            } else {
                stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            String stepName = step.Phoenix_Approver_Team__c;
            System.debug('-----------stepName------' + stepName);
            if (stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            stepnameNoMap.put(stepName, stepNo);
        }
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(5);
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = stepMap.get(6);
        if (financeAppStatus == 'Approved') {
            if (currentStep != null) {
                System.debug('-------updateProcessStep.Phoenix_Status__c-' + currentStep.Phoenix_Status__c);
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Contracts';
            update bidCurrent;
        } else if (financeAppStatus == 'Not Approved') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps2) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            
            
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            
            bidCurrent.Phoenix_Approval_Status__c = 'Finance Rejected';
            update bidCurrent;
            
        } else {
            
        }
    }
    
    @AuraEnabled
    public static void makeApprovalsContracts(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if (stepMap.get(stepNo) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo, adededSteps);
            } else {
                stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            String stepName = step.Phoenix_Approver_Team__c;
            System.debug('-----------stepName------' + stepName);
            if (stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            stepnameNoMap.put(stepName, stepNo);
        }
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(6);
        if (financeAppStatus == 'Processed') {
            if (currentStep != null) {
                System.debug('-------updateProcessStep.Phoenix_Status__c-' + currentStep.Phoenix_Status__c);
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Completed'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Closed';
            update bidCurrent;
        } else if (financeAppStatus == 'Not_Processed') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Contracts Rejected';
            update bidCurrent;
        } else {
            
        }
    }
    @AuraEnabled
    public static void saveToBidBus(string bidId, String busStatus, String busCom) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Business_Approval__c = busStatus;
        bidRecord.Phoenix_Business_Approval_Comments__c = busCom;
        update bidRecord;
    }
    @AuraEnabled
    public static void saveToBidCountry(string bidId, String countryStatus, String countryCom) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Country_Head_Approval__c = countryStatus;
        bidRecord.Phoenix_Country_Head_Comments__c = countryCom;
        update bidRecord;
    }
    @AuraEnabled
    public static void saveToBidContr(string bidId, String contrStatus, String contrCom) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Contracts_Approval__c = contrStatus;
        bidRecord.Phoenix_Contracts_Approval_Comments__c = contrCom;
        update bidRecord;
    }
    @AuraEnabled
    public static void saveToBidFin(string bidId, String finStatus, String finCom) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Finance_Approval__c, Phoenix_Finance_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Finance_Approval__c = finStatus;
        bidRecord.Phoenix_Finance_Approval_Comments__c = finCom;
        update bidRecord;
    }
}