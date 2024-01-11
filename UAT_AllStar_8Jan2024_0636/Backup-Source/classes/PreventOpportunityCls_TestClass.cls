@istest
public class PreventOpportunityCls_TestClass {
    
    Static testmethod void testingdata()
    {
        Account acc = new Account();
        acc.Name='Test Account ';
        Insert acc;
        
        Opportunity opp = new Opportunity ();
        opp.Name= 'Test Opportunity ';
        opp.CloseDate= system.today();
        opp.StageName='Opportunity in progress';
        Insert opp;
        
        List<Product_Opportunity__c> polist = new List<Product_Opportunity__c>();
        
        Product_Opportunity__c  po1=new Product_Opportunity__c();
        po1.Name= 'test product opportunity';
        po1.Opportunity__c=opp.id;
        po1.Vision_Annual_Wmt_Units__c=10.0;
        po1.Vision_Total_Annual_Units__c=20.0;
        po1.Is_GSN_Pack_Size_Matched__c=True;
        po1.Is_GPI_Pack_Size_Matched__c=True;
        po1.Is_GCN_Pack_Size_Matched__c=True;
        po1.Is_GCN_Matched__c=True;
        po1.Is_NDC_Matched__c=True;
        po1.Status__c='Matched';
        polist.add(po1);
        
        Product_Opportunity__c  po2=new Product_Opportunity__c();
        po2.Name= 'test product opportunity';
        po2.Opportunity__c=opp.id;
        po2.Vision_Annual_Wmt_Units__c=10.0;
        po2.Vision_Total_Annual_Units__c=20.0;
        po2.Is_GSN_Pack_Size_Matched__c=True;
        po2.Is_GPI_Pack_Size_Matched__c=True;
        po2.Is_GCN_Pack_Size_Matched__c=True;
        po2.Is_GCN_Matched__c=True;
        po2.Is_NDC_Matched__c=True;
        po2.Status__c='Unmatched';
        polist.add(po2);
        
        Product_Opportunity__c  po3=new Product_Opportunity__c();
        po3.Name= 'test product opportunity';
        po3.Opportunity__c=opp.id;
        po3.Vision_Annual_Wmt_Units__c=10.0;
        po3.Vision_Total_Annual_Units__c=20.0;
        po3.Is_GSN_Pack_Size_Matched__c=True;
        po3.Is_GPI_Pack_Size_Matched__c=True;
        po3.Is_GCN_Pack_Size_Matched__c=True;
        po3.Is_GCN_Matched__c=True;
        po3.Is_NDC_Matched__c=True;
        po3.Status__c='discrepant';
        polist.add(po3);
        
        Insert polist;
        
        
        
        PreventOpportunityCls.getOpportunityProductsList(opp.id) ;
        PreventOpportunityCls.deleteOpportunity(opp.id) ;
        
        
    }
}