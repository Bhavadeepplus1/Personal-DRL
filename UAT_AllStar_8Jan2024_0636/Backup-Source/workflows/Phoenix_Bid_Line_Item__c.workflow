<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Phoenix_Estimated_Medicaid_Returns</fullName>
        <field>Phoenix_Estimated_Medicaid_Returns__c</field>
        <formula>(Phoenix_Gross_Contract_Sales__c-Phoenix_Value_Rebate__c - Phoenix_Value_Per_Unit_Rebate__c-Phoenix_Value_Admin_Fee__c - Phoenix_Value_Est_VIP__c)*0.02</formula>
        <name>Estimated Medicaid &amp; Returns</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Internal_Dead_Net_Price</fullName>
        <field>Phoenix_Internal_Dead_Net_Price__c</field>
        <formula>IF(Phoenix_Final_Total_Selling_Unit__c=0,0,Phoenix_Net_Sales_Internal__c / Phoenix_Final_Total_Selling_Unit__c)</formula>
        <name>Internal Dead Net Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Net_Price_after_Rebates</fullName>
        <field>Phoenix_Net_Price_after_RebatesbeforeVIP__c</field>
        <formula>IF(Phoenix_Gross_Contract_Sales__c  =0,0,( Phoenix_Gross_Contract_Sales__c - Phoenix_Value_Rebate__c - Phoenix_Value_Per_Unit_Rebate__c - Phoenix_Value_Admin_Fee__c - Phoenix_Sales_Out_Promotion__c - Phoenix_Initial_Order_Discount__c )/Phoenix_Final_Total_Selling_Unit__c )</formula>
        <name>Net Price after Rebates (before VIP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Net_Price_after_Rebates_Terms</fullName>
        <field>Phoenix_Net_Price_after_Rebates_Terms__c</field>
        <formula>IF(Phoenix_Final_Total_Selling_Unit__c=0,0,Phoenix_Net_Sales_External__c / Phoenix_Final_Total_Selling_Unit__c)</formula>
        <name>Net Price after Rebates &amp; Terms</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Net_Price_after_Rebates_after</fullName>
        <field>Phoenix_Net_Price_afterRebates_after_VIP__c</field>
        <formula>IF( Phoenix_Gross_Contract_Sales__c  =0,0,(Phoenix_Gross_Contract_Sales__c- Phoenix_Value_Rebate__c - Phoenix_Value_Per_Unit_Rebate__c - Phoenix_Value_Admin_Fee__c - Phoenix_Value_Est_VIP__c - Phoenix_Sales_Out_Promotion__c - Phoenix_Initial_Order_Discount__c )/ Phoenix_Final_Total_Selling_Unit__c )</formula>
        <name>Net Price after Rebates (after VIP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Net_Sales_External</fullName>
        <field>Phoenix_Net_Sales_External__c</field>
        <formula>Phoenix_Gross_Contract_Sales__c - Phoenix_Value_Rebate__c - Phoenix_Value_Per_Unit_Rebate__c - Phoenix_Value_Admin_Fee__c - Phoenix_Value_Est_VIP__c - Phoenix_Sales_Out_Promotion__c - Phoenix_Initial_Order_Discount__c</formula>
        <name>Net Sales (External)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Net_Sales_Internal</fullName>
        <field>Phoenix_Net_Sales_Internal__c</field>
        <formula>Phoenix_Gross_Contract_Sales__c  - Phoenix_Value_Rebate__c - Phoenix_Value_Per_Unit_Rebate__c - Phoenix_Value_Admin_Fee__c - Phoenix_Value_Est_VIP__c - Phoenix_Sales_Out_Promotion__c - Phoenix_Initial_Order_Discount__c -  Phoenix_Contr_Management_Fee_Wholesaler__c - Phoenix_Cash_Terms_Weighted__c - Phoenix_Estimated_Medicaid_Returns__c</formula>
        <name>Net Sales (Internal)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Formula fields in Bid Line Item</fullName>
        <actions>
            <name>Phoenix_Estimated_Medicaid_Returns</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phoenix_Internal_Dead_Net_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phoenix_Net_Price_after_Rebates</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phoenix_Net_Price_after_Rebates_Terms</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phoenix_Net_Price_after_Rebates_after</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phoenix_Net_Sales_External</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phoenix_Net_Sales_Internal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISBLANK(Name ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
