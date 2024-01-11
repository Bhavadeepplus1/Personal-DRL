<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Updating_Rebate_Identifier</fullName>
        <field>Phoenix_Rebate_Identifier__c</field>
        <formula>LEFT(Phoenix_Customer__r.Name , 50)+&apos;_&apos;+ TEXT(MONTH( Phoenix_Start_Date__c ))+&quot;/&quot; +TEXT(DAY(Phoenix_Start_Date__c ))+&quot;/&quot; +TEXT(YEAR(Phoenix_Start_Date__c ))+&apos;_&apos;+TEXT(MONTH( Phoenix_End_Date__c ))+&quot;/&quot; +TEXT(DAY(Phoenix_End_Date__c ))+&quot;/&quot; +TEXT(YEAR(Phoenix_End_Date__c ))</formula>
        <name>Updating Rebate Identifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Updating Rebate Identifier</fullName>
        <actions>
            <name>Updating_Rebate_Identifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Phoenix_Bid_VIP_Rebate__c.Name</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Phoenix_Bid_VIP_Rebate__c.Phoenix_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Phoenix_Bid_VIP_Rebate__c.Phoenix_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
