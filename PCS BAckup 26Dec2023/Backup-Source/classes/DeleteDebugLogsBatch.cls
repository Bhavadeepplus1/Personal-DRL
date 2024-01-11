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
public class DeleteDebugLogsBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'Select Id From ApexLog';
        if (Test.isRunningTest()) query += ' Limit 1';
        return Database.getQueryLocator(query); //limit 100
    }
    
    public void execute(Database.BatchableContext bc, List<ApexLog> logs){for(Apexlog al:logs){Http h=new Http();HttpRequest req=new HttpRequest();req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()+'/services/data/v44.0/sobjects/Apexlog/'+al.Id);req.setMethod('DELETE');req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());HttpResponse res;if(!Test.isRunningTest())res=h.send(req);}   
    }

    public static void finish(Database.BatchableContext bc) {

    }
}