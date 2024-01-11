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
public class Phoenix_AllJobsMonitor_Test {

    static testmethod void test1() {
        try{
        Test.startTest();
        Phoenix_AllJobsMonitor monitor = new Phoenix_AllJobsMonitor();
        monitor.execute(null);
        Test.stopTest();
        }catch(Exception ex){}
    }
    
    static testmethod void test2() {
        
        Test.startTest();
        Phoenix_AllJobsMonitor monitor = new Phoenix_AllJobsMonitor();
        monitor.execute(null);
        Test.stopTest();
       
    }
    
   static testmethod void testIncrement() {
         Phoenix_AllJobsMonitor.justIncrement();
       
       
    }
    
    
    
    
    
    
}