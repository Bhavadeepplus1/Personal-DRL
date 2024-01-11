@isTest
public class ProductPlaybookNPRFieldHistoryTest {
    @testSetup static void setupTestData() {
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        insert acc;
        Phoenix_Partner__c pn= new Phoenix_Partner__c();
        pn.Name='Test';
        insert pn;
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.ProductCode='30000001';
        pro.Phoenix_PS_Partner_2_Name__c=pn.Id;
        insert pro;
        Phoenix_Product_Playbook__c pb= new Phoenix_Product_Playbook__c();
        pb.Phoenix_Shelf_Life__c='10';
        pb.Phoenix_Product__c=pro.Id;
        insert pb;
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        insert npr;
        Phoenix_NPR_Data__c npr2= new Phoenix_NPR_Data__c();
        npr2.Phoenix_Contract__c=cont.Id;
        npr2.Phoenix_Product__c=pro.Id;
        npr2.Phoenix_Add_ABS_Value__c=3.00;
        insert npr2;
    }
    @isTest
    public static void Product1(){
        Phoenix_Partner__c pn1= new Phoenix_Partner__c();
        pn1.Name='Test1';
        insert pn1;
        Product2 pro3= new  Product2 ();
        pro3.Name='Product';
        insert pro3;
        Product2 pro=[select Id from Product2 where Name='Test'];
        pro.ProductCode='123';
        pro.Phoenix_PS_Partner_2_Name__c=pn1.Id;
        update pro;
        Phoenix_Product_Playbook__c pb1=[select Id from Phoenix_Product_Playbook__c where Phoenix_Shelf_Life__c='10'];
        pb1.Phoenix_Product__c=pro3.Id;
        pb1.Phoenix_DLS_formerly_NDC__c='1234';
        update pb1;
    }
    @isTest
    public static void Product2(){
        Product2 pro1= new Product2();
        pro1.Name='Test123';
        insert pro1;
        Phoenix_Product_Playbook__c pb1=[select Id from Phoenix_Product_Playbook__c where Phoenix_Shelf_Life__c='10'];
        pb1.Phoenix_Shelf_Life__c='100';
        pb1.Phoenix_Product__c=pro1.Id;
        update pb1;
    }
    @isTest
    public static void Product3(){
        Product2 pro=[select Id,ProductCode,Phoenix_PS_Partner_2_Name__c from Product2 where Name='Test'];
        pro.ProductCode='123';
        pro.Phoenix_PS_Partner_2_Name__c=null;
        update pro;
    }
     @isTest
    public static void Product4(){
        Phoenix_Partner__c pn1= new Phoenix_Partner__c();
        pn1.Name='Test1';
        insert pn1;
        Product2 pro=[select Id from Product2 where Name='Test'];
       // pro.ProductCode='123';
        pro.Phoenix_PS_Partner_2_Name__c=pn1.Id;
        update pro;
    }
    @isTest
    public static void nprData(){
        Phoenix_NPR_Data__c npr= [select id from Phoenix_NPR_Data__c where Phoenix_Add_ABS_Value__c=2.00];
        npr.Phoenix_Add_ABS_Value__c=3.00;
        update npr;
    }
    
    @isTest
    public static void nprData2(){
        Account ac1= new Account();
        ac1.Name='Account';
        insert ac1;
        Phoenix_NPR_Data__c npr= [select id from Phoenix_NPR_Data__c where Phoenix_Add_ABS_Value__c=2.00];
        npr.Phoenix_Account__c=ac1.Id;
        update npr;
    }
    @isTest
    public static void nprData3(){
        Phoenix_NPR_Data__c npr= [select id from Phoenix_NPR_Data__c where Phoenix_Add_ABS_Value__c=2.00];
        npr.Phoenix_Account__c=null;
        update npr;
        
    }
    @isTest
    public static void nprData4(){
        
        Account ac11= new Account();
        ac11.Name='Account';
        insert ac11;
        Phoenix_NPR_Data__c npr= [select id from Phoenix_NPR_Data__c where Phoenix_Add_ABS_Value__c=3.00];
        npr.Phoenix_Account__c=ac11.Id;
        update npr;
    }
    @isTest
    public static void playBook(){
        Phoenix_Product_Playbook__c pb1=[select Id from Phoenix_Product_Playbook__c where Phoenix_Shelf_Life__c='10'];
        pb1.Phoenix_Shelf_Life__c='100';
        pb1.Phoenix_DLS_formerly_NDC__c='1234';
        update pb1;
    }
  @isTest
    public static void Product5(){
        Product2 pn1= new Product2();
        pn1.Name='Test Pro';
        insert pn1;
        Phoenix_Product_Playbook__c pb1=[select Id, Phoenix_Product__c from Phoenix_Product_Playbook__c where Phoenix_Shelf_Life__c='10'];
        pb1.Phoenix_Product__c=pn1.Id;
        update pb1;
    } 
    static testmethod void BidLineItemTrigger(){
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		Phoenix_Bid__c pb = new Phoenix_Bid__c();
		pb.Phoenix_Status__c = 'New';
		pb.Phoenix_Comments__c = 'Test Comments';
		pb.Phoenix_Customer__c = testAccount.Id;
		pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
		pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
		insert pb;
        
        Phoenix_Bid_Line_Item__c bl= new Phoenix_Bid_Line_Item__c();
		bl.Phoenix_Bid__c=pb.Id;
        bl.Phoenix_Current_Direct_Price__c=10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c=10;
        insert bl;
	}
}