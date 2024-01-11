/**
 * @description       :
 * @author            : Surender Patel (Dhruvsoft)
 * @group             :
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   03-12-2020   Surender Patel (Dhruvsoft)   Initial Version
 **/
public class Phoenix_TermMatrixEditCtrl {
	@AuraEnabled
	public static WrapperClass getTermsMatrix(String recordId) {
		WrapperClass wrapperCls = new WrapperClass();
		if (recordId != null)
			wrapperCls.termsMatrix = [SELECT Id, Name
				FROM Phoenix_Terms_Matrix__c
				WHERE Id =: recordId
				LIMIT 1
			];
		List < String > sectionNames = new List < String > {
			'Key_Terms',
			'General_Information',
			'Payment_Term_Information',
			'System_Information',
			'Term_and_Terminations',
			'Health_System_GPO_Information',
			'General_Financial_Terms',
			'FTS_and_Service_Level_Penalties',
			'PV_and_QA_Terms',
			'Customer_Notes_and_Practices',
			'Additional_Terms'
		};
		List < string > fieldSet;
		List < LayoutPage > listLayoutPage = new List < LayoutPage > ();
		for (String secName: sectionNames) {
			Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
			Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Phoenix_Terms_Matrix__c');
			Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
			Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(secName);
			List < Schema.FieldSetMember > fieldSetMemberList = fieldSetObj.getFields();
			fieldSet = new List < string > ();
			for (Schema.FieldSetMember fieldSetMemberObj: fieldSetMemberList) {
				fieldSet.add(fieldSetMemberObj.getFieldPath());
			}
			LayoutPage layout = new LayoutPage(secName.replace('_', ' '), fieldSet);
			listLayoutPage.add(layout);


		}
		wrapperCls.layoutList = listLayoutPage;
		return wrapperCls;
	}

	public class WrapperClass {
		@AuraEnabled
		public Phoenix_Terms_Matrix__c termsMatrix;
		@AuraEnabled
		public List < LayoutPage > layoutList;

		// =new List<String>{'Section 1','Payment Term','Section 2','Section 3','Section 4','Section 5','Section 6','Section 7','Section 8'};
		public WrapperClass() {
			termsMatrix = new Phoenix_Terms_Matrix__c();
			layoutList = new List < LayoutPage > ();
		}
	}

	public class LayoutPage {
		@AuraEnabled
		public string sectionName;
		@AuraEnabled
		public List < string > fieldSet;
		@AuraEnabled
		public List < SeperateFields > sepFields;
		public LayoutPage(String secName, List < string > fields) {
			this.sectionName = secName;
			this.fieldSet = fields;
			sepFields = new List < SeperateFields > ();
			for (Integer i = 0; i < fields.size(); i = i + 2) {
				if (i + 1 < fields.size()) {
					SeperateFields sf = new SeperateFields(fields[i], fields[i + 1]);
					sepFields.add(sf);
				}
			}
			if (math.mod(fields.size(), 2) == 1) {
				SeperateFields sf = new SeperateFields(fields[fields.size() - 1], null);
				sepFields.add(sf);
			}
		}
	}

	public class SeperateFields {
		@AuraEnabled
		public String firstField;
		@AuraEnabled
		public String secondField;
		public SeperateFields(String first, String second) {
			this.firstField = first;
			this.secondField = second;
		}
	}
}