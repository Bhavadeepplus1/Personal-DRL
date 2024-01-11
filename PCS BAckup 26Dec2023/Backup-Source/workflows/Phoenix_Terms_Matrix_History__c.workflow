<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Terms_Matrix_History_Id</fullName>
        <field>Name</field>
        <formula>LEFT( Phoenix_Field_Name__c, 20)  &amp; &quot; &quot; &amp;   LEFT( TEXT( Phoenix_Date__c ), 10)</formula>
        <name>Update Terms Matrix History Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Terms Matrix History Id</fullName>
        <actions>
            <name>Update_Terms_Matrix_History_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Phoenix_Terms_Matrix_History__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>used update the terms matrix history id with field name and modified date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
