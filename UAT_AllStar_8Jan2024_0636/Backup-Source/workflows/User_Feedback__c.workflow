<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>User_Feedback_Email_Notiifcation</fullName>
        <ccEmails>techease@drreddys.com</ccEmails>
        <description>User Feedback Email Notiifcation</description>
        <protected>false</protected>
        <recipients>
            <recipient>ramakrishnay@drreddys.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>bright-support@drreddys.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/User_Feeback</template>
    </alerts>
    <rules>
        <fullName>Ticket%3A User Feeback</fullName>
        <actions>
            <name>User_Feedback_Email_Notiifcation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User_Feedback__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
