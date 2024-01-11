<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Phoenix_Best_Price_Email</fullName>
        <ccEmails>deepakktv@drreddys.com</ccEmails>
        <ccEmails>ssshah@drreddys.com</ccEmails>
        <description>Best Price Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>jcalvarez@drreddys.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>bright-support@drreddys.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Phoenix/Phoenix_Best_Price_Email</template>
    </alerts>
    <alerts>
        <fullName>Phoenix_Tracking_Customer_Email</fullName>
        <ccEmails>deepakktv@drreddys.com</ccEmails>
        <ccEmails>ssshah@drreddys.com</ccEmails>
        <description>Tracking Customer Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>jcalvarez@drreddys.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>bright-support@drreddys.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Phoenix/Phoenix_Tracking_Customer_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Phoenix_Product_GPI</fullName>
        <field>Phoenix_GPI_Generic_Product_Identifier__c</field>
        <formula>RIGHT ( LPAD(   Phoenix_GPI_Generic_Product_Identifier__c , 14, &apos;0&apos;) , 14 )</formula>
        <name>Product GPI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phoenix_Product_NDC_11</fullName>
        <field>Phoenix_NDC_11__c</field>
        <formula>RIGHT ( LPAD(  Phoenix_NDC_11__c  , 11, &apos;0&apos;) , 11 )</formula>
        <name>Product NDC-11</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Product GPI</fullName>
        <actions>
            <name>Phoenix_Product_GPI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Phoenix_GPI_Generic_Product_Identifier__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product NDC-11</fullName>
        <actions>
            <name>Phoenix_Product_NDC_11</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Product2.Phoenix_NDC_11__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
