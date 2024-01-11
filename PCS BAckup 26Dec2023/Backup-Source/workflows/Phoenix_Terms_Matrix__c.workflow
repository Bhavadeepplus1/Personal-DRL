<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Terms_Matrix_Name</fullName>
        <description>Used update terms matrix name with customer name and agreement effective date</description>
        <field>Name</field>
        <formula>IF(
AND(NOT(ISNULL(Phoenix_Customer_Name__r.Name)),NOT(ISNULL(Phoenix_Customer_s_Agreement_Effective_D__c))),
Phoenix_Customer_Name__r.Name &amp; &quot; &quot; &amp; 
TEXT(Phoenix_Customer_s_Agreement_Effective_D__c),
IF(NOT(ISNULL(Phoenix_Customer_s_Agreement_Effective_D__c)),TEXT(Phoenix_Customer_s_Agreement_Effective_D__c),

IF(NOT(ISNULL(Phoenix_Customer_Name__r.Name)), 
Phoenix_Customer_Name__r.Name ,
&apos;Test&apos;

)

))</formula>
        <name>Update Terms Matrix Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Terms Matrix Name</fullName>
        <actions>
            <name>Update_Terms_Matrix_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR (NOT(ISNULL(Phoenix_Customer_s_Agreement_Effective_D__c)) ,  NOT(ISBLANK( Phoenix_Customer_Name__c ))   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
