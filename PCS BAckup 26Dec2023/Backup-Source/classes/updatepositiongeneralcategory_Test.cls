@istest
public class updatepositiongeneralcategory_Test {
    static testmethod void setup(){
        Phoenix_Product_Position__c p= new Phoenix_Product_Position__c();
        p.name='Primary';
        p.Phoenix_General_Category__c='Primary';
        insert p;
          Phoenix_Product_Position__c p1= new Phoenix_Product_Position__c();
        p1.name='Secondary';
        p1.Phoenix_General_Category__c='Secondary';
        insert p1;
        
        Vision_Customer_Product_Tracker__c cpt= new Vision_Customer_Product_Tracker__c();
        cpt.Vision_Current_Product_Position__c='Primary';
        insert cpt;
         Vision_Customer_Product_Tracker__c cpt1= new Vision_Customer_Product_Tracker__c();
        cpt1.Vision_Current_Product_Position__c='Secondary';
        insert cpt1;
         Vision_Customer_Product_Tracker__c cpt2= new Vision_Customer_Product_Tracker__c();
        cpt2.Vision_Current_Product_Position__c='Multi';
        insert cpt2;
        
    }
}