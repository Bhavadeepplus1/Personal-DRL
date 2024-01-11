@IsTest
public class VisionDRLSalesProductsReport_Test 
{
  @IsTest
   Public static void testdata(){
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser12@example.com',
            Alias = 'tuser',
            Division = 'Division',
            ProfileId = userProfile.Id,
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
       List<String> selections = new List<String>{'RX','SRX', 'OTC'};
           
       Vision_InternalDRLSales_ProductSummary__c data = new Vision_InternalDRLSales_ProductSummary__c();
       data.Vision_Product_Family__c = 'data';
       data.Vision_Units__c = 2;
       data.Vision_TPT_Dollar__c = 200;
       data.Vision_Sales__c = 200;
       data.Vision_Unique_Identifier__c = 'data';
       insert data;
       
      
       
       VisionDRLSalesProductsReportController.wrapperClass result1 = VisionDRLSalesProductsReportController.getDRLSalesRelatedList(selections, 'last12monthsvsprevious12months', 'test', data.Id, true, 'test', selections);
       VisionDRLSalesProductsReportController.wrapperClass result11 = VisionDRLSalesProductsReportController.getDRLSalesRelatedList(selections, 'lastquartervspreviousquarter', 'test', data.Id, true, 'test', selections);
       VisionDRLSalesProductsReportController.wrapperClass result12 = VisionDRLSalesProductsReportController.getDRLSalesRelatedList(selections, 'fytdvspreviousfytd', 'test', data.Id, true, 'test', selections);
       VisionDRLSalesProductsReportController.wrapperClass result2 = VisionDRLSalesProductsReportController.getLasttwmonthsVsPrevtwmonthsData(selections, 'test', 'test', 'test', selections, true, 3, 2 );
       VisionDRLSalesProductsReportController.wrapperClass result22 = VisionDRLSalesProductsReportController.getLasttwmonthsVsPrevtwmonthsData(selections, 'test', 'test', 'test', selections, true, 2, 2 );
       VisionDRLSalesProductsReportController.wrapperClass result3 = VisionDRLSalesProductsReportController.getLastQuarterVsPrevQuarterData(selections, 'test', 'test', 'test', selections, true );
       VisionDRLSalesProductsReportController.wrapperClass result4 = VisionDRLSalesProductsReportController.getfytdData(selections, 'fytdvspreviousfytd', 'test', 'test', selections, true );
    }
    @IsTest
   Public static void testdata1(){
        List<String> selections = new List<String>{'RX','SRX', 'OTC'};
        Vision_InternalDRLSales_ProductSummary__c data1 = new Vision_InternalDRLSales_ProductSummary__c();
       data1.Vision_Product_Family__c = 'data';
       data1.Vision_Units__c = 2;
       data1.Vision_TPT_Dollar__c = 400;
       data1.Vision_Sales__c = 250;
       data1.Vision_Unique_Identifier__c = 'data';
       data1.Vision_Processed_Date__c = Date.today();
       insert data1;
       //VisionDRLSalesProductsReportController.wrapperClass result2 = VisionDRLSalesProductsReportController.getLasttwmonthsVsPrevtwmonthsData(selections, 'last12monthsvsprevious12months', 'test', 'test', selections, true, 2, 3 );
       VisionDRLSalesProductsReportController.wrapperClass result11 = VisionDRLSalesProductsReportController.getDRLSalesRelatedList(selections, 'last12monthsvsprevious12months', 'test', data1.Id, false, 'test', selections);
   }
    @IsTest
   Public static void testdata2(){
        List<String> selections = new List<String>{'RX','SRX', 'OTC'};
        Vision_InternalDRLSales_ProductSummary__c data1 = new Vision_InternalDRLSales_ProductSummary__c();
       data1.Vision_Product_Family__c = 'data';
       data1.Vision_Units__c = 2;
       data1.Vision_TPT_Dollar__c = 400;
       data1.Vision_Sales__c = 250;
       data1.Vision_Unique_Identifier__c = 'data';
       data1.Vision_Processed_Date__c = Date.today();
       insert data1;
       VisionDRLSalesProductsReportController.wrapperClass result12 = VisionDRLSalesProductsReportController.getDRLSalesRelatedList(selections, 'lastquartervspreviousquarter', 'test', data1.Id, false, 'test', selections);
   }
      @IsTest
   Public static void testdata3(){
        List<String> selections = new List<String>{'RX','SRX', 'OTC'};
       // List<Vision_InternalDRLSales_ProductSummary__c> newList = new List<Vision_InternalDRLSales_ProductSummary__c>();
        Vision_InternalDRLSales_ProductSummary__c data1 = new Vision_InternalDRLSales_ProductSummary__c();
       data1.Vision_Product_Family__c = 'data';
       data1.Vision_Units__c = 200;
       data1.Vision_TPT_Percent__c  = 10;
       data1.Vision_TPT_Dollar__c = 500;
       data1.Vision_Sales__c = 200;
       data1.Vision_Unique_Identifier__c = 'data';
       data1.Vision_Processed_Date__c = Date.today();
       //newList.add(data1);
       insert data1;
       
    
       VisionDRLSalesProductsReportController.wrapperClass result22 = VisionDRLSalesProductsReportController.getLasttwmonthsVsPrevtwmonthsData(selections, 'test', 'test', 'test', selections, true, 3, 2 );
       VisionDRLSalesProductsReportController.wrapperClass result13 = VisionDRLSalesProductsReportController.getDRLSalesRelatedList(selections, 'fytdvspreviousfytd', 'test', data1.Id, false, 'test', selections);
   }
    @isTest
    Public static void testdata4() {
        
        List<String> selections = new List<String>{'RX','SRX', 'OTC'};
        Vision_InternalDRLSales_ProductSummary__c testRecord1 = new Vision_InternalDRLSales_ProductSummary__c();
         testRecord1.Vision_Processed_Date__c = Date.today();
          
        insert testRecord1;
        
        Boolean recentLastMonth = true;
        Boolean previousLastMonth = true;
        
       
       VisionDRLSalesProductsReportController.wrapperClass result22 = VisionDRLSalesProductsReportController.getLasttwmonthsVsPrevtwmonthsData(selections, 'test', 'test', 'test', selections, false, 2, 3 );
       
        VisionDRLSalesProductsReportController.wrapperClass result13 = VisionDRLSalesProductsReportController.getDRLSalesRelatedList(selections, 'fytdvspreviousfytd', 'test', testRecord1.Id, false, 'test', selections);
		
        VisionDRLSalesProductsReportController.wrapperClass result23 = VisionDRLSalesProductsReportController.getLasttwmonthsVsPrevtwmonthsData(selections, 'test', 'test', 'test', selections, true, 3, 2 );
    }
}