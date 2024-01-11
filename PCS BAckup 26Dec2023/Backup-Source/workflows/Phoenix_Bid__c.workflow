<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Phoenix_Customer_Bid_Deadline</fullName>
        <description>This will deaults customer bid dead line time as 6 PM and timezone as EST.</description>
        <field>Phoenix_Customer_Bid_Deadline_Date_Time__c</field>
        <formula>Phoenix_Customer_Bid_Deadline_Date_Time__c+18/24</formula>
        <name>Customer Bid Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Customer_Bid_Deadline_Time_Zone</fullName>
        <field>Phoenix_Customer_Bid_Deadline_Time_zone__c</field>
        <literalValue>EST</literalValue>
        <name>Customer Bid Deadline Time Zone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
