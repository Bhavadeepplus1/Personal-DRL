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
public class Phoenix_DirectCustomerOfferCtrl {
  public Phoenix_Bid__c bid {
    get;
    set;
  }
  public user currentuser {
    get;
    set;
  }
  public String LogoId {
    get;
    set;
  }
  public Phoenix_DirectCustomerOfferCtrl() {
    string BidId = Apexpages.CurrentPage().getParameters().get('BidID'); ////Apexpages.CurrentPage().getParameters().get('BidID');
    bid = new Phoenix_Bid__c();
    currentuser = [Select Id, Name, Email, Title from User where Id =: userinfo.getuserId()];

    if (BidId != null) bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Bid_Name__c, Phoenix_Contact__r.Name, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer__r.City__c, Phoenix_Customer__r.State__c, Phoenix_Customer__r.Zip__c, Phoenix_Customer__r.Street_Address_1__c, (Select Id, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Product__r.Name, Phoenix_Bid__c, Phoenix_Product__c, Phoenix_NDC__c, Phoenix_Product__r.Description, Phoenix_Product__r.Phoenix_Direct_Order_Price__c, Phoenix_Initial_Order_Discount__c from Bid_Line_Items__r) FROM Phoenix_Bid__c WHERE ID =: BidId LIMIT 1];
    system.debug('::::: ' + bid);
  }
}