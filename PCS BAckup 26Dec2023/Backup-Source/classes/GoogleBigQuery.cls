public class GoogleBigQuery {
    
    private String projectId; // Project ID from Google BigQuery
    private String datasetId; // Dataset ID from Google BigQuery
    private String tableId; // Table ID from Google BigQuery
    private Boolean isSuccess = false;
    private String response;
    
    public GoogleBigQuery(String projectId) {
        this.projectId = projectId;
    }
    
    public GoogleBigQuery(String projectId, String datasetId) {
        this.datasetId = datasetId;
        this.projectId = projectId;
    }
    
    public GoogleBigQuery(String projectId, String datasetId, String tableId) {
        this.datasetId = datasetId;
        this.projectId = projectId;
        this.tableId = tableId;
    }
    
/*   public Boolean add111(Object data) {
        GoogleAuthProvider auth = new GoogleAuthProvider(); // Custom Google OAuth Provider
        if (auth.authorize()) {
            Request req = new Request (auth, 'add', projectId, datasetId, tableId);
            req.send(data);
            this.isSuccess = req.isSuccess();
            this.response = req.getResponse();
        } else {
            this.response = auth.getErrorMessage();
        }
        return this.isSuccess;
    }
*/
      public Boolean process(Object data, String action) {
        GoogleAuthProvider auth = new GoogleAuthProvider(); // Custom Google OAuth Provider
        if (auth.authorize()) {
            Request req = new Request (auth, action, projectId, datasetId, tableId);
            req.send(data);
            this.isSuccess = req.isSuccess();
            this.response = req.getResponse();
        } else {            this.response = auth.getErrorMessage();
        }
        return this.isSuccess;
    }

    public Boolean query(Object data) {
        GoogleAuthProvider auth = new GoogleAuthProvider(); // Custom Google OAuth Provider
        if (auth.authorize()) {
            Request req = new Request (auth, 'query', projectId);
            req.send(data);
            this.isSuccess = req.isSuccess();
            this.response = req.getResponse();
        } else {            this.response = 'Authentication error';
        }
        return this.isSuccess;
    }
    
    public Boolean isSuccess() {
        return this.isSuccess;
    }
    
    public String getResponse() {
        return this.response;
    }
    
    // Internal class for handling communication with Google BigQuery
    class Request {
        
        private String accessToken;
        private String requestType;
        private String baseUrl = 'https://www.googleapis.com/bigquery/v2/projects/projectId/';
        private String projectId;
        private String datasetId;
        private String tableId;
        private Boolean isSuccess = false;
        private String response;
        
        Request(GoogleAuthProvider auth, String type, String projectId) {
            this.accessToken = auth.getAccessToken();
            this.requestType = type;
            this.projectId = projectId;
        }
        
  /*      Request(GoogleAuthProvider auth, String type, String projectId, String datasetId) {
            this.accessToken = auth.getAccessToken();
            this.requestType = type;
            this.projectId = projectId;
            this.datasetId = datasetId;
        }
  */      
        Request(GoogleAuthProvider auth, String type, String projectId, String datasetId, String tableId) {
            this.accessToken = auth.getAccessToken();
            this.requestType = type;
            this.projectId = projectId;
            this.datasetId = datasetId;
            this.tableId = tableId;
        }
        
        public void send(Object data) {
            String url = '';
            String jsonData = '';
            String methodName = '';
            switch on this.requestType {
                when 'query' {
                    this.baseUrl = this.baseUrl + 'queries';
                    methodName = 'POST';
                }
                 when 'insertAll' {
                    this.baseUrl = this.baseUrl + 'datasets/datasetId/tables/tableId/insertAll';
                    methodName = 'POST';
                } 
               /*when 'list' {
                    this.baseUrl = this.baseUrl + 'datasets/datasetId/tables/tableId/data';
                    methodName = 'POST';
                }
                 when 'update' {
                    this.baseUrl = this.baseUrl + 'datasets/datasetId/tables/tableId';
                     methodName = 'PATCH';
                }
                 when 'updateAll' {
                    this.baseUrl = this.baseUrl + 'datasets/datasetId/tables/tableId';
                     methodName = 'PUT';
                }*/
            }
            
            this.baseUrl = this.baseUrl.replace('projectId', projectId);
            if (datasetId != null) {
                this.baseUrl = this.baseUrl.replace('datasetId', datasetId);
            }
            if (tableId != null) {
                this.baseUrl = this.baseUrl.replace('tableId', tableId);
            }
            
            jsonData = System.JSON.serialize(data);
            jsonData = jsonData.replaceAll('__c', '');
            HttpRequest req = new HttpRequest();
            req.setMethod(methodName);
            req.setEndpoint(this.baseUrl);
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + this.accessToken);
            req.setBody(jsonData);
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!TEST.isRunningTest())res = http.send(req);
            else{
                res.setStatusCode(200);
            }
            System.debug('jsonData is '+jsonData);
            System.debug('baseUrl is '+baseUrl); 
            System.debug('req is '+req.getBody()); 
            System.debug('Auth  is '+req.getHeader('Authorization')); 
            this.response = res.getBody();
            if (res.getStatusCode()==200) {
                this.isSuccess = true;
                System.debug('No error found');
                System.debug('Success is '+this.response);
            } else {
                //   Map<String, Object> errorResponse = (Map<String, Object>)JSON.deserializeUntyped(this.response);
                //   Map<String, Object> error = (Map<String, Object>)errorResponse.get('error');
                //   this.response = (String)error.get('message');
                System.debug('error is '+this.response);
            }
        }
        
        public Boolean isSuccess() {
            return this.isSuccess;
        }
        
        public String getResponse() {
            return this.response;
        }
        
    }
    
    // Class for constructing a simple query
    public class JobsQuery {
        public String query;
    }
    
    // Class for constructing an insert call
    public class InsertAll {
        String kind = 'bigquery#tableDataInsertAllRequest';
        Boolean skipInvalidRows = false;
        Boolean ignoreUnknownValues = true;
        List<Object> rows = new List<Object>();
        
        public void addObject(Object data) {
            Map<String, Object> details = new Map<String, Object>();
            details.put('json', data);
            rows.add(details);
        }
    }
  
    public class Payload {
        String kind = '';
        Boolean skipInvalidRows = false;
        Boolean ignoreUnknownValues = true;
        List<Object> rows = new List<Object>();
        
        public void addObject(Object data,String action) {
          if(action == 'insertAll')  kind = 'bigquery#tableDataInsertAllRequest';
            Map<String, Object> details = new Map<String, Object>();
            details.put('json', data);
            rows.add(details);
        }
    }
    
    public class GoogleBigQueryRespWrapper {
    public Map<Integer,String> jsonFieldMap{get; set;}
    public Map<Integer,map<Integer,String>> jsonRowMap{get; set;}
   	public Integer totalRows{get;set;}
        

}
    
    public static GoogleBigQueryRespWrapper RespParser(String gcpResponse){
        GoogleBigQueryRespWrapper gbqrw = new GoogleBigQueryRespWrapper();
        Map<String, Object> m =(Map<String, Object>) JSON.deserializeUntyped(gcpResponse);
        Map<String, Object> schema = (Map<String, Object>)m.get('schema');
        
        // Parsing fields from BigQuery Response
        //List<Object> fieldListObj = (Object[])schema.get('fields');
        gbqrw.jsonFieldMap = new Map<Integer,String>();
        gbqrw.jsonRowMap = new Map<Integer,map<Integer,String>>();
        System.debug('Get Total Rows '+m.get('totalRows'));
        gbqrw.totalRows = Integer.valueOf(m.get('totalRows'));
        
        Integer i = 1;
        for(Object o : (Object[])schema.get('fields'))
        {
            //String fiedName = String.valueOf(((Map<string, Object>)o).get('name'));
            gbqrw.jsonFieldMap.put(i,String.valueOf(((Map<string, Object>)o).get('name')));
            i++;
        }

        // Parsing Rows from BigQuery Response
        //List<Object> jsonRows = (Object[])m.get('rows');
        Integer rowNo=1;
        if(m!=null){
            if(m.containskey('rows')){   
        for(Object row : (Object[])m.get('rows')){
            Map<string, Object> eachRowjson = (Map<string, Object>)row;
            //List<Object> rows = (Object[])eachRowjson.get('f');
            Map<Integer,String> fieldValuemap = new Map<Integer,String>();
            Integer valCount = 1 ;
            for(Object eachRow : (Object[])eachRowjson.get('f')){
                String rowValue = String.valueOf(((Map<string, Object>)eachRow).get('v'));
                //System.debug('ROW VALUE =========> '+rowValue);
               // if(String.isNotBlank(rowValue)) rowValue = rowValue.remove('%');
                fieldValuemap.put(valCount,rowValue);
                valCount++;
            }
            gbqrw.jsonRowMap.put(rowNo,fieldValuemap);
            rowNo++;
        }
        }
        }
        return gbqrw;
    }
}