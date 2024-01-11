@isTest//(seealldata=true)
public class Rx_Compliance_Indirect_Sales_Batch_Test {
      static testMethod void setup(){
      
          List<Account> Acclist = new  List<Account>();
        Account acc =new Account();
        acc.name='test';
        acc.AccountNumber = '154328';
        Acclist.add(acc);
        insert Acclist;
        // Phoenix Data
        List<Phoenix_Contract__c> Ctlist  = new List<Phoenix_Contract__c>();
        Phoenix_Contract__c ct = new Phoenix_Contract__c ();
        ct.Phoenix_Contract_Number__c='123456';
        ct.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct.Phoenix_Contract_End_Date__c=system.today();
      
        ctlist.add(ct);
        insert ctlist;
        
        // Product Data
        list<Product2> plist = new list  < Product2>();
        
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='300000904';
        p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        p.Vision_Is_CPT_Batch_Executed__c = false;
        p.Phoenix_Is_Exclude_Bid__c = false;
        p.IsActive=true;
        p.Phoenix_Rx_SRx_OTC__c = 'Rx';
        p.Description='my testing';
        
        Product2 p1=new Product2();
        p1.Name='abc pharma 2';
        p1.Phoenix_NDC_11__c='123364848';
        p1.ProductCode='300028872';
        p1.Phoenix_NDC__c='5555555';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p1.Family = 'Test Family';
        p1.Phoenix_Throughput_cost__c=10.23456576;
        p1.Phoenix_GCN_Sequence_Number__c='666666';
        p1.Phoenix_Pkg_Size__c=25.0;
        p1.Vision_Is_CPT_Batch_Executed__c = false;
        p1.Phoenix_Is_Exclude_Bid__c = false;
        p1.IsActive=true;
        p1.Phoenix_Rx_SRx_OTC__c = 'SRx';
        p1.Description='my testing';
      	plist.add(p1);
        insert plist;

        
        // NprData Data
        List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        npdata.Phoenix_Account__c=acc.Id;
        npdata.Phoenix_Contract__c=ct.Id;
        nprdtlist.add(npdata);
        insert nprdtlist;
            GCP_SFDC_Indirect_Sales__c indirectSalesA1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='07/04/2022');
        
       insert indirectSalesA1;
        List<Vision_Customer_Product_Tracker__c> cpotlist= new List<Vision_Customer_Product_Tracker__c>();
        for ( Product2 pp:plist){
            Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
            cpt.Vision_Account__c=Acc.Id;
            cpt.Vision_Contract__c=ct.Id;
            cpt.Vision_NPR_Data__c=npdata.Id;
            cpt.Vision_Product__c=pp.Id;
            cpt.Vision_Product_Code__c='300023750';
            cpt.Vision_Contract_Number__c='123456';
            cpt.Vision_Customer_Code__c = '154328';
            cpt.Vision_Current_Product_Position__c = 'Testing Current Product Position';
            cpt.Vision_Contract_Type__c = 'Indirect';
            cpt.Vision_Awarded_Volume__c = 25;
            cpt.Vision_Awarded_Value__c = 35;
            cpt.Vision_Is_In_Awarded__c = true;
            cpt.Is_Initial_Order__c = true;
            cpotlist.add(cpt);
            Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=Acc.Id;
            cpt.Vision_Contract__c=ct.Id;
            cpt1.Vision_NPR_Data__c=npdata.Id;
            cpt1.Vision_Product__c=pp.Id;
            cpt1.Vision_Product_Code__c='300022350';
            cpt1.Vision_Customer_Code__c = '154328';
            cpt1.Vision_Contract_Number__c='123456';
            cpt1.Vision_Contract_Type__c = 'Indirect';
            cpt.Vision_Awarded_Volume__c = 75;
            cpt.Vision_Awarded_Value__c = 85;
            cpt1.Vision_Current_Product_Position__c = 'Testing Current Product Position 1';
            cpt1.Vision_Is_In_Awarded__c = true;
            cpt1.Is_Initial_Order__c = true;
            cpotlist.add(cpt1);
        }
        insert cpotlist;
          
          List<GCP_SFDC_Indirect_Sales__c> indirectSalesList = new List<GCP_SFDC_Indirect_Sales__c>();
          // Mar Month
      /*    GCP_SFDC_Indirect_Sales__c indirectSalesA1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c 04-03-2022
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='03-04-2022');*/
          GCP_SFDC_Indirect_Sales__c indirectSalesA2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300024550',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='04-03-2022',Vision_Settlement_Date_From__c='14/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesA3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300022350',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='',Vision_Settlement_Date_From__c='21/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesA4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300026750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='28/04/2022');
          // March month null data
          GCP_SFDC_Indirect_Sales__c indirectSalesAA1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='07/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesAA2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='14/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesAA3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='21/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesAA4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Mar 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='07/04/2022');
          // Feb Month
          GCP_SFDC_Indirect_Sales__c indirectSalesB1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='14/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesB2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='21/03/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesB3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='07/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesB4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='14/04/2022');
          // Feb month null data
          GCP_SFDC_Indirect_Sales__c indirectSalesBB1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='21/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesBB2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='07/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesBB3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='14/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesBB4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Feb 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2022',Vision_Settlement_Date_From__c='21/04/2022');
          // Jan Month
          GCP_SFDC_Indirect_Sales__c indirectSalesC1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='07/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesC2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='14/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesC3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='21/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesC4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='28/04/2022');
          // Jan month null data
          GCP_SFDC_Indirect_Sales__c indirectSalesCC1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='14/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesCC2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='28/04/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesCC3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='07/02/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesCC4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Jan 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='14/02/2022');
          // Dec Month
          GCP_SFDC_Indirect_Sales__c indirectSalesD1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='21/01/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesD2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='07/01/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesD3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='14/01/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesD4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='21/01/2022');
          // Dec month null data
          GCP_SFDC_Indirect_Sales__c indirectSalesDD1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='07/01/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesDD2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='14/01/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesDD3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='21/01/2022');
          GCP_SFDC_Indirect_Sales__c indirectSalesDD4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Dec 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='07/01/2022');
          // Nov Month
          GCP_SFDC_Indirect_Sales__c indirectSalesE1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='14/12/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesE2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='21/12/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesE3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='28/12/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesE4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='07/12/2021');
          // Nov month null data
          GCP_SFDC_Indirect_Sales__c indirectSalesEE1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='14/12/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesEE2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='21/12/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesEE3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='28/12/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesEE4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Nov 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='07/12/2021');
          // Oct Month
          GCP_SFDC_Indirect_Sales__c indirectSalesF1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='03/11/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesF2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='15/11/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesF3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='23/11/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesF4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c='12',
                                                                                Vision_Contract_Sales_Indirect_Price__c='1000',Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='22/04/2022');
          // Oct month null data
          GCP_SFDC_Indirect_Sales__c indirectSalesFF1 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='03/11/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesFF2 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='15/11/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesFF3 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='23/11/2021');
          GCP_SFDC_Indirect_Sales__c indirectSalesFF4 = new GCP_SFDC_Indirect_Sales__c(Vision_Account__c= acc.Id,Vision_Material_Number__c='300023750',Vision_Product__c=p.Id, 
                                                                                    Vision_Contract__c= ct.Id, Vision_Customer_Code__c ='154328',Vision_Conversion_Quantity__c=null,
                                                                                Vision_Contract_Sales_Indirect_Price__c=null,Vision_Month__c='Oct 22',
                                                                                Vision_Settlement_Date_To__c='03-01-2021',Vision_Settlement_Date_From__c='28/11/2021');
     
     
         // indirectSalesList.add(indirectSalesA1);
          indirectSalesList.add(indirectSalesA2);
          indirectSalesList.add(indirectSalesA3);
          indirectSalesList.add(indirectSalesA4);
          indirectSalesList.add(indirectSalesAA1);
          indirectSalesList.add(indirectSalesAA2);
          indirectSalesList.add(indirectSalesAA3);
          indirectSalesList.add(indirectSalesAA4);
          indirectSalesList.add(indirectSalesB1);
          indirectSalesList.add(indirectSalesB2);
          indirectSalesList.add(indirectSalesB3);
          indirectSalesList.add(indirectSalesB4);
          indirectSalesList.add(indirectSalesBB1);
          indirectSalesList.add(indirectSalesBB2);
          indirectSalesList.add(indirectSalesBB3);
          indirectSalesList.add(indirectSalesBB4);
          indirectSalesList.add(indirectSalesC1);
          indirectSalesList.add(indirectSalesC2);
          indirectSalesList.add(indirectSalesC3);
          indirectSalesList.add(indirectSalesC4);
          indirectSalesList.add(indirectSalesCC1);
          indirectSalesList.add(indirectSalesCC2);
          indirectSalesList.add(indirectSalesCC3);
          indirectSalesList.add(indirectSalesCC4);
          indirectSalesList.add(indirectSalesD1);
          indirectSalesList.add(indirectSalesD2);
          indirectSalesList.add(indirectSalesD3);
          indirectSalesList.add(indirectSalesD4);
          indirectSalesList.add(indirectSalesDD1);
          indirectSalesList.add(indirectSalesDD2);
          indirectSalesList.add(indirectSalesDD3);
          indirectSalesList.add(indirectSalesDD4);
          indirectSalesList.add(indirectSalesE1);
          indirectSalesList.add(indirectSalesE2);
          indirectSalesList.add(indirectSalesE3);
          indirectSalesList.add(indirectSalesE4);
          indirectSalesList.add(indirectSalesEE1);
          indirectSalesList.add(indirectSalesEE2);
          indirectSalesList.add(indirectSalesEE3);
          indirectSalesList.add(indirectSalesEE4);
          indirectSalesList.add(indirectSalesF1);
          indirectSalesList.add(indirectSalesF2);
          indirectSalesList.add(indirectSalesF3);
          indirectSalesList.add(indirectSalesF4);
          indirectSalesList.add(indirectSalesFF1);
          indirectSalesList.add(indirectSalesFF2);
          indirectSalesList.add(indirectSalesFF3);
          indirectSalesList.add(indirectSalesFF4);
          insert indirectSalesList;
          // Sample Rx Compliance Summary Records
          List<Rx_Compliance_Summary__c> insertionList = new List<Rx_Compliance_Summary__c>();
          Rx_Compliance_Summary__c summaryObj = new Rx_Compliance_Summary__c();
          summaryObj.Vision_Product__c = p.Id;
          summaryObj.Vision_Account__c = Acc.Id;
          summaryObj.Vision_Package_Size__c = p.Phoenix_Pkg_Size__c;
          summaryObj.M1_Indirect_Quantity__c = 10;
          summaryObj.M2_Indirect_Quantity__c = 10;
          summaryObj.M3_Indirect_Quantity__c = 10;
          summaryObj.M4_Indirect_Quantity__c = 10;
          summaryObj.M5_Indirect_Quantity__c = 10;
          summaryObj.M6_Indirect_Quantity__c = 10;
          summaryObj.Month1__c = 'Oct 22';
          summaryObj.Month2__c = 'Nov 22';
          summaryObj.Month3__c = 'Dec 22';
          summaryObj.Month4__c = 'Jan 22';
          summaryObj.Month5__c = 'Feb 22';
          summaryObj.Month6__c = 'Mar 22';
          //summaryObj.M2_Direct_Value_Compliance__c = 10;
          //summaryObj.M2_Indirect_Value_Compliance__c = 10;
          summaryObj.M1_Indirect_Net_Dollar__c = 10000;
          summaryObj.M2_Indirect_Net_Dollar__c = 10000;
          summaryObj.M3_Indirect_Net_Dollar__c = 10000;
          summaryObj.M4_Indirect_Net_Dollar__c = 10000;
          summaryObj.M5_Indirect_Net_Dollar__c = 10000;
          summaryObj.M6_Indirect_Net_Dollar__c = 10000;
          //summaryObj.Vision_Direct_Awarded_Qty__c = 50;
          //summaryObj.M2_Total_Compliance__c = 10;
          //summaryObj.Vision_Direct_Awarded_Value__c = 0;
          //summaryObj.Vision_Direct_Awarded_Value_Monthly__c = 0;
          summaryObj.Vision_Indirect_Awarded_Value__c = 1772;
          //summaryObj.Vision_Indirect_Awarded_Value_Monthly__c = 148;
          //summaryObj.Vision_Total_Awarded_Value__c = 1772;
          summaryObj.Indirect_Awarded_Position__c = 'Testing Awarded Position';
          summaryObj.Vision_Unique_Identifier__c = '154328-300023750';
          insertionList.add(summaryObj);
          Rx_Compliance_Summary__c summaryObj1 = new Rx_Compliance_Summary__c();
          summaryObj1.Vision_Product__c = p1.Id;
          summaryObj1.Vision_Account__c = Acc.Id;
          summaryObj1.Vision_Package_Size__c = p.Phoenix_Pkg_Size__c;
          summaryObj1.M1_Indirect_Quantity__c = 10;
          summaryObj1.M2_Indirect_Quantity__c = 10;
          summaryObj1.M3_Indirect_Quantity__c = 10;
          summaryObj1.M4_Indirect_Quantity__c = 10;
          summaryObj1.M5_Indirect_Quantity__c = 10;
          summaryObj1.M6_Indirect_Quantity__c = 10;
          summaryObj1.Month1__c = 'Oct 22';
          summaryObj1.Month2__c = 'Nov 22';
          summaryObj1.Month3__c = 'Dec 22';
          summaryObj1.Month3__c = 'Jan 22';
          summaryObj1.Month3__c = 'Feb 22';
          summaryObj1.Month3__c = 'Mar 22';
          //summaryObj.M2_Direct_Value_Compliance__c = 10;
          //summaryObj.M2_Indirect_Value_Compliance__c = 10;
          summaryObj1.M1_Indirect_Net_Dollar__c = 10000;
          summaryObj1.M2_Indirect_Net_Dollar__c = 10000;
          summaryObj1.M3_Indirect_Net_Dollar__c = 10000;
          summaryObj1.M4_Indirect_Net_Dollar__c = 10000;
          summaryObj1.M5_Indirect_Net_Dollar__c = 10000;
          summaryObj1.M6_Indirect_Net_Dollar__c = 10000;
          //summaryObj1.Vision_Direct_Awarded_Qty__c = 50;
          //summaryObj.M2_Total_Compliance__c = 10;
          //summaryObj1.Vision_Direct_Awarded_Value__c = 0;
          //summaryObj.Vision_Direct_Awarded_Value_Monthly__c = 0;
          summaryObj1.Vision_Indirect_Awarded_Value__c = 1772;
          //summaryObj.Vision_Indirect_Awarded_Value_Monthly__c = 148;
          //summaryObj.Vision_Total_Awarded_Value__c = 1772;
          summaryObj1.Indirect_Awarded_Position__c = 'Testing Awarded Position';
          summaryObj1.Vision_Unique_Identifier__c = '556738-60496672';
          insertionList.add(summaryObj1);
          upsert insertionList;
          Test.startTest();
         DataBase.executeBatch(new Rx_Compliance_Indirect_Sales_Batch());
         
          Test.stopTest();  
          
   }
}