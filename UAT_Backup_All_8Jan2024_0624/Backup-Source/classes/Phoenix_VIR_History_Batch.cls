/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_VIR_History_Batch implements Database.Batchable < sObject > , Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new Phoenix_VIR_History_Batch(), 1000);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
       String query = 'select id, Name from Account WHERE Phoenix_Is_Bid_Account__c=TRUE';
      // String query = 'select id, Name from Account WHERE Id= \'0010m00000iluT0AAI\'';
        system.debug('vir======='+query);
        return Database.getQueryLocator(query);

    }

    public void execute(Database.BatchableContext BC, List < Account > accList) {
        try{
        List < Phoenix_VIR_History__c > newVIRHistoryList = new List < Phoenix_VIR_History__c > ();
        Map < Id, List < Phoenix_Contract__c >> accWithContr = new Map < Id, List < Phoenix_Contract__c >> ();
        Map < Id, List < Phoenix_NPR_Data__c >> accWithNPR = new Map < Id, List < Phoenix_NPR_Data__c >> ();
        Map < Id, Account > accMap = new Map < Id, Account > ();
        for (Account acc: accList) {
            accMap.put(acc.Id, acc);
        }
        List < Phoenix_Contract__c > contrList = [select id, Phoenix_Customer__c, Phoenix_Contract_Number__c from Phoenix_Contract__c where Phoenix_Customer__c =: accMap.keyset()];
        List < Phoenix_NPR_Data__c > nprList = [select id, Name, Phoenix_Account__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Account__c =: accMap.keyset()];

        for (Phoenix_Contract__c npVol: contrList) {
            if (accWithContr.containsKey(npVol.Phoenix_Customer__c)) {
                List < Phoenix_Contract__c > usersId = accWithContr.get(npVol.Phoenix_Customer__c);
             
                usersId.add(npVol);
                accWithContr.put(npVol.Phoenix_Customer__c, usersId);
            } else {
                accWithContr.put(npVol.Phoenix_Customer__c, new List < Phoenix_Contract__c > {
                    npVol
                });
            }
        }



        for (Phoenix_NPR_Data__c npVol: nprList) {
            if (accWithNPR.containsKey(npVol.Phoenix_Account__c)) {
                List < Phoenix_NPR_Data__c > usersId = accWithNPR.get(npVol.Phoenix_Account__c);
                usersId.add(npVol);
                accWithNPR.put(npVol.Phoenix_Account__c, usersId);
            } else {
                accWithNPR.put(npVol.Phoenix_Account__c, new List < Phoenix_NPR_Data__c > {
                    npVol
                });
            }
        }



        for (Account acc: accList) {
            String contractNo = '';
            if (accWithContr.containsKey(acc.Id)) {
                for (Phoenix_Contract__c contract: accWithContr.get(acc.Id)) {
                    if (contract.Phoenix_Contract_Number__c != Null) {
                        contractNo += contract.Phoenix_Contract_Number__c + ',';

                    }
                }
            }

            set < Decimal > grSet = new set < Decimal > ();

            if (accWithNPR.containsKey(acc.Id)) {
                for (Phoenix_NPR_Data__c nprdata: accWithNPR.get(acc.Id)) {
                    if (nprdata.Phoenix_GR_TrackingTier__c != Null) {
                        grSet.add(nprdata.Phoenix_GR_TrackingTier__c);
                    }
                }
            }
            Phoenix_VIR_History__c virHistory = new Phoenix_VIR_History__c();

            virHistory.Account__c = acc.Id;
            virHistory.Date__c = system.today();
            virHistory.Contracts__c = contractNo;
            if (grSet.size() == 1) {
                List < Decimal > GrsList = new List < Decimal > ();
                GrsList.addAll(grSet);
                virHistory.GR_TrackingTier__c = GrsList[0];
            } else {
                List < Decimal > minValue = new List < Decimal > ();
                minValue.addAll(grSet);
                minValue.sort();
                if (minValue.size() > 0)
                    virHistory.GR_TrackingTier__c = minValue[0];
                string remarksValue = '';
                for (Decimal grVal: grSet) {
                    remarksValue += String.valueOf(grVal) + '%,';
                }
                virHistory.Remarks__c = remarksValue;
            }


            newVIRHistoryList.add(virHistory);
        }
        if (!newVIRHistoryList.isEmpty())
            insert newVIRHistoryList;
        }
       Catch(Exception e) {Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_VIR_History_Batch', Phoenix_Error_Message__c=e.getMessage(),Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='execute', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=e.getStackTraceString(),Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;}
    }

    public void finish(Database.BatchableContext BC) {}

}