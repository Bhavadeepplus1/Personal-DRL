<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Phoenix_Update_Product_History_Name</fullName>
        <field>Name</field>
        <formula>LEFT( Phoenix_Field_Name__c, 20)  &amp; &quot; &quot; &amp;   LEFT( TEXT( Phoenix_Modified_Date__c ), 10)</formula>
        <name>Update Product History Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Product History Name</fullName>
        <actions>
            <name>Phoenix_Update_Product_History_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Phoenix_Product_History__c.Name</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
