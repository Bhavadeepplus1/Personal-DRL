@istest
public class Vision_IDN_Tab2_Summary_Batch_test {

    public testmethod static void test1(){
           account acc1 = new account(name = 'acc1');
        List<IDN_Charge_Back__c> chargebackrecList = new List<IDN_Charge_Back__c>();
        IDN_Charge_Back__c rec1 = new  IDN_Charge_Back__c();
       rec1.Account__c = '0011K00002UrWG9QAN';
        rec1.Hospital_Name__c = 'University of Wisconsin Health (AKA UW Health)';
        rec1.Child_1__c = 'University Hospital';
        rec1.Child_2__c = 'None';
       	rec1.Sales_Rep_Territory__c = 'Zack McClard';
        rec1.Region__c = 'West';
        rec1.Category__c = 'GPO';
        rec1.revised_product_family__c = 'Thiotepa';
        rec1.material_description__c = 'Thiotepa For Injection 100mg/Vial 1s USA';
        rec1.Contact_Description__c = 'RCA-N';
        rec1.Settlement_Paid_Date__c = system.today();
        chargebackrecList.add(rec1);
        insert chargebackrecList;
      IDN_Charge_Back__c rec2 = new  IDN_Charge_Back__c();
       rec2.Account__c = '0011K00002UrWG9QAN';
        rec2.Hospital_Name__c = 'University of Wisconsin Health (AKA UW Health)';
        rec2.Child_1__c = 'University Hospital';
        rec2.Child_2__c = 'None';
       	rec2.Sales_Rep_Territory__c = 'Zack McClard';
        rec2.Region__c = 'West';
        rec2.Category__c = 'GPO';
        rec2.revised_product_family__c = 'Thiotepa';
        rec2.material_description__c = 'Thiotepa For Injection 100mg/Vial 1s USA';
        rec2.Contact_Description__c = 'RCA-N';
        rec2.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert rec2;
        IDN_Charge_Back_Hospital_Summary__c rec3 = new  IDN_Charge_Back_Hospital_Summary__c();
     
          IDN_Charge_Back_Hospital_Summary__c rec4 = new  IDN_Charge_Back_Hospital_Summary__c();
       rec4.Account__c = '0011K00002UrWG9QAN';
        rec4.Hospital_Name__c = 'University of Wisconsin Health (AKA UW Health)';
        rec4.Child1__c = 'University Hospital1';
        rec4.Child_2__c = 'None';
       	rec4.Sales_Rep_Territory__c = 'Zack McClard';
        rec4.Region__c = 'West';
        rec4.Category__c = 'GPi';
        rec4.revised_product_family__c = 'Thiotepa';
        rec4.material_description__c = 'Thiotepa For Injection 100mg/Vial 1s USA';
        rec4.Contact_Description__c = 'RCA-N';
        rec4.Settlement_Paid_Date__c = system.today().addyears(-1);
        insert rec4;
        test.startTest();
        database.executeBatch(new Vision_IDN_Tab2_Summary_Batch());
        test.stopTest();
    }
    
    public testmethod static void test2(){
           account acc1 = new account(name = 'acc1');
        List<IDN_Charge_Back__c> chargebackrecList = new List<IDN_Charge_Back__c>();
        IDN_Charge_Back__c rec1 = new  IDN_Charge_Back__c();
       rec1.Account__c = '0011K00002UrWG9QAN';
        rec1.Hospital_Name__c = 'University of Wisconsin Health (AKA UW Health)';
        rec1.Child_1__c = 'University Hospital';
        rec1.Child_2__c = 'None';
       	rec1.Sales_Rep_Territory__c = 'Zack McClard';
        rec1.Region__c = 'West';
        rec1.Category__c = 'GPO';
        rec1.revised_product_family__c = 'Thiotepa';
        rec1.material_description__c = 'Thiotepa For Injection 100mg/Vial 1s USA';
        rec1.Contact_Description__c = 'RCA-N';
        rec1.Settlement_Paid_Date__c = system.today();
        chargebackrecList.add(rec1);
          IDN_Charge_Back__c rec2 = new  IDN_Charge_Back__c();
       rec2.Account__c = '0011K00002UrWG9QAN';
        rec2.Hospital_Name__c = 'University of Wisconsin Health (AKA UW Health)';
        rec2.Child_1__c = 'University Hospital';
        rec2.Child_2__c = 'None';
       	rec2.Sales_Rep_Territory__c = 'Zack McClard';
        rec2.Region__c = 'West';
        rec2.Category__c = 'GPO';
        rec2.revised_product_family__c = 'Thiotepa';
        rec2.material_description__c = 'Thiotepa For Injection 100mg/Vial 1s USA';
        rec2.Contact_Description__c = 'RCA-N';
        rec2.Settlement_Paid_Date__c = system.today();
        insert rec2;
        insert chargebackrecList;
          IDN_Charge_Back_Hospital_Summary__c rec4 = new  IDN_Charge_Back_Hospital_Summary__c();
       rec4.Account__c = '0011K00002UrWG9QAN';
        rec4.Hospital_Name__c = 'University of Wisconsin Health (AKA UW Health)';
        rec4.Child1__c = 'University Hospital';
        rec4.Child_2__c = 'None';
       	rec4.Sales_Rep_Territory__c = 'Zack McClard';
        rec4.Region__c = 'West';
        rec4.Category__c = 'GPO';
        rec4.revised_product_family__c = 'Thiotepa';
        rec4.material_description__c = 'Thiotepa For Injection 100mg/Vial 1s USA';
        rec4.Contact_Description__c = 'RCA-N';
        rec4.Settlement_Paid_Date__c = system.today();
        insert rec4;
        
        Vision_IDN_Tab2_Summary_Batch.codecoverageBlock();
        test.startTest();
        database.executeBatch(new Vision_IDN_Tab2_Summary_Batch());
        test.stopTest();
    }
}