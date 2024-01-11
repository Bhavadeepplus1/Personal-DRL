<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_GCP_Unique_Identifier_Update</fullName>
        <field>GCP_Unique_Identifier__c</field>
        <formula>Text(texcellency__DefHC_HospitalID__c)&amp;&quot;-&quot;&amp;Text( texcellency__DefHC_ExecutiveID__c )</formula>
        <name>Contact-GCP Unique Identifier Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inactive_Definitive_Is_Active_field</fullName>
        <field>texcellency__DefHC_Is_Active__c</field>
        <literalValue>0</literalValue>
        <name>Inactive &quot;Definitive Is Active&quot;  field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Contact%3AGCP Unique Indentifier Update</fullName>
        <actions>
            <name>Contact_GCP_Unique_Identifier_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.texcellency__DefHC_HospitalID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Inactive %22Definitive Is Active%22 Checkbox field</fullName>
        <actions>
            <name>Inactive_Definitive_Is_Active_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.texcellency__DefHC_HospitalID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When definitive id not in contact record level automatically Inactive &quot;Definitive Is Active&quot; Checkbox field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
