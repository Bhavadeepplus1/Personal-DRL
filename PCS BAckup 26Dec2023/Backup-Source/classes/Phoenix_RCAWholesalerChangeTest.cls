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
@isTest
public class Phoenix_RCAWholesalerChangeTest {
    static testmethod void RCAWholesalerChangeMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Phoenix_Contract__c pc1 = new Phoenix_Contract__c(Name = 'Test Contract1', Phoenix_Contract_Start_Date__c = system.today(), Phoenix_Contract_End_Date__c = system.today() + 10, Phoenix_Is_RCA_Contract__c = true, Phoenix_Contract_Number__c = '1234567', Phoenix_Is_IPA_Contract__c = true);
        insert pc1;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_RCA_Agreement__c = pc1.Id;
        //pb.Phoenix_Bid_Type__c='RCA/IPA Member GPO or Wholesaler Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_RCA_Change_Date__c = system.today();
        insert pb;
        list < Account > accList = new list < Account > ();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_RCA_Agreement__c = pc1.Id, GPO1__c = 'Ahold Indirect Contract', Wholesaler1__c = 'AmerisourceBergen', Wholesaler_DC_1__c = 'Amityville, NY');
        Account testAccount1 = new Account(Name = 'Test Account1', Phoenix_RCA_Agreement__c = pc1.Id, GPO1__c = 'Ahold Indirect Contract', Wholesaler1__c = 'AmerisourceBergen', Wholesaler_DC_1__c = 'Amityville, NY');
        Account testAccount2 = new Account(Name = 'Test Account2', Phoenix_RCA_Agreement__c = pc1.Id, GPO1__c = 'Ahold Indirect Contract', Wholesaler1__c = 'AmerisourceBergen', Wholesaler_DC_1__c = 'Amityville, NY');
        accList.add(testAccount);
        accList.add(testAccount1);
        accList.add(testAccount2);
        insert accList;





        Phoenix_RCAWholesalerChange.getRCAContracts(pb.Id);



        Phoenix_RCAWholesalerChange.PicklistWrapper pbw = new Phoenix_RCAWholesalerChange.PicklistWrapper();
        Phoenix_RCAWholesalerChange.PicklistEntryWrapper pbw1 = new Phoenix_RCAWholesalerChange.PicklistEntryWrapper();
        list < Phoenix_RCAWholesalerChange.Wrapper > wrap = new list < Phoenix_RCAWholesalerChange.Wrapper > ();
        list < string > productIds = new list < string > ();
        list < Phoenix_RCA_IPA_LINE__c > rcList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < accList.size(); i++) {


            Phoenix_RCA_IPA_LINE__c rcItem = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id, Phoenix_RCA_Change_Date__c = pb.Phoenix_RCA_Change_Date__c, Phoenix_RCA_Agreement__c = accList[i].Phoenix_RCA_Agreement__c, Phoenix_Customer__c = accList[i].Id, Phoenix_Current_GPO__c = accList[i].GPO1__c, Phoenix_Current_Wholesaler__c = accList[i].Wholesaler1__c, Phoenix_RAM__c = accList[i].OwnerId);


            rcList.add(rcItem);



        }
        Phoenix_RCAWholesalerChange.saveRCAMembers(rcList);
        Phoenix_RCAWholesalerChange.processRCALine(pb.Id);
        Phoenix_RCAWholesalerChange.getRCAmemberInfo(accList[0].Id,accList[0].Id);
        Phoenix_RCAWholesalerChange.getDependentPicklist();


        Phoenix_Contract__c pc2 = new Phoenix_Contract__c(Name = 'Test Contract1', Phoenix_Contract_Start_Date__c = system.today(), Phoenix_Contract_End_Date__c = system.today() + 10, Phoenix_Is_RCA_Contract__c = true, Phoenix_Contract_Number__c = '1234567', Phoenix_Is_IPA_Contract__c = true);
        insert pc2;
        pb.Phoenix_RCA_Agreement__c = pc2.Id;
        update pb;
        Phoenix_RCAWholesalerChange.getRCAContracts(pb.Id);
    }


}