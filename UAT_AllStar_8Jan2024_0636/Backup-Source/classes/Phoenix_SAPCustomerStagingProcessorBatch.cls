/*
Phoenix_SAPCustomerStagingProcessorBatch
* This controller is used to sync all SAP Customer Staging data to actual SAP Customer object
* It usually Identify which records to insert/update into SAP Customer object from staging table
*/
public class Phoenix_SAPCustomerStagingProcessorBatch implements Database.batchable < sObject > , Schedulable, Database.Stateful {

    Map < String, String > fieldsStagingToMasterMap = new Map < String, String > ();
    public Map < String, SAP_Customer__c > sapCustomerWithoutAccountMap = new Map < String, SAP_Customer__c > (); //Modified the line by Mamatha
    public Phoenix_SAPCustomerStagingProcessorBatch() {
        fieldsStagingToMasterMap.put('Phoenix_City__c', 'Phoenix_City__c');
        fieldsStagingToMasterMap.put('Phoenix_Country__c', 'Phoenix_Country__c');
        fieldsStagingToMasterMap.put('Phoenix_Distribution_Channel__c', 'Phoenix_Distribution_Channel__c');
        fieldsStagingToMasterMap.put('Phoenix_Division__c', 'Phoenix_Division__c');
        fieldsStagingToMasterMap.put('Phoenix_Effective_From__c', 'Phoenix_Valid_from__c');
        fieldsStagingToMasterMap.put('Phoenix_Effective_To__c', 'Phoenix_Valid_to__c');
        fieldsStagingToMasterMap.put('Phoenix_Parent_SAP_Customer_Code__c', 'Phoenix_Staging_Parent_SAP_Customer_Code__c');
        fieldsStagingToMasterMap.put('Phoenix_Postal_Code__c', 'Phoenix_Postal_Code__c');
        fieldsStagingToMasterMap.put('Phoenix_Region__c', 'Phoenix_Region__c');
        fieldsStagingToMasterMap.put('Phoenix_Sales_Organization__c', 'Phoenix_Sales_Organization__c');
        fieldsStagingToMasterMap.put('Phoenix_SAP_Customer_Code__c', 'Phoenix_SAP_Customer_Code__c');
        fieldsStagingToMasterMap.put('Phoenix_SAP_Customer_Group__c', 'Phoenix_Grouping__c');
        fieldsStagingToMasterMap.put('Phoenix_SAP_Customer_Name__c', 'Name');
        fieldsStagingToMasterMap.put('Phoenix_SAP_Created_Date__c', 'Phoenix_SAP_Customer_Created_Date__c');
        fieldsStagingToMasterMap.put('Phoenix_SAP_Customer_Name_2__c', 'Phoenix_SAP_Customer_Name_2__c');
        fieldsStagingToMasterMap.put('Phoenix_Street__c', 'Phoenix_Street__c');
        fieldsStagingToMasterMap.put('Phoenix_Partner_Function__c', 'Phoenix_Partner_Function__c');
    }

    //schedule controller
    public void execute(SchedulableContext sc) {
        database.executeBatch(new Phoenix_SAPCustomerStagingProcessorBatch(), 1);
    }

    //batchable controller
    public Database.QueryLocator start(Database.BatchableContext info) { //
        String status = 'Pending';
        String baseQuery = 'Select Id, Name, Phoenix_City__c, Phoenix_Country__c, Phoenix_Customer_Key__c, Phoenix_Distribution_Channel__c, Phoenix_Division__c, Phoenix_Effective_From__c, Phoenix_Effective_To__c, Phoenix_Parent_SAP_Customer__c, Phoenix_Parent_SAP_Customer_Code__c, Phoenix_Partner_Function__c, Phoenix_Postal_Code__c, Phoenix_Region__c, Phoenix_Sales_Organization__c, Phoenix_SAP_Created_Date__c, Phoenix_SAP_Customer_Code__c, Phoenix_SAP_Customer_Group__c, Phoenix_SAP_Customer_Name__c, Phoenix_SAP_Customer_Name_2__c, Phoenix_SAP_Modified_Date__c, Phoenix_Source_Type__c, Phoenix_Status__c, Phoenix_Street__c';

        baseQuery += ' FROM Phoenix_SAP_Customer_Staging__c WHERE Phoenix_Status__c=:status';
        if (Test.isRunningTest()) baseQuery += ' Limit 1';
        return Database.getQueryLocator(baseQuery);
    }

    public void execute(Database.BatchableContext info, List < Phoenix_SAP_Customer_Staging__c > scope) {
        List < SAP_Customer__c > upsertCustomerList = new List < SAP_Customer__c > ();

        // Initializing a Map to handle Division multi-picklist value in upsertion of SAP Customer
        Map < String, List < Phoenix_SAP_Customer_Staging__c >> sapCustStgDivisionHandleMap = new Map < String, List < Phoenix_SAP_Customer_Staging__c >> ();

        String sapCustomerkey;
        //collect SAP Customer staging records
        Map < String, Phoenix_SAP_Customer_Staging__c > stagingCustomersMap = new Map < String, Phoenix_SAP_Customer_Staging__c > ();
        Set < String > parentCodes = new Set < String > ();
        for (Phoenix_SAP_Customer_Staging__c customer: scope) {
            stagingCustomersMap.put(customer.Phoenix_SAP_Customer_Code__c, customer);

            //------Building Map for using that to update the Division field in upsertion of SAP Customer------START

            for (Phoenix_SAP_Customer_Staging__c newSAPCustStg: [SELECT Phoenix_SAP_Customer_Code__c, Phoenix_Division__c FROM Phoenix_SAP_Customer_Staging__c LIMIT 50000]) {
                if (sapCustStgDivisionHandleMap.containsKey(newSAPCustStg.Phoenix_SAP_Customer_Code__c)) {
                    List < Phoenix_SAP_Customer_Staging__c > stgList = sapCustStgDivisionHandleMap.get(newSAPCustStg.Phoenix_SAP_Customer_Code__c);
                    stgList.add(newSAPCustStg);
                    sapCustStgDivisionHandleMap.put(newSAPCustStg.Phoenix_SAP_Customer_Code__c, stgList);
                } else {
                    sapCustStgDivisionHandleMap.put(newSAPCustStg.Phoenix_SAP_Customer_Code__c, new List < Phoenix_SAP_Customer_Staging__c > {
                        newSAPCustStg
                    });
                }
            }

            //-----Building Map for using that to update the Division field in upsertion of SAP Customer------END 

            if (String.isNotBlank(customer.Phoenix_Parent_SAP_Customer_Code__c)) parentCodes.add(customer.Phoenix_Parent_SAP_Customer_Code__c);
        }

        //now collect sap customer data based on key
        Map < String, SAP_Customer__c > existingSAPCustomerMap = new Map < String, SAP_Customer__c > ();
        for (SAP_Customer__c customer: [Select Id, Name, Phoenix_Active__c, Phoenix_City__c, Phoenix_Country__c, Phoenix_Customer_Key__c, Phoenix_Distribution_Channel__c, Phoenix_Division__c, Phoenix_Grouping__c, Phoenix_Parent_Distribution_Channel__c, Phoenix_Parent_Division__c, Phoenix_Parent_Sales_Organization__c, Phoenix_Parent__c, Phoenix_Parent_SAP_Customer_Code__c, Phoenix_Part_of_Hierarchy__c, Phoenix_Postal_Code__c, Phoenix_Region__c, Phoenix_Sales_Organization__c, Phoenix_SAP_Customer_Code__c, Phoenix_SAP_Customer_Created_Date__c, SAP_Customer_Key__c, Phoenix_SAP_Customer_Name_2__c, Phoenix_SF_Customer_Name__c, Phoenix_SF_Customer_Parent__c, Phoenix_Street__c, Phoenix_Valid_from__c, Phoenix_Valid_to__c, Phoenix_Partner_Function__c
                from SAP_Customer__c where Phoenix_SAP_Customer_Code__c IN: parentCodes OR Phoenix_SAP_Customer_Code__c IN: stagingCustomersMap.keyset()
            ]) {
            existingSAPCustomerMap.put(customer.Phoenix_SAP_Customer_Code__c, customer);
        }

        Map < String, SAP_Customer__c > newParentsMap = new Map < String, SAP_Customer__c > ();
        for (String pCode: parentCodes) {
            //
            if ((existingSAPCustomerMap.get(pCode) == null) && (Integer.valueOf(pCode) >= 100000)) {
                SAP_Customer__c sapCustomer = new SAP_Customer__c(
                    Name = pCode,
                    Phoenix_SAP_Customer_Code__c = pCode
                );
                newParentsMap.put(pCode, sapCustomer);
            }
        }

        insert newParentsMap.values(); //Inserted new parents

        existingSAPCustomerMap.putAll(newParentsMap); //Updated all SAP customers

        Set < String > stagingCodes = new Set < String > ();
        for (SAP_Customer__c sapCus: existingSAPCustomerMap.values()) stagingCodes.add(sapCus.Phoenix_SAP_Customer_Code__c);

        //now collect accounts data based on staging customer nos
        Map < String, Account > existingAccountsMap = new Map < String, Account > ();

        for (Account acnt: [Select Id, Name, AccountNumber from Account where AccountNumber IN: stagingCodes]) {
            existingAccountsMap.put(acnt.AccountNumber, acnt);
        }

        Map < String, Account > newAcntMap = new Map < String, Account > ();
        for (String accntNo: stagingCodes) {
            if (!existingAccountsMap.containsKey(accntNo)) {
                SAP_Customer__c sapCus = existingSAPCustomerMap.get(accntNo);
                sapCustomerWithoutAccountMap.put(accntNo, sapCus); //Modified the line by Mamatha
                /*      Account acc =new Account(
Name = sapCus.Name,
AccountNumber = accntNo                  
); 
newAcntMap.put(accntNo,acc);  */
            }
        }
        // insert newAcntMap.values(); //Inserted new accounts
        // System.debug('newAcntMap.values()==>'+newAcntMap.values());

        existingAccountsMap.putAll(newAcntMap); //Updated all accounts to map
        List < Phoenix_SAP_Customer_Staging__c > stagingUpdateList = new List < Phoenix_SAP_Customer_Staging__c > ();
        for (String stagingKey: stagingCustomersMap.keySet()) {
            Phoenix_SAP_Customer_Staging__c customerStaging = stagingCustomersMap.get(stagingKey);
            customerStaging.Phoenix_Status__c = 'Completed';
            SAP_Customer__c sapCustomer = new SAP_Customer__c();
            sapCustomer.Name = customerStaging.Phoenix_SAP_Customer_Name__c;
            String masterField;
            for (String field: fieldsStagingToMasterMap.keySet()) {
                Object fieldValue = customerStaging.get(field);
                masterField = fieldsStagingToMasterMap.get(field);
                sapCustomer.put(masterField, fieldValue);
            }

            //-------Manipulating Division field in SAP Customer staging and upserting it into SAP Customer-----START-->
            //--**----Preventing upsertion of SAP Customer if the Customer Code is less than 6 digits----**--
            String divisions = ' ';
            Boolean Start = true;
            if (sapCustStgDivisionHandleMap.containskey(stagingKey) && (Integer.valueOf(stagingKey) >= 100000)) {
                List < Phoenix_SAP_Customer_Staging__c > customerStgForDiv = sapCustStgDivisionHandleMap.get(stagingKey);
                System.debug('----------customerStgForDiv---1------' + customerStgForDiv);
                for (Phoenix_SAP_Customer_Staging__c stg: customerStgForDiv) {
                    if (Start) {
                        if (stg.Phoenix_Division__c != null) {
                            divisions = stg.Phoenix_Division__c;
                            Start = false;
                        } else {
                            //  
                        }
                    } else {
                        if (!divisions.contains(stg.Phoenix_Division__c)) {
                            divisions = divisions + ';' + stg.Phoenix_Division__c;
                        } else {
                            //
                        }
                    }
                    sapCustomer.Phoenix_Division__c = divisions;
                }
            }

            //-------Manipulating Division field in SAP Customer staging and upserting it into SAP Customer-----END-->


            if (existingSAPCustomerMap.containskey(stagingKey)) {
                //exists customer
                sapCustomer.Id = existingSAPCustomerMap.get(stagingKey).Id;
                //sapCustomer.Phoenix_Division__c=existingSAPCustomerMap.get(stagingKey).Phoenix_Division__c;//Modified the line by Mamatha
            }
            if(existingAccountsMap.get(customerStaging.Phoenix_SAP_Customer_Code__c) != null)sapCustomer.Phoenix_SF_Customer_Name__c = existingAccountsMap.get(customerStaging.Phoenix_SAP_Customer_Code__c).Id;
            if (sapCustomer.Phoenix_Staging_Parent_SAP_Customer_Code__c != null && existingSAPCustomerMap.get(sapCustomer.Phoenix_Staging_Parent_SAP_Customer_Code__c) != null) {
                sapCustomer.Phoenix_Parent__c = existingSAPCustomerMap.get(sapCustomer.Phoenix_Staging_Parent_SAP_Customer_Code__c).Id;
            } else if (sapCustomer.Phoenix_Staging_Parent_SAP_Customer_Code__c != null && existingSAPCustomerMap.get(sapCustomer.Phoenix_Staging_Parent_SAP_Customer_Code__c) == null) {
                SAP_Customer__c sapParent = new SAP_Customer__c();
                sapParent.Name = customerStaging.Phoenix_Parent_SAP_Customer__c;
                String masterField1;
                for (String field: fieldsStagingToMasterMap.keySet()) {
                    Object fieldValue = customerStaging.get(field);
                    masterField1 = fieldsStagingToMasterMap.get(field);
                    sapParent.put(masterField1, fieldValue);
                }
                sapCustomer.Phoenix_Parent__c = sapParent.Id;
                upsertCustomerList.add(sapParent);
            }

            upsertCustomerList.add(sapCustomer);
            stagingUpdateList.add(customerStaging);
        }

        if (!upsertCustomerList.isEmpty()) {
            upsert upsertCustomerList;
        }

        if (!stagingUpdateList.isEmpty()) {
            update stagingUpdateList;
        }


    }
    public void finish(Database.BatchableContext info) { //Modified the line by Mamatha---START
        if (!sapCustomerWithoutAccountMap.isEmpty()) {
            String emailBody = '<html>Hi Team, <br/><br/> Find the below list of SAP Customers which does linked to Salesforce Customer.Please create Salesforce Customers for them.<br/><br/>';
            Integer i = 1;
            for (SAP_Customer__c sapCust: sapCustomerWithoutAccountMap.values()) {
                if (sapCust.Phoenix_SF_Customer_Name__c == null) {
                    emailBody += i + '.' + '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + sapCust.Id + '">' + sapCust.Name + '_' + sapCust.Phoenix_SAP_Customer_Code__c + '</a> <br/>';
                    i++;
                }
            }
            emailBody += '<br/>Thanks, <br/> Phoenix System Admin.</html>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Link SAP Customer With SF Customer');
            List < String > emailTo = new List < String > ();
            /*  for(User u: [Select Id, Email FROM User WHERE profile.Name = 'Contracts User'])
{
emailTo.add(u.email);
}
email.setToAddresses(emailTo);
email.setCcAddresses(emailTo);*/
            email.setToAddresses(new List < String > {
                'neela@dhruvsoft.com'
            });
            email.setCcAddresses(new List < String > {
                'surender@dhruvsoft.com'
            });
            email.setHtmlBody(emailBody);
            //  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });       

            /*  CronTrigger[] jobs = [SELECT CreatedById,CreatedDate,CronExpression,CronJobDetailId,CronJobDetail.Name,EndTime,Id,LastModifiedById,NextFireTime,OwnerId,PreviousFireTime,StartTime,State,TimesTriggered,TimeZoneSidKey FROM CronTrigger WHERE CronJobDetail.Name='Phoenix_NPRStagingProcessor'];
if (jobs.isEmpty()) {
if (!Test.isRunningTest())
{
Database.executeBatch(new Phoenix_SAPCustomerStagingProcessorBatch(),1);
//System.scheduleBatch(new Phoenix_SAPCustomerStagingProcessorBatch(),'Phoenix_SAPCustomerStagingProcessorBatch',2);
}
}*/
        }
    } //Modified the line by Mamatha---END
}