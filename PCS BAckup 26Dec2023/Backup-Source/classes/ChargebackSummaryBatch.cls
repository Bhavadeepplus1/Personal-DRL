public class ChargebackSummaryBatch implements Database.Batchable <sObject> ,Schedulable{
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ChargebackSummaryBatch());
    }
    public database.QueryLocator start(database.BatchableContext bc){
      string contact = '3000000437';
      string Hospital_Name='CommonSpirit Health';
        string revised_product_family='Phytoniadone'; 
        string productcode='300027352';
        string Child_1='560403';//  and Month_Year__c='Dec-22'
 
       // string mon='Dec-22';
        string query='select Product__r.productcode,'+Phoenix_Util.getsObjectFieds('IDN_Charge_Back__c')+'from IDN_Charge_Back__c where contact_id__c != :contact';
        return database.getQueryLocator(query);
    }
    public void execute(database.BatchableContext bc ,list<IDN_Charge_Back__c> chargebacklist){
        system.debug('chargebacklist.size()====='+chargebacklist.size());
        if(chargebacklist.size()>0){
            try{
                set<String> UniqueIds = new set<String>();
                
                Map<String,Map<String,String>> SummaryMap = new Map<String,Map<String,String>>();
                string uniqueid='';
                for(IDN_Charge_Back__c item:chargebacklist){
                    if(item.Hospital_Name__c!=null && item.Child_1__c!=null && item.revised_product_family__c!=null && item.Product__r.productcode!=null && item.Month_Year__c!=null){
                        uniqueid=item.contact_id__c+'-'+item.Hospital_Name__c+'-' +item.Child_1__c+'-' +item.Child_2__c+'-' +item.revised_product_family__c+'-'+item.Sales_Rep_Territory__c+'-'+ item.Product__r.productcode+'_'+item.Vision_Unique_Identifier__c;
                        UniqueIds.add(item.contact_id__c+'-'+item.Hospital_Name__c+'-' +item.Child_1__c+'-' +item.Child_2__c+'-' +item.revised_product_family__c+'-'+item.Sales_Rep_Territory__c+'-'+ item.Product__r.productcode+'-'+item.Month_Year__c);
                        if(SummaryMap.containskey(UniqueId)){
                            Map<String,String> oneStepInnerMap = SummaryMap.get(uniqueId);
                            if(item.Hospital_Name__c!=null){
                                onestepinnermap.put('HospitalName',string.valueof(item.Hospital_Name__c));
                            }
                            if(item.Child_1__c!=null){
                                onestepinnermap.put('child1',string.valueof(item.Child_1__c));
                            }
                            if(item.revised_product_family__c!=null){
                                onestepinnermap.put('productfamily',string.valueof(item.revised_product_family__c));
                            }
                            
                            if(item.Product__r.productcode!=null){
                                onestepinnermap.put('productcode',string.valueof(item.Product__r.productcode));
                            }
                            if(item.Month_Year__c!=null){
                                onestepinnermap.put('month',string.valueof(item.Month_Year__c));
                            }
                            if(item.Account__c!=null){
                                onestepinnermap.put('Acc',string.valueof(item.Account__c));
                            }
                            if(item.Address__c!=null){
                                onestepinnermap.put('address',string.valueof(item.Address__c));
                            }
                            if(item.Category__c!=null){
                                onestepinnermap.put('category',string.valueof(item.Category__c));
                            }
                            if(item.Child_2__c!=null){
                                onestepinnermap.put('child2',string.valueof(item.Child_2__c));
                            }
                            if(item.Child1_Firm_Type__c!=null){
                                onestepinnermap.put('Child1_Firm_Type__c',string.valueof(item.Child1_Firm_Type__c));
                            }
                            if(item.Child1_Name__c!=null){
                                onestepinnermap.put('Child1_Name__c',string.valueof(item.Child1_Name__c));
                            }
                            if(item.Child2_Firm_Type__c!=null){
                                onestepinnermap.put('Child2_Firm_Type__c',string.valueof(item.Child2_Firm_Type__c));
                            }
                            if(item.Child2_Name__c!=null){
                                onestepinnermap.put('Child2_Name__c',string.valueof(item.Child2_Name__c));
                            }
                            if(item.Claim_date__c!=null){
                                onestepinnermap.put('Claim_date__c',string.valueof(item.Claim_date__c));
                            }
                            if(item.Contact_Description__c!=null){
                                onestepinnermap.put('Contact_Description__c',string.valueof(item.Contact_Description__c));
                            }
                            if(item.contact_id__c!=null){
                                onestepinnermap.put('contact_id__c',string.valueof(item.contact_id__c));
                            }
                            if(item.Contract__c!=null){
                                onestepinnermap.put('Contract__c',string.valueof(item.Contract__c));
                            }
                            if(item.Contract_Sales_Indirect_Price__c!=null){
                                onestepinnermap.put('Contract_Sales_Indirect_Price__c',string.valueof(item.Contract_Sales_Indirect_Price__c));
                            }
                            if(item.contract_units_paid_qty__c!=null){
                                onestepinnermap.put('contract_units_paid_qty__c',string.valueof(item.contract_units_paid_qty__c));
                            }
                            if(item.CR_Number__c!=null){
                                onestepinnermap.put('CR_Number__c',string.valueof(item.CR_Number__c));
                            }
                            if(item.Customer_Name__c!=null){
                                onestepinnermap.put('Customer_Name__c',string.valueof(item.Customer_Name__c));
                            }
                            if(item.customer_segment__c!=null){
                                onestepinnermap.put('customer_segment__c',string.valueof(item.customer_segment__c));
                            }
                            if(item.Dea_Number__c!=null){
                                onestepinnermap.put('Dea_Number__c',string.valueof(item.Dea_Number__c));
                            }
                            if(item.Debit_Memo_Date__c!=null){
                                onestepinnermap.put('Debit_Memo_Date__c',string.valueof(item.Debit_Memo_Date__c));
                            }
                            if(item.Debit_Memo_Number__c!=null){
                                onestepinnermap.put('Debit_Memo_Number__c',string.valueof(item.Debit_Memo_Number__c));
                            }
                            if(item.fiscal_quarter__c!=null){
                                onestepinnermap.put('fiscal_quarter__c',string.valueof(item.fiscal_quarter__c));
                            }
                            
                            if(item.Hospital_Name__c!=null){
                                onestepinnermap.put('Hospital_Name__c',string.valueof(item.Hospital_Name__c));
                            }
                            if(item.invoice_date__c!=null){
                                onestepinnermap.put('invoice_date__c',string.valueof(item.invoice_date__c));
                            }
                            if(item.invoice_number__c!=null){
                                onestepinnermap.put('invoice_number__c',string.valueof(item.invoice_number__c));
                            }
                            if(item.material_alias__c!=null){
                                onestepinnermap.put('material_alias__c',string.valueof(item.material_alias__c));
                            }
                            if(item.invoice_number__c!=null){
                                onestepinnermap.put('invoice_number__c',string.valueof(item.invoice_number__c));
                            }
                            if(item.material_description__c!=null){
                                onestepinnermap.put('material_description__c',string.valueof(item.material_description__c));
                            }
                            if(item.Material_Number__c!=null){
                                onestepinnermap.put('Material_Number__c',string.valueof(item.Material_Number__c));
                            }
                            if(item.member_city__c!=null){
                                onestepinnermap.put('member_city__c',string.valueof(item.member_city__c));
                            }
                            if(item.Member_Dea__c!=null){
                                onestepinnermap.put('Member_Dea__c',string.valueof(item.Member_Dea__c));
                            }
                            if(item.Member_Name__c!=null){
                                onestepinnermap.put('Member_Name__c',string.valueof(item.Member_Name__c));
                            }
                            if(item.Member_Number__c!=null){
                                onestepinnermap.put('Member_Number__c',string.valueof(item.Member_Number__c));
                            }
                            if(item.member_postal_code__c!=null){
                                onestepinnermap.put('member_postal_code__c',string.valueof(item.member_postal_code__c));
                            }
                            if(item.Member_State__c!=null){
                                onestepinnermap.put('Member_State__c',string.valueof(item.Member_State__c));
                            }                        
                            if(item.Member_Street__c!=null){
                                onestepinnermap.put('Member_Street__c',string.valueof(item.Member_Street__c));
                            }
                            if(item.NDC_Code__c!=null){
                                onestepinnermap.put('NDC_Code__c',string.valueof(item.NDC_Code__c));
                            }
                            if(item.Paid_Chargeback_Amount__c!=null){
                                onestepinnermap.put('Paid_Chargeback_Amount__c',string.valueof(item.Paid_Chargeback_Amount__c));
                            }
                            if(item.Parent_Firm_Type__c!=null){
                                onestepinnermap.put('Parent_Firm_Type__c',string.valueof(item.Parent_Firm_Type__c));
                            }
                            if(item.Product__c!=null){
                                onestepinnermap.put('Product__c',string.valueof(item.Product__c));
                            }
                            if(item.product_segment__c!=null){
                                onestepinnermap.put('product_segment__c',string.valueof(item.product_segment__c));
                            }
                            if(item.Region__c!=null){
                                onestepinnermap.put('Region__c',string.valueof(item.Region__c));
                            }
                            if(item.Rep_Dtls_Rep__c	!=null){
                                onestepinnermap.put('Rep_Dtls_Rep__c',string.valueof(item.Rep_Dtls_Rep__c	));
                            }
                            if(item.Sales_Rep_Territory__c	!=null){
                                onestepinnermap.put('Sales_Rep_Territory__c',string.valueof(item.Sales_Rep_Territory__c	));
                            }
                            if(item.Settlement_Number__c	!=null){
                                onestepinnermap.put('Settlement_Number__c',string.valueof(item.Settlement_Number__c	));
                            }
                            if(item.Settlement_Paid_Date__c	!=null){
                                onestepinnermap.put('Settlement_Paid_Date__c',string.valueof(item.Settlement_Paid_Date__c	));
                            }
                            if(item.Settlement_Week__c	!=null){
                                onestepinnermap.put('Settlement_Week__c',string.valueof(item.Settlement_Week__c));
                            }
                            if(item.Sold_to_Name__c	!=null){
                                onestepinnermap.put('Sold_to_Name__c',string.valueof(item.Sold_to_Name__c));
                            }
                            if(item.Submitter_Name__c!=null){
                                onestepinnermap.put('Submitter_Name__c',string.valueof(item.Submitter_Name__c));
                            }
                            if(item.Submitter_Number__c	!=null){
                                onestepinnermap.put('Sold_to_Name__c',string.valueof(item.Submitter_Number__c));
                            }
                            if(item.year_month__c	!=null){
                                onestepinnermap.put('year_month__c',string.valueof(item.year_month__c));
                            }
                            if(item.Zip_Dtls_Rep__c	!=null){
                                onestepinnermap.put('Zip_Dtls_Rep__c',string.valueof(item.Zip_Dtls_Rep__c));
                            }
                            
                        }
                        else{
                            map<string,string> onestepinnermap = new  map<string,string>();
                            if(item.Hospital_Name__c!=null){
                                onestepinnermap.put('HospitalName',string.valueof(item.Hospital_Name__c));
                            }
                            if(item.Child_1__c!=null){
                                onestepinnermap.put('child1',string.valueof(item.Child_1__c));
                            }
                            if(item.revised_product_family__c!=null){
                                onestepinnermap.put('productfamily',string.valueof(item.revised_product_family__c));
                            }
                            
                            if(item.Product__r.productcode!=null){
                                onestepinnermap.put('productcode',string.valueof(item.Product__r.productcode));
                            }
                            if(item.Month_Year__c!=null){
                                onestepinnermap.put('month',string.valueof(item.Month_Year__c));
                            }
                            if(item.Account__c!=null){
                                onestepinnermap.put('Acc',string.valueof(item.Account__c));
                            }
                            if(item.Address__c!=null){
                                onestepinnermap.put('address',string.valueof(item.Address__c));
                            }
                            if(item.Category__c!=null){
                                onestepinnermap.put('category',string.valueof(item.Category__c));
                            }
                            if(item.Child_2__c!=null){
                                onestepinnermap.put('child2',string.valueof(item.Child_2__c));
                            }
                            if(item.Child1_Firm_Type__c!=null){
                                onestepinnermap.put('Child1_Firm_Type__c',string.valueof(item.Child1_Firm_Type__c));
                            }
                            if(item.Child1_Name__c!=null){
                                onestepinnermap.put('Child1_Name__c',string.valueof(item.Child1_Name__c));
                            }
                            if(item.Child2_Firm_Type__c!=null){
                                onestepinnermap.put('Child2_Firm_Type__c',string.valueof(item.Child2_Firm_Type__c));
                            }
                            if(item.Child2_Name__c!=null){
                                onestepinnermap.put('Child2_Name__c',string.valueof(item.Child2_Name__c));
                            }
                            if(item.Claim_date__c!=null){
                                onestepinnermap.put('Claim_date__c',string.valueof(item.Claim_date__c));
                            }
                            if(item.Contact_Description__c!=null){
                                onestepinnermap.put('Contact_Description__c',string.valueof(item.Contact_Description__c));
                            }
                            if(item.contact_id__c!=null){
                                onestepinnermap.put('contact_id__c',string.valueof(item.contact_id__c));
                            }
                            if(item.Contract__c!=null){
                                onestepinnermap.put('Contract__c',string.valueof(item.Contract__c));
                            }
                            if(item.Contract_Sales_Indirect_Price__c!=null){
                                onestepinnermap.put('Contract_Sales_Indirect_Price__c',string.valueof(item.Contract_Sales_Indirect_Price__c));
                            }
                            if(item.contract_units_paid_qty__c!=null){
                                onestepinnermap.put('contract_units_paid_qty__c',string.valueof(item.contract_units_paid_qty__c));
                            }
                            if(item.CR_Number__c!=null){
                                onestepinnermap.put('CR_Number__c',string.valueof(item.CR_Number__c));
                            }
                            if(item.Customer_Name__c!=null){
                                onestepinnermap.put('Customer_Name__c',string.valueof(item.Customer_Name__c));
                            }
                            if(item.customer_segment__c!=null){
                                onestepinnermap.put('customer_segment__c',string.valueof(item.customer_segment__c));
                            }
                            if(item.Dea_Number__c!=null){
                                onestepinnermap.put('Dea_Number__c',string.valueof(item.Dea_Number__c));
                            }
                            if(item.Debit_Memo_Date__c!=null){
                                onestepinnermap.put('Debit_Memo_Date__c',string.valueof(item.Debit_Memo_Date__c));
                            }
                            if(item.Debit_Memo_Number__c!=null){
                                onestepinnermap.put('Debit_Memo_Number__c',string.valueof(item.Debit_Memo_Number__c));
                            }
                            if(item.fiscal_quarter__c!=null){
                                onestepinnermap.put('fiscal_quarter__c',string.valueof(item.fiscal_quarter__c));
                            }
                            
                            if(item.Hospital_Name__c!=null){
                                onestepinnermap.put('Hospital_Name__c',string.valueof(item.Hospital_Name__c));
                            }
                            if(item.invoice_date__c!=null){
                                onestepinnermap.put('invoice_date__c',string.valueof(item.invoice_date__c));
                            }
                            if(item.invoice_number__c!=null){
                                onestepinnermap.put('invoice_number__c',string.valueof(item.invoice_number__c));
                            }
                            if(item.material_alias__c!=null){
                                onestepinnermap.put('material_alias__c',string.valueof(item.material_alias__c));
                            }
                            if(item.invoice_number__c!=null){
                                onestepinnermap.put('invoice_number__c',string.valueof(item.invoice_number__c));
                            }
                            if(item.material_description__c!=null){
                                onestepinnermap.put('material_description__c',string.valueof(item.material_description__c));
                            }
                            if(item.Material_Number__c!=null){
                                onestepinnermap.put('Material_Number__c',string.valueof(item.Material_Number__c));
                            }
                            if(item.member_city__c!=null){
                                onestepinnermap.put('member_city__c',string.valueof(item.member_city__c));
                            }
                            if(item.Member_Dea__c!=null){
                                onestepinnermap.put('Member_Dea__c',string.valueof(item.Member_Dea__c));
                            }
                            if(item.Member_Name__c!=null){
                                onestepinnermap.put('Member_Name__c',string.valueof(item.Member_Name__c));
                            }
                            if(item.Member_Number__c!=null){
                                onestepinnermap.put('Member_Number__c',string.valueof(item.Member_Number__c));
                            }
                            if(item.member_postal_code__c!=null){
                                onestepinnermap.put('member_postal_code__c',string.valueof(item.member_postal_code__c));
                            }
                            if(item.Member_State__c!=null){
                                onestepinnermap.put('Member_State__c',string.valueof(item.Member_State__c));
                            }                        
                            if(item.Member_Street__c!=null){
                                onestepinnermap.put('Member_Street__c',string.valueof(item.Member_Street__c));
                            }
                            if(item.NDC_Code__c!=null){
                                onestepinnermap.put('NDC_Code__c',string.valueof(item.NDC_Code__c));
                            }
                            if(item.Paid_Chargeback_Amount__c!=null){
                                onestepinnermap.put('Paid_Chargeback_Amount__c',string.valueof(item.Paid_Chargeback_Amount__c));
                            }
                            if(item.Parent_Firm_Type__c!=null){
                                onestepinnermap.put('Parent_Firm_Type__c',string.valueof(item.Parent_Firm_Type__c));
                            }
                            if(item.Product__c!=null){
                                onestepinnermap.put('Product__c',string.valueof(item.Product__c));
                            }
                            if(item.product_segment__c!=null){
                                onestepinnermap.put('product_segment__c',string.valueof(item.product_segment__c));
                            }
                            if(item.Region__c!=null){
                                onestepinnermap.put('Region__c',string.valueof(item.Region__c));
                            }
                            if(item.Rep_Dtls_Rep__c	!=null){
                                onestepinnermap.put('Rep_Dtls_Rep__c',string.valueof(item.Rep_Dtls_Rep__c	));
                            }
                            if(item.Sales_Rep_Territory__c	!=null){
                                onestepinnermap.put('Sales_Rep_Territory__c',string.valueof(item.Sales_Rep_Territory__c	));
                            }
                            if(item.Settlement_Number__c	!=null){
                                onestepinnermap.put('Settlement_Number__c',string.valueof(item.Settlement_Number__c	));
                            }
                            if(item.Settlement_Paid_Date__c	!=null){
                                onestepinnermap.put('Settlement_Paid_Date__c',string.valueof(item.Settlement_Paid_Date__c	));
                            }
                            if(item.Settlement_Week__c	!=null){
                                onestepinnermap.put('Settlement_Week__c',string.valueof(item.Settlement_Week__c));
                            }
                            if(item.Sold_to_Name__c	!=null){
                                onestepinnermap.put('Sold_to_Name__c',string.valueof(item.Sold_to_Name__c));
                            }
                            if(item.Submitter_Name__c!=null){
                                onestepinnermap.put('Submitter_Name__c',string.valueof(item.Submitter_Name__c));
                            }
                            if(item.Submitter_Number__c	!=null){
                                onestepinnermap.put('Sold_to_Name__c',string.valueof(item.Submitter_Number__c));
                            }
                            if(item.year_month__c	!=null){
                                onestepinnermap.put('year_month__c',string.valueof(item.year_month__c));
                            }
                            if(item.Zip_Dtls_Rep__c	!=null){
                                onestepinnermap.put('Zip_Dtls_Rep__c',string.valueof(item.Zip_Dtls_Rep__c));
                            }
                            
                            
                           summarymap.put(UniqueId,onestepinnermap); 
                            
                        }
                        
                    }
                }
                system.debug('SummaryMap...'+SummaryMap);
                  system.debug('SummaryMap...'+SummaryMap.keyset());
                  system.debug('SummaryMap...'+SummaryMap.keyset().size());
                  system.debug('SummaryMap...'+SummaryMap.values().size());
                Map<String,IDN_Charge_Back_Summary__c> ChargebackSummaryMap = new Map<String,IDN_Charge_Back_Summary__c>();
                Map<String,IDN_Charge_Back_Summary__c> ExIstingChargebackSummaryMap = new Map<String,IDN_Charge_Back_Summary__c>();
                 String query = 'Select '+Phoenix_Util.getsObjectFieds('IDN_Charge_Back_Summary__c')+' from IDN_Charge_Back_Summary__c where Unique_Identifier__c IN:UniqueIds';
                for(IDN_Charge_Back_Summary__c existingRec : database.query(query)){
                    ExistingChargebackSummaryMap.put(existingRec.Unique_Identifier__c,existingRec);
                }
                
                for(String key:SummaryMap.keySet()){
                  string internalkey1= key.split('_')[0];
                      if(!ExistingChargebackSummaryMap.containskey(internalkey1)){
                        IDN_Charge_Back_Summary__c newrec = ChargebackSummaryMap.containsKey(internalkey1) ? ChargebackSummaryMap.get(internalkey1) : new IDN_Charge_Back_Summary__c();
                          newrec.Month_Year__c=summarymap.get(key).get('month');
                         // newrec.Contract_Sales_Indirect_Price__c= summarymap.get(key).get('Contract_Sales_Indirect_Price__c'));
                          if(newrec.Paid_Chargeback_Amount__c!=null){
                                  system.debug('newrec.Paid_Chargeback_Amount__c'+newrec.Paid_Chargeback_Amount__c);
                          }
                          //newrec.Paid_Chargeback_Amount__c= newrec.Paid_Chargeback_Amount__c!=null?(newrec.Paid_Chargeback_Amount__c+decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c'))):decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c'));
                          if(summarymap.get(key).get('Contract_Sales_Indirect_Price__c')!=null){
                          newrec.Contract_Sales_Indirect_Price__c=newrec.Contract_Sales_Indirect_Price__c!=null?newrec.Contract_Sales_Indirect_Price__c+decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c')):decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c'));
                          }
                          newrec.Paid_Chargeback_Amount__c= newrec.Paid_Chargeback_Amount__c!=null?newrec.Paid_Chargeback_Amount__c+decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c')):decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c'));
                           newrec.contract_units_paid_qty__c=newrec.contract_units_paid_qty__c!=null?newrec.contract_units_paid_qty__c+decimal.valueof(summarymap.get(key).get('contract_units_paid_qty__c')):Decimal.valueof(summarymap.get(key).get('contract_units_paid_qty__c'));
                          newrec.Child1_Firm_Type__c=summarymap.get(key).get('Child1_Firm_Type__c');
                            newrec.Account__c=summarymap.get(key).get('account');
                            newrec.Child1_Name__c=summarymap.get(key).get('Child1_Name__c');
                           newrec.Child_2__c=summarymap.get(key).get('Child_2__c');
                           newrec.Child2_Firm_Type__c=summarymap.get(key).get('Child2_Firm_Type__c');
                           newrec.Child2_Name__c=summarymap.get(key).get('Child2_Name__c');
                           newrec.Child_1__c=summarymap.get(key).get('child1');
                            newrec.Hospital_Name__c=summarymap.get(key).get('HospitalName');
                            newrec.revised_product_family__c=summarymap.get(key).get('productfamily');
                            newrec.Address__c=summarymap.get(key).get('address');
                            newrec.invoice_date__c=date.valueof(summarymap.get(key).get('invoice_date__c'));
                            newrec.Category__c=summarymap.get(key).get('category');
                            newrec.Claim_date__c=summarymap.get(key).get('Claim_date__c');
                            newrec.Contact_Description__c=summarymap.get(key).get('Contact_Description__c');
                            newrec.contact_id__c=summarymap.get(key).get('contact_id__c');
                            newrec.Contract__c=summarymap.get(key).get('Contract__c');
                           // newrec.Contract_Sales_Indirect_Price__c=summarymap.get(key).get('Contract_Sales_Indirect_Price__c')!=null?decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c')):null;
                         //   newrec.contract_units_paid_qty__c=decimal.valueof(summarymap.get(key).get('contract_units_paid_qty__c'));
                            newrec.CR_Number__c=summarymap.get(key).get('CR_Number__c');
                            newrec.Customer_Name__c=summarymap.get(key).get('Customer_Name__c');
                            newrec.customer_segment__c=summarymap.get(key).get('customer_segment__c');
                            newrec.Dea_Number__c=summarymap.get(key).get('Dea_Number__c');
                            newrec.Debit_Memo_Date__c=summarymap.get(key).get('Debit_Memo_Date__c');
                            newrec.Debit_Memo_Number__c=summarymap.get(key).get('Debit_Memo_Number__c');
                            newrec.fiscal_quarter__c=summarymap.get(key).get('fiscal_quarter__c');
                            newrec.Hospital_Id__c=summarymap.get(key).get('Hospital_Id__c');
                            //newrec.Name=summarymap.get(key).get('Name');
                            newrec.invoice_number__c=summarymap.get(key).get('invoice_number__c');
                            newrec.invoice_date__c=date.valueof(summarymap.get(key).get('invoice_date__c'));
                            newrec.material_alias__c=summarymap.get(key).get('material_alias__c');
                            newrec.material_description__c	=summarymap.get(key).get('material_description__c');
                            newrec.Material_Number__c=summarymap.get(key).get('Material_Number__c');
                            newrec.Member_Dea__c=summarymap.get(key).get('Member_Dea__c');
                            newrec.member_city__c=summarymap.get(key).get('member_city__c');
                            newrec.Member_Name__c=summarymap.get(key).get('Member_Name__c');
                            newrec.Member_Number__c=summarymap.get(key).get('Member_Number__c');
                            newrec.Member_State__c=summarymap.get(key).get('Member_State__c');
                           newrec.member_postal_code__c=summarymap.get(key).get('member_postal_code__c');
                          newrec.Member_Street__c=summarymap.get(key).get('Member_Street__c');
                         // newrec.Month_Year__c=summarymap.get(key).get('Month_Year__c');
                          newrec.NDC_Code__c=summarymap.get(key).get('NDC_Code__c');
                         // newrec.Paid_Chargeback_Amount__c=decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c'));
                          newrec.Parent_Firm_Type__c=summarymap.get(key).get('Parent_Firm_Type__c');
                          newrec.Product__c=summarymap.get(key).get('Product__c');
                          newrec.product_segment__c=summarymap.get(key).get('product_segment__c');
                          newrec.Region__c=summarymap.get(key).get('Region__c');
                          newrec.Rep_Dtls_Rep__c=summarymap.get(key).get('Rep_Dtls_Rep__c');
                          newrec.Sales_Rep_Territory__c=summarymap.get(key).get('Sales_Rep_Territory__c');
                          newrec.Settlement_Number__c=summarymap.get(key).get('Settlement_Number__c');
                          newrec.Settlement_Paid_Date__c=date.valueof(summarymap.get(key).get('Settlement_Paid_Date__c'));
                          newrec.Settlement_Week__c=date.valueof(summarymap.get(key).get('Settlement_Week__c'));
                          newrec.Sold_to_Name__c=summarymap.get(key).get('Sold_to_Name__c');
                          newrec.Sold_to_Number__c=summarymap.get(key).get('Sold_to_Number__c');
                          newrec.Submitter_Name__c=summarymap.get(key).get('Submitter_Name__c');
                          newrec.Submitter_Number__c=summarymap.get(key).get('Submitter_Number__c');
                          newrec.year_month__c=summarymap.get(key).get('year_month__c');
                          newrec.Zip_Dtls_Rep__c=summarymap.get(key).get('Zip_Dtls_Rep__c');
                          newrec.Unique_Identifier__c=internalkey1;
                           ChargebackSummaryMap.put(internalkey1,newrec);
                      }
                    else{
                         IDN_Charge_Back_Summary__c newrec = ExistingChargebackSummaryMap.get(internalkey1);
                          newrec.Month_Year__c=summarymap.get(key).get('month');
                    //  newrec.Contract_Sales_Indirect_Price__c=newrec.Contract_Sales_Indirect_Price__c!=null?newrec.Contract_Sales_Indirect_Price__c+decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c')):decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c'));
                         if(summarymap.get(key).get('Contract_Sales_Indirect_Price__c')!=null){
                          newrec.Contract_Sales_Indirect_Price__c=newrec.Contract_Sales_Indirect_Price__c!=null?newrec.Contract_Sales_Indirect_Price__c+decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c')):decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c'));
                          }
                        
                        newrec.Paid_Chargeback_Amount__c= newrec.Paid_Chargeback_Amount__c!=null?newrec.Paid_Chargeback_Amount__c+decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c')):decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c'));
                          newrec.Child1_Firm_Type__c=summarymap.get(key).get('Child1_Firm_Type__c');
                            newrec.Account__c=summarymap.get(key).get('account');
                            newrec.Child1_Name__c=summarymap.get(key).get('Child1_Name__c');
                           newrec.Child_2__c=summarymap.get(key).get('Child_2__c');
                           newrec.Child2_Firm_Type__c=summarymap.get(key).get('Child2_Firm_Type__c');
                           newrec.Child2_Name__c=summarymap.get(key).get('Child2_Name__c');
                           newrec.Child_1__c=summarymap.get(key).get('child1');
                            newrec.Hospital_Name__c=summarymap.get(key).get('HospitalName');
                            newrec.revised_product_family__c=summarymap.get(key).get('productfamily');
                            newrec.Address__c=summarymap.get(key).get('address');
                            newrec.invoice_date__c=date.valueof(summarymap.get(key).get('invoice_date__c'));
                            newrec.Category__c=summarymap.get(key).get('category');
                            newrec.Claim_date__c=summarymap.get(key).get('Claim_date__c');
                            newrec.Contact_Description__c=summarymap.get(key).get('Contact_Description__c');
                            newrec.contact_id__c=summarymap.get(key).get('contact_id__c');
                            newrec.Contract__c=summarymap.get(key).get('Contract__c');
                            //newrec.Contract_Sales_Indirect_Price__c=decimal.valueof(summarymap.get(key).get('Contract_Sales_Indirect_Price__c'));
                            newrec.contract_units_paid_qty__c=newrec.contract_units_paid_qty__c!=null?newrec.contract_units_paid_qty__c+decimal.valueof(summarymap.get(key).get('contract_units_paid_qty__c')):Decimal.valueof(summarymap.get(key).get('contract_units_paid_qty__c'));
                            newrec.CR_Number__c=summarymap.get(key).get('CR_Number__c');
                            newrec.Customer_Name__c=summarymap.get(key).get('Customer_Name__c');
                            newrec.customer_segment__c=summarymap.get(key).get('customer_segment__c');
                            newrec.Dea_Number__c=summarymap.get(key).get('Dea_Number__c');
                            newrec.Debit_Memo_Date__c=summarymap.get(key).get('Debit_Memo_Date__c');
                            newrec.Debit_Memo_Number__c=summarymap.get(key).get('Debit_Memo_Number__c');
                            newrec.fiscal_quarter__c=summarymap.get(key).get('fiscal_quarter__c');
                            newrec.Hospital_Id__c=summarymap.get(key).get('Hospital_Id__c');
                            //newrec.Name=summarymap.get(key).get('Name');
                            newrec.invoice_number__c=summarymap.get(key).get('invoice_number__c');
                            newrec.invoice_date__c=date.valueof(summarymap.get(key).get('invoice_date__c'));
                            newrec.material_alias__c=summarymap.get(key).get('material_alias__c');
                            newrec.material_description__c	=summarymap.get(key).get('material_description__c');
                            newrec.Material_Number__c=summarymap.get(key).get('Material_Number__c');
                            newrec.Member_Dea__c=summarymap.get(key).get('Member_Dea__c');
                            newrec.member_city__c=summarymap.get(key).get('member_city__c');
                            newrec.Member_Name__c=summarymap.get(key).get('Member_Name__c');
                            newrec.Member_Number__c=summarymap.get(key).get('Member_Number__c');
                            newrec.Member_State__c=summarymap.get(key).get('Member_State__c');
                           newrec.member_postal_code__c=summarymap.get(key).get('member_postal_code__c');
                          newrec.Member_Street__c=summarymap.get(key).get('Member_Street__c');
                         // newrec.Month_Year__c=summarymap.get(key).get('Month_Year__c');
                          newrec.NDC_Code__c=summarymap.get(key).get('NDC_Code__c');
                         // newrec.Paid_Chargeback_Amount__c=decimal.valueof(summarymap.get(key).get('Paid_Chargeback_Amount__c'));
                          newrec.Parent_Firm_Type__c=summarymap.get(key).get('Parent_Firm_Type__c');
                          newrec.Product__c=summarymap.get(key).get('Product__c');
                          newrec.product_segment__c=summarymap.get(key).get('product_segment__c');
                          newrec.Region__c=summarymap.get(key).get('Region__c');
                          newrec.Rep_Dtls_Rep__c=summarymap.get(key).get('Rep_Dtls_Rep__c');
                          newrec.Sales_Rep_Territory__c=summarymap.get(key).get('Sales_Rep_Territory__c');
                          newrec.Settlement_Number__c=summarymap.get(key).get('Settlement_Number__c');
                          newrec.Settlement_Paid_Date__c=date.valueof(summarymap.get(key).get('Settlement_Paid_Date__c'));
                          newrec.Settlement_Week__c=date.valueof(summarymap.get(key).get('Settlement_Week__c'));
                          newrec.Sold_to_Name__c=summarymap.get(key).get('Sold_to_Name__c');
                          newrec.Sold_to_Number__c=summarymap.get(key).get('Sold_to_Number__c');
                          newrec.Submitter_Name__c=summarymap.get(key).get('Submitter_Name__c');
                          newrec.Submitter_Number__c=summarymap.get(key).get('Submitter_Number__c');
                          newrec.year_month__c=summarymap.get(key).get('year_month__c');
                          newrec.Zip_Dtls_Rep__c=summarymap.get(key).get('Zip_Dtls_Rep__c');
                         newrec.Unique_Identifier__c=internalkey1;
                        ChargebackSummaryMap.put(internalkey1,newrec);
                        
                    }
                }
                if(ChargebackSummaryMap.size()>0){
                    upsert ChargebackSummaryMap.values();
                }
            }//try ending 
            catch(exception e){
                 Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'ChargebackSummaryBatch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;            }//catch ending
        }//ifblock of size ending
    }//method endiing 
    public void finish(database.BatchableContext bc){
        
    }
    
   
    
}