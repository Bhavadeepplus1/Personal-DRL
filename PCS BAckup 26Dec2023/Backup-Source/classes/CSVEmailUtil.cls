public class CSVEmailUtil {
    public static String listToCSV(List<String> items) {
        String csvHeader = 'ClassName\n'; // CSV header, add any other column names if needed
        
        String csvData = csvHeader + String.join(items, '\n');
        return csvData;
    }
    
    public static void sendCSVEmail(List<String> items) {
        // Convert list to CSV format
        String csvData = listToCSV(items);
        
        // Create the email attachment
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('data.csv');
        attachment.setBody(Blob.valueOf(csvData));
        
        // Create and send the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ 'sumanthreddy.kanthala@dhruvsoft.com' });
        email.setSubject('CSV Data');
        email.setPlainTextBody('Please find the attached CSV data.');
        email.setFileAttachments(new List<Messaging.EmailFileAttachment>{ attachment });
        Messaging.sendEmail(new List<Messaging.Email>{ email });
    }
}