@istest
public class ChargeBackobjLookupUpdateTest {
    static testmethod void setup(){
        product2 p= new product2();
        p.Name='ABC';
        p.ProductCode='35677';
        insert p;
        account a= new account ();
        a.name='test';
        a.AccountNumber='1234';
        insert a;
        Phoenix_Contract__c cp= new Phoenix_Contract__c();
        cp.Phoenix_Contract_Number__c='1444';
        cp.Phoenix_Contract_Start_Date__c=system.today();
        cp.Phoenix_Contract_End_Date__c=system.today()+365;
        insert cp;
        IDN_Charge_Back__c idn= new IDN_Charge_Back__c();
            idn.contact_id__c='1444';
            idn.Material_Number__c='35677';
        insert idn;
    }
}