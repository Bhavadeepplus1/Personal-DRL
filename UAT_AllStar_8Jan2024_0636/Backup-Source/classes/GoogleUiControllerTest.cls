@isTest
public class GoogleUiControllerTest {
    
    static testmethod void test01(){
        GoogleUiController.runBigQuerySql('SELECT product_family,customer_code,ims_mat_sales FROM Test.sfdc_market_tracker LIMIT 1');
    }
    
}