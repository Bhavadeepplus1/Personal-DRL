@isTest
private class MultiSelectLookupControllerTest1 {
    @isTest
    static void testFetchRecords() {
        // Create test data
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        String objectName = 'Account';
        String filterField = 'Name';
        String searchString = 'Test';
        List<String> values = new List<String>{testAccount.Id};

        // Call the fetchRecords method
        Test.startTest();
        List<MultiSelectLookupController.RecordsData> recordsDataList = MultiSelectLookupController.fetchRecords(objectName, filterField, searchString, JSON.serialize(values));
        Test.stopTest();

        // Verify the results
      //  System.assertEquals(1, recordsDataList.size());
        MultiSelectLookupController.RecordsData recordsData = recordsDataList[0];
        System.assertEquals(testAccount.Name, recordsData.label);
        System.assertEquals(testAccount.Name, recordsData.value);
    }
}