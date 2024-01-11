/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_NPR_Snapshot_Creator_Batch implements Database.Batchable < sObject > , Database.Stateful, Schedulable {

    //schedule controller
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new Phoenix_NPR_Snapshot_Creator_Batch(), 1000);
    }


    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT' + Phoenix_Util.nprDataFields + ' ,Phoenix_Account__r.Name,Phoenix_Product__r.Name,Phoenix_Contract__r.Name FROM Phoenix_NPR_Data__c';
        // String query = 'SELECT'+ Phoenix_Util.nprDataFields+' ,Phoenix_Account__r.Name,Phoenix_Product__r.Name,Phoenix_Contract__r.Name FROM Phoenix_NPR_Data__c WHERE Id=\'a0C0m000001iIUhEAM\'';

        if (Test.isRunningTest()) query += ' Limit 1';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List < Phoenix_NPR_Data__c > nprList) {
        try{
        List < Phoenix_NPR_Snapshot__c > newNPRSnapshotList = new List < Phoenix_NPR_Snapshot__c > ();
        for (Phoenix_NPR_Data__c npr: nprList) {
            DateTime todayDateTime = Datetime.now();
            String month = todayDateTime.format('MMMM'); //get month
            Integer year = todayDateTime.Year(); //get year
            Phoenix_NPR_Snapshot__c snapShot = new Phoenix_NPR_Snapshot__c();
            snapShot.Phoenix_NPR_Snapshot_Ref__c = npr.Name + '_' + month + '_' + year;
            snapShot.Phoenix_NPR_Data__c = npr.Id;
            snapShot.Phoenix_CD__c = npr.Phoenix_CD__c;
            snapShot.Phoenix_CD_in__c = npr.Phoenix_CD_in__c;
            snapShot.Phoenix_12Months_Actual_Sales_Unit__c = npr.Phoenix_12Months_Actual_Sales_Unit__c;
            snapShot.Phoenix_12Months_Net_Sales__c = npr.Phoenix_12Months_Net_Sales__c;
            snapShot.Phoenix_12Months_Sales_Unit__c = npr.Phoenix_12Months_Sales_Unit__c;
            snapShot.Phoenix_12Mt_Sales_Ut_Actual__c = npr.Phoenix_12Mt_Sales_Ut_Actual__c;
            snapShot.Phoenix_ABS__c = npr.Phoenix_ABS__c;
            snapShot.Phoenix_ABS_in__c = npr.Phoenix_ABS_in__c;
            snapShot.Phoenix_Add_ABS_Value__c = npr.Phoenix_Add_ABS_Value__c;
            snapShot.Phoenix_Bonafied_G_N_Indicator__c = npr.Phoenix_Bonafied_G_N_Indicator__c;
            snapShot.Phoenix_CM_Fee__c = npr.Phoenix_CM_Fee__c;
            snapShot.Phoenix_CM_Fee_in__c = npr.Phoenix_CM_Fee_in__c;
            snapShot.Phoenix_Comments_Section_1__c = npr.Phoenix_Comments_Section_1__c;
            snapShot.Phoenix_Comments_Section_2__c = npr.Phoenix_Comments_Section_2__c;
            snapShot.Phoenix_Comments_Section_3__c = npr.Phoenix_Comments_Section_3__c;
            snapShot.Phoenix_Contract__c = npr.Phoenix_Contract__c;
            snapShot.Phoenix_Contract_End_Date__c = npr.Phoenix_Contract_End_Date__c;
            snapShot.Phoenix_Contract_External_Description__c = npr.Phoenix_Contract_External_Description__c;
            snapShot.Phoenix_Contract_Internal_Description__c = npr.Phoenix_Contract_Internal_Description__c;
            snapShot.Phoenix_Contract_Number__c = npr.Phoenix_Contract_Number__c;
            snapShot.Phoenix_Contract_Price__c = npr.Phoenix_Contract_Price__c;
            snapShot.Phoenix_Contract_Start_Date__c = npr.Phoenix_Contract_Start_Date__c;
            snapShot.Phoenix_Contract_Type__c = npr.Phoenix_Contract_Type__c;
            snapShot.Phoenix_CP_Units__c = npr.Phoenix_CP_Units__c;
            snapShot.Phoenix_Account__c = npr.Phoenix_Account__c;
            snapShot.Phoenix_Customer_Group__c = npr.Phoenix_Customer_Group__c;
            snapShot.Phoenix_Customer_Number__c = npr.Phoenix_Customer_Number__c;
            snapShot.Phoenix_Dead_Net_High_GR__c = npr.Phoenix_Dead_Net_High_GR__c;
            snapShot.Phoenix_Dead_Net_Tracking_GR__c = npr.Phoenix_Dead_Net_Tracking_GR__c;
            snapShot.Phoenix_Fee_Bonafied_Fee__c = npr.Phoenix_Fee_Bonafied_Fee__c;
            snapShot.Phoenix_Fee_in_Value__c = npr.Phoenix_Fee_in_Value__c;
            snapShot.Phoenix_GR_HighTier_in__c = npr.Phoenix_GR_HighTier_in__c;
            snapShot.Phoenix_GR_Tracking_in__c = npr.Phoenix_GR_Tracking_in__c;
            snapShot.Phoenix_GR_TrackingTier__c = npr.Phoenix_GR_TrackingTier__c;
            snapShot.Phoenix_GR_Rebate_High_Tier__c = npr.Phoenix_GR_Rebate_High_Tier__c;
            snapShot.Phoenix_Indirect_Customers__c = npr.Phoenix_Indirect_Customers__c;
            snapShot.Phoenix_Market_Share__c = npr.Phoenix_Market_Share__c;
            snapShot.Phoenix_Material_Number__c = npr.Phoenix_Material_Number__c;
            snapShot.Phoenix_NDC_11__c = npr.Phoenix_NDC_11__c;
            snapShot.Phoenix_Net_Price_Fees_CD__c = npr.Phoenix_Net_Price_Fees_CD__c;
            snapShot.Phoenix_Net_Price_Fees_CD_HiGR__c = npr.Phoenix_Net_Price_Fees_CD_HiGR__c;
            snapShot.Phoenix_Net_Price_for_GR_basis__c = npr.Phoenix_Net_Price_for_GR_basis__c;
            snapShot.Phoenix_Net_Price_w_o_fee_CD__c = npr.Phoenix_Net_Price_w_o_fee_CD__c;
            snapShot.Phoenix_Net_Price_w_o_Fee_CD_HiGR__c = npr.Phoenix_Net_Price_w_o_Fee_CD_HiGR__c;
            snapShot.Phoenix_Net_Price_w_o_Fees__c = npr.Phoenix_Net_Price_w_o_Fees__c;
            snapShot.Phoenix_Net_Price_with_Fees__c = npr.Phoenix_Net_Price_with_Fees__c;
            snapShot.Phoenix_Net_Sales_90__c = npr.Phoenix_Net_Sales_90__c;
            snapShot.Phoenix_NPR_Customer_Code__c = npr.Phoenix_NPR_Customer_Code__c;
            snapShot.Phoenix_NPR_Customer_Name__c = npr.Phoenix_NPR_Customer_Name__c;
            snapShot.Phoenix_NPR_Status__c = npr.Phoenix_NPR_Status__c;
            snapShot.Phoenix_Per_Unit_Bonfied_Fee__c = npr.Phoenix_Per_Unit_Bonfied_Fee__c;
            snapShot.Phoenix_Per_Unit_Rebate__c = npr.Phoenix_Per_Unit_Rebate__c;
            snapShot.Phoenix_Price_Effective_Value_From__c = npr.Phoenix_Price_Effective_Value_From__c;
            snapShot.Phoenix_Price_Effective_Value_To__c = npr.Phoenix_Price_Effective_Value_To__c;
            snapShot.Phoenix_Product__c = npr.Phoenix_Product__c;
            snapShot.Phoenix_Product_Desc__c = npr.Phoenix_Product_Desc__c;
            snapShot.Phoenix_Product_Hierarchy__c = npr.Phoenix_Product_Hierarchy__c;
            snapShot.Phoenix_Product_Position__c = npr.Phoenix_Product_Position__c;
            snapShot.Phoenix_RDC_NLC__c = npr.Phoenix_RDC_NLC__c;
            snapShot.Phoenix_RDC_NLC_in__c = npr.Phoenix_RDC_NLC_in__c;
            snapShot.Phoenix_Rebate__c = npr.Phoenix_Rebate__c;
            snapShot.Phoenix_Rebate_in_Value__c = npr.Phoenix_Rebate_in_Value__c;
            snapShot.Phoenix_Rebate_G_N_Indicator__c = npr.Phoenix_Rebate_G_N_Indicator__c;
            snapShot.Phoenix_Sales_From_Date_for_last_90_Days__c = npr.Phoenix_Sales_From_Date_for_last_90_Days__c;
            snapShot.Phoenix_Sales_Group__c = npr.Phoenix_Sales_Group__c;
            snapShot.Phoenix_SalesUnit_90__c = npr.Phoenix_SalesUnit_90__c;
            snapShot.Phoenix_SF_Product_Description__c = npr.Phoenix_SF_Product_Description__c;
            snapShot.Phoenix_SF_Product_Family__c = npr.Phoenix_SF_Product_Family__c;
            snapShot.Phoenix_tracking_Gr_annual_usage_Sales__c = npr.Phoenix_tracking_Gr_annual_usage_Sales__c;
            snapShot.Phoenix_Tracking_Gr_last_12_months_Sales__c = npr.Phoenix_Tracking_Gr_last_12_months_Sales__c;
            snapShot.Phoenix_UPC_NDC10__c = npr.Phoenix_UPC_NDC10__c;
            snapShot.Phoenix_Vistex_Description__c = npr.Phoenix_Vistex_Description__c;
            snapShot.Phoenix_Vistex_Product_Hierarchy__c = npr.Phoenix_Vistex_Product_Hierarchy__c;
            snapShot.Phoenix_WAC__c = npr.Phoenix_WAC__c;
            snapShot.Phoenix_WAC_Check__c = npr.Phoenix_WAC_Check__c;
            snapShot.Phoenix_WAC_Units__c = npr.Phoenix_WAC_Units__c;
            snapShot.Phoenix_ZD07_Off_Inv__c = npr.Phoenix_ZD07_Off_Inv__c;
            snapShot.Phoenix_ZD07_Off_InvCurrency__c = npr.Phoenix_ZD07_Off_InvCurrency__c;
            snapShot.Phoenix_ZITD_Value__c = npr.Phoenix_ZITD_Value__c;
            snapShot.Phoenix_Customer_Name__c = npr.Phoenix_Account__r.Name;
            snapShot.Phoenix_Product_Name__c = npr.Phoenix_Product__r.Name;
            snapShot.Phoenix_Contract_Name__c = npr.Phoenix_Contract__r.Name;
            snapShot.Phoenix_Customer_Bucket__c = npr.Phoenix_Customer_Bucket__c;
            snapShot.Phoenix_Date__c = system.today();
            newNPRSnapshotList.add(snapShot);

        }
        if (!newNPRSnapshotList.isEmpty())
            insert newNPRSnapshotList;
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_NPR_Snapshot_Creator_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }

        
    }
    public void finish(Database.BatchableContext BC) {}
}