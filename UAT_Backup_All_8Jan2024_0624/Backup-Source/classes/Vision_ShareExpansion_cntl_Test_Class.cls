@isTest(seeAlldata=true)
public class Vision_ShareExpansion_cntl_Test_Class {
    static testmethod void testingdata(){
        Account acc1 = new Account();
        acc1.Name= 'Test Account 1';
        acc1.Phoenix_Customer_Class_Bid_Template__c='Walgreens';
        Insert acc1;
        
        
        Account acc2 = new Account();
        acc2.Name= 'Test Account 2';
        acc2.Phoenix_Customer_Class_Bid_Template__c='ABC Pharmagen';
        Insert acc2;
        
        
        Account acc3 = new Account();
        acc3.Name= 'Test Account 3';
        acc3.Phoenix_Customer_Class_Bid_Template__c='ClarusOne';
        Insert acc3;
        
        Account acc4 = new Account();
        acc4.Name= 'Test Account 4';
        acc4.Phoenix_Customer_Class_Bid_Template__c='RXSS';
        Insert acc4;
		
        
        
        List<Opportunity> opplist = new List<Opportunity>();
        
        Opportunity opp1 = new Opportunity ();
        opp1.Name='Test opportunity';
        opp1.AccountId=acc1.id;
        opp1.CloseDate=system.today()+1;
        opp1.StageName='Sent to BRIGHT';
       // opp1.Vision_Internal_Closing_Date__c=system.today()+1;
        opp1.Bid_Type__c='Product Addition';
        opplist.add(opp1);
        
        Opportunity opp2 = new Opportunity ();
        opp2.Name='Levocetirizine-MSEmove-00049';
        opp2.AccountId=acc1.id;
        opp2.CloseDate=system.today()+1;
        opp2.StageName='Opportunity in progress';
       // opp2.Vision_Internal_Closing_Date__c=system.today()+1;
        opp2.Bid_Type__c='Price Change';
        opplist.add(opp2);
        
        Opportunity opp3 = new Opportunity ();
        opp3.Name='RAMELTEON-MSEmove-00050';
        opp3.AccountId=acc1.id;
        opp3.CloseDate=system.today()+1;
        opp3.StageName='Opportunity in progress';
        //opp3.Vision_Internal_Closing_Date__c=system.today()+1;
        opp3.Bid_Type__c='RFP';
        opplist.add(opp3);
        
        Insert opplist;
        
        
        Product2 p1 = new Product2();
        p1.Name='Test Product';
        p1.ProductCode='123456';
        p1.Phoenix_GPI_Generic_Product_Identifier__c='test123';
        p1.Phoenix_GCN_Generic_Code_Number__c='test456';
        p1.Phoenix_GCN_Sequence_Number__c='987456';
        p1.Family='Habitrol';
        p1.Phoenix_Rx_SRx_OTC__c = 'OTC';
        p1.Phoenix_Is_Private_Label_OTC__c = true;
        p1.Strength__c='strong';
        p1.Phoenix_Lowest_Price_SKU__c=10;
        p1.Description='good';
        p1.Phoenix_NDC_11__c='123';
        p1.Phoenix_Pkg_Size__c=20;
        p1.OTC_Customer__c = acc1.Id;
        //p1.Phoenix_Rx_SRx_OTC__c = 'OTC';
        Insert p1;
        
        
        Product2 p2 = new Product2();
        p2.Name='Test Product2';
        p2.ProductCode='1234567';
        p2.Phoenix_GPI_Generic_Product_Identifier__c='test1234';
        p2.Phoenix_GCN_Generic_Code_Number__c='test4567';
        p2.Phoenix_GCN_Sequence_Number__c='9874567';
        p2.Family='Habitrol';
        p2.Strength__c='strong';
        p2.Phoenix_Lowest_Price_SKU__c=100;
        p2.Description='goodItem';
        p2.Phoenix_NDC_11__c='1234';
        p2.Phoenix_Pkg_Size__c=25;
        Insert p2;
        
        
        Product2 p3 = new Product2();
        p3.Name='Test Product3';
        p3.ProductCode='12345678';
        p3.Phoenix_GPI_Generic_Product_Identifier__c='test12345';
        p3.Phoenix_GCN_Generic_Code_Number__c='test4567';
        p3.Phoenix_GCN_Sequence_Number__c='98745';
        p3.Family='Habitrol';
        p3.Strength__c='strong';
        p3.Phoenix_Lowest_Price_SKU__c=50;
        p3.Description='goodItem';
        p3.Phoenix_NDC_11__c='12345';
        p3.Phoenix_Pkg_Size__c=20;
        Insert p3;
        
        
        
        
        List<Phoenix_Contract__c> Ctlist  = new List<Phoenix_Contract__c>();
        Phoenix_Contract__c ct = new Phoenix_Contract__c ();
        ct.Phoenix_Contract_Number__c='3000000733';
        ct.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct.Phoenix_Contract_End_Date__c=system.today();
        
        ctlist.add(ct);
        Phoenix_Contract__c ct1 = new Phoenix_Contract__c ();
        ct1.Phoenix_Contract_Number__c='3000000957';
        ct1.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct1.Phoenix_Contract_End_Date__c=system.today();
        
        ctlist.add(ct1);
        
        Phoenix_Contract__c ct2 = new Phoenix_Contract__c ();
        ct2.Phoenix_Contract_Number__c='3000001332';
        ct2.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct2.Phoenix_Contract_End_Date__c=system.today();
        
        ctlist.add(ct2);
        insert ctlist;
        
        
        List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_Account__c=acc2.Id;
        npdata.Phoenix_Contract__c=ctlist[0].id;
        npdata.Phoenix_Product__c=p1.id;
        npdata.Phoenix_NPR_Status__c = 'Active';
        npdata.Phoenix_Contract_Type__c = 'Indirect';
        npdata.Phoenix_Contract_Number__c = '3000000733';
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        nprdtlist.add(npdata);
        
        Phoenix_NPR_Data__c  npdata1 = new Phoenix_NPR_Data__c();
        npdata1.Phoenix_Account__c=acc1.Id;
        npdata1.Phoenix_Contract__c=ctlist[1].id;
        npdata1.Phoenix_Product__c=p3.id;
        npdata1.Phoenix_Contract_Type__c = 'Indirect';
        npdata1.Phoenix_NPR_Status__c = 'Active';
        npdata1.Phoenix_Contract_Number__c = '3000000957';
        npdata1.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata1.Phoenix_12Months_Net_Sales__c=250.00;
        npdata1.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata1.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        nprdtlist.add(npdata1);
        
        Phoenix_NPR_Data__c  npdata2 = new Phoenix_NPR_Data__c();
        npdata2.Phoenix_Account__c=acc3.Id;
        npdata2.Phoenix_Contract__c=ctlist[2].id;
        npdata2.Phoenix_Product__c=p3.id;
        npdata2.Phoenix_Contract_Type__c = 'Indirect';
        npdata2.Phoenix_NPR_Status__c = 'Active';
        npdata2.Phoenix_Contract_Number__c = '3000001332';
        npdata2.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata2.Phoenix_12Months_Net_Sales__c=250.00;
        npdata2.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata2.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        nprdtlist.add(npdata2);
        
        Phoenix_NPR_Data__c  npdata3 = new Phoenix_NPR_Data__c();
        npdata3.Phoenix_Account__c=acc4.Id;
        npdata3.Phoenix_Contract__c=ctlist[2].id;
        npdata3.Phoenix_Product__c=p3.id;
        npdata3.Phoenix_Contract_Type__c = 'Indirect';
        npdata3.Phoenix_NPR_Status__c = 'Active';
        npdata3.Phoenix_Contract_Number__c = '3000001332';
        npdata3.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata3.Phoenix_12Months_Net_Sales__c=250.00;
        npdata3.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata3.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        nprdtlist.add(npdata3);
        
        insert nprdtlist;
        
        
        
        List<Vision_Market_Share_Expansion__c> vmselist= new List<Vision_Market_Share_Expansion__c>();
        
        Vision_Market_Share_Expansion__c vmse1 = new Vision_Market_Share_Expansion__c();
        vmse1.Vision_Customer__c=acc1.id;
        vmse1.Task_Status__c='Sent to OPPORTUNITY';
        vmse1.Vision_Product__c=p1.id;
        //vmse1.ProductOpportunity__c=po1.id;        
        vmse1.Vision_Product_Family__c='Habitrol';
        vmse1.Vision_Proposed_Volume__c = 10;
        vmse1.Proposed_Direct_Selling_Units__c = 20;
        vmse1.Proposed_Indirect_Selling_Units__c = 10;
        vmse1.Vision_Proposed_OS_Units__c = 30;
        vmse1.Vision_Proposed_RAD_Units__c = 10;
        vmse1.Vision_Proposed_WMT_Units__c = 40;
        vmse1.Vision_Proposed_BASE_Units__c = 10;
        vmse1.Vision_Proposed_DSH_Units__c = 10;
        vmse1.Vision_Proposed_AutoSub_Units__c = 20;
        vmse1.Vision_Proposed_Smith_Drug_Units__c = 50;
        vmse1.Vision_Proposed_Anda_Units__c = 20;
        vmse1.Vision_Proposed_DirectAholdDelhaizeUnits__c = 30;
        vmse1.Vision_Proposed_Direct_Gaint_Eagle_Units__c = 40;
        vmse1.Vision_Proposed_TotalRetailIndirectUnits__c = 10;
        vmse1.Vision_isAccepted__c=true;
        
        vmselist.add(vmse1);
        
        Vision_Market_Share_Expansion__c vmse2 = new Vision_Market_Share_Expansion__c();
        vmse2.Vision_Customer__c=acc2.id;
        vmse2.Task_Status__c='Sent to BRIGHT';
        vmse2.Vision_Product__c=p2.id;
        //vmse2.ProductOpportunity__c=po1.id;
        vmse2.Vision_Product_Family__c='Habitrol';
        vmse2.Vision_Proposed_Volume__c = 10;
        vmse2.Proposed_Direct_Selling_Units__c = 20;
        vmse2.Proposed_Indirect_Selling_Units__c = 10;
        vmse2.Vision_Proposed_OS_Units__c = 30;
        vmse2.Vision_Proposed_RAD_Units__c = 10;
        vmse2.Vision_Proposed_WMT_Units__c = 40;
        vmse2.Vision_Proposed_BASE_Units__c = 10;
        vmse2.Vision_Proposed_DSH_Units__c = 10;
        vmse2.Vision_Proposed_AutoSub_Units__c = 20;
        vmse2.Vision_Proposed_Smith_Drug_Units__c = 50;
        vmse2.Vision_Proposed_Anda_Units__c = 20;
        vmse2.Vision_Proposed_DirectAholdDelhaizeUnits__c = 30;
        vmse2.Vision_Proposed_Direct_Gaint_Eagle_Units__c = 40;
        vmse2.Vision_Proposed_TotalRetailIndirectUnits__c = 10;
        vmse2.Vision_isAccepted__c=true;
        vmselist.add(vmse2);
        
        
        Vision_Market_Share_Expansion__c vmse3 = new Vision_Market_Share_Expansion__c();
        vmse3.Vision_Customer__c=acc3.id;
        vmse3.Task_Status__c='New';
        vmse3.Vision_Product__c=p3.id;
        //vmse2.ProductOpportunity__c=po1.id;
        vmse3.Vision_Product_Family__c='Habitrol';
        vmse3.Vision_Proposed_Volume__c = 10;
        vmse3.Proposed_Direct_Selling_Units__c = 20;
        vmse3.Proposed_Indirect_Selling_Units__c = 10;
        vmse3.Vision_Proposed_OS_Units__c = 30;
        vmse3.Vision_Proposed_RAD_Units__c = 10;
        vmse3.Vision_Proposed_WMT_Units__c = 40;
        vmse3.Vision_Proposed_BASE_Units__c = 10;
        vmse3.Vision_Proposed_DSH_Units__c = 10;
        vmse3.Vision_Proposed_AutoSub_Units__c = 20;
        vmse3.Vision_Proposed_Smith_Drug_Units__c = 50;
        vmse3.Vision_Proposed_Anda_Units__c = 20;
        vmse3.Vision_Proposed_DirectAholdDelhaizeUnits__c = 30;
        vmse3.Vision_Proposed_Direct_Gaint_Eagle_Units__c = 40;
        vmse3.Vision_Proposed_TotalRetailIndirectUnits__c = 10;
        vmse3.Vision_isAccepted__c=true;
        vmselist.add(vmse3);
        
        Vision_Market_Share_Expansion__c vmse4 = new Vision_Market_Share_Expansion__c();
        vmse4.Vision_Customer__c=acc3.id;
        vmse4.Task_Status__c='New';
        vmse4.Vision_Product__c=p3.id;
        vmse4.ProductOpportunity__c=null;
        vmse4.Vision_Product_Family__c='Habitrol';
        vmse4.Vision_Proposed_Volume__c = 10;
        vmse4.Proposed_Direct_Selling_Units__c = 20;
        vmse4.Proposed_Indirect_Selling_Units__c = 10;
        vmse4.Vision_Proposed_OS_Units__c = 30;
        vmse4.Vision_Proposed_RAD_Units__c = 10;
        vmse4.Vision_Proposed_WMT_Units__c = 40;
        vmse4.Vision_Proposed_BASE_Units__c = 10;
        vmse4.Vision_Proposed_DSH_Units__c = 10;
        vmse4.Vision_Proposed_AutoSub_Units__c = 20;
        vmse4.Vision_Proposed_Smith_Drug_Units__c = 50;
        vmse4.Vision_Proposed_Anda_Units__c = 20;
        vmse4.Vision_Proposed_DirectAholdDelhaizeUnits__c = 30;
        vmse4.Vision_Proposed_Direct_Gaint_Eagle_Units__c = 40;
        vmse4.Vision_Proposed_TotalRetailIndirectUnits__c = 10;
        vmse4.Vision_isAccepted__c=true;
        vmselist.add(vmse4);
        
        Vision_Market_Share_Expansion__c vmse5 = new Vision_Market_Share_Expansion__c();
        vmse5.Vision_Customer__c=acc2.id;
        vmse5.Task_Status__c='New';
        //vmse5.Vision_Product__c=p3.id;
        vmse5.ProductOpportunity__c=null;
        vmse5.Vision_Product_Family__c='Habitrol';
        vmse5.Vision_Proposed_Volume__c = 10;
        vmse5.Proposed_Direct_Selling_Units__c = 20;
        vmse5.Proposed_Indirect_Selling_Units__c = 10;
        vmse5.Vision_Proposed_OS_Units__c = 30;
        vmse5.Vision_Proposed_RAD_Units__c = 10;
        vmse5.Vision_Proposed_WMT_Units__c = 40;
        vmse5.Vision_Proposed_BASE_Units__c = 10;
        vmse5.Vision_Proposed_DSH_Units__c = 10;
        vmse5.Vision_Proposed_AutoSub_Units__c = 20;
        vmse5.Vision_Proposed_Smith_Drug_Units__c = 50;
        vmse5.Vision_Proposed_Anda_Units__c = 20;
        vmse5.Vision_Proposed_DirectAholdDelhaizeUnits__c = 30;
        vmse5.Vision_Proposed_Direct_Gaint_Eagle_Units__c = 40;
        vmse5.Vision_Proposed_TotalRetailIndirectUnits__c = 10;
        vmse5.Vision_isAccepted__c=true;
        vmselist.add(vmse5);
        
        Insert vmselist;
        system.debug('list is --->' + vmselist[0].Vision_Product__c);
        
        
        List<Product_Opportunity__c> polist = new List<Product_Opportunity__c>();
        Product_Opportunity__c  po1=new Product_Opportunity__c();
        po1.Name= 'test product opportunity';
        po1.Opportunity__c=opp1.id;
        id prodid = vmse1.Vision_Product__c;
        po1.Product__c=prodid;
        po1.Opportunity__c = opp1.id;
        po1.Status__c='Matched';
        polist.add(po1);
        
        Product_Opportunity__c  po2=new Product_Opportunity__c();
        po2.Name= 'test product opportunity';
        id prodid1 = vmse2.Vision_Product__c;
        po2.Product__c=prodid1;
        po2.Opportunity__c=opp2.id;
        po2.Status__c='Matched';
        polist.add(po2);
        
        
        insert polist;
        
        Date internalTargetDate = system.today()+1;
        
       /* Vision_ShareExpansion_cntl.wrapper wp= new Vision_ShareExpansion_cntl.wrapper();
        wp.accObj=acc1;
        wp.expnList=vmselist;
        wp.expnObj=vmse1;
        wp.oppId=opp1.id;
        wp.oppName=opp1.Name;
        wp.prodFamilyName='Habitrol';*/
        
        List<string> pickList = new List<String>{'New','Sent to OPPORTUNITY','Sent to BRIGHT'};
            
        //Vision_ShareExpansion_cntl.getExpansionData(acc1.id,pickList);
        Vision_ShareExpansion_cntl.createOptyCntl(vmselist, 'Product Addition',100,string.valueOf(internalTargetDate),new List<String>{'3000000551','1000000701','3000000957','3000000105','3000001031','1000000767'},'Walgreens');
        Vision_ShareExpansion_cntl.createOptyCntl(vmselist, 'Product Addition',100,string.valueOf(internalTargetDate),new List<String>{'3000000551','1000000701','3000000957','3000000105','3000001031','1000000767'},'Walgreens');
        Vision_ShareExpansion_cntl.updateShareExpansionComment(vmse2, 'ndcComment');
        Vision_ShareExpansion_cntl.updateShareExpansionComment(null, 'ndcComment');
        vision_ShareExpansion_cntl.getContracts(acc1.Id,'','Walgreens');
        vision_ShareExpansion_cntl.saveNdcWithBidTemplate(vmselist, acc1.id);
        vision_ShareExpansion_cntl.saveShareExpWithContracts(new List<String>{'3000000957'},vmselist,acc1.id);
        vision_ShareExpansion_cntl.saveShareExpWithContracts(new List<String>{'3000000733'},vmselist,acc2.id);
        vision_ShareExpansion_cntl.saveShareExpWithContracts(new List<String>{'3000001332'},vmselist,acc3.id);
        vision_ShareExpansion_cntl.saveShareExpWithContracts(new List<String>{'3000001332'},vmselist,acc4.id);
        //vision_ShareExpansion_cntl.updateItems();
    }
    
    
}