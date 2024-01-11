public class Phoenix_Date_Time_Format_Class {
    public DateTime date_time {
        get;
        set;
    } //property that reads the datetime value from component attribute tag
    public String defined_format {
        get;
        set;
    } //property that reads the string value from component attribute tag
    public String getFormattedDatetime() {
        
        if (date_time == null)
            
        {
            return '';
        } 
        else {
            if (defined_format == null)
            {
                return date_time.format(); 
            } else
            {
                return date_time.format(defined_format, 'America/New_York');
            }
        }
    }
    
}