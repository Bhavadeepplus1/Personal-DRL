@RestResource(urlMapping='/GetDeadnetPrice1/*')

global class DeadNet_Calculator_Class {
    @AuraEnabled  @Httppatch
     global static String getTemplate(String accId, Decimal wac,Decimal contractPrice,String productType,String Template){
        String bidTemplate;
        String query = '';
        String SobjectApiName = 'Account';
        query = 'SELECT '+Phoenix_Util.customerFields+' FROM '+SobjectApiName+' WHERE Id =: accId LIMIT 1';
        Account acc = Database.query(query);
        //  Account acc = [SELECT Id,Phoenix_Customer_Class_Bid_Template__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Is_Govt_Customer__c,Phoenix_VIP__c,Phoenix_Cash_Discount__c,Phoenix_Rebates__c,Phoenix_Order_Analytics_Fee__c,Phoenix_Wbad_VIR__c,Phoenix_Local_VIP__c,Phoenix_Fee__c from Account where AccountNumber =: accNumber];
        bidTemplate = acc.Phoenix_Customer_Class_Bid_Template__c;
        return bidTemplate;
    }
    @AuraEnabled @Httppost
  global static resultResponseWrapper calculateDeadNet(String params){
      system.debug('params...'+params);
        responseWrapper wrap = (responseWrapper)JSON.deserialize(params, responseWrapper.class);
        system.debug('bidTemplateStr====='+wrap.bidTemplateStr);
        String prefferedWholesaler;
        String customerType;
        if(wrap.bidTemplateStr == 'ABC Progen'){
            wrap.bidTemplateStr=null;
        }
        system.debug('bidTemplateStr====='+wrap.bidTemplateStr);
        
        Decimal vipperc=0;
        Decimal vipperUnit=0;
        Decimal cmfeePerc=0;
        Decimal cmFeePerUnit=0;
        Decimal rebatePerc=0;
        Decimal rebatespPerUnit=0;
        Decimal orderAnltFeePerc=0;
        Decimal orderanlfeeunit=0;
        Decimal grpVIPPerc=0;
        Decimal grpVIPPerUnit=0;
        Decimal salesoutPrmPerc=0;
        Decimal salesoutPromotionPerUnit=0;
        Decimal salesoutPrmNoDays=0;
        Decimal cashDiscountPerUnit=0;
        Decimal cashDiscPerc=0;
        Decimal customerDeadnet = 0;
        Decimal Deadnetprice=0;
        Decimal localVIPPerc=0;
        Decimal localVIPPerUnit=0;
        Decimal accFeePerc=0;
        Decimal accFeePerUnit=0;
        Decimal RDCNLCPerc=0;
        Decimal RDCNLC=0;
        Decimal DRLDeadNet=0;
        String accountId =wrap.accId;
        //added by Srimayee
        Decimal directCD = 0;
        String query = '';
        String SobjectApiName = 'Account';
        query = 'SELECT '+Phoenix_Util.customerFields+' FROM '+SobjectApiName+' WHERE Id =: accountId LIMIT 1';
        Account acc = Database.query(query);
        //  Account acc = [SELECT Id,Phoenix_Customer_Class_Bid_Template__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Is_Govt_Customer__c,Phoenix_VIP__c,Phoenix_Cash_Discount__c,Phoenix_Rebates__c,Phoenix_Order_Analytics_Fee__c,Phoenix_Wbad_VIR__c,Phoenix_Local_VIP__c,Phoenix_Fee__c from Account where AccountNumber =: accNumber];
        String bidTemplate = acc.Phoenix_Customer_Class_Bid_Template__c;
        System.debug('bid template==>'+acc.Phoenix_Customer_Class_Bid_Template__c);
        
        System.debug('customerType==>'+acc.Phoenix_Is_Govt_Customer__c);
        prefferedWholesaler = acc.Phoenix_Preferred_Wholesaler__c != null ? acc.Phoenix_Preferred_Wholesaler__c : '';
        System.debug('prefferedWholesaler==>'+prefferedWholesaler);
        if(acc.Phoenix_Is_Govt_Customer__c == true){
            customerType = 'Govt business';
        }else{
            customerType = 'Non Govt business';   
        }
        
        List<Phoenix_Bid_Fee_Master__c> cmfeerecord = new  List<Phoenix_Bid_Fee_Master__c>();
        List<Phoenix_Bid_Fee_Master__c> rdcNLCrecord =  new List<Phoenix_Bid_Fee_Master__c>();
        if(prefferedWholesaler != null && prefferedWholesaler != ''){
            cmfeerecord = [SELECT Id,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Fee__c,Phoenix_Customer_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =:prefferedWholesaler AND Phoenix_Customer_Type__c = :customerType AND Phoenix_Product_Type_for_CM_Fee__c =:wrap.productType AND Phoenix_Fee_Type__c = 'CM Fee%'];
            
        }
        if(prefferedWholesaler != null && prefferedWholesaler != ''){
            rdcNLCrecord = [SELECT Id,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Fee__c,Phoenix_Customer_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =:prefferedWholesaler AND Phoenix_Fee_Type__c = 'RDC/NLC %'];
            
        }
        if(cmfeerecord.size()>0){
            if(cmfeerecord[0].Phoenix_Fee_Type__c != null && cmfeerecord[0].Phoenix_Fee_Type__c != '' && cmfeerecord[0].Phoenix_Fee_Type__c == 'CM Fee%')
                cmfeePerc = cmfeerecord[0].Phoenix_Fee__c != null ? (cmfeerecord[0].Phoenix_Fee__c) : 0;     
        }
        if(rdcNLCrecord.size()>0){
            if(rdcNLCrecord[0].Phoenix_Fee_Type__c != null && rdcNLCrecord[0].Phoenix_Fee_Type__c !='' && rdcNLCrecord[0].Phoenix_Fee_Type__c == 'RDC/NLC %')
                RDCNLCPerc = rdcNLCrecord[0].Phoenix_Fee__c != null ? (rdcNLCrecord[0].Phoenix_Fee__c) : 0; 
            RDCNLC = rdcNLCrecord[0].Phoenix_Fee__c != null ? rdcNLCrecord[0].Phoenix_Fee__c : 0; 
        }
        vipperc = acc.Phoenix_VIP__c != null ? acc.Phoenix_VIP__c : 0;
        rebatePerc = acc.Phoenix_Rebates__c != null ? acc.Phoenix_Rebates__c : 0;
        
        orderAnltFeePerc = acc.Phoenix_Order_Analytics_Fee__c != null ?  acc.Phoenix_Order_Analytics_Fee__c : 0;
        
        grpVIPPerc = 	acc.Phoenix_Wbad_VIR__c != null ? acc.Phoenix_Wbad_VIR__c : 0;
        
        cashDiscPerc = acc.Phoenix_Cash_Discount__c != null ? acc.Phoenix_Cash_Discount__c : 0;
        
        //for progen//
        localVIPPerc = acc.Phoenix_Local_VIP__c != null ? acc.Phoenix_Local_VIP__c : 0;
        
        accFeePerc = acc.Phoenix_Fee__c != null ? acc.Phoenix_Fee__c :0;
        resultResponseWrapper resWrap = new resultResponseWrapper();
        if(bidTemplate == 'Walgreens'){
            Decimal IndirectDeadNet = 0;
            if(vipperc != null && vipperc != 0)
                vipperUnit = (wrap.contractPrice  * vipperc) /100;
            if(cmfeePerc != null && cmfeePerc != 0)
                cmFeePerUnit = (wrap.contractPrice * (cmfeePerc/100));
            if(rebatePerc != null && rebatePerc != 0)
                rebatespPerUnit =  (wrap.contractPrice * rebatePerc) /100;
            if(orderAnltFeePerc != null && orderAnltFeePerc != 0)
                orderanlfeeunit = (wrap.contractPrice * orderAnltFeePerc) /100;
            if(grpVIPPerc != null && grpVIPPerc != 0)
                grpVIPPerUnit = (wrap.contractPrice * grpVIPPerc) /100;
            if(localVIPPerc != null && localVIPPerc != 0)
                localVIPPerUnit = (wrap.contractPrice * localVIPPerc) /100;
            if(cashDiscPerc != null && cashDiscPerc != 0)
                cashDiscountPerUnit = (wrap.wac * cashDiscPerc) /100;
            customerDeadnet = (wrap.contractPrice - vipperUnit - cmFeePerUnit  - cashDiscountPerUnit).setScale(2);
            IndirectDeadNet = (wrap.contractPrice - vipperUnit - cmFeePerUnit - rebatespPerUnit - orderanlfeeunit - grpVIPPerUnit  - cashDiscountPerUnit).setScale(2);
            resWrap.customerDeadnet = customerDeadnet;
            resWrap.IndirectDeadNet = IndirectDeadNet;
            
        }
        else if(bidTemplate == 'ABC Progen' && wrap.bidTemplateStr == null){
             Decimal IndirectDeadNet = 0;
            vipperUnit = (wrap.contractPrice * vipperc) /100;
            rebatespPerUnit =  (wrap.contractPrice * rebatePerc) /100;
            grpVIPPerUnit = (wrap.contractPrice * grpVIPPerc) /100;
            cashDiscountPerUnit = (wrap.wac * cashDiscPerc) /100;
            localVIPPerUnit = (wrap.contractPrice * localVIPPerc) /100;
            accFeePerUnit = (wrap.contractPrice * accFeePerc) /100;
            Decimal vipDiffPerUnit = (((vipperc -localVIPPerc)/100) * wrap.contractPrice);
            customerDeadnet = (wrap.contractPrice - localVIPPerUnit - accFeePerUnit - cashDiscountPerUnit).setScale(2);
            IndirectDeadNet = (wrap.contractPrice - localVIPPerUnit - vipDiffPerUnit - accFeePerUnit  - rebatespPerUnit  - grpVIPPerUnit - cashDiscountPerUnit).setScale(2);
            resWrap.customerDeadnet = customerDeadnet;
            resWrap.IndirectDeadNet = IndirectDeadNet;
        }
        
        else if(bidTemplate == 'ABC Progen' && wrap.bidTemplateStr == 'ABC Pharmagen'){
            Decimal rebate=0;
            Decimal CD=0;
            Decimal additionalRebate=0;
            system.debug('bidTemplateStr====='+wrap.bidTemplateStr);
            if(acc.Phoenix_Rebate_Pharmagen__c != null && acc.Phoenix_Rebate_Pharmagen__c != 0)
                rebate = wrap.contractPrice * (acc.Phoenix_Rebate_Pharmagen__c/100);
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                CD = wrap.wac *(acc.Phoenix_Cash_Discount__c/100);
            additionalRebate = (1.25*wrap.contractPrice)/100;
            //Harmonized Dead net
            customerDeadnet = wrap.contractPrice - rebate - CD;
            DRLDeadNet = (customerDeadnet - additionalRebate).setScale(2);
            system.debug('DRLDeadNet====='+DRLDeadNet);
            
            resWrap.DRLDeadNet = DRLDeadNet;
            
        }
        else if(bidTemplate == 'Humana' && wrap.bidTemplateStr == 'Humana Indirect retail'){
            Decimal indirectCD=0; //AK 
            Decimal CMFee=0;//AO
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                indirectCD = wrap.contractPrice * (acc.Phoenix_Cash_Discount__c/100);
            if(cmfeePerc != null && cmfeePerc != 0)
                CMFee = wrap.wac *(cmfeePerc/100);
            
            customerDeadnet = wrap.contractPrice - CMFee - indirectCD;
            
            resWrap.customerDeadnet = customerDeadnet;
            
        }
        else if(bidTemplate == 'Humana' && wrap.bidTemplateStr == 'Humana Indirect CII'){
            Decimal indirectCD = 0; //AK 
            Decimal CMFee = 0;//AO
            
            if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c !=0)
                indirectCD = wrap.wac * (acc.Phoenix_Indirect_Cash_Discount__c/100);
            if(cmfeePerc != null && cmfeePerc !=0)
                CMFee = (wrap.contractPrice *(cmfeePerc/100)).setScale(4);
            
            customerDeadnet = (wrap.directContractPrice - CMFee - indirectCD).setScale(2);
            resWrap.customerDeadnet = customerDeadnet;
            
            
        }
        else if(bidTemplate == 'Government Pricing'){
            Decimal adminFee=0;//AC
            Decimal rebateFee=0;//AG
            Decimal indirectCD=0; //AK 
            Decimal RDC=0;//AM
            Decimal CMFee=0;//AO
            if(acc.Rebate_Type__c == 'Gross'){
                rebateFee =  wrap.contractPrice*(acc.Phoenix_Rebates__c/100);
            }
            else if(acc.Rebate_Type__c == 'Net'){
                rebateFee =  (wrap.contractPrice-wrap.proposedPUR)*(acc.Phoenix_Rebates__c/100);
                
            }                
            indirectCD = wrap.wac * (acc.Phoenix_Indirect_Cash_Discount__c/100);
            
            if(RDCNLCPerc != null && RDCNLCPerc != 0)
                RDC = wrap.wac * (RDCNLCPerc/100);
            if(cmfeePerc != null && cmfeePerc != 0)
                CMFee = wrap.contractPrice *(cmfeePerc/100);
            
            customerDeadnet = (wrap.contractPrice - indirectCD - RDC - CMFee - rebateFee).setScale(2);
            resWrap.customerDeadnet = customerDeadnet;
            
        }
        else if(bidTemplate == 'Sams Club'){
            //wrap.contractPrice as Indirect Price to be loaded @ABC & McKesson  
            Decimal indirectCD = 0;
            Decimal directCDval =0;
            Decimal CMFee =0;
            if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c!= 0)
                indirectCD =  wrap.wac * (acc.Phoenix_Indirect_Cash_Discount__c/100);//AC
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c!= 0)
                directCDval =  wrap.directContractPrice * (acc.Phoenix_Cash_Discount__c/100);//AB
            if(cmfeePerc != null && cmfeePerc!= 0)
                CMFee = wrap.contractPrice * (cmfeePerc/100);//AE
            system.debug('indirectCD====='+indirectCD);
            system.debug('directCDval====='+directCDval);
            system.debug('CMFee====='+CMFee);
            Decimal netIndirectPrice =  wrap.directContractPrice + indirectCD +CMFee-directCDval;
            system.debug('netIndirectPrice====='+netIndirectPrice);
            customerDeadnet = (wrap.contractPrice - netIndirectPrice) >0 ? netIndirectPrice-indirectCD-CMFee :0;
            resWrap.customerDeadnet = customerDeadnet;
            
        }
        else if(bidTemplate == 'Net Indirect Pricing'){
            Decimal indirectCD=0;
            Decimal CMFee=0;//AO
            Decimal directDeadNet=0;
            Decimal IndirectDeadNet=0;
            Decimal RDCIndirectCD=0;//RDC + indirect CD
            directCD = wrap.directContractPrice * (acc.Phoenix_Cash_Discount__c/100);
            directDeadNet = (wrap.directContractPrice - directCD ).setScale(2);//Direct Dead net
            system.debug('acc----'+acc.Phoenix_Indirect_Cash_Discount__c);
            system.debug('acc-----'+RDCNLCPerc);
            system.debug('acc-----'+acc.Phoenix_Indirect_Cash_Discount__c + acc.Phoenix_RDC_NLC__c);
            RDCIndirectCD = (acc.Phoenix_Indirect_Cash_Discount__c + RDCNLC )/100;
            system.debug('acc-----'+RDCIndirectCD);
            indirectCD = wrap.wac * RDCIndirectCD;
            if(acc.Phoenix_CM_Fees__c != null && acc.Phoenix_CM_Fees__c != 0){
                CMFee = wrap.contractPrice *(acc.Phoenix_CM_Fees__c/100); 
            }
            Decimal netIndirectPrice = wrap.directContractPrice + CMFee +  indirectCD - directCD;
            IndirectDeadNet = (netIndirectPrice - indirectCD - CMFee).setScale(2);
            resWrap.directDeadNet = directDeadNet;
            resWrap.IndirectDeadNet = IndirectDeadNet;
            
        }
        else if(bidTemplate == 'Direct'){
            //wrap.proposedPUR 
            Decimal adminFee=0;//AC
            Decimal rebateFee=0;//AG
            Decimal vipDollar=0;//AI
            //AK ------>  directCD
            if(acc.Fee_Type__c == 'Gross' && acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0){
                adminFee =  wrap.contractPrice*(acc.Phoenix_Fee__c/100);
            }
            else if(acc.Fee_Type__c == 'Net' && acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0){
                adminFee =  (wrap.contractPrice-wrap.proposedPUR)*(acc.Phoenix_Fee__c/100);
                
            }
            if(acc.Rebate_Type__c == 'Gross' && acc.Phoenix_Rebates__c != null && acc.Phoenix_Rebates__c != 0){
                rebateFee =  wrap.contractPrice*(acc.Phoenix_Rebates__c/100);
            }
            else if(acc.Rebate_Type__c == 'Net' && acc.Phoenix_Rebates__c != null && acc.Phoenix_Rebates__c != 0){
                rebateFee =  (wrap.contractPrice-wrap.proposedPUR)*(acc.Phoenix_Rebates__c/100);
                
            }
            if(acc.Phoenix_VIP_Type__c == 'Gross' && acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c != 0){
                vipDollar =  wrap.contractPrice*(acc.Phoenix_VIP__c/100);
            }
            else if(acc.Phoenix_VIP_Type__c == 'Net' && acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c != 0){
                vipDollar =  (wrap.contractPrice-wrap.proposedPUR)*(acc.Phoenix_VIP__c/100);
                
            }
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0){
                directCD = wrap.contractPrice * (acc.Phoenix_Cash_Discount__c/100);   
            }
            
            customerDeadnet = (wrap.contractPrice-wrap.proposedPUR-adminFee-rebateFee-vipDollar-directCD)>0 ? (wrap.contractPrice-wrap.proposedPUR-adminFee-rebateFee-vipDollar-directCD) : 0;
            resWrap.customerDeadnet = customerDeadnet;
        }
        else if(bidTemplate == 'Indirect'){
            //wrap.proposedPUR 
            Decimal adminFee=0;//AC
            Decimal rebateFee=0;//AG
            Decimal vipDollar=0;//AI
            Decimal indirectCD=0; //AK 
            Decimal RDC=0;//AM
            Decimal CMFee=0;//AO
            system.debug('ffees====='+acc.Phoenix_Fee__c);
            system.debug('Fee_Type__c====='+acc.Fee_Type__c);
            if(acc.Fee_Type__c == 'Gross'){
                adminFee =  wrap.contractPrice*(acc.Phoenix_Fee__c/100);
            }
            else if(acc.Fee_Type__c == 'Net'){
                adminFee =  (wrap.contractPrice-wrap.proposedPUR)*(acc.Phoenix_Fee__c/100);
                
            }
            if(acc.Rebate_Type__c == 'Gross'){
                rebateFee =  wrap.contractPrice*(acc.Phoenix_Rebates__c/100);
            }
            else if(acc.Rebate_Type__c == 'Net'){
                rebateFee =  (wrap.contractPrice-wrap.proposedPUR)*(acc.Phoenix_Rebates__c/100);
                
            }
            if(acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c !=0)
                vipDollar =  wrap.contractPrice*(acc.Phoenix_VIP__c/100);
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c !=0)                
                indirectCD = wrap.wac * (acc.Phoenix_Cash_Discount__c/100);
            if(RDCNLCPerc != null && RDCNLCPerc !=0)                
                RDC = wrap.wac * (RDCNLCPerc/100);
            if(cmfeePerc != null && cmfeePerc !=0)                
                CMFee = wrap.contractPrice *(cmfeePerc/100);
            
            customerDeadnet = (wrap.contractPrice-wrap.proposedPUR-adminFee-rebateFee-vipDollar-indirectCD-RDC-CMFee) >0 ? (wrap.contractPrice-wrap.proposedPUR-adminFee-rebateFee-vipDollar-indirectCD-RDC-CMFee).setScale(2) : 0;
            resWrap.customerDeadnet = customerDeadnet; 
        }
        else if(bidTemplate == 'RXSS'){
            //retailDirectDRLNETPrice retailIndirectDRLNETPrice Wholesaler DRL Net Price wrap.directContractPrice(Anda CP Price) retailIndirectMarketingPrice
            //decimal directCD;
            decimal retailDirectAdminFee=0;
            decimal RetailDirectVIP=0;
            decimal retailDirectDRLNETPrice=0;
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                directCD = wrap.directContractPrice * (acc.Phoenix_Cash_Discount__c/100);
            if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c >0)
                retailDirectAdminFee = wrap.directContractPrice * (acc.Phoenix_Fee__c/100);
            if(acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c >0)
                RetailDirectVIP = (acc.Phoenix_VIP__c/100)*(wrap.directContractPrice - retailDirectAdminFee);
            retailDirectDRLNETPrice = (wrap.directContractPrice - directCD - retailDirectAdminFee - RetailDirectVIP).setScale(2);
            decimal retailIndirectDRLDeadnet=0;
            decimal retailIndirectAdminFees=0; 
            decimal retailIndirectVIP=0;
            decimal RetailIndirectNetMarketing=0;
            decimal cmfeeVal=0;
            decimal rdcVal=0;
            decimal cdVal=0;
            decimal retailIndirectwacNLCFee=0;
            decimal retailIndirectWholsesalerFee=0;
            if(cmfeePerc != null && cmfeePerc >0)
                cmfeeVal = (wrap.contractPrice * (cmfeePerc/100));
            if(RDCNLCPerc != null && RDCNLCPerc >0)
                rdcVal = ((RDCNLCPerc/100)*wrap.wac);
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                cdVal = ((acc.Phoenix_Cash_Discount__c/100)*wrap.directContractPrice);
            RetailIndirectNetMarketing = wrap.directContractPrice + cmfeeVal + rdcVal - cdVal;//Anda CP Price
            decimal retailIndirectZITD = wrap.contractPrice - RetailIndirectNetMarketing;
            retailIndirectAdminFees = (acc.Phoenix_Fee__c/100) * (wrap.contractPrice - retailIndirectZITD);
            retailIndirectVIP = (acc.Phoenix_VIP__c/100)*(wrap.contractPrice - retailIndirectZITD - retailIndirectAdminFees);
            retailIndirectwacNLCFee = (cmfeePerc/100) * wrap.wac;
            retailIndirectWholsesalerFee = (cmfeePerc/100) *wrap.contractPrice;
            retailIndirectDRLDeadnet = (wrap.contractPrice - retailIndirectAdminFees - retailIndirectVIP - retailIndirectwacNLCFee - retailIndirectWholsesalerFee - retailIndirectZITD).setScale(2);
            decimal wholesalerDRLNetPrice=0;
            decimal WhlsrPrice=0;
            decimal whslrVal=0;
            decimal WholsesalerCD=0;
            decimal wholsesalerAdminFee=0;
            decimal WholsesalerVIP=0;
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                whslrVal =   ((acc.Phoenix_Cash_Discount__c/100) * wrap.wac) - ((acc.Phoenix_Cash_Discount__c/100) * wrap.directContractPrice);
            if(wrap.directContractPrice >0){
                WhlsrPrice = wrap.directContractPrice + whslrVal;
            }
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c >0)
                WholsesalerCD = wrap.wac * (acc.Phoenix_Cash_Discount__c/100);
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
                ANDAAdminFees = wrap.directContractPrice * (acc.Phoenix_Fee__c/100);
            if(acc.Phoenix_VIP__c != null && acc.Phoenix_VIP__c >0)
                ANDAVIP = (wrap.directContractPrice - ANDAAdminFees) * (acc.Phoenix_VIP__c/100);
            ANDADRLNetPrice = (wrap.directContractPrice - CashTerms - ANDAAdminFees - ANDAVIP).setScale(2);
            resWrap.retailDirectDRLNETPrice = retailDirectDRLNETPrice;
            resWrap.retailIndirectDRLDeadnet = retailIndirectDRLDeadnet;
            resWrap.wholesalerDRLNetPrice = wholesalerDRLNetPrice;
            resWrap.ANDADRLNetPrice = ANDADRLNetPrice;
        }
        else if(bidTemplate == 'Econdisc'){
            
            decimal finalprice = wrap.contractPrice != null ? wrap.contractPrice : wrap.wholesalerPriceIndirect;
            decimal RebatePercDollar=0;//BB
            decimal CDPerUnit=0;//BF
            decimal adminFee=0;//AY
            decimal VIPpercPerUnit=0;//AV 
            Decimal salesoutPrromotion=0;//BE
            //decimal drlDeadNet=0;//BH
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
            system.debug('Val====='+(wrap.contractPrice - CDPerUnit - adminFee - RebatePercDollar));
            Decimal Val=wrap.contractPrice - CDPerUnit - adminFee - RebatePercDollar;
            if(Val != null && Val != 0)
                VIPpercPerUnit = (acc.Phoenix_VIP__c/100) * Val;
            customerDeadnet = (wrap.contractPrice - VIPpercPerUnit).setScale(2); //AW
            system.debug('salesoutPromotionDays====='+wrap.salesoutPromotionDays);
            system.debug('salesOutPromotionPercentage====='+wrap.salesOutPromotionPercentage);
            // salesoutPrromotion = (wrap.contractPrice * wrap.salesoutPromotionDays * wrap.salesOutPromotionPercentage) /360;
            system.debug('finalprice====='+finalprice);
            system.debug('RebatePercDollar====='+RebatePercDollar);
            system.debug('CDPerUnit====='+CDPerUnit);
            system.debug('adminFee====='+adminFee);
            system.debug('VIPpercPerUnit====='+VIPpercPerUnit);
            system.debug('iodPerUnit====='+iodPerUnit);
            
            DRLDeadNet = (customerDeadnet - adminFee - salesoutPrromotion - CDPerUnit - RebatePercDollar).setScale(2);
            Decimal ProposedZITD=0;//BL
            decimal adminFeeDollar=0;//AY
            decimal indirectCD=0;//BM
            decimal rdcNLCdollar=0;//BP
            decimal CMFeePerUnitDollar=0;//BR
            decimal IndirectVIPPerUnit=0;//BN
            decimal IndirectDeadNet=0;//BS
            
            
            if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c != 0)
                indirectCD = (wrap.wac * (acc.Phoenix_Indirect_Cash_Discount__c/100)).setScale(4);
            if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                adminFeeDollar = wrap.contractPrice * (acc.Phoenix_Fee__c/100);
            ProposedZITD = wrap.wholesalerPriceIndirect-wrap.contractPrice; 
            if(RDCNLCPerc != null && RDCNLCPerc != 0)
                rdcNLCdollar = (wrap.wac * (RDCNLCPerc/100)).setScale(4);
            if(cmfeePerc != null && cmfeePerc != 0)
                CMFeePerUnitDollar = (wrap.wac * (cmfeePerc/100)).setScale(4);
            IndirectVIPPerUnit = ((wrap.wholesalerPriceIndirect - ProposedZITD - adminFeeDollar - CDPerUnit - RebatePercDollar) * (acc.Phoenix_VIP__c/100)).setScale(4);
            system.debug('ProposedZITD====='+ProposedZITD);
            system.debug('adminFeeDollar====='+adminFeeDollar);
            system.debug('indirectCD====='+indirectCD);
            system.debug('rdcNLCdollar====='+rdcNLCdollar);
            system.debug('CMFeePerUnitDollar====='+CMFeePerUnitDollar);
            system.debug('IndirectVIPPerUnit====='+IndirectVIPPerUnit);
            
            
            IndirectDeadNet = (wrap.wholesalerPriceIndirect - ProposedZITD - adminFeeDollar - indirectCD - rdcNLCdollar - CMFeePerUnitDollar - IndirectVIPPerUnit).setScale(2);
            system.debug('IndirectDeadNet====='+IndirectDeadNet);
            resWrap.DRLDeadNet = DRLDeadNet;
            resWrap.IndirectDeadNet = IndirectDeadNet;
            resWrap.customerDeadnet = customerDeadnet;
        }
        else if(bidTemplate == 'ClarusOne'){
            //wrap.ProposedNCPforMcKOSRAD wrap.ProposedNCPforWMTDirect wrap.ProposedNCPforWMTIndirect
            Decimal MckRADDataFee = 0;
            Decimal MckRebate = 0.0;
            Decimal MckAdminFee = 0;
            Decimal MckCashTerms = 0;
            Decimal MckRDC = 0;
            Decimal McKRADDeadNet = 0;
            Decimal CustomerDeadnetMcKAndRAD = 0;
            system.debug('wrap.ProposedNCPforMcKOSRAD====='+wrap.ProposedNCPforMcKOSRAD);
            system.debug('MckRADDataFee====='+acc.Phoenix_ABS__c);
            system.debug('MckRebate====='+acc.Mck_RAD_Rebate__c);
            system.debug('MckAdminFee====='+acc.Phoenix_Fee__c);
            system.debug('MckCashTerms====='+acc.Phoenix_Cash_Discount__c);
            system.debug('MckRDC====='+RDCNLCPerc);
            system.debug('McKRADDeadNet====='+RDCNLCPerc/100);
            if(acc.Phoenix_ABS__c != null && acc.Phoenix_ABS__c != 0)
                MckRADDataFee = wrap.ProposedNCPforMcKOSRAD * (acc.Phoenix_ABS__c/100);
            
            system.debug('Vaal====='+acc.Phoenix_Rebates__c/100);
            if(acc.Mck_RAD_Rebate__c != null && acc.Mck_RAD_Rebate__c != 0)
                MckRebate = wrap.ProposedNCPforMcKOSRAD * (acc.Mck_RAD_Rebate__c/100);
            if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                MckAdminFee = wrap.ProposedNCPforMcKOSRAD * (acc.Phoenix_Fee__c/100);
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                MckCashTerms = wrap.wac * (acc.Phoenix_Cash_Discount__c/100);
            if(RDCNLCPerc != null && RDCNLCPerc != 0)
                MckRDC = wrap.wac * (RDCNLCPerc/100);
            CustomerDeadnetMcKAndRAD = wrap.ProposedNCPforMcKOSRAD - MckRebate - MckAdminFee - MckCashTerms - MckRDC;
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
            system.debug('wrap.ProposedNCPforWMTDirect====='+wrap.ProposedNCPforWMTDirect);
            system.debug('WMTDirectInvoiceAllowance====='+acc.Phoenix_WMT_Direct_Rebate__c);
            system.debug('WMTDirectCashTerms====='+acc.Phoenix_Cash_Discount__c);
            system.debug('WMTDirectAdminFee====='+acc.Phoenix_Fee__c);
            if(acc.Phoenix_WMT_Direct_Rebate__c != null && acc.Phoenix_WMT_Direct_Rebate__c != 0)
                WMTDirectInvoiceAllowance = (wrap.ProposedNCPforWMTDirect * (acc.Phoenix_WMT_Direct_Rebate__c/100)).setScale(2);
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c != 0)
                WMTDirectCashTerms = (wrap.ProposedNCPforWMTDirect * (acc.Phoenix_Cash_Discount__c/100)).setScale(2);
            if(acc.Phoenix_Fee__c != null && acc.Phoenix_Fee__c != 0)
                WMTDirectAdminFee = (wrap.ProposedNCPforWMTDirect * (acc.Phoenix_Fee__c/100)).setScale(4);
            system.debug('WMTDirectInvoiceAllowance====='+WMTDirectInvoiceAllowance);
            system.debug('WMTDirectCashTerms====='+WMTDirectCashTerms);
            system.debug('WMTDirectAdminFee====='+WMTDirectAdminFee);
            if(wrap.ProposedNCPforWMTDirect > 0){
                system.debug('inside direct');
                WMTDirectDeadNet = (wrap.ProposedNCPforWMTDirect - WMTDirectInvoiceAllowance - WMTDirectCashTerms - WMTDirectAdminFee).setScale(2);    
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
                WMTIndirectAdminFee = wrap.ProposedNCPforWMTIndirect * (acc.Phoenix_Fee__c/100); 
            if(acc.Phoenix_Indirect_Cash_Discount__c != null && acc.Phoenix_Indirect_Cash_Discount__c != 0)
                WMTIndirectCD = wrap.wac * (acc.Phoenix_Indirect_Cash_Discount__c/100);
            if(RDCNLCPerc != null && RDCNLCPerc != 0)
                WMTIndirectRDC = wrap.wac * (RDCNLCPerc/100);
            WMTIndirectCMFees = wrap.ProposedNCPforWMTIndirect * (cmfeePerc/100);
            ZITD = wrap.ProposedNCPforWMTIndirect - wrap.ProposedNCPforWMTDirect;
            system.debug('WMTIndirectDeadNet====='+WMTIndirectDeadNet);
            system.debug('WMTIndirectAdminFee====='+WMTIndirectAdminFee);
            system.debug('WMTIndirectCD====='+WMTIndirectCD);
            system.debug('WMTIndirectRDC====='+WMTIndirectRDC);
            system.debug('WMTIndirectCMFees====='+WMTIndirectCMFees);
            system.debug('ZITD====='+ZITD);
            if(wrap.ProposedNCPforWMTIndirect > 0){
                WMTIndirectDeadNet = (wrap.ProposedNCPforWMTIndirect - WMTIndirectAdminFee - WMTIndirectCD - WMTIndirectCMFees - WMTIndirectRDC - ZITD).setScale(2);    
            }else{
                WMTIndirectDeadNet = 0; 
            }
            
            resWrap.McKRADDeadNet = McKRADDeadNet;
            resWrap.WMTDirectDeadNet = WMTDirectDeadNet;
            resWrap.WMTIndirectDeadNet = WMTIndirectDeadNet;
            resWrap.customerDeadnet = CustomerDeadnetMcKAndRAD;
        }
        else if(bidTemplate == 'ROS'){
            //wrap.contractPrice wrap.mktngPrice
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
            system.debug('wrap.mktngPrice====='+wrap.mktngPrice);
            system.debug('wrap.contractPrice====='+wrap.contractPrice);
            // if(wrap.mktngPrice > 0 && (acc.Phoenix_Cash_Discount__c /100) - (acc.Phoenix_Fee__c /100)) != 0){
            ProposedCVSDirectContractPrice = wrap.mktngPrice / (1 - FeePerc - CDPerc);
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
            ZITD = wrap.contractPrice - ProposedCVSDirectContractPrice;
            if(acc.Phoenix_Cash_Discount__c != null && acc.Phoenix_Cash_Discount__c !=0)
                indirectCD = wrap.wac * (acc.Phoenix_Cash_Discount__c /100);
            RDC = wrap.wac * (RDCNLCPerc/100);
            CMFee = wrap.contractPrice * (cmfeePerc/100);
            InternalCVSIndirectDeadNet = (wrap.contractPrice - ZITD - indirectCD - CMFee - RDC).setScale(2);
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
            CashDiscountonWAC = wrap.wac * (acc.Phoenix_Cash_Discount__c /100);//BY
            Decimal vals=1-PreferredCardinalRebate;
            if(CashDiscountonWAC != null && CashDiscountonWAC !=0 && wrap.mktngPrice !=null && wrap.mktngPrice !=0)
                ProposedCardinalContractPrice = ((wrap.mktngPrice + CashDiscountonWAC)/vals).setScale(4);//BI
            CardinalPreferredRebate = (ProposedCardinalContractPrice * PreferredCardinalRebate).setScale(4);//
            NLCFees = (wrap.wac * (RDCNLCPerc/100)).setScale(4);
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
            resWrap.InternalCVSDirectDeadNet = InternalCVSDirectDeadNet;
            resWrap.InternalCVSIndirectDeadNet = InternalCVSIndirectDeadNet;
            resWrap.InternalCardinalDeadNet = InternalCardinalDeadNet;
            resWrap.InternalMajorDeadNet = InternalMajorDeadNet;
        }
        else if(bidTemplate == 'Costco'){
            system.debug('=====Costco=====');
            //mktngPrice as Indirect Price to be loaded @ABC & McKesson   
            system.debug('indirectNet====='+wrap.indirectNet);            
            system.debug('indirectNet====='+wrap.contractPrice);            
            system.debug('rebatePerc====='+rebatePerc);            
            system.debug('cashDiscPerc====='+cashDiscPerc);            
            decimal indirectNet = wrap.indirectNet !=null ? wrap.indirectNet:null;//costco;
            decimal rebates = 0;
            decimal cashDiscount =0;
            if(rebatePerc >0)
                rebates = wrap.contractPrice * (rebatePerc/100);
            
            if(cashDiscPerc >0)
                cashDiscount = wrap.contractPrice * (cashDiscPerc/100);
            decimal deadnet = indirectNet - rebates - cashDiscount;
            system.debug('rebates====='+rebates);    
            system.debug('cashDiscount====='+cashDiscount);    
            system.debug('deadnet====='+deadnet);    
            resWrap.customerDeadnet = deadnet;
        }
        else if(bidTemplate == 'BASE/DSH'){
            // wrap.proposedBASEContractPrice wrap.ProposedDSHContractPrice wrap.ProposedAutoSubContractPrice
            Decimal baseCD=0;
            Decimal basePUR=0;//and aslo DSH PUR
            Decimal rebateFee=0;
            Decimal vipDollar=0;
            Decimal baseWholesalerFee=0;
            Decimal baseCustomerNetPrice=0;  
            Decimal bonafideFee=0;
            Decimal BASEDRLNetPrice=0;
            Decimal DSHCustNetPrice=0;
            Decimal DSHDRLNetPrice=0;
            Decimal DSHCD=0;//BT
            Decimal dshRebateFee=0;
            Decimal DSHWholesalerFee=0;//BU
            Decimal DSHBonafideFee=0;
            Decimal dshVIP=0;
            Decimal AutoSubDRLNetPrice=0;
            Decimal autoCD=0;
            Decimal autoRebateFee=0;
            Decimal autoBonafideFee=0;
            Decimal autoWholesalerFee=0;
            Decimal autoVIP=0;
            Decimal AutoCustNetPrice=0;
            Decimal baseCustNetPrice=0;
            system.debug('Phoenix_Cash_Discount__c====='+acc.Phoenix_Cash_Discount__c);
            system.debug('Phoenix_Rebates__c====='+acc.Phoenix_Rebates__c);
            system.debug('Phoenix_VIP__c====='+acc.Phoenix_VIP__c);
            system.debug('cmfeePerc====='+cmfeePerc);
            system.debug('Phoenix_Fee__c====='+acc.Phoenix_Fee__c);
            baseCD = wrap.wac * (acc.Phoenix_Cash_Discount__c/100);
            if(acc.Phoenix_Rebates__c > 0)
                rebateFee =  wrap.proposedBASEContractPrice*((acc.Phoenix_Rebates__c/100).setScale(0));
            if(acc.Phoenix_VIP__c > 0)
                vipDollar =  wrap.proposedBASEContractPrice*(acc.Phoenix_VIP__c/100);
            if(cmfeePerc > 0)
                baseWholesalerFee = wrap.proposedBASEContractPrice * (cmfeePerc/100);
            if(acc.Phoenix_Fee__c > 0)
                bonafideFee = (wrap.proposedBASEContractPrice * (acc.Phoenix_Fee__c/100));
            baseCustNetPrice=wrap.proposedBASEContractPrice - basePUR - rebateFee - vipDollar - bonafideFee;
            BASEDRLNetPrice = (baseCustNetPrice - baseCD - baseWholesalerFee).setScale(2);
            if(acc.Phoenix_Cash_Discount__c > 0)
                DSHCD = wrap.wac * (acc.Phoenix_Cash_Discount__c/100);
            if(cmfeePerc > 0)
                DSHWholesalerFee = wrap.ProposedDSHContractPrice * (cmfeePerc/100);
            if(acc.Phoenix_Fee__c > 0)
                DSHBonafideFee = (wrap.ProposedDSHContractPrice * (acc.Phoenix_Fee__c/100));
            if(acc.Phoenix_VIP__c > 0)
                dshVIP = (wrap.ProposedDSHContractPrice * (acc.Phoenix_VIP__c/100));
            system.debug('rebate Value====='+(acc.Phoenix_Rebates__c/100).setScale(0));
            if(acc.Phoenix_Rebates__c > 0)
                dshRebateFee = wrap.ProposedDSHContractPrice*(acc.Phoenix_Rebates__c/100);
            DSHCustNetPrice = wrap.ProposedDSHContractPrice - basePUR -dshRebateFee-dshVIP-DSHBonafideFee;
            DSHDRLNetPrice = (DSHCustNetPrice -DSHCD - DSHWholesalerFee).setScale(2);
            system.debug('DSHCD====='+DSHCD);
            system.debug('DSHWholesalerFee====='+DSHWholesalerFee);
            system.debug('DSHBonafideFee====='+DSHBonafideFee);
            system.debug('dshVIP====='+dshVIP);
            system.debug('dshRebateFee====='+dshRebateFee);
            system.debug('DSHCustNetPrice====='+DSHCustNetPrice);
            system.debug('DSHDRLNetPrice====='+DSHDRLNetPrice);
            if(acc.Phoenix_Cash_Discount__c > 0)
                autoCD = wrap.wac * (acc.Phoenix_Cash_Discount__c/100);
            if(cmfeePerc > 0)
                autoWholesalerFee = wrap.ProposedAutoSubContractPrice * (cmfeePerc/100);
            if(acc.Phoenix_VIP__c > 0)
                autoVIP = (wrap.ProposedAutoSubContractPrice * (acc.Phoenix_VIP__c/100));
            if(acc.Phoenix_Fee__c > 0)
                autoBonafideFee = (wrap.ProposedAutoSubContractPrice * (acc.Phoenix_Fee__c/100));
            if(acc.Phoenix_Rebates__c > 0)
                autoRebateFee = wrap.ProposedAutoSubContractPrice*((acc.Phoenix_Rebates__c/100)).setScale(0);
            AutoCustNetPrice = wrap.ProposedAutoSubContractPrice - basePUR - autoRebateFee - autoVIP - autoBonafideFee;
            
            AutoSubDRLNetPrice =  (AutoCustNetPrice - autoCD - autoWholesalerFee).setScale(2);
            resWrap.BASEDRLNetPrice = BASEDRLNetPrice;
            resWrap.DSHDRLNetPrice = DSHDRLNetPrice;
            resWrap.AutoSubDRLNetPrice = AutoSubDRLNetPrice;
        }
        /*  if(bidTemplate == 'Walgreens' || bidTemplate == 'ABC Progen' || bidTemplate == 'Government Pricing' || bidTemplate == 'Direct' || bidTemplate == 'Indirect' || bidTemplate == 'Humana' || bidTemplate == 'Sams Club' || bidTemplate == 'Costco'){
return customerDeadnet;
}
else if(bidTemplate == 'ABC Pharmagen'){
return DRLDeadNet;
}
else{
return null;
}*/
        return resWrap;
    }
    global class responseWrapper{
        @AuraEnabled public String accId;
        @AuraEnabled public Decimal wac;
        @AuraEnabled public Decimal contractPrice;
        @AuraEnabled public String productType;
        @AuraEnabled public String bidTemplateStr;
        @AuraEnabled public Decimal proposedPUR;
        @AuraEnabled public Decimal directContractPrice;
        @AuraEnabled public Decimal salesOutPromotionPercentage;
        @AuraEnabled public Decimal wholesalerPriceIndirect;
        @AuraEnabled public Decimal salesoutPromotionDays;
        @AuraEnabled public Decimal ProposedNCPforWMTIndirect;
        @AuraEnabled public Decimal ProposedNCPforMcKOSRAD;
        @AuraEnabled public Decimal ProposedNCPforWMTDirect;
        @AuraEnabled public Decimal mktngPrice;
        @AuraEnabled public Decimal indirectNet;
        @AuraEnabled public Decimal proposedBASEContractPrice;
        @AuraEnabled public Decimal ProposedDSHContractPrice;
        @AuraEnabled public Decimal ProposedAutoSubContractPrice;
    }
    global class resultResponseWrapper{
        @AuraEnabled public Decimal customerDeadnet;
        @AuraEnabled public Decimal DRLDeadNet;
        @AuraEnabled public Decimal IndirectDeadNet;
        @AuraEnabled public Decimal wholesalerDRLNetPrice;
        @AuraEnabled public Decimal retailDirectDRLNETPrice;
        @AuraEnabled public Decimal retailIndirectDRLDeadnet;
        @AuraEnabled public Decimal ANDADRLNetPrice;
        @AuraEnabled public Decimal McKRADDeadNet;
        @AuraEnabled public Decimal WMTDirectDeadNet;
        @AuraEnabled public Decimal WMTIndirectDeadNet;
        @AuraEnabled public Decimal InternalCVSDirectDeadNet;
        @AuraEnabled public Decimal InternalCVSIndirectDeadNet;
        @AuraEnabled public Decimal InternalCardinalDeadNet;
        @AuraEnabled public Decimal InternalMajorDeadNet;
        @AuraEnabled public Decimal directDeadNet;
        @AuraEnabled public Decimal BASEDRLNetPrice;
        @AuraEnabled public Decimal DSHDRLNetPrice;
        @AuraEnabled public Decimal AutoSubDRLNetPrice;
    }
}