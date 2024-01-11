<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>GCP_Unique_Identifier_Update</fullName>
        <field>GCP_Unique_Identifier__c</field>
        <formula>Text(Definitive_Id__c)&amp;&quot;-&quot;&amp;SKU_Code__c&amp;&quot;-&quot;&amp;TEXT(MONTH(Month_Details__c))+&quot;/&quot; +TEXT(DAY(Month_Details__c))+&quot;/&quot; +TEXT(YEAR(Month_Details__c))</formula>
        <name>GCP Unique Identifier Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>GCP Unique Indentifier Update</fullName>
        <actions>
            <name>GCP_Unique_Identifier_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Charge_Back_Data__c.Definitive_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
