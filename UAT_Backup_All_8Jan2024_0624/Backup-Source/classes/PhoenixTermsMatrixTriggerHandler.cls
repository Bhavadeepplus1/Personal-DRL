public class PhoenixTermsMatrixTriggerHandler extends TriggerHandler{
	private list<Phoenix_Terms_Matrix__c> triggerNew;
    private list<Phoenix_Terms_Matrix__c> triggerOld;
    private Map<Id, Phoenix_Terms_Matrix__c> newMap;
    private Map<Id, Phoenix_Terms_Matrix__c> oldMap;
    
    public PhoenixTermsMatrixTriggerHandler(){
        this.newMap = (Map<Id, Phoenix_Terms_Matrix__c>)Trigger.newMap;
        this.oldMap = (Map<Id, Phoenix_Terms_Matrix__c>)Trigger.oldMap;
        this.triggerNew = (List<Phoenix_Terms_Matrix__c>)Trigger.new;
        this.triggerOld = (List<Phoenix_Terms_Matrix__c>)Trigger.old;
        
    }
    public override void beforeInsert(){
        
        for(Phoenix_Terms_Matrix__c termMatrix : triggerNew){
             termMatrix.Phoenix_Total_Rebate_Details1__c	= termMatrix.Phoenix_Customer_Rebate_CONSOLIDATED_Det__c;
             termMatrix.Phoenix_Total_Bonafide_Fee_Details1__c = termMatrix.Phoenix_Customer_BonafideFee_CONSOLIDATE__c ;
             termMatrix.Phoenix_Customary_Practices_not_in_AGR1__c = termMatrix.Phoenix_Customary_Practices_Customarily__c ;
        }
    }
    public override void beforeUpdate(){
        for(Phoenix_Terms_Matrix__c termMatrix : triggerNew ){
            termMatrix.Phoenix_Total_Rebate_Details1__c	= termMatrix.Phoenix_Customer_Rebate_CONSOLIDATED_Det__c;
            termMatrix.Phoenix_Total_Bonafide_Fee_Details1__c = termMatrix.Phoenix_Customer_BonafideFee_CONSOLIDATE__c ;
            termMatrix.Phoenix_Customary_Practices_not_in_AGR1__c = termMatrix.Phoenix_Customary_Practices_Customarily__c ;
        }
        
        
    }
}