@istest
public class Deleterecordstest {
    static testmethod void setup(){
       account a= new account();
        a.name='test';
        insert a;
        test.startTest();
        database.executeBatch(new DeleteRecordsBatchCls());
        test.stopTest();
    }
}