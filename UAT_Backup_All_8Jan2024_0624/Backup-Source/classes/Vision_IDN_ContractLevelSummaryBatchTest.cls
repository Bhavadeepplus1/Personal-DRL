@isTest
public class Vision_IDN_ContractLevelSummaryBatchTest {
	static testmethod void testMethod1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
        Product2 pro=new Product2(Name='Test',Family='Carboprost');
        insert pro;
        Product2 pro1=new Product2(Name='Test1',Family='Carboprost');
        insert pro1;
         Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = acc1.Id;
        insert ctr;
        IDN_Charge_Back__c chargeback = new IDN_Charge_Back__c();
        chargeback.Account__c = acc1.Id;
        chargeback.Sales_Rep_Territory__c ='Zachary McClard';
        chargeback.Hospital_Name__c ='Advocate Aurora Health ';
        //chargeback.Child1__c = '4740';
        chargeback.Child_2__c = '1127';
        chargeback.Contract__c= ctr.id;
        chargeback.Child1_Name__c ='Advocate Health Care';
        chargeback.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback.revised_product_family__c = 'Carboprost';
        chargeback.material_description__c = 'Zoledronic Acid Injection 5mg/100ml USA';
        chargeback.Contact_Description__c = 'PREMIERPP BASE';
        chargeback.Region__c = 'East';
        chargeback.Category__c = 'GPO';
        chargeback.Member_State__c = 'IA';
        chargeback.member_city__c = 'ADA';
        chargeback.Submitter_Name__c = 'Anda, Inc.';
        chargeback.Contract_Sales_Indirect_Price__c = 123.45;
        chargeback.contract_units_paid_qty__c = 100;
        chargeback.Material_Number__c = '300019237';
        chargeback.contact_id__c = '3000000224';
        chargeback.Settlement_Paid_Date__c = system.today()-475;
         insert chargeback;
     
        IDN_Charge_Back__c chargeback2 =  new IDN_Charge_Back__c();
       
        chargeback2.Account__c = acc1.Id;
        chargeback2.Sales_Rep_Territory__c ='Zachary McClard';
        chargeback2.Hospital_Name__c ='Advocate Aurora Health ';
        //chargeback.Child1__c = '4740';
        chargeback2.Child_2__c = '1127';
        chargeback2.Contract__c= ctr.id;
        chargeback2.Child1_Name__c ='Advocate Health Care';
        chargeback2.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback2.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback2.revised_product_family__c = 'Carboprost';
        chargeback2.material_description__c = 'Zoledronic Acid Injection 5mg/100ml USA';
        chargeback2.Contact_Description__c = 'PREMIERPP BASE';
        chargeback2.Region__c = 'East';
        chargeback2.Category__c = 'GPO';
        chargeback2.Member_State__c = 'IA';
        chargeback2.member_city__c = 'ADA';
        chargeback2.Submitter_Name__c = 'Anda, Inc.';
        chargeback2.Contract_Sales_Indirect_Price__c = 123.45;
        chargeback2.contract_units_paid_qty__c = 100;
        chargeback2.Material_Number__c = '300019237';
        chargeback2.contact_id__c = '3000000224';
        chargeback2.Settlement_Paid_Date__c = system.today().addmonths(-1)-475;
         insert chargeback2;
      
  //   Vision_IDN_ContractLevel_Summary_Batch.codecoverageBlock();
         Test.startTest();
        Database.executeBatch(new Vision_IDN_ContractLevel_Summary_Batch(), 5);
        Test.stopTest();   
        
    }
  static testmethod void testMethod2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
        Product2 pro=new Product2(Name='Test',Family='Carboprost');
        insert pro;
        Product2 pro1=new Product2(Name='Test1',Family='Carboprost');
        insert pro1;
         Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = acc1.Id;
        insert ctr;
        IDN_Charge_Back__c chargeback = new IDN_Charge_Back__c();
        chargeback.Account__c = acc1.Id;
        chargeback.Sales_Rep_Territory__c ='Zachary McClard';
        chargeback.Hospital_Name__c ='Advocate Aurora Health ';
        //chargeback.Child1__c = '4740';
        chargeback.Child_2__c = '1127';
        chargeback.Contract__c= ctr.id;
        chargeback.Child1_Name__c ='Advocate Health Care';
        chargeback.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback.revised_product_family__c = 'Carboprost';
        chargeback.material_description__c = 'Zoledronic Acid Injection 5mg/100ml USA';
        chargeback.Contact_Description__c = 'PREMIERPP BASE';
        chargeback.Region__c = 'East';
        chargeback.Category__c = 'GPO';
        chargeback.Member_State__c = 'IA';
        chargeback.member_city__c = 'ADA';
        chargeback.Submitter_Name__c = 'Anda, Inc.';
        chargeback.Contract_Sales_Indirect_Price__c = 123.45;
        chargeback.contract_units_paid_qty__c = 100;
        chargeback.Material_Number__c = '300019237';
        chargeback.contact_id__c = '3000000224';
        chargeback.Settlement_Paid_Date__c = system.today()-475;
         insert chargeback;
     
        IDN_Charge_Back__c chargeback2 =  new IDN_Charge_Back__c();
       
        chargeback2.Account__c = acc1.Id;
        chargeback2.Sales_Rep_Territory__c ='Zachary McClard';
        chargeback2.Hospital_Name__c ='Advocate Aurora Health ';
        //chargeback.Child1__c = '4740';
        chargeback2.Child_2__c = '1127';
        chargeback2.Contract__c= ctr.id;
        chargeback2.Child1_Name__c ='Advocate Health Care';
        chargeback2.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback2.Child2_Name__c ='Advocate Christ Medical Center';
        chargeback2.revised_product_family__c = 'Carboprost';
        chargeback2.material_description__c = 'Zoledronic Acid Injection 5mg/100ml USA';
        chargeback2.Contact_Description__c = 'PREMIERPP BASE';
        chargeback2.Region__c = 'East';
        chargeback2.Category__c = 'GPO';
        chargeback2.Member_State__c = 'IA';
        chargeback2.member_city__c = 'ADA';
        chargeback2.Submitter_Name__c = 'Anda, Inc.';
        chargeback2.Contract_Sales_Indirect_Price__c = 123.45;
        chargeback2.contract_units_paid_qty__c = 100;
        chargeback2.Material_Number__c = '300019237';
        chargeback2.contact_id__c = '3000000224';
        chargeback2.Settlement_Paid_Date__c = system.today()-475;
         insert chargeback2;
      
     Vision_IDN_ContractLevel_Summary_Batch.codecoverageBlock();
         Test.startTest();
        Database.executeBatch(new Vision_IDN_ContractLevel_Summary_Batch(), 5);
        Test.stopTest();   
        
    }
}