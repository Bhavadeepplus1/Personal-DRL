/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   03-12-2020   Surender Patel (Dhruvsoft)   Initial Version
 **/
public class SAPCustomerTriggerHandler extends TriggerHandler {
	private list < SAP_Customer__c > triggerNew;
	private list < SAP_Customer__c > triggerOld;
	private Map < Id, SAP_Customer__c > newMap;
	private Map < Id, SAP_Customer__c > oldMap;

	public SAPCustomerTriggerHandler() {
		this.newMap = (Map < Id, SAP_Customer__c > ) Trigger.newMap;
		this.oldMap = (Map < Id, SAP_Customer__c > ) Trigger.oldMap;
		this.triggerNew = (List < SAP_Customer__c > ) Trigger.new;
		this.triggerOld = (List < SAP_Customer__c > ) Trigger.old;
	}

	public override void beforeInsert() {
		system.debug('---SAPCustomerTriggerHandler:beforeInsert()---');
		Map < String, String > sapCustomerToSfAccIdMap = new Map < String, String > ();
		set < String > parentCustomerIds = new set < String > ();

		SAP_Customer__c oldCustomer;
		for (SAP_Customer__c newCustomer: triggerNew) {
			if (newCustomer.Phoenix_Parent__c != null) {
				parentCustomerIds.add(newCustomer.Phoenix_Parent__c);
			}
		}
		system.debug('---parentCustomerIds---' + parentCustomerIds);
		//query parent cuser and their SF account Ids
		for (SAP_Customer__c parentCustomer: [Select Id, Name, Phoenix_SF_Customer_Name__c
				from SAP_Customer__c
				where ID IN: parentCustomerIds and Phoenix_SF_Customer_Name__c != null
			]) {
			sapCustomerToSfAccIdMap.put(parentCustomer.Id, parentCustomer.Phoenix_SF_Customer_Name__c);
		}

		for (SAP_Customer__c newCustomer: triggerNew) {
			if (newCustomer.Phoenix_Parent__c != null) {
				newCustomer.Phoenix_SF_Customer_Name__c = sapCustomerToSfAccIdMap.get(newCustomer.Phoenix_Parent__c);
			}
		}
	}

	public override void afterUpdate() {
		system.debug('---SAPCustomerTriggerHandler---');
		Map < String, String > sapCustomerToSfAccIdMap = new Map < String, String > ();

		SAP_Customer__c oldCustomer;
		for (SAP_Customer__c newCustomer: triggerNew) {
			oldCustomer = oldMap.get(newCustomer.Id);
			if (newCustomer.Phoenix_SF_Customer_Name__c != null && newCustomer.Phoenix_SF_Customer_Name__c != oldCustomer.Phoenix_SF_Customer_Name__c) {
				sapCustomerToSfAccIdMap.put(newCustomer.Id, newCustomer.Phoenix_SF_Customer_Name__c);
				//yes change in sf customer
				//then collect, SAP customer code

			}
		}
		system.debug('---sapCustomerToSfAccIdMap---' + sapCustomerToSfAccIdMap);

		if (!sapCustomerToSfAccIdMap.isEmpty()) {
			populateSFAccountIds(sapCustomerToSfAccIdMap);
		}
	}

	public void populateSFAccountIds(Map < String, String > sapCustomerToSfAccIdMap) {
		//query all child SF customers based on parent customer code
		list < SAP_Customer__c > childSAPCustomers = [Select Id, Name, Phoenix_SF_Customer_Parent__c, Phoenix_Parent__c, Phoenix_SF_Customer_Name__c, Phoenix_SF_Customer_Name__r.ParentId
			from SAP_Customer__c
			where Phoenix_Parent__c IN: sapCustomerToSfAccIdMap.keyset()
		];
		for (SAP_Customer__c cSapCustomer: childSAPCustomers) {
			cSapCustomer.Phoenix_SF_Customer_Name__c = sapCustomerToSfAccIdMap.get(cSapCustomer.Phoenix_Parent__c);
			//cSapCustomer.Phoenix_SF_Customer_Parent__c = sapCustomerToSfAccIdMap.get(cSapCustomer.Phoenix_Parent__c);
		}
		if (!childSAPCustomers.isEmpty()) {
			update childSAPCustomers;
		}
	}
}