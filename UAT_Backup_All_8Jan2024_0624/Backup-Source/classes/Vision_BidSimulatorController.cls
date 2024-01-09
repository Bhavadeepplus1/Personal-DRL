public class Vision_BidSimulatorController {
    public class simWrapper{
        @auraEnabled
        Public Account accObj;
        @auraEnabled
        public Product2 prodObj;
        @auraEnabled
        Public List<Vision_Bid_Simulator__c> scenList;
        @auraEnabled
        public boolean isError = false;
        @auraEnabled
        public string errorMessage;
    }
    
    @auraEnabled
    public static simWrapper getProdList(String prodId, String accId){
        simWrapper wrapObj = new simWrapper();
        List<Vision_Bid_Simulator__c> bidSimList = database.query('SELECT '+Phoenix_Util.getsObjectFieds('Vision_Bid_Simulator__c')+' FROM Vision_Bid_Simulator__c WHERE Product__c =: prodId AND Account__c =: accId');
        Product2 prodObj = database.query('SELECT '+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id =: prodId');
        Account accObj = database.query('SELECT '+Phoenix_Util.getsObjectFieds('Account')+' FROM Account WHERE Id =: accId');
        wrapObj.accObj = accObj;
        wrapObj.prodObj = prodObj;
        wrapObj.scenList = bidSimList;
        return wrapObj;
    }
    
    @auraEnabled
    public static List<String> getScenarioList(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Vision_Bid_Simulator__c.Vision_Scenario_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
}