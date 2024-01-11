public class GoogleUiController {

    @AuraEnabled
    public static String runBigQuerySql(String sql){
         String projectId = 'nag-analytics';

        GoogleBigQuery google = new GoogleBigQuery(projectId);
        GoogleBigQuery.JobsQuery query = new GoogleBigQuery.JobsQuery();
        query.query = sql;
        if (!google.query(query)) {
            System.debug('Error when Querying: ' + google.getResponse());
            throw new AuraHandledException('Error when Querying: ' + google.getResponse());
        }
        return google.getResponse();
    }

}