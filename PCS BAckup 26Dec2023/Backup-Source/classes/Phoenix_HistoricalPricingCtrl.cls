/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Mamatha (Dhruvsoft)   Initial Version
**/
public class Phoenix_HistoricalPricingCtrl {

    @AuraEnabled public static list < wrapperClass > getHistoricalData(string recordId, boolean isCustomerLink, boolean isCustomerGroupLink) {

        list < wrapperClass > wrapList = new list < wrapperClass > ();
        List < Phoenix_NPR_Data__c > nprlist;
        //string customer='';
        string product = '';
        if (recordId != null && isCustomerLink == true) {
            product = '';

            Phoenix_Bid_Line_Item__c pbl = [select Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name from Phoenix_Bid_Line_Item__c where Id =: recordId];
            //customer= pbl.Phoenix_Bid__r.Phoenix_Customer__r.Name;
            product = pbl.Phoenix_Product__r.Name;
            //system.debug('customer---------'+customer);
            nprlist = [SELECT Phoenix_Product__c, Phoenix_Account__c, Phoenix_Account__r.Name, Phoenix_Contract_Price__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Dead_Net_High_GR__c FROM Phoenix_NPR_Data__c where(Phoenix_Product__c =: pbl.Phoenix_Product__c and Phoenix_Account__c =: pbl.Phoenix_Bid__r.Phoenix_Customer__c and Phoenix_Price_Effective_Value_From__c = LAST_N_DAYS: 540) ORDER BY Phoenix_Price_Effective_Value_From__c ASC limit 30000];

        }
        if (recordId != null && isCustomerGroupLink == true) {
            product = '';
            set < Id > accList = new set < Id > ();
            Phoenix_Bid_Line_Item__c pbl = [select Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__c from Phoenix_Bid_Line_Item__c where Id =: recordId];
            product = pbl.Phoenix_Product__r.Name;
            Account acc = [select Id, ParentId from Account where Id =: pbl.Phoenix_Bid__r.Phoenix_Customer__c];
            accList.add(acc.Id);
            If(acc.ParentId != null) {
                accList.add(acc.ParentId);
                Account accParent = [select Id, ParentId from Account where Id =: acc.ParentId];
                if (accParent.ParentId != null) {
                    accList.add(accParent.ParentId);
                }

            }
            //accList=[select Id from Account where Phoenix_Customer_Group_Type__c=:acc.Phoenix_Customer_Group_Type__c ];
            //accList=[select Id from Account where Phoenix_Customer_Group_Type__c=:acc.Phoenix_Customer_Group_Type__c ];
            nprlist = [SELECT Phoenix_Product__c, Phoenix_Account__c, Phoenix_Account__r.Name, Phoenix_Contract_Price__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Dead_Net_High_GR__c FROM Phoenix_NPR_Data__c where(Phoenix_Product__c =: pbl.Phoenix_Product__c and Phoenix_Account__c IN: accList and Phoenix_Price_Effective_Value_From__c = LAST_N_DAYS: 540) ORDER BY Phoenix_Price_Effective_Value_From__c ASC limit 30000];

        }
        for (Integer i = 0; i < nprlist.size(); i++) {
            Decimal change = 0;
            Decimal changePer = 0;
            Decimal changeDead = 0;
            Decimal changeDeadPer = 0;
            wrapperClass wrap = new wrapperClass();
            wrap.npr = nprlist[i];
            wrap.customerName = nprlist[i].Phoenix_Account__r.Name;
            if (i > 0) {


                if (nprlist[i].Phoenix_Contract_Price__c != null && nprlist[i - 1].Phoenix_Contract_Price__c != null) {
                    if (nprlist[i].Phoenix_Contract_Price__c > nprlist[i - 1].Phoenix_Contract_Price__c) {
                        change = nprlist[i].Phoenix_Contract_Price__c - nprlist[i - 1].Phoenix_Contract_Price__c;
                        changePer = (change / nprlist[i - 1].Phoenix_Contract_Price__c) * 100;
                        wrap.changePercent = changePer.setScale(2);
                        wrap.iconName = 'utility:arrowup';
                        wrap.fillColor = 'green';


                    } else if (nprlist[i].Phoenix_Contract_Price__c < nprlist[i - 1].Phoenix_Contract_Price__c) {
                        change = nprlist[i - 1].Phoenix_Contract_Price__c - nprlist[i].Phoenix_Contract_Price__c;
                        changePer = (change / nprlist[i - 1].Phoenix_Contract_Price__c) * 100;
                        wrap.changePercent = changePer.setScale(2);
                        wrap.iconName = 'utility:arrowdown';
                        wrap.fillColor = 'red';
                    } else {
                        change = nprlist[i - 1].Phoenix_Contract_Price__c - nprlist[i].Phoenix_Contract_Price__c;
                        changePer = (change / nprlist[i - 1].Phoenix_Contract_Price__c) * 100;
                        wrap.changePercent = changePer.setScale(2);
                        wrap.iconName = '';
                        wrap.fillColor = '';

                    }
                }
                if (nprlist[i].Phoenix_Dead_Net_High_GR__c != null && nprlist[i - 1].Phoenix_Dead_Net_High_GR__c != null) {
                    if (nprlist[i].Phoenix_Dead_Net_High_GR__c > nprlist[i - 1].Phoenix_Dead_Net_High_GR__c) {
                        changeDead = nprlist[i].Phoenix_Dead_Net_High_GR__c - nprlist[i - 1].Phoenix_Dead_Net_High_GR__c;
                        changeDeadPer = (changeDead / nprlist[i - 1].Phoenix_Dead_Net_High_GR__c) * 100;
                        wrap.changeDeadPercent = changeDeadPer.setScale(2);
                        wrap.iconNameDead = 'utility:arrowup';
                        wrap.fillColorDead = 'green';


                    } else if (nprlist[i].Phoenix_Dead_Net_High_GR__c < nprlist[i - 1].Phoenix_Dead_Net_High_GR__c) {
                        changeDead = nprlist[i - 1].Phoenix_Dead_Net_High_GR__c - nprlist[i].Phoenix_Dead_Net_High_GR__c;
                        changeDeadPer = (changeDead / nprlist[i - 1].Phoenix_Dead_Net_High_GR__c) * 100;
                        wrap.changeDeadPercent = changeDeadPer.setScale(2);
                        wrap.iconNameDead = 'utility:arrowdown';
                        wrap.fillColorDead = 'red';
                    } else {
                        changeDead = nprlist[i - 1].Phoenix_Dead_Net_High_GR__c - nprlist[i].Phoenix_Dead_Net_High_GR__c;
                        changeDeadPer = (changeDead / nprlist[i - 1].Phoenix_Dead_Net_High_GR__c) * 100;
                        wrap.changeDeadPercent = changeDeadPer.setScale(2);
                        wrap.iconNameDead = '';
                        wrap.fillColorDead = '';

                    }
                }


            } else {

                wrap.iconName = '';
                wrap.fillColor = '';
                wrap.iconNameDead = '';
                wrap.fillColorDead = '';

                //wrap.customerName=customer;
                wrap.productName = product;

            }

            wrapList.add(wrap);
        }
        return wrapList;
    }

    public class wrapperClass {


        @AuraEnabled
        public Phoenix_NPR_Data__c npr {
            get;
            set;
        }

        @AuraEnabled
        public Decimal changePercent {
            get;
            set;
        }

        @AuraEnabled
        public Decimal changeDeadPercent {
            get;
            set;
        }

        @AuraEnabled
        public String iconName {
            get;
            set;
        }

        @AuraEnabled
        public String iconNameDead {
            get;
            set;
        }

        @AuraEnabled
        public String fillColor {
            get;
            set;
        }

        @AuraEnabled
        public String customerName {
            get;
            set;
        }

        @AuraEnabled
        public String productName {
            get;
            set;
        }

        @AuraEnabled
        public String fillColorDead {
            get;
            set;
        }

        //@AuraEnabled
        //public String currencyCode{ get; set; }

        //@AuraEnabled
        //public Boolean isSelected{ get; set; }
    }
}