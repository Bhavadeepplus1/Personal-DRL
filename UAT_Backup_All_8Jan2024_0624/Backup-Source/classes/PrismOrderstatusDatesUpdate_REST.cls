@RestResource(urlMapping='/UpdateVisiondata/*')
global with sharing class PrismOrderstatusDatesUpdate_REST{
    @HttpGet
    global static string doGet() {
      Vision_GCP_SFDC_Order_Status__c cusOrdRec = [select Vision_GCP_Update_Date__c,GCP_Unique_Identifier__c,Testing_field__c,lastmodifieddate,Vision_Created_Date__c,Vision_GCP_Update_DateTime__c,Vision_SAP_Created_DateTime__c from Vision_GCP_SFDC_Order_Status__c order by Vision_GCP_Update_DateTime__c desc , Vision_SAP_Created_DateTime__c desc,Vision_GCP_Update_DateTime__c desc,lastmodifieddate desc limit 1];
                  // cusOrdRec.Testing_field__c='tet1';
               // update cusOrdRec;
String Vision_gcp_update_date  = String.valueOf(cusOrdRec.Vision_GCP_Update_Date__c);
                          system.debug('cusOrdRec.Vision_GCP_Update_DateTime__c....'+cusOrdRec.Vision_GCP_Update_DateTime__c);
                    String Vision_GCP_Update_DateTime = String.valueOfGmt(cusOrdRec.Vision_GCP_Update_DateTime__c);
                    system.debug('gcp after conevrsion.,,'+Vision_GCP_Update_DateTime);
                      system.debug('before convo'+cusOrdRec.Vision_SAP_Created_DateTime__c);
                    String SAP_Created_DateTime  = String.valueOfGMT(cusOrdRec.Vision_SAP_Created_DateTime__c);
                    system.debug('after convo...'+SAP_Created_DateTime);
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    system.debug('--Vision_gcp_update_date--'+Vision_gcp_update_date);
                    system.debug('--Vision_update_date--'+Vision_update_date);
                    cus_ord_trend_dates_info__c  cotdi = cus_ord_trend_dates_info__c.getInstance('Data1');
      
                    cotdi.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
        
                    cotdi.Vision_Update_Date__c = Vision_update_date;
                    cotdi.Vision_GCP_Update_DateTime__c=Vision_GCP_Update_DateTime;
                    cotdi.SAP_Created_DateTime__c=SAP_Created_DateTime;
                    cotdi.Vision_Updated_DateTime__c=string.valueofGmt(Phoenix_Util.getUserTime(cusOrdRec.lastmodifieddate,'America/New_York'));
        
                    update cotdi;
        
        return 'success';
    }
}