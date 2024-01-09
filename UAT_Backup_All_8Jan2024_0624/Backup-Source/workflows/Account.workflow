<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Strategy_Count_Update</fullName>
        <field>Total_Account_Strategy_Records__c</field>
        <formula>1</formula>
        <name>Account Strategy Count Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_0</fullName>
        <field>Account_Category__c</field>
        <literalValue>Category 0</literalValue>
        <name>Category 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_1</fullName>
        <field>Account_Category__c</field>
        <literalValue>Category 1</literalValue>
        <name>Category 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_2</fullName>
        <field>Account_Category__c</field>
        <literalValue>Category 2</literalValue>
        <name>Category 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_3</fullName>
        <field>Account_Category__c</field>
        <literalValue>Category 3</literalValue>
        <name>Category 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_4</fullName>
        <field>Account_Category__c</field>
        <literalValue>Category 4</literalValue>
        <name>Category 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_5</fullName>
        <field>Account_Category__c</field>
        <literalValue>Category 5</literalValue>
        <name>Category 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Category_6</fullName>
        <field>Account_Category__c</field>
        <literalValue>Category 6</literalValue>
        <name>Category 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_s_Buying_Strategy_Count_Update</fullName>
        <field>Total_Customer_s_Buying_Strategy__c</field>
        <formula>1</formula>
        <name>Customer&apos;s Buying Strategy Count Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Growth_Goal_Records_Count_Update</fullName>
        <field>Total_Growth_Goals_Records__c</field>
        <formula>1</formula>
        <name>Growth Goal Records Count Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Risks_Challenges_Records_Update</fullName>
        <field>Total_Risks_Challenges_Records__c</field>
        <formula>1</formula>
        <name>Risks &amp; Challenges Records Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Account_Overview_Records_Count_Upd</fullName>
        <field>Total_Account_Overview_Records__c</field>
        <formula>1</formula>
        <name>Account Overview Records Count Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Total Account Overview Records Count Update</fullName>
        <actions>
            <name>Total_Account_Overview_Records_Count_Upd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Overview__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow only used for Total Account Overview Count Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Account Strategy Count Update</fullName>
        <actions>
            <name>Account_Strategy_Count_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Strategy__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow only used for Total Account Strategy Count Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Customer%27s Buying Strategy Count Update</fullName>
        <actions>
            <name>Customer_s_Buying_Strategy_Count_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Customer_s_Buying_Strategy__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow only used for Total Customer&apos;s Buying Strategy Count Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Growth Goal Records Count Update</fullName>
        <actions>
            <name>Growth_Goal_Records_Count_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Growth_Goals__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow only used for Total Growth Goal Count Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Risks %26 Challenges Records Update</fullName>
        <actions>
            <name>Risks_Challenges_Records_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Risks_and_Challenges__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow only used for Total Risks &amp; Challenges Count Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
