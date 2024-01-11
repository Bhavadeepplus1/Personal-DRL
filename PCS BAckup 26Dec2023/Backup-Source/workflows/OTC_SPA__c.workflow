<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Final_Approval_Notification</fullName>
        <ccEmails>kkhimani@drreddys.com</ccEmails>
        <ccEmails>soliva@drreddys.com</ccEmails>
        <ccEmails>melabd@drreddys.com</ccEmails>
        <ccEmails>abhijitp@drreddys.com</ccEmails>
        <ccEmails>OTC_SPA_ExtendedUsers@drreddys.com</ccEmails>
        <description>Final Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>OTC_SPA_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/FinalReport</template>
    </alerts>
    <fieldUpdates>
        <fullName>Customer_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Customer Approved</literalValue>
        <name>Customer Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Customer Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finished_Good_Number_Update</fullName>
        <field>Finished_Good_Number__c</field>
        <formula>Product__r.ProductCode</formula>
        <name>Finished Good Number Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SPA_Submitted_Date</fullName>
        <description>This field update is used in SPA approval process to log Approval process submitted date.</description>
        <field>Submitted_Date__c</field>
        <formula>NOW()</formula>
        <name>SPA Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_as_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Status as Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Finance_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Finance-Approved</literalValue>
        <name>Update Finance Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Marketing_Director_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Marketing Director-Approved</literalValue>
        <name>Update Marketing Director Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Marketing_Team_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Marketing-Approved</literalValue>
        <name>Update Marketing Team Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SKU_Count</fullName>
        <field>SKU_Count__c</field>
        <formula>TEXT(Product__r.Count__c)</formula>
        <name>Update SKU Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_Marketing_VP_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Sales&amp; Marketing VP-Approved</literalValue>
        <name>Update Sales &amp; Marketing VP Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_Team_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Sales Team Approved</literalValue>
        <name>Update Sales Team Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_as_Contract_Accepted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Contracts-Accepted</literalValue>
        <name>Update Status as Contract Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_as_Pricing_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Pricing completed</literalValue>
        <name>Update Status as Pricing Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_as_Sales_Submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Sales-Submitted</literalValue>
        <name>Update Status as Sales-Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Finished Good Number</fullName>
        <actions>
            <name>Finished_Good_Number_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SKU_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OTC_SPA__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OTC_SPA__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Price Reduction</value>
        </criteriaItems>
        <description>Update Finished Good Number, SKU count from product object to OTC-SPA object.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
