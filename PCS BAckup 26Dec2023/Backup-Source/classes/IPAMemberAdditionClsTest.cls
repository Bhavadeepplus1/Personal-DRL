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
@isTest
public class IPAMemberAdditionClsTest {
    static testmethod void IPAMemberAdditionClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Phoenix_Contract__c pc1 = new Phoenix_Contract__c(Name = 'Test Contract1', Phoenix_Contract_Start_Date__c = system.today(), Phoenix_Contract_End_Date__c = system.today() + 10, Phoenix_Is_RCA_Contract__c = true, Phoenix_Contract_Number__c = '1234567', Phoenix_Is_IPA_Contract__c = true);
        insert pc1;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';

        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_RCA_Change_Date__c = system.today();
        insert pb;
        list < Account > accList = new list < Account > ();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_RCA_Agreement__c = pc1.Id, GPO1__c = 'Ahold Indirect Contract', Wholesaler1__c = 'AmerisourceBergen', Wholesaler_DC_1__c = 'Amityville, NY', Street_Address_1__c = 'Madhapur', State__c = 'AK', City__c = 'Hyderabad', Zip__c = '500082');
        Account testAccount1 = new Account(Name = 'Test Account1', Phoenix_RCA_Agreement__c = pc1.Id, GPO1__c = 'Ahold Indirect Contract', Wholesaler1__c = 'AmerisourceBergen', Wholesaler_DC_1__c = 'Amityville, NY');
        Account testAccount2 = new Account(Name = 'Test Account2', Phoenix_RCA_Agreement__c = pc1.Id, GPO1__c = 'Ahold Indirect Contract', Wholesaler1__c = 'AmerisourceBergen', Wholesaler_DC_1__c = 'Amityville, NY');
        accList.add(testAccount);
        accList.add(testAccount1);
        accList.add(testAccount2);
        insert accList;
        Contact con = new Contact(LastName = 'Test', Email = 'suseela+test@gmail.com', Phone = '56784242', Phoenix_Phone_External__c = '75377346');
        insert con;

        IPAMemberAdditionCls.getIPAMemberList(pb.Id);
        IPAMemberAdditionCls.PicklistWrapper pbw = new IPAMemberAdditionCls.PicklistWrapper();
        IPAMemberAdditionCls.PicklistEntryWrapper pbw1 = new IPAMemberAdditionCls.PicklistEntryWrapper();

        list < string > productIds = new list < string > ();
        list < Phoenix_RCA_IPA_LINE__c > rcList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < accList.size(); i++) {


            Phoenix_RCA_IPA_LINE__c rcItem = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id, Phoenix_RCA_Change_Date__c = pb.Phoenix_RCA_Change_Date__c, Phoenix_Customer__c = accList[i].Id, Phoenix_Contact__c = con.Id, Phoenix_Current_GPO__c = accList[i].GPO1__c, Phoenix_Current_Wholesaler__c = accList[i].Wholesaler1__c, Phoenix_RAM__c = accList[i].OwnerId);
            rcList.add(rcItem);



        }
        IPAMemberAdditionCls.saveIPAMembers(rcList, pb);
        IPAMemberAdditionCls.processIPAMember(pb.Id);
        IPAMemberAdditionCls.getIPAmemberInfo(accList[0].Id, con.Id);
        IPAMemberAdditionCls.getDependentPicklist();


    }





}