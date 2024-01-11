@istest
public class Vision_ShareExpansionallpanorma_testcls {
static testmethod void testingdata(){
        Account acc1 = new Account();
        acc1.Name= 'Test Account 1';
        acc1.Phoenix_Customer_Class_Bid_Template__c='Walgreens';
        Insert acc1;
        
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
        p1.Strength__c='strong';
        p1.Phoenix_Lowest_Price_SKU__c=10;
        p1.Description='good';
        p1.Phoenix_NDC_11__c='123';
        p1.Phoenix_Pkg_Size__c=20;
        Insert p1;
        
        List<Product_Opportunity__c> polist = new List<Product_Opportunity__c>();
        Product_Opportunity__c  po1=new Product_Opportunity__c();
        po1.Name= 'test product opportunity';
        po1.Opportunity__c=opp1.id;
        polist.add(po1);
        
        Product_Opportunity__c  po2=new Product_Opportunity__c();
        po2.Name= 'test product opportunity';
        po2.Opportunity__c=opp2.id;
        polist.add(po2);
        
        insert polist;
        
        List<Vision_Market_Share_Expansion__c> vmselist= new List<Vision_Market_Share_Expansion__c>();
        
        Vision_Market_Share_Expansion__c vmse1 = new Vision_Market_Share_Expansion__c();
        vmse1.Vision_Customer__c=acc1.id;
        vmse1.Task_Status__c='Sent to OPPORTUNITY';
        vmse1.Vision_Product__c=p1.id;
        vmse1.ProductOpportunity__c=po1.id;
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
        vmse2.Vision_Customer__c=acc1.id;
        vmse2.Task_Status__c='Sent to BRIGHT';
        vmse2.Vision_Product__c=p1.id;
        vmse2.ProductOpportunity__c=po1.id;
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
        
        Insert vmselist;
        
        Date internalTargetDate = system.today()+1;
        
        
        List<string> pickList = new List<String>{'New','Sent to OPPORTUNITY','Sent to BRIGHT'};
            
        Vision_ShareExpansion_cntl_all_panorma.getExpansionData(pickList);
        Vision_ShareExpansion_cntl_all_panorma.createOptyCntl(vmselist, 'Product Addition',100,string.valueOf(internalTargetDate));
        Vision_ShareExpansion_cntl_all_panorma.updateShareExpansionComment(vmse2, 'ndcComment');
        Vision_ShareExpansion_cntl_all_panorma.updateShareExpansionComment(null, 'ndcComment');
        Vision_ShareExpansion_cntl_all_panorma.fetchSortResults('Vision_Customer__r.Name ', true, pickList);
    }
    
}