/*

* @description       : This is a REST Class to calculate DeadnetPrice and return to Panorama.
* @author            : Sumanth
* @group             : 
* @last modified on  : 01-02-2022
* @last modified by  : Sumanth Dhruvsoft
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   01-02-2022   Sumanth Dhruvsoft   Initial Version

*/


@RestResource(urlMapping='/GetDeadnetPrice/*')//endpoint definition > {Salesforce Base URL}/services/apexrest/GetDeadnetPrice/


//This class is integration related class this comment was added just for copado testing.

global class Panaroma_GetDeadnetPrice_REST {
    @HttpPost
    global static responseWrapper  getDeadnetPrice(){
        RestRequest req = RestContext.request;
        Map<String, Object> body = new Map<String, Object>();
        responseWrapper responseJSON = new responseWrapper();
        String jsonBody = req.requestBody.toString();
        if (!String.isBlank(jsonBody)) {
            body = (Map<String, Object>)JSON.deserializeUntyped(jsonBody);
            system.debug('body.....'+body);
            
            //added by satya//
            String accNumber = body.containskey('AccountNumber')?string.valueof(body.get('AccountNumber')):null;
            string wac=body.containskey('WAC')?string.valueof(body.get('WAC')):null;
            string marketingprice=body.containskey('MarketingPrice')?string.valueof(body.get('MarketingPrice')):null;//RXSS(Retail Direct Marketing Price) || costco(Indirect Price)
            string wholesalerprice=body.containskey('WholesalerDiffPriceIndirect')?string.valueof(body.get('WholesalerDiffPriceIndirect')):null;//RXSS(Retail Indirect Marketing Price) 
            string productType=body.containskey('productType')?string.valueof(body.get('productType')):null;
            string contractType=body.containskey('contractType')?string.valueof(body.get('contractType')):null;
            //RXSS
            String retailDirectMarketingPriceStr = body.containskey('RetailDirectMarketingPrice')?string.valueof(body.get('RetailDirectMarketingPrice')):null;
            String retailIndirectMarketingPriceStr = body.containskey('RetailIndirectMarketingPrice')?string.valueof(body.get('RetailIndirectMarketingPrice')):null;
            // for Econdisc
            string salesoutPromotionDaysStr = body.containskey('salesoutPromotionDays')?string.valueof(body.get('salesoutPromotionDays')):null;
            string salesOutPromotionPercentageStr=body.containskey('salesOutPromotionPercentage')?string.valueof(body.get('salesOutPromotionPercentage')):null;
            //for Costco 
            String indirectNetStr = body.containskey('IndirectNet')?string.valueof(body.get('IndirectNet')):null;
            //for Samsclub and direct and indirect and humana and net indirect
            String proposedDirectContractPriceStr = body.containskey('ProposedDirectContractPrice')?string.valueof(body.get('ProposedDirectContractPrice')):null;
            String proposedInirectContractPriceStr = body.containskey('proposedIndirectContractPrice')?string.valueof(body.get('proposedIndirectContractPrice')):null;
            String proposedPURStr = body.containskey('proposedPUR')?string.valueof(body.get('proposedPUR')):null;
            // for DSH
            String proposedBASEContractPriceStr = body.containskey('ProposedBASEContractPrice')?string.valueof(body.get('ProposedBASEContractPrice')):null;
            String ProposedDSHContractPriceStr = body.containskey('ProposedDSHContractPrice')?string.valueof(body.get('ProposedDSHContractPrice')):null;
            String ProposedAutoSubContractPriceStr = body.containskey('ProposedAutoSubContractPrice')?string.valueof(body.get('ProposedAutoSubContractPrice')):null;
            system.debug('proposedBASEContractPriceStr ======'+proposedBASEContractPriceStr);
            system.debug('ProposedDSHContractPriceStr ======'+ProposedDSHContractPriceStr);
            system.debug('ProposedAutoSubContractPriceStr ======'+ProposedAutoSubContractPriceStr);
            // for Clarusone
            String ProposedNCPforMcKOSRADStr = body.containskey('ProposedNCPforMcKOSRAD')?string.valueof(body.get('ProposedNCPforMcKOSRAD')):null;
            String ProposedNCPforWMTDirectStr = body.containskey('ProposedNCPforWMTDirect')?string.valueof(body.get('ProposedNCPforWMTDirect')):null;
            String ProposedNCPforWMTIndirectStr = body.containskey('ProposedNCPforWMTIndirect')?string.valueof(body.get('ProposedNCPforWMTIndirect')):null;
            //for Pharmagen
            String bidTemplateStr = body.containskey('bidTemplate')?string.valueof(body.get('bidTemplate')):null;
            //for Econdisc 
            Integer salesoutPromotionDays = salesoutPromotionDaysStr!=null?integer.valueof(salesoutPromotionDaysStr):0;
            decimal salesOutPromotionPercentage = salesOutPromotionPercentageStr!=null?decimal.valueof(salesOutPromotionPercentageStr):0;
            decimal proposedDirectContractPrice = proposedDirectContractPriceStr!=null?decimal.valueof(proposedDirectContractPriceStr):0;
            decimal proposedIndirectContractPrice = proposedInirectContractPriceStr!=null?decimal.valueof(proposedInirectContractPriceStr):0;
            decimal proposedBASEContractPrice = proposedBASEContractPriceStr!=null?decimal.valueof(proposedBASEContractPriceStr):0;
            decimal ProposedDSHContractPrice = ProposedDSHContractPriceStr!=null?decimal.valueof(ProposedDSHContractPriceStr):0;
            decimal ProposedAutoSubContractPrice = ProposedAutoSubContractPriceStr!=null?decimal.valueof(ProposedAutoSubContractPriceStr):0;
            
            decimal proposedPUR = proposedPURStr!=null?decimal.valueof(proposedPURStr):0;
            
            decimal ProposedNCPforMcKOSRAD = ProposedNCPforMcKOSRADStr!=null?decimal.valueof(ProposedNCPforMcKOSRADStr):0;
            decimal ProposedNCPforWMTDirect = ProposedNCPforWMTDirectStr!=null?decimal.valueof(ProposedNCPforWMTDirectStr):0;
            decimal ProposedNCPforWMTIndirect = ProposedNCPforWMTIndirectStr!=null?decimal.valueof(ProposedNCPforWMTIndirectStr):0;
            decimal retailDirectMarketingPrice = retailDirectMarketingPriceStr!=null?decimal.valueof(retailDirectMarketingPriceStr):0;
            decimal retailIndirectMarketingPrice = retailIndirectMarketingPriceStr!=null?decimal.valueof(retailIndirectMarketingPriceStr):0;
                
            System.debug('accNumber==>'+accNumber);
            System.debug('wac==>'+wac);
            System.debug('marketingprice==>'+marketingprice);
            System.debug('productType==>'+productType);
            System.debug('bidTemplateStr==>'+bidTemplateStr);
            
            String bidTemplate;
            String prefferedWholesaler;
            String customerType;
            Decimal vipperc;
            Decimal vipperUnit;
            Decimal cmfeePerc;
            Decimal cmFeePerUnit;
            Decimal rebatePerc;
            Decimal rebatespPerUnit;
            Decimal orderAnltFeePerc;
            Decimal orderanlfeeunit;
            Decimal grpVIPPerc;
            Decimal grpVIPPerUnit;
            Decimal salesoutPrmPerc;
            Decimal salesoutPromotionPerUnit;
            Decimal salesoutPrmNoDays;
            Decimal cashDiscountPerUnit;
            Decimal cashDiscPerc;
            Decimal customerDeadnet;
            Decimal Deadnetprice;
            Decimal localVIPPerc;
            Decimal localVIPPerUnit;
            Decimal accFeePerc;
            Decimal accFeePerUnit;
            Decimal RDCNLCPerc;
            Decimal RDCNLC;
            //added by Srimayee
            Decimal directCD = 0;
            //try{
            decimal mktngPrice=marketingprice!=null?decimal.valueof(marketingprice):null;
            decimal wholesalerPriceIndirect=wholesalerprice!=null?decimal.valueof(wholesalerprice):null;
            decimal wacValue=wac!=null?decimal.valueof(wac):null;
            System.debug('account number ==>'+accNumber);
            String query = '';
            String SobjectApiName = 'Account';
            query = 'SELECT '+Phoenix_Util.customerFields+' FROM '+SobjectApiName+' WHERE AccountNumber =: accNumber LIMIT 1';
            Account acc = Database.query(query);
            //  Account acc = [SELECT Id,Phoenix_Customer_Class_Bid_Template__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Is_Govt_Customer__c,Phoenix_VIP__c,Phoenix_Cash_Discount__c,Phoenix_Rebates__c,Phoenix_Order_Analytics_Fee__c,Phoenix_Wbad_VIR__c,Phoenix_Local_VIP__c,Phoenix_Fee__c from Account where AccountNumber =: accNumber];
            bidTemplate = acc.Phoenix_Customer_Class_Bid_Template__c;
            System.debug('bid template==>'+acc.Phoenix_Customer_Class_Bid_Template__c);
            
            System.debug('customerType==>'+acc.Phoenix_Is_Govt_Customer__c);
            System.debug('acc.Phoenix_Preferred_Wholesaler__c==>'+acc.Id);
            prefferedWholesaler = acc.Phoenix_Preferred_Wholesaler__c != null ? acc.Phoenix_Preferred_Wholesaler__c : '';
            System.debug('prefferedWholesaler==>'+prefferedWholesaler);
            if(acc.Phoenix_Is_Govt_Customer__c == true){
                customerType = 'Govt business';
            }else{
                customerType = 'Non Govt business';   
            }
          /*  List<Phoenix_Bid_Fee_Master__c> bidfeeRec = new List<Phoenix_Bid_Fee_Master__c>();
            System.debug('customerType==>'+customerType);
            if(prefferedWholesaler != null && prefferedWholesaler != ''){
                bidfeeRec =  [SELECT Id,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Fee__c,Phoenix_Customer_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =:prefferedWholesaler AND Phoenix_Customer_Type__c = :customerType AND Phoenix_Product_Type_for_CM_Fee__c =:productType];
                
            }
             for(Phoenix_Bid_Fee_Master__c fee:bidfeeRec){
                system.debug('bidfee fee ===== '+fee.Phoenix_Fee__c);
                if(fee.Phoenix_Fee_Type__c == 'CM Fee%' && cmfeePerc == null)
                    cmfeePerc = fee.Phoenix_Fee__c != null ? (fee.Phoenix_Fee__c) : 0;  
                if(fee.Phoenix_Fee_Type__c == 'RDC/NLC %' && RDCNLCPerc == null)
                    RDCNLCPerc = fee.Phoenix_Fee__c != null ? (fee.Phoenix_Fee__c) : 0; 
                RDCNLC = fee.Phoenix_Fee__c != null ? fee.Phoenix_Fee__c : 0; 
            }*/
            Phoenix_Bid_Fee_Master__c cmfeerecord = new Phoenix_Bid_Fee_Master__c();
            Phoenix_Bid_Fee_Master__c rdcNLCrecord = new Phoenix_Bid_Fee_Master__c();
            if(prefferedWholesaler != null && prefferedWholesaler != ''){
                cmfeerecord = [SELECT Id,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Fee__c,Phoenix_Customer_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =:prefferedWholesaler AND Phoenix_Customer_Type__c = :customerType AND Phoenix_Product_Type_for_CM_Fee__c =:productType AND Phoenix_Fee_Type__c = 'CM Fee%'];
                
            }
             if(prefferedWholesaler != null && prefferedWholesaler != ''){
             rdcNLCrecord = [SELECT Id,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Fee__c,Phoenix_Customer_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =:prefferedWholesaler AND Phoenix_Fee_Type__c = 'RDC/NLC %'];
           
             }system.debug('cmfeerecord----'+cmfeerecord.Phoenix_Fee__c);
            system.debug('rdcNLCrecord----'+rdcNLCrecord.Phoenix_Fee__c);
            if(cmfeerecord.Phoenix_Fee_Type__c == 'CM Fee%')
                cmfeePerc = cmfeerecord.Phoenix_Fee__c != null ? (cmfeerecord.Phoenix_Fee__c) : 0;  
            if(rdcNLCrecord.Phoenix_Fee_Type__c == 'RDC/NLC %')
                RDCNLCPerc = rdcNLCrecord.Phoenix_Fee__c != null ? (rdcNLCrecord.Phoenix_Fee__c) : 0; 
            RDCNLC = rdcNLCrecord.Phoenix_Fee__c != null ? rdcNLCrecord.Phoenix_Fee__c : 0; 
            vipperc = acc.Phoenix_VIP__c != null ? acc.Phoenix_VIP__c : 0;
            rebatePerc = acc.Phoenix_Rebates__c != null ? acc.Phoenix_Rebates__c : 0;
            
            orderAnltFeePerc = acc.Phoenix_Order_Analytics_Fee__c != null ?  acc.Phoenix_Order_Analytics_Fee__c : 0;
            
            grpVIPPerc = 	acc.Phoenix_Wbad_VIR__c != null ? acc.Phoenix_Wbad_VIR__c : 0;
            
            cashDiscPerc = acc.Phoenix_Cash_Discount__c != null ? acc.Phoenix_Cash_Discount__c : 0;
            
            //for progen//
            localVIPPerc = acc.Phoenix_Local_VIP__c != null ? acc.Phoenix_Local_VIP__c : 0;
            
            accFeePerc = acc.Phoenix_Fee__c != null ? acc.Phoenix_Fee__c :0;
            
            system.debug('Phoenix_ABS__c====='+acc.Phoenix_ABS__c);
            system.debug('Phoenix_Rebates__c====='+acc.Phoenix_Rebates__c);
            system.debug('Phoenix_Fee__c====='+acc.Phoenix_Fee__c);
            system.debug('Phoenix_Cash_Discount__c====='+acc.Phoenix_Cash_Discount__c);
            system.debug('RDCNLCPerc====='+RDCNLCPerc);
            system.debug('cmfeePerc====='+cmfeePerc);
            //for Econdisc
            
            if(bidTemplate == 'Walgreens'){
                system.debug('vipperc====='+vipperc);
                system.debug('cmfeePerc====='+cmfeePerc);
                system.debug('rebatePerc====='+rebatePerc);
                system.debug('orderAnltFeePerc====='+orderAnltFeePerc);
                system.debug('grpVIPPerc====='+grpVIPPerc);
                system.debug('localVIPPerc====='+localVIPPerc);
                vipperUnit = (mktngPrice * vipperc) /100;
                cmFeePerUnit = (mktngPrice * (cmfeePerc/100));
                rebatespPerUnit =  (mktngPrice * rebatePerc) /100;
                orderanlfeeunit = (mktngPrice * orderAnltFeePerc) /100;
                grpVIPPerUnit = (mktngPrice * grpVIPPerc) /100;
                localVIPPerUnit = (mktngPrice * localVIPPerc) /100;
                cashDiscountPerUnit = (decimal.valueof(wac) * cashDiscPerc) /100;
                system.debug('vipperUnit====='+vipperUnit);
                system.debug('cmFeePerUnit====='+cmFeePerUnit);
                system.debug('rebatespPerUnit====='+rebatespPerUnit);
                system.debug('orderanlfeeunit====='+orderanlfeeunit);
                system.debug('grpVIPPerUnit====='+grpVIPPerUnit);
                system.debug('localVIPPerUnit====='+localVIPPerUnit);
                system.debug('cashDiscountPerUnit====='+cashDiscountPerUnit);
                customerDeadnet = mktngPrice - vipperUnit - cmFeePerUnit - rebatespPerUnit - orderanlfeeunit - grpVIPPerUnit  - cashDiscountPerUnit;
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'Failure in Walgreens';
                    responseJSON.errorMessage ='Some thing went wrong with the Walgreens';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }
                
            }
            else if(bidTemplate == 'ABC Progen' && bidTemplateStr == null){
                vipperUnit = (mktngPrice * vipperc) /100;
                rebatespPerUnit =  (mktngPrice * rebatePerc) /100;
                grpVIPPerUnit = (mktngPrice * grpVIPPerc) /100;
                cashDiscountPerUnit = (decimal.valueof(wac) * cashDiscPerc) /100;
                localVIPPerUnit = (mktngPrice * localVIPPerc) /100;
                accFeePerUnit = (mktngPrice * accFeePerc) /100;
                Decimal vipDiffPerUnit = (((vipperc -localVIPPerc)/100) * mktngPrice);
                customerDeadnet = mktngPrice - localVIPPerUnit - vipDiffPerUnit - accFeePerUnit  - rebatespPerUnit  - grpVIPPerUnit - cashDiscountPerUnit;
                System.debug('mktngPrice==>'+mktngPrice);
                System.debug('vipperc==>'+vipperc);
                System.debug('localVIPPerc==>'+localVIPPerc);
                System.debug('accFeePerc==>'+accFeePerc);
                System.debug('rebatePerc==>'+rebatePerc);
                System.debug('grpVIPPerc==>'+grpVIPPerc);
                System.debug('cashDiscPerc==>'+cashDiscPerc);
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'ABC Progen';
                    responseJSON.errorMessage ='Some thing went wrong with the ABC Progen';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }
                
            }
            else if(bidTemplate == 'Econdisc'){
              
                decimal finalprice = mktngPrice != null ? mktngPrice : wholesalerPriceIndirect;
                decimal RebatePercDollar=0;//BB
                decimal CDPerUnit=0;//BF
                decimal adminFee=0;//AY
                decimal VIPpercPerUnit=0;//AV 
                Decimal salesoutPrromotion=0;//BE
                decimal drlDeadNet=0;//BH
                decimal iodPerUnit=0;
                
                system.debug('accFeePerc====='+accFeePerc);
                if(accFeePerc != null && accFeePerc != 0)
                accFeePerUnit = (finalprice * accFeePerc) /100;//Admin Fee in $
                system.debug('rebatePerc====='+rebatePerc);
                if(rebatePerc != null && rebatePerc != 0)
                RebatePercDollar =  (finalprice * rebatePerc) /100;
                system.debug('Phoenix_Cash_Discount__c====='+acc.Phoenix_Cash_Discount__c);
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                CDPerUnit = finalprice * (acc.Phoenix_Cash_Discount__c/100);
                system.debug('Phoenix_Fee__c====='+acc.Phoenix_Fee__c);
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                adminFee = finalprice * (acc.Phoenix_Fee__c/100);
                system.debug('Val====='+(mktngPrice - CDPerUnit - adminFee - RebatePercDollar));
                Decimal Val=mktngPrice - CDPerUnit - adminFee - RebatePercDollar;
                if(Val != null && Val != 0)
                VIPpercPerUnit = (acc.Phoenix_VIP__c/100) * Val;
                customerDeadnet = mktngPrice - VIPpercPerUnit; //AW
                system.debug('salesoutPromotionDays====='+salesoutPromotionDays);
                 system.debug('salesOutPromotionPercentage====='+salesOutPromotionPercentage);
                salesoutPrromotion = (mktngPrice * salesoutPromotionDays * salesOutPromotionPercentage) /360;
                 system.debug('finalprice====='+finalprice);
                 system.debug('RebatePercDollar====='+RebatePercDollar);
                 system.debug('CDPerUnit====='+CDPerUnit);
                 system.debug('adminFee====='+adminFee);
                 system.debug('VIPpercPerUnit====='+VIPpercPerUnit);
                 system.debug('salesoutPrromotion====='+salesoutPrromotion);
                 system.debug('iodPerUnit====='+iodPerUnit);
                
                drlDeadNet = (customerDeadnet - adminFee - salesoutPrromotion - CDPerUnit - RebatePercDollar).setScale(2);
                Decimal ProposedZITD;//BL
                decimal adminFeeDollar;//AY
                decimal indirectCD;//BM
                decimal rdcNLCdollar;//BP
                decimal CMFeePerUnitDollar;//BR
                decimal IndirectVIPPerUnit;//BN
                decimal IndirectDeadNet;//BS
                
				
                if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c != 0)
                indirectCD = (wacValue * (acc.Phoenix_Indirect_Cash_Discount__c/100)).setScale(4);
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                adminFeeDollar = mktngPrice * (acc.Phoenix_Fee__c/100);
                ProposedZITD = wholesalerPriceIndirect-mktngPrice; 
                if(RDCNLCPerc != null && RDCNLCPerc != 0)
                rdcNLCdollar = (wacValue * (RDCNLCPerc/100)).setScale(4);
                if(cmfeePerc != null && cmfeePerc != 0)
                CMFeePerUnitDollar = (wacValue * (cmfeePerc/100)).setScale(4);
                IndirectVIPPerUnit = ((wholesalerPriceIndirect - ProposedZITD - adminFeeDollar - CDPerUnit - RebatePercDollar) * (acc.Phoenix_VIP__c/100)).setScale(4);
                 system.debug('ProposedZITD====='+ProposedZITD);
                 system.debug('adminFeeDollar====='+adminFeeDollar);
                 system.debug('indirectCD====='+indirectCD);
                 system.debug('rdcNLCdollar====='+rdcNLCdollar);
                 system.debug('CMFeePerUnitDollar====='+CMFeePerUnitDollar);
                 system.debug('IndirectVIPPerUnit====='+IndirectVIPPerUnit);
                 
                
                IndirectDeadNet = (wholesalerPriceIndirect - ProposedZITD - adminFeeDollar - indirectCD - rdcNLCdollar - CMFeePerUnitDollar - IndirectVIPPerUnit).setScale(2);
                  system.debug('IndirectDeadNet====='+IndirectDeadNet);
                if(drlDeadNet != null || IndirectDeadNet != null){
                    responseJSON.status='Success';
                    responseJSON.Success='DRL Dead net W/o IOD, Medicaid & Returns is : '+string.valueOf(drlDeadNet) +' and Indirect Dead Net w/o Medicaid & Returns is: '+string.valueOf(IndirectDeadNet);
                }
                else{
                    responseJSON.status = 'Econdisc';
                    responseJSON.errorMessage ='Some thing went wrong with the Econdisc';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }
            }
            else if(bidTemplate == 'RXSS'){
                //retailDirectDRLNETPrice retailIndirectDRLNETPrice Wholesaler DRL Net Price retailDirectMarketingPrice(Anda CP Price) retailIndirectMarketingPrice
				//decimal directCD;
				decimal retailDirectAdminFee=0;
                decimal RetailDirectVIP=0;
                decimal retailDirectDRLNETPrice=0;
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                directCD = retailDirectMarketingPrice * (acc.Phoenix_Cash_Discount__c/100);
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c >0)
                retailDirectAdminFee = retailDirectMarketingPrice * (acc.Phoenix_Fee__c/100);
                if(acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c >0)
                RetailDirectVIP = (acc.Phoenix_VIP__c/100)*(retailDirectMarketingPrice - retailDirectAdminFee);
                retailDirectDRLNETPrice = (retailDirectMarketingPrice - directCD - retailDirectAdminFee - RetailDirectVIP).setScale(2);
                decimal retailIndirectDRLDeadnet=0;
                decimal retailIndirectAdminFees=0; 
                decimal retailIndirectVIP=0;
                decimal RetailIndirectNetMarketing=0;
                decimal cmfeeVal=0;
                decimal rdcVal=0;
                decimal cdVal=0;
                decimal retailIndirectWACNLCFee=0;
                decimal retailIndirectWholsesalerFee=0;
                if(cmfeePerc != null && cmfeePerc >0)
                    cmfeeVal = (retailIndirectMarketingPrice * (cmfeePerc/100));
                if(RDCNLCPerc != null && RDCNLCPerc >0)
                    rdcVal = ((RDCNLCPerc/100)*wacValue);
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                    cdVal = ((acc.Phoenix_Cash_Discount__c/100)*retailDirectMarketingPrice);
                RetailIndirectNetMarketing = retailDirectMarketingPrice + cmfeeVal + rdcVal - cdVal;//Anda CP Price
                decimal retailIndirectZITD = retailIndirectMarketingPrice - RetailIndirectNetMarketing;
                retailIndirectAdminFees = (acc.Phoenix_Fee__c/100) * (retailIndirectMarketingPrice - retailIndirectZITD);
                retailIndirectVIP = (acc.Phoenix_VIP__c/100)*(retailIndirectMarketingPrice - retailIndirectZITD - retailIndirectAdminFees);
                retailIndirectWACNLCFee = (cmfeePerc/100) * wacValue;
                retailIndirectWholsesalerFee = (cmfeePerc/100) *retailIndirectMarketingPrice;
                retailIndirectDRLDeadnet = (retailIndirectMarketingPrice - retailIndirectAdminFees - retailIndirectVIP - retailIndirectWACNLCFee - retailIndirectWholsesalerFee - retailIndirectZITD).setScale(2);
                decimal wholesalerDRLNetPrice=0;
                decimal WhlsrPrice=0;
                decimal whslrVal=0;
                decimal WholsesalerCD=0;
                decimal wholsesalerAdminFee=0;
                decimal WholsesalerVIP=0;
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                 whslrVal =   ((acc.Phoenix_Cash_Discount__c/100) * wacValue) - ((acc.Phoenix_Cash_Discount__c/100) * retailDirectMarketingPrice);
                if(retailDirectMarketingPrice >0){
                    WhlsrPrice = retailDirectMarketingPrice + whslrVal;
                        }
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                WholsesalerCD = wacValue * (acc.Phoenix_Cash_Discount__c/100);
                wholsesalerAdminFee = WhlsrPrice * retailDirectAdminFee;
                WholsesalerVIP = (WhlsrPrice - wholsesalerAdminFee) * RetailDirectVIP;
                wholesalerDRLNetPrice = (WhlsrPrice - WholsesalerCD - wholsesalerAdminFee - WholsesalerVIP).setScale(2);
                decimal ANDADRLNetPrice=0;
                decimal CashTerms=0;
                decimal ANDAAdminFees=0;
                decimal ANDAVIP=0; 
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                    CashTerms = RetailIndirectNetMarketing *(acc.Phoenix_Cash_Discount__c/100);
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c >0)
                    ANDAAdminFees = retailDirectMarketingPrice * (acc.Phoenix_Fee__c/100);
                if(acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c >0)
                ANDAVIP = (retailDirectMarketingPrice - ANDAAdminFees) * (acc.Phoenix_VIP__c/100);
                ANDADRLNetPrice = (retailDirectMarketingPrice - CashTerms - ANDAAdminFees - ANDAVIP).setScale(2);
                  if(ANDADRLNetPrice !=null || wholesalerDRLNetPrice != null || retailIndirectDRLDeadnet != null || retailDirectDRLNETPrice != null){
                    responseJSON.status='Success';
                    responseJSON.Success='Retail Direct DRL NET Price is : '+string.valueOf(retailDirectDRLNETPrice) +' and Retail Indirect DRL Dead net is: '+string.valueOf(retailIndirectDRLDeadnet)+' and Wholesaler DRL Net Price is: '+string.valueOf(wholesalerDRLNetPrice)+' and ANDA DRL Net Price is: '+string.valueOf(ANDADRLNetPrice);
                }
                else{
                    responseJSON.status = 'ROS';
                    responseJSON.errorMessage ='Some thing went wrong with the ROS';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }   
            }
            else if(bidTemplate == 'ClarusOne'){
                //ProposedNCPforMcKOSRAD ProposedNCPforWMTDirect ProposedNCPforWMTIndirect
                Decimal MckRADDataFee = 0;
                Decimal MckRebate = 0.0;
                Decimal MckAdminFee = 0;
                Decimal MckCashTerms = 0;
                Decimal MckRDC = 0;
                Decimal McKRADDeadNet = 0;
                Decimal CustomerDeadnetMcKAndRAD = 0;
                   system.debug('ProposedNCPforMcKOSRAD====='+ProposedNCPforMcKOSRAD);
                 system.debug('MckRADDataFee====='+acc.Phoenix_ABS__c);
                system.debug('MckRebate====='+acc.Mck_RAD_Rebate__c);
                system.debug('MckAdminFee====='+acc.Phoenix_Fee__c);
                system.debug('MckCashTerms====='+acc.Phoenix_Cash_Discount__c);
                system.debug('MckRDC====='+RDCNLCPerc);
                system.debug('McKRADDeadNet====='+RDCNLCPerc/100);
                if(acc.Phoenix_ABS__c != null && acc.Phoenix_ABS__c != 0)
                    MckRADDataFee = ProposedNCPforMcKOSRAD * (acc.Phoenix_ABS__c/100);
                
                 system.debug('Vaal====='+acc.Phoenix_Rebates__c/100);
                if(acc.Mck_RAD_Rebate__c != null && acc.Mck_RAD_Rebate__c != 0)
                    MckRebate = ProposedNCPforMcKOSRAD * (acc.Mck_RAD_Rebate__c/100);
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                    MckAdminFee = ProposedNCPforMcKOSRAD * (acc.Phoenix_Fee__c/100);
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                    MckCashTerms = wacValue * (acc.Phoenix_Cash_Discount__c/100);
                if(RDCNLCPerc != null && RDCNLCPerc != 0)
                MckRDC = wacValue * (RDCNLCPerc/100);
                CustomerDeadnetMcKAndRAD = ProposedNCPforMcKOSRAD - MckRebate - MckAdminFee - MckCashTerms - MckRDC;
                if(CustomerDeadnetMcKAndRAD != 0){
                    system.debug('inside McKRADDeadNet');
                 McKRADDeadNet = (CustomerDeadnetMcKAndRAD - MckRADDataFee).setScale(2);   
                }
                else{
                   McKRADDeadNet = 0; 
                }
                
                system.debug('MckRADDataFee====='+MckRADDataFee);
                system.debug('MckRebate====='+MckRebate);
                system.debug('MckAdminFee====='+MckAdminFee);
                system.debug('MckCashTerms====='+MckCashTerms);
                system.debug('MckRDC====='+MckRDC);
                system.debug('McKRADDeadNet====='+McKRADDeadNet);
                system.debug('CustomerDeadnetMcKAndRAD====='+CustomerDeadnetMcKAndRAD);
                Decimal WMTDirectDeadNet = 0;
                Decimal WMTDirectInvoiceAllowance = 0;
                Decimal WMTDirectCashTerms = 0;
                Decimal WMTDirectAdminFee = 0;
                system.debug('ProposedNCPforWMTDirect====='+ProposedNCPforWMTDirect);
                system.debug('WMTDirectInvoiceAllowance====='+acc.Phoenix_WMT_Direct_Rebate__c);
                system.debug('WMTDirectCashTerms====='+acc.Phoenix_Cash_Discount__c);
                system.debug('WMTDirectAdminFee====='+acc.Phoenix_Fee__c);
                if(acc.Phoenix_WMT_Direct_Rebate__c != null && acc.Phoenix_WMT_Direct_Rebate__c != 0)
                    WMTDirectInvoiceAllowance = (ProposedNCPforWMTDirect * (acc.Phoenix_WMT_Direct_Rebate__c/100)).setScale(2);
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                    WMTDirectCashTerms = (ProposedNCPforWMTDirect * (acc.Phoenix_Cash_Discount__c/100)).setScale(2);
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                    WMTDirectAdminFee = (ProposedNCPforWMTDirect * (acc.Phoenix_Fee__c/100)).setScale(4);
                system.debug('WMTDirectInvoiceAllowance====='+WMTDirectInvoiceAllowance);
                system.debug('WMTDirectCashTerms====='+WMTDirectCashTerms);
                system.debug('WMTDirectAdminFee====='+WMTDirectAdminFee);
                if(ProposedNCPforWMTDirect > 0){
                    system.debug('inside direct');
                WMTDirectDeadNet = (ProposedNCPforWMTDirect - WMTDirectInvoiceAllowance - WMTDirectCashTerms - WMTDirectAdminFee).setScale(2);    
                }else{
                  WMTDirectDeadNet = 0;  
                }
                
                Decimal WMTIndirectDeadNet = 0;
                Decimal WMTIndirectAdminFee = 0;
                Decimal WMTIndirectCD = 0;
                Decimal WMTIndirectRDC = 0;
                Decimal WMTIndirectCMFees = 0;
                Decimal ZITD = 0;
                
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                    WMTIndirectAdminFee = ProposedNCPforWMTIndirect * (acc.Phoenix_Fee__c/100); 
                if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c != 0)
                    WMTIndirectCD = wacValue * (acc.Phoenix_Indirect_Cash_Discount__c/100);
                if(RDCNLCPerc != null && RDCNLCPerc != 0)
                WMTIndirectRDC = wacValue * (RDCNLCPerc/100);
                WMTIndirectCMFees = ProposedNCPforWMTIndirect * (cmfeePerc/100);
                ZITD = ProposedNCPforWMTIndirect - ProposedNCPforWMTDirect;
                 system.debug('WMTIndirectDeadNet====='+WMTIndirectDeadNet);
                system.debug('WMTIndirectAdminFee====='+WMTIndirectAdminFee);
                system.debug('WMTIndirectCD====='+WMTIndirectCD);
                system.debug('WMTIndirectRDC====='+WMTIndirectRDC);
                system.debug('WMTIndirectCMFees====='+WMTIndirectCMFees);
                system.debug('ZITD====='+ZITD);
                if(ProposedNCPforWMTIndirect > 0){
                WMTIndirectDeadNet = (ProposedNCPforWMTIndirect - WMTIndirectAdminFee - WMTIndirectCD - WMTIndirectCMFees - WMTIndirectRDC - ZITD).setScale(2);    
                }else{
                   WMTIndirectDeadNet = 0; 
                }
                
                if(McKRADDeadNet !=null || WMTDirectDeadNet != null || WMTIndirectDeadNet != null){
                    responseJSON.status='Success';
                    responseJSON.Success='McK & RAD Dead Net is : '+string.valueOf(McKRADDeadNet) +' and WMT Direct Dead Net is: '+string.valueOf(WMTDirectDeadNet)+' and WMT Indirect Dead Net is: '+string.valueOf(WMTIndirectDeadNet);
                }
                else{
                    responseJSON.status = 'ClarusOne';
                    responseJSON.errorMessage ='Some thing went wrong with the ROS';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }   
            }
            else if(bidTemplate == 'ROS'){
                //proposedIndirectContractPrice mktngPrice
                Decimal InternalCVSDirectDeadNet=0;
                Decimal ProposedCVSDirectContractPrice=0;
                Decimal CD=0;
                Decimal serviceFee=0;
                Decimal CDPerc=0;
                Decimal FeePerc=0;
                if(acc.Phoenix_Cash_Discount__c !=null && acc.Phoenix_Cash_Discount__c > 0)
                    CDPerc = acc.Phoenix_Cash_Discount__c /100;
                 if(acc.Phoenix_Fee__c !=null && acc.Phoenix_Fee__c > 0)
                    FeePerc = acc.Phoenix_Fee__c /100;
                system.debug('CDPerc====='+CDPerc);
                system.debug('FeePerc====='+FeePerc);
                system.debug('mktngPrice====='+mktngPrice);
                system.debug('proposedIndirectContractPrice====='+proposedIndirectContractPrice);
               // if(mktngPrice > 0 && (acc.Phoenix_Cash_Discount__c /100) - (acc.Phoenix_Fee__c /100)) != 0){
                    ProposedCVSDirectContractPrice = mktngPrice / (1 - FeePerc - CDPerc);
               // }
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c !=0)
                CD = ProposedCVSDirectContractPrice * (acc.Phoenix_Cash_Discount__c /100);
                if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c !=0)
                serviceFee = ProposedCVSDirectContractPrice * (acc.Phoenix_Fee__c /100);
                InternalCVSDirectDeadNet = (ProposedCVSDirectContractPrice - CD - serviceFee).setScale(2);
                system.debug('ProposedCVSDirectContractPrice====='+ProposedCVSDirectContractPrice);
                system.debug('CD====='+CD);
                system.debug('serviceFee====='+serviceFee);
                Decimal InternalCVSIndirectDeadNet=0;
                Decimal ZITD=0;
                Decimal indirectCD=0;
                Decimal RDC=0;
                Decimal CMFee=0;
                ZITD = proposedIndirectContractPrice - ProposedCVSDirectContractPrice;
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c !=0)
                indirectCD = wacValue * (acc.Phoenix_Cash_Discount__c /100);
                RDC = wacValue * (RDCNLCPerc/100);
                CMFee = proposedIndirectContractPrice * (cmfeePerc/100);
                InternalCVSIndirectDeadNet = (proposedIndirectContractPrice - ZITD - indirectCD - CMFee - RDC).setScale(2);
                Decimal InternalCardinalDeadNet=0;
                Decimal  ProposedCardinalContractPrice=0;
                Decimal CashDiscountonWAC=0;
                Decimal CardinalPreferredRebate=0;
                Decimal NLCFees=0; 
                Decimal CardinaladditionalRebate=0;
                Decimal PreferredCardinalRebate =0;
                system.debug('Phoenix_Rebates__c ====='+acc.Phoenix_Rebates__c);
                system.debug('Phoenix_Cash_Discount__c ====='+acc.Phoenix_Cash_Discount__c);
                system.debug('RDCNLCPerc ====='+RDCNLCPerc);
                PreferredCardinalRebate = acc.Phoenix_Rebates__c/100;//PreferredMajorRebate
                CashDiscountonWAC = wacValue * (acc.Phoenix_Cash_Discount__c /100);//BY
                Decimal vals=1-PreferredCardinalRebate;
                if(CashDiscountonWAC != null && CashDiscountonWAC !=0 && mktngPrice !=null && mktngPrice !=0)
                    ProposedCardinalContractPrice = ((mktngPrice + CashDiscountonWAC)/vals).setScale(4);//BI
                CardinalPreferredRebate = (ProposedCardinalContractPrice * PreferredCardinalRebate).setScale(4);//
                NLCFees = (wacValue * (RDCNLCPerc/100)).setScale(4);
                CardinaladditionalRebate = (ProposedCardinalContractPrice * (RDCNLCPerc/100)).setScale(4);//same for major also
                system.debug('CashDiscountonWAC ====='+CashDiscountonWAC);
                system.debug('CardinalPreferredRebate ====='+CardinalPreferredRebate);
                system.debug('NLCFees ====='+NLCFees);
                system.debug('CardinaladditionalRebate ====='+CardinaladditionalRebate);
                InternalCardinalDeadNet = (ProposedCardinalContractPrice - CashDiscountonWAC - CardinalPreferredRebate - NLCFees - CardinaladditionalRebate).setScale(2);
                Decimal InternalMajorDeadNet=0;
                Decimal ProposedMajorContractPrice=0; 
                Decimal MajorPreferredRebate=0;
                ProposedMajorContractPrice = ProposedCardinalContractPrice;//BK
                MajorPreferredRebate = ProposedMajorContractPrice * PreferredCardinalRebate;
                InternalMajorDeadNet = (ProposedMajorContractPrice - CashDiscountonWAC - MajorPreferredRebate - CardinaladditionalRebate).setScale(2);
                if(ProposedMajorContractPrice !=null || MajorPreferredRebate != null || InternalMajorDeadNet != null){
                    responseJSON.status='Success';
                    responseJSON.Success='Internal CVS Direct Dead Net is : '+string.valueOf(InternalCVSDirectDeadNet) +' and Internal CVS Indirect Dead Net is: '+string.valueOf(InternalCVSIndirectDeadNet)+' and Internal Cardinal Dead Net  is: '+string.valueOf(InternalCardinalDeadNet)+' and Internal Major Dead Net is: '+string.valueOf(InternalMajorDeadNet);
                }
                else{
                    responseJSON.status = 'ROS';
                    responseJSON.errorMessage ='Some thing went wrong with the ROS';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }   
            }
            else if(bidTemplate == 'Net Indirect Pricing'){
                Decimal indirectCD=0;
                Decimal CMFee=0;//AO
                Decimal directDeadNet=0;
                Decimal indirectDeadNet=0;
                Decimal RDCIndirectCD=0;//RDC + indirect CD
                directCD = proposedDirectContractPrice * (acc.Phoenix_Cash_Discount__c/100);
                directDeadNet = (proposedDirectContractPrice - directCD ).setScale(2);//Direct Dead net
                system.debug('acc----'+acc.Phoenix_Indirect_Cash_Discount__c);
                system.debug('acc-----'+RDCNLCPerc);
                system.debug('acc-----'+acc.Phoenix_Indirect_Cash_Discount__c + acc.Phoenix_RDC_NLC__c);
                RDCIndirectCD = (acc.Phoenix_Indirect_Cash_Discount__c + RDCNLC )/100;
                system.debug('acc-----'+RDCIndirectCD);
                indirectCD = wacValue * RDCIndirectCD;
                if(acc.Phoenix_CM_Fees__c != null && acc.Phoenix_CM_Fees__c != 0){
                    CMFee = proposedIndirectContractPrice *(acc.Phoenix_CM_Fees__c/100); 
                }
                Decimal netIndirectPrice = proposedDirectContractPrice + CMFee +  indirectCD - directCD;
                indirectDeadNet = (netIndirectPrice - indirectCD - CMFee).setScale(2);
                if(indirectDeadNet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Indirect Dead net is : '+string.valueOf(indirectDeadNet) +' and Direct Dead net is: '+string.valueOf(directDeadNet);
                }
                else{
                    responseJSON.status = 'Net Indirect Pricing';
                    responseJSON.errorMessage ='Some thing went wrong with the Net Indirect Pricing';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }  
            }
            else if(bidTemplate == 'ABC Progen' && bidTemplateStr == 'ABC Pharmagen'){
                Decimal rebate;
                Decimal CD;
                Decimal additionalRebate;
                rebate = proposedIndirectContractPrice * (acc.Phoenix_Rebate_Pharmagen__c/100);
                CD = wacValue *(acc.Phoenix_Cash_Discount__c/100);
                additionalRebate = (1.25*proposedIndirectContractPrice)/100;
                //Harmonized Dead net
                customerDeadnet = proposedIndirectContractPrice - rebate - CD;
                Decimal DRLDeadNet = customerDeadnet - additionalRebate;
                if(DRLDeadNet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(DRLDeadNet);
                }
                else{
                    responseJSON.status = 'ABC Pharmagen';
                    responseJSON.errorMessage ='Some thing went wrong with the ABC Pharmagen';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }     
            }
            else if(bidTemplate == 'Costco'){
                //mktngPrice as Indirect Price to be loaded @ABC & McKesson               
                decimal indirectNet = indirectNetStr!=null ? decimal.valueOf(indirectNetStr):null;//costco;
                decimal rebates = mktngPrice * (rebatePerc/100);
                decimal cashDiscount = mktngPrice * (cashDiscPerc/100);
                decimal deadnet = indirectNet - rebates - cashDiscount;
                if(deadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(deadnet);
                }
                else{
                    responseJSON.status = 'ABC Progen';
                    responseJSON.errorMessage ='Some thing went wrong with the Costco';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }
            }
            else if(bidTemplate == 'Sams Club'){
                //mktngPrice as Indirect Price to be loaded @ABC & McKesson  
                Decimal indirectCD = 0;
                Decimal directCDval =0;
                Decimal CMFee =0;
                if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c!= 0)
                 indirectCD =  wacValue * (acc.Phoenix_Indirect_Cash_Discount__c/100);//AC
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c!= 0)
                 directCDval =  proposedDirectContractPrice * (acc.Phoenix_Cash_Discount__c/100);//AB
                if(cmfeePerc != null && cmfeePerc!= 0)
                 CMFee = proposedIndirectContractPrice * (cmfeePerc/100);//AE
                system.debug('indirectCD====='+indirectCD);
                system.debug('directCDval====='+directCDval);
                system.debug('CMFee====='+CMFee);
                Decimal netIndirectPrice =  proposedDirectContractPrice + indirectCD +CMFee-directCDval;
                system.debug('netIndirectPrice====='+netIndirectPrice);
                customerDeadnet = (proposedIndirectContractPrice-netIndirectPrice) >0 ? netIndirectPrice-indirectCD-CMFee :0;
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'Samsclub';
                    responseJSON.errorMessage ='Some thing went wrong with the Samsclub';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                } 
            }
            else if(bidTemplate == 'BASE/DSH'){
                // proposedBASEContractPrice ProposedDSHContractPrice ProposedAutoSubContractPrice
                Decimal baseCD;
                Decimal basePUR=0;//and aslo DSH PUR
                Decimal rebateFee;
                Decimal vipDollar;
                Decimal baseWholesalerFee=0;
                Decimal baseCustomerNetPrice;  
                Decimal bonafideFee=0;
                Decimal BASEDRLNetPrice;
                Decimal DSHCustNetPrice;
                Decimal DSHDRLNetPrice;
                Decimal DSHCD;//BT
                Decimal dshRebateFee;
                Decimal DSHWholesalerFee;//BU
                Decimal DSHBonafideFee;
                Decimal dshVIP;
                Decimal AutoSubDRLNetPrice;
                Decimal autoCD;
                Decimal autoRebateFee;
                Decimal autoBonafideFee;
                Decimal autoWholesalerFee;
                Decimal autoVIP;
                Decimal AutoCustNetPrice;
                Decimal baseCustNetPrice;
                system.debug('Phoenix_Cash_Discount__c====='+acc.Phoenix_Cash_Discount__c);
                system.debug('Phoenix_Rebates__c====='+acc.Phoenix_Rebates__c);
                system.debug('Phoenix_VIP__c====='+acc.Phoenix_VIP__c);
                system.debug('cmfeePerc====='+cmfeePerc);
                system.debug('Phoenix_Fee__c====='+acc.Phoenix_Fee__c);
                baseCD = wacValue * (acc.Phoenix_Cash_Discount__c/100);
                rebateFee =  proposedBASEContractPrice*((acc.Phoenix_Rebates__c/100).setScale(0));
                vipDollar =  proposedBASEContractPrice*(acc.Phoenix_VIP__c/100);
                baseWholesalerFee = proposedBASEContractPrice * (cmfeePerc/100);
                bonafideFee = (proposedBASEContractPrice * (acc.Phoenix_Fee__c/100));
                baseCustNetPrice=proposedBASEContractPrice - basePUR - rebateFee - vipDollar - bonafideFee;
                BASEDRLNetPrice = (baseCustNetPrice - baseCD - baseWholesalerFee).setScale(2);
               
                DSHCD = wacValue * (acc.Phoenix_Cash_Discount__c/100);
                DSHWholesalerFee = ProposedDSHContractPrice * (cmfeePerc/100);
                DSHBonafideFee = (ProposedDSHContractPrice * (acc.Phoenix_Fee__c/100));
                dshVIP = (ProposedDSHContractPrice * (acc.Phoenix_VIP__c/100));
                system.debug('rebate Value====='+(acc.Phoenix_Rebates__c/100).setScale(0));
                dshRebateFee = ProposedDSHContractPrice*(acc.Phoenix_Rebates__c/100);
                DSHCustNetPrice = ProposedDSHContractPrice - basePUR -dshRebateFee-dshVIP-DSHBonafideFee;
                DSHDRLNetPrice = (DSHCustNetPrice -DSHCD - DSHWholesalerFee).setScale(2);
                 system.debug('DSHCD====='+DSHCD);
                system.debug('DSHWholesalerFee====='+DSHWholesalerFee);
                system.debug('DSHBonafideFee====='+DSHBonafideFee);
                system.debug('dshVIP====='+dshVIP);
                system.debug('dshRebateFee====='+dshRebateFee);
                system.debug('DSHCustNetPrice====='+DSHCustNetPrice);
                system.debug('DSHDRLNetPrice====='+DSHDRLNetPrice);
                autoCD = wacValue * (acc.Phoenix_Cash_Discount__c/100);
                autoWholesalerFee = ProposedAutoSubContractPrice * (cmfeePerc/100);
                autoVIP = (ProposedAutoSubContractPrice * (acc.Phoenix_VIP__c/100));
                autoBonafideFee = (ProposedAutoSubContractPrice * (acc.Phoenix_Fee__c/100));
                autoRebateFee = ProposedAutoSubContractPrice*((acc.Phoenix_Rebates__c/100)).setScale(0);
                AutoCustNetPrice = ProposedAutoSubContractPrice - basePUR - autoRebateFee - autoVIP - autoBonafideFee;
                
                AutoSubDRLNetPrice =  (AutoCustNetPrice - autoCD - autoWholesalerFee).setScale(2);
                if(BASEDRLNetPrice !=null || DSHDRLNetPrice != null || AutoSubDRLNetPrice != null){
                    responseJSON.status='Success';
                    responseJSON.Success='BASE DRL Net Price is : '+string.valueOf(BASEDRLNetPrice) +' and DSH DRL Net Price is: '+string.valueOf(DSHDRLNetPrice) +' and Auto Sub DRL Net Price is: '+string.valueOf(AutoSubDRLNetPrice);
                }
                else{
                    responseJSON.status = 'BASE/DSH';
                    responseJSON.errorMessage ='Some thing went wrong with the BASE/DSH';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                } 
            }
            else if(bidTemplate == 'Government Pricing'){
                Decimal adminFee=0;//AC
                Decimal rebateFee=0;//AG
                Decimal indirectCD=0; //AK 
                Decimal RDC=0;//AM
                Decimal CMFee=0;//AO
                if(acc.Rebate_Type__c == 'Gross'){
                    rebateFee =  proposedIndirectContractPrice*(acc.Phoenix_Rebates__c/100);
                }
                else if(acc.Rebate_Type__c == 'Net'){
                    rebateFee =  (proposedIndirectContractPrice-proposedPUR)*(acc.Phoenix_Rebates__c/100);
                    
                }                
                indirectCD = wacValue * (acc.Phoenix_Indirect_Cash_Discount__c/100);
                system.debug('RDC====='+RDCNLCPerc);
                system.debug('CMFee====='+acc.Phoenix_CM_Fees__c);
                if(RDCNLCPerc != null && RDCNLCPerc != 0)
                RDC = wacValue * (RDCNLCPerc/100);
                if(cmfeePerc != null && cmfeePerc != 0)
                    CMFee = proposedIndirectContractPrice *(cmfeePerc/100);
                system.debug('indirectCD====='+indirectCD);
                system.debug('RDC====='+RDC);
                system.debug('CMFee====='+CMFee);
                system.debug('rebateFee====='+rebateFee);
                customerDeadnet = (proposedIndirectContractPrice - indirectCD - RDC - CMFee - rebateFee).setScale(2);
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'Government Pricing';
                    responseJSON.errorMessage ='Some thing went wrong with the Government Pricing';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }    
            }
            else if(bidTemplate == 'Direct'){
                //proposedPUR 
                Decimal adminFee=0;//AC
                Decimal rebateFee=0;//AG
                Decimal vipDollar=0;//AI
                //AK ------>  directCD
                if(acc.Fee_Type__c == 'Gross' && acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0){
                    adminFee =  proposedDirectContractPrice*(acc.Phoenix_Fee__c/100);
                }
                else if(acc.Fee_Type__c == 'Net' && acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0){
                    adminFee =  (proposedDirectContractPrice-proposedPUR)*(acc.Phoenix_Fee__c/100);
                    
                }
                if(acc.Rebate_Type__c == 'Gross' && acc.Phoenix_Rebates__c != null && acc.Phoenix_Rebates__c != 0){
                    rebateFee =  proposedDirectContractPrice*(acc.Phoenix_Rebates__c/100);
                }
                else if(acc.Rebate_Type__c == 'Net' && acc.Phoenix_Rebates__c != null && acc.Phoenix_Rebates__c != 0){
                    rebateFee =  (proposedDirectContractPrice-proposedPUR)*(acc.Phoenix_Rebates__c/100);
                    
                }
                if(acc.Phoenix_VIP_Type__c == 'Gross' && acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c != 0){
                    vipDollar =  proposedDirectContractPrice*(acc.Phoenix_VIP__c/100);
                }
                else if(acc.Phoenix_VIP_Type__c == 'Net' && acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c != 0){
                    vipDollar =  (proposedDirectContractPrice-proposedPUR)*(acc.Phoenix_VIP__c/100);
                    
                }
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0){
                    directCD = proposedDirectContractPrice * (acc.Phoenix_Cash_Discount__c/100);   
                }
                system.debug('cash discount====='+acc.Phoenix_Cash_Discount__c);
                system.debug('proposedDirectContractPrice====='+proposedDirectContractPrice);
                system.debug('proposedPUR====='+proposedPUR);
                system.debug('adminFee====='+adminFee);
                system.debug('rebateFee====='+rebateFee);
                system.debug('vipDollar====='+vipDollar);
                system.debug('directCD====='+directCD);
                customerDeadnet = (proposedDirectContractPrice-proposedPUR-adminFee-rebateFee-vipDollar-directCD)>0 ? (proposedDirectContractPrice-proposedPUR-adminFee-rebateFee-vipDollar-directCD) : 0;
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'Direct';
                    responseJSON.errorMessage ='Some thing went wrong with the Direct';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                } 
            }
            else if(bidTemplate == 'Indirect'){
                //proposedPUR 
                Decimal adminFee=0;//AC
                Decimal rebateFee=0;//AG
                Decimal vipDollar=0;//AI
                Decimal indirectCD=0; //AK 
                Decimal RDC=0;//AM
                Decimal CMFee=0;//AO
                system.debug('ffees====='+acc.Phoenix_Fee__c);
                system.debug('Fee_Type__c====='+acc.Fee_Type__c);
                if(acc.Fee_Type__c == 'Gross'){
                    adminFee =  proposedIndirectContractPrice*(acc.Phoenix_Fee__c/100);
                }
                else if(acc.Fee_Type__c == 'Net'){
                    adminFee =  (proposedIndirectContractPrice-proposedPUR)*(acc.Phoenix_Fee__c/100);
                    
                }
                if(acc.Rebate_Type__c == 'Gross'){
                    rebateFee =  proposedIndirectContractPrice*(acc.Phoenix_Rebates__c/100);
                }
                else if(acc.Rebate_Type__c == 'Net'){
                    rebateFee =  (proposedIndirectContractPrice-proposedPUR)*(acc.Phoenix_Rebates__c/100);
                    
                }
                if(acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c !=0)
                    vipDollar =  proposedIndirectContractPrice*(acc.Phoenix_VIP__c/100);
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c !=0)                
                    indirectCD = wacValue * (acc.Phoenix_Cash_Discount__c/100);
                if(RDCNLCPerc != null && RDCNLCPerc !=0)                
                    RDC = wacValue * (RDCNLCPerc/100);
                if(cmfeePerc != null && cmfeePerc !=0)                
                    CMFee = proposedIndirectContractPrice *(cmfeePerc/100);
                system.debug('cash discount====='+acc.Phoenix_Cash_Discount__c);
                system.debug('proposedDirectContractPrice====='+proposedDirectContractPrice);
                system.debug('RDC====='+RDC);
                system.debug('CMFee====='+CMFee);
                system.debug('adminFee====='+adminFee);
                system.debug('rebateFee====='+rebateFee);
                system.debug('vipDollar====='+vipDollar);
                system.debug('indirectCD====='+indirectCD);
                customerDeadnet = (proposedIndirectContractPrice-proposedPUR-adminFee-rebateFee-vipDollar-indirectCD-RDC-CMFee) >0 ? (proposedIndirectContractPrice-proposedPUR-adminFee-rebateFee-vipDollar-indirectCD-RDC-CMFee).setScale(2) : 0;
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'Indirect';
                    responseJSON.errorMessage ='Some thing went wrong with the Indirect';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }           
            }
            else if(bidTemplate == 'Humana' && bidTemplateStr == 'Humana Indirect retail'){
                Decimal indirectCD=0; //AK 
                Decimal CMFee=0;//AO
                if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                    indirectCD = proposedIndirectContractPrice * (acc.Phoenix_Cash_Discount__c/100);
                if(cmfeePerc != null && cmfeePerc != 0)
                    CMFee = wacValue *(cmfeePerc/100);
                system.debug('indirectCD ====='+acc.Phoenix_Cash_Discount__c);
                system.debug('indirectCD ====='+indirectCD);
                system.debug('CMFee ====='+cmfeePerc);
                system.debug('CMFee ====='+CMFee);
                customerDeadnet = proposedIndirectContractPrice - CMFee - indirectCD;
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'Humana Indirect retail';
                    responseJSON.errorMessage ='Some thing went wrong with the Humana Indirect retail';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }    
                
            }
            else if(bidTemplate == 'Humana' && bidTemplateStr == 'Humana Indirect CII'){
                Decimal indirectCD = 0; //AK 
                Decimal CMFee = 0;//AO
                
                if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c !=0)
                indirectCD = wacValue * (acc.Phoenix_Indirect_Cash_Discount__c/100);
                if(cmfeePerc != null && cmfeePerc !=0)
                CMFee = (proposedIndirectContractPrice *(cmfeePerc/100)).setScale(4);
                system.debug('proposedIndirectContractPrice ====='+proposedIndirectContractPrice);
                system.debug('proposedDirectContractPrice ====='+proposedDirectContractPrice);
                 system.debug('indirectCD ====='+acc.Phoenix_Cash_Discount__c);
                system.debug('indirectCD ====='+indirectCD);
                system.debug('CMFee ====='+cmfeePerc);
                system.debug('CMFee ====='+CMFee);
                customerDeadnet = (proposedDirectContractPrice - CMFee - indirectCD).setScale(2);
                if(customerDeadnet !=null){
                    responseJSON.status='Success';
                    responseJSON.Success='Deadnet Price is  '+string.valueOf(customerDeadnet);
                }
                else{
                    responseJSON.status = 'Humana Indirect CII';
                    responseJSON.errorMessage ='Some thing went wrong with the Humana Indirect CII';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                }    
                
            }
            else{
                responseJSON.status = 'Failure';
                responseJSON.errorMessage ='Please Provide Correct Template Name';
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='Received Wrong template Name.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
            }
          
        }
        
        
        //ABC Progen
        
        
        else{
            responseJSON.status = 'Failure';
            responseJSON.errorMessage ='No JSON body received.';
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Panaroma_GetDeadnetPrice_REST', Phoenix_Error_Message__c='No JSON body received.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='getDeadnetPrice', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
        }
        
        
        return  responseJSON;
    }
    global class responseWrapper {
        
        global String status {get;set;} //status string
        global string errorMessage {get;set;}
        global string Success{get;set;}
        //constructor
        global responseWrapper() {
            //default all values
            this.status = '';
            this.errorMessage= '';
            this.Success='';
        }
    }
    
}