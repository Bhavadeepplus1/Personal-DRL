@isTest(seealldata=true)
public class Phoenix_Date_Time_Format_ClassTest {
    @isTest
    public static void DateTimeformat() {
        Phoenix_Date_Time_Format_Class obj = new Phoenix_Date_Time_Format_Class();
        obj.getFormattedDatetime();
        
        obj.date_time= system.now();
        obj.getFormattedDatetime();
        obj.defined_format='yyyy-MM-dd\'T\'HH:mm:ss.SSSZ';
        obj.getFormattedDatetime();
    }
    
}