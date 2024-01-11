@isTest (seealldata=true)//positive unit test for the REST API GET call
    public class  PrismOrderstatusDatesUpdate_REST_Test {
        
      static testmethod void gettt(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/UpdateVisiondata/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
          Vision_GCP_SFDC_Order_Status__c nn=new Vision_GCP_SFDC_Order_Status__c();
         // nn.LastModifiedDate=today();
          nn.PRISM_SAP_Created_Time__c=string.valueof(system.today());
          nn.Vision_GCP_Update_Date__c=system.today();
          nn.Vision_Created_Date__c=system.today();
          nn.Vision_GCP_Update_Date__c=system.today();
         insert nn;
          
          cus_ord_trend_dates_info__c cotdi=new cus_ord_trend_dates_info__c();
                     cotdi.Vision_GCP_Update_Date__c = ' ';
        
                    cotdi.Vision_Update_Date__c = ' ';
                    cotdi.Vision_GCP_Update_DateTime__c='';
                    cotdi.SAP_Created_DateTime__c=' ';
                    cotdi.Vision_Updated_DateTime__c=' ';
                    cotdi.Name='data1';
                    insert cotdi;
        Test.startTest();
      PrismOrderstatusDatesUpdate_REST.doGet();
        Test.stopTest(); 
        }
    }