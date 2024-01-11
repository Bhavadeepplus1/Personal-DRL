@istest
public class MultiSelectLookupControllerTest {

    public testmethod static  void test1(){
        account acc= new account();
        acc.name='test';
        insert acc;
        //string account='Account';
      //  string name='Name';
         test.startTest();
        
        
        
        
        MultiSelectLookupController.fetchRecords('Account', 'name', 'test', acc.id);
         MultiSelectLookupController.fetchRecords('Account', 'name', 'test', null);
          MultiSelectLookupController.justIncrement();
        test.stopTest();
    }   
     
}