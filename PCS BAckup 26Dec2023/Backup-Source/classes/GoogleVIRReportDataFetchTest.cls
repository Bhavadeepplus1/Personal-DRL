@istest
public class GoogleVIRReportDataFetchTest {
    static  testmethod void setup(){
        Account a = new Account();
        a.Name='es';
        a.AccountNumber='12563';
        insert a;
         Account bv = new Account();
        bv.Name='esq';
        bv.AccountNumber='12565';
        insert bv;
          Phoenix_Contract__c cc= new Phoenix_Contract__c();
        cc.Phoenix_Contract_Start_Date__c=system.today();
        cc.Phoenix_Contract_Number__c='11111';
        cc.Phoenix_Contract_End_Date__c=system.today()+30;
        cc.Phoenix_Customer__c=a.id;
        insert cc;
        GCP_Product_Family_Map__c gcpf= new GCP_Product_Family_Map__c();
        gcpf.SFDC_Product_Family__c='A';
        gcpf.GCP_Product_Family__c='A';
        insert gcpf;
        GCP_VIR_Report__c vir = new GCP_VIR_Report__c();
        vir.Vision_GCP_Agreement__c='122';
        vir.Vision_Account__c=a.id;
        vir.Vision_GCP_Customer__c='ABC';
        vir.Vision_GCP_Customer_Code__c='12563';
        vir.Vision_GCP_Month__c=25;
        vir.Vision_GCP_Month_Text__c='april';
        vir.Vision_GCP_Tenure__c='Jan21toDEC23';
        vir.Vision_Gcp_Direct_Sales__c=2225.22;
        vir.Vision_GCP_Year__c='2021';
        vir.Vision_Agreement_Number__c='11111';
        //vir.Vision_GCP_Start_Date__c=date.newInstance(2022, 03, 05);
       // vir.Vision_GCP_End_Date__c=date.newInstance(2022, 12, 05);
      
        insert vir;
         GCP_VIR_Report__c vir1 = new GCP_VIR_Report__c();
        vir1.Vision_Agreement_Number__c='122';
       // vir1.Vision_Account__c=a.id;
        vir1.Vision_GCP_Customer__c=null;
        vir1.Vision_GCP_Customer_Code__c='12562';
        vir1.Vision_GCP_Month__c=25;
        vir1.Vision_GCP_Month_Text__c='jan';
        vir1.Vision_GCP_Tenure__c='jan21 to dec22';
        vir1.Vision_Gcp_Direct_Sales__c=2225.22;
        vir1.Vision_GCP_Year__c='2022';
        //vir.Vision_GCP_Start_Date__c=date.newInstance(2022, 03, 05);
       // vir.Vision_GCP_End_Date__c=date.newInstance(2022, 12, 05);
        
        insert vir1;
        test.startTest();
        GoogleVIRReportDataFetch b = new GoogleVIRReportDataFetch();
        database.executeBatch(b);
         Database.executeBatch(new GoogleVIRReportDataFetch(5,1));
        test.stopTest();
    }
        static  testmethod void setup1(){
        Account a = new Account();
        a.Name='es';
        a.AccountNumber='12563';
        insert a;
         Account bv = new Account();
        bv.Name='esq';
        bv.AccountNumber='12565';
        insert bv;
          Phoenix_Contract__c cc= new Phoenix_Contract__c();
        cc.Phoenix_Contract_Start_Date__c=system.today();
        cc.Phoenix_Contract_Number__c='11111';
        cc.Phoenix_Contract_End_Date__c=system.today()+30;
        cc.Phoenix_Customer__c=a.id;
        insert cc;
        GCP_Product_Family_Map__c gcpf= new GCP_Product_Family_Map__c();
        gcpf.SFDC_Product_Family__c='A';
        gcpf.GCP_Product_Family__c='A';
        insert gcpf;
        GCP_VIR_Report__c vir = new GCP_VIR_Report__c();
        vir.Vision_GCP_Agreement__c='122';
        vir.Vision_Account__c=a.id;
        vir.Vision_GCP_Customer__c='ABC';
        vir.Vision_GCP_Customer_Code__c='12563';
        vir.Vision_GCP_Month__c=25;
        vir.Vision_GCP_Month_Text__c='april';
        vir.Vision_GCP_Tenure__c='Jan21toDEC23';
        vir.Vision_Gcp_Direct_Sales__c=2225.22;
        vir.Vision_GCP_Year__c='2021';
        vir.Vision_Agreement_Number__c='11111';
        //vir.Vision_GCP_Start_Date__c=date.newInstance(2022, 03, 05);
       // vir.Vision_GCP_End_Date__c=date.newInstance(2022, 12, 05);
      
        insert vir;
         GCP_VIR_Report__c vir1 = new GCP_VIR_Report__c();
        vir1.Vision_Agreement_Number__c='122';
       // vir1.Vision_Account__c=a.id;
        vir1.Vision_GCP_Customer__c=null;
        vir1.Vision_GCP_Customer_Code__c='12562';
        vir1.Vision_GCP_Month__c=25;
        vir1.Vision_GCP_Month_Text__c='jan';
        vir1.Vision_GCP_Tenure__c='jan21 to dec22';
        vir1.Vision_Gcp_Direct_Sales__c=2225.22;
        vir1.Vision_GCP_Year__c='2022';
        //vir.Vision_GCP_Start_Date__c=date.newInstance(2022, 03, 05);
       // vir.Vision_GCP_End_Date__c=date.newInstance(2022, 12, 05);
        
        insert vir1;
        test.startTest();
        GoogleVIRReportDataFetch b = new GoogleVIRReportDataFetch();
        database.executeBatch(b);
         Database.executeBatch(new GoogleVIRReportDataFetch(5,1));
        test.stopTest();
        
        
    }

}