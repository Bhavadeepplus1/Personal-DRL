/**
 * @description       :
 * @author            : Surender Patel (Dhruvsoft)
 * @group             :
 * @last modified on  : 03-12-2020
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   18-11-2020   Surender Patel (Dhruvsoft)   Initial Version
 **/
public class Phoenix_TermsMatrixList{
	@AuraEnabled
	public static WrapperClass getTermsMatrix(String recordId){
		WrapperClass wrapperCls = new WrapperClass();

		if (!recordId.startsWith('001')){
			try{
				recordId = [SELECT Phoenix_Customer__c
				            FROM Phoenix_Bid__c
				            WHERE Id = :recordId
				            LIMIT 1].Phoenix_Customer__c;
			} catch (Exception e){

			}

		}

		Set<Id> parentAccIds = new Set<Id>();
		parentAccIds.add(recordId);
		//Fetch related accounts
		Map<Id, Account> allAccMap = new Map<Id, Account>();
		//Map of all accounts
		for (Account acc : Database.query('SELECT ' + Phoenix_Util.customerFields+' FROM Account LIMIT 10000'))
			allAccMap.put(acc.Id, acc);
		String tempId = recordId;

		while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL){
			tempId = allAccMap.get(tempId).ParentId;
			parentAccIds.add(tempId);
		}

	

		wrapperCls.termsMatrixList = [SELECT id, Name, Phoenix_Customer_Name__c
		                              FROM Phoenix_Terms_Matrix__c
		                              WHERE Phoenix_Customer_Name__c IN :parentAccIds AND Phoenix_Status__c ='Active'
		                              ORDER BY Name ASC
		                              LIMIT 500];
		
		List<String> sectionNames = new List<String>{'Key_Terms','General_Information', 'Payment_Term_Information', 'System_Information', 'Term_and_Terminations', 'Health_System_GPO_Information', 'General_Financial_Terms', 'FTS_and_Service_Level_Penalties', 'PV_and_QA_Terms', 'Customer_Notes_and_Practices', 'Additional_Terms'};
		List<string> fieldSet;
		List<LayoutPage> listLayoutPage = new List<LayoutPage>();
		for (String secName : sectionNames){
			Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
			Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Phoenix_Terms_Matrix__c');
			Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
			Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(secName);
			List<Schema.FieldSetMember> fieldSetMemberList = fieldSetObj.getFields();
			fieldSet = new List<string>();
			for (Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList){
				fieldSet.add(fieldSetMemberObj.getFieldPath());
			}
			LayoutPage layout = new LayoutPage(secName.replace('_', ' '), fieldSet);
			listLayoutPage.add(layout);


		}
		wrapperCls.layoutList = listLayoutPage;
		return wrapperCls;
	}

	public class WrapperClass{
		@AuraEnabled
		public List<Phoenix_Terms_Matrix__c> termsMatrixList;
		@AuraEnabled
		public List<LayoutPage> layoutList;

		// =new List<String>{'Section 1','Payment Term','Section 2','Section 3','Section 4','Section 5','Section 6','Section 7','Section 8'};
		public WrapperClass(){
			termsMatrixList = new List<Phoenix_Terms_Matrix__c>();
			layoutList = new List<LayoutPage>();
		}
	}

	public class LayoutPage{
		@AuraEnabled
		public string sectionName;
		@AuraEnabled
		public List<string> fieldSet;
		public LayoutPage(String secName, List<string> fields){
			this.sectionName = secName;
			this.fieldSet = fields;
		}
	}
}