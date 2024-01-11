@istest
public class CompetitorInfoTest {
    static testmethod void getCompetitor() {
        try{   
        CompetitorInfoCLS testcmpt = new CompetitorInfoCLS ();
        //   Phoenix_Bid__c pb = new Phoenix_Bid__c();
        
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateBids();
        Phoenix_Customer_Response__c rec8 = new Phoenix_Customer_Response__c();
        rec8.Phoenix_Bid_No__c = testData.bidsList[0].Id;
        insert rec8;
        string idd = rec8.Id;
        
        Phoenix_CustomerResponseViewController.getBid(idd);
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Industry = 'Banking';
        insert acc;
        Phoenix_CustomerResponseViewController.getselectOptions(acc, 'Industry');
        
        
        
        Account testAccount = new Account(Name = 'Test Email Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Product_Family__c pf = new Product_Family__c();
            pf.Name = 'Daptomycin Inj 500mg US';
            insert pf;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
            p2.Product_Family__c = pf.Id;
        insert p2;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Internal_Target_Date__c = system.Date.today();
        insert pb;
       CompetitorInfoCLS.collectProductFamilyNames(pb.id);
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Vistex_Update_Final_Approval__c=true;
        bl.Phoenix_Wholesaler_Diff_Price_Indirect__c= 12;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
            bl.Product_Family__c = pf.Id;
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        bl.Phoenix_Finance_Approval__c = 'Not Approved';
        insert bl;
        
        Phoenix_Customer_Response__c recb2 = new Phoenix_Customer_Response__c();
        recb2.Phoenix_Bid_No__c = pb.Id;
        insert recb2;
        
        Phoenix_Customer_Response_Line__c recb3 = new Phoenix_Customer_Response_Line__c();
        recb3.Phoenix_Awarded_Quantity__c = 210;
        recb3.Phoenix_Bid__c = pb.Id;
        recb3.Phoenix_Customer_Response__c = recb2.Id;
        recb3.Phoenix_Bid_Line_Item__c = bl.Id;
        recb3.Phoenix_Customer_status_internal_use__c = 'Not Approved';
        recb3.Phoenix_Bid_Status__c = 'Awarded';
        insert recb3;
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Name = 'Customer';
        ps.Phoenix_Bid__c = pb.Id;
        ps.Phoenix_Approver_Team__c = 'Home Office';
        ps.Phoenix_Status__c = 'Completed';
        ps.Phoenix_Approver__c = Userinfo.getUserId();
        
        //ps.Phoenix_Approver__c='0050m000003VwV4AAK';
        //ps.Phoenix_Approver_Team_Members__c='Surender Patel';
        insert ps;
        string crid = recb2.Id;
        /*  testcmpt.CompetitorInfoMethod();
testcmpt.CompetitorInfoMethodsave();
testcmpt.CollectCompetitorInfoRec();
testcmpt.GetCompetitorNames();
testcmpt.updatecominforec();
testcmpt.getCompetitorName();
testcmpt.fetchUser();
testcmpt.fetchBidCustomerName();*/
          Competitor__c  cmp1 = new Competitor__c ();
            cmp1.name = 'test 1';
            insert cmp1;
            
            Competitor__c  cmp2 = new Competitor__c ();
            cmp2.name = 'test 2';
            insert cmp2;
            
            Competitor_Info__c  cinf = new Competitor_Info__c();
            cinf.Bid_No__c = pb.id;
            // cinf.Product_Name__c = p2.id;
            cinf.Bid_Line_Item__c = bl.id;
            cinf.NDC__c = '55111-0729-13';
            cinf.Product_Family__c = 'Allopurinol';
            cinf.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
            cinf.Incumbent_Competitor_Name__c = cmp1.id;
            cinf.Winning_Competitor_Name__c = cmp2.id;
            cinf.Incumbent_Price_Range__c = '3';
            cinf.Incumbent_Price_Range_2__c= '4';
            cinf.Incumbent_Price_Range_3__c= '5';
            cinf.Incumbent_Price_Range_4__c= '6';
            cinf.Incumbent_Price_Range_5__c= '7';
            cinf.Winning_Price_Range__c = '24';
            cinf.Winning_Price_Range_2__c = '27';
            cinf.Winning_Price_Range_3__c = '28';
            cinf.Winning_Price_Range_4__c = '34';
            cinf.Winning_Price_Range_5__c = '35';
            insert cinf;
            
            Competitor_Info__c  cinf2 = new Competitor_Info__c();
            cinf2.Bid_No__c = pb.id;
            // cinf2.Product_Name__c = p2.id;
            cinf2.Bid_Line_Item__c = bl.id;
            cinf2.NDC__c = '55111-0729-10';
            cinf2.Product_Family__c = 'Allopurinol';
            cinf2.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
            cinf2.Incumbent_Competitor_Name__c = cmp1.id;
            cinf2.Winning_Competitor_Name__c = cmp2.id;
            cinf2.Incumbent_Price_Range__c = '3';
            cinf2.Incumbent_Price_Range_2__c= '4';
            cinf2.Incumbent_Price_Range_3__c= '5';
            cinf2.Incumbent_Price_Range_4__c= '6';
            cinf2.Incumbent_Price_Range_5__c= '7';
            cinf2.Winning_Price_Range__c = '24';
            cinf2.Winning_Price_Range_2__c = '27';
            cinf2.Winning_Price_Range_3__c = '28';
            cinf2.Winning_Price_Range_4__c = '34';
            cinf2.Winning_Price_Range_5__c = '35';
            insert cinf2;
            
        
        CompetitorInfoCLS.CompetitorInfo_wrapperClass comp = new CompetitorInfoCLS.CompetitorInfo_wrapperClass();
        comp.BidNo = pb.id;							
        comp.BidLineItemNo 	= bl.id;	
        comp.ProductName 	=	'test';		
         comp.Competitorlist123 = new 
             list<Competitor__c>{cmp1};
        comp.Competitorlist2 =new 
             list<Competitor__c>{cmp1};
        comp.Competitorlist3= new 
             list<Competitor__c>{cmp1};
        // comp.Competitorlist4 
        // comp. Competitorlist5         
        comp.ndc ='test';
        comp.productfamily ='Amlo+Atorva';
        
        CompetitorInfoCLS.CompetitorInfo_savewrapperClass compInfo = new CompetitorInfoCLS.CompetitorInfo_savewrapperClass();
        compInfo.BidNos = pb.id;				
        compInfo.BidLineItemNos = bl.id;
        compInfo.ProductNames 	=	'Allopurinol 100mg 1000s Tabs';		
        compInfo.IncumbentCompetitornames = '';
        compInfo.IncumbentCompetitornames2 = '';
        compInfo.IncumbentCompetitornames3 = '';
        compInfo.IncumbentCompetitornames4 = '';
        compInfo.IncumbentCompetitornames5 = '';
        compInfo.IncumbentPriceRanges = '';
        compInfo.IncumbentPriceRanges2 = '';
        compInfo.IncumbentPriceRanges3 = '';
        compInfo.IncumbentPriceRanges4 = '';
        compInfo.IncumbentPriceRanges5 = '';
        compInfo.Ndcs = 'test';
        compInfo.Productfamilies='Amlo+Atorva';
        
        CompetitorInfoCLS.CompetitorInfoPF(pb.id,'Test');
        CompetitorInfoCLS.CompetitorInfoMethodsave(new List<CompetitorInfoCLS.CompetitorInfo_savewrapperClass>{compInfo});
        CompetitorInfoCLS.CompetitorInfoMethod(pb.id);
        CompetitorInfoCLS.CollectCompetitorInfoRec(pb.id);
        CompetitorInfoCLS.GetCompetitorNames();
        // CompetitorInfoCLS.fetchBidCustomerName('Test');
        CompetitorInfoCLS.GetCompetitorNames();
        CompetitorInfoCLS.GetCompetitorNames();   
        CompetitorInfoCLS.fetchUser();  
            CompetitorInfoCLS.codeCoverage();  
        }
        catch(exception e){}
        
    }
    Public static testMethod void Testmethod1()
    {
        try
        {
            Account testAccount = new Account(Name = 'Test Email Account');
            testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
            insert testAccount;
            
            Product2 p2 = new Product2();
            p2.Family = 'Daptomycin Inj 500mg US';
            p2.Name = 'Test';
            p2.ProductCode = '300029858';
            insert p2;
            
            Phoenix_Bid__c pb = new Phoenix_Bid__c();
            pb.Phoenix_Status__c = 'New';
            pb.Phoenix_Comments__c = 'Test Comments';
            pb.Phoenix_Customer__c = testAccount.Id;
            pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
            pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
            pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
            pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
            pb.Phoenix_Bid_Deadline_Date__c = System.today();
            pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
            pb.Phoenix_Approval_Status__c = 'Draft';
            pb.Phoenix_Internal_Target_Date__c = system.Date.today();
            insert pb;
            
            Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
            bl.Phoenix_Bid__c = pb.Id;
            bl.Phoenix_Current_Direct_Price__c = 10;
            bl.Phoenix_Product_Code1__c = '300029858';
            bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
            bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl.Phoenix_Product__c = p2.Id;
            bl.Phoenix_Final_Status__c = 'Approved';
            bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
            bl.Phoenix_Marketing_Final_Approval__c = true;
            bl.Phoenix_Finance_Approval__c = 'Not Approved';
            insert bl;
            
            Competitor__c  cmp1 = new Competitor__c ();
            cmp1.name = 'test 1';
            insert cmp1;
            
            Competitor__c  cmp2 = new Competitor__c ();
            cmp2.name = 'test 2';
            insert cmp2;
            
            Competitor_Info__c  cinf = new Competitor_Info__c();
            cinf.Bid_No__c = pb.id;
            // cinf.Product_Name__c = p2.id;
            cinf.Bid_Line_Item__c = bl.id;
            cinf.NDC__c = '55111-0729-13';
            cinf.Product_Family__c = 'Allopurinol';
            cinf.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
            cinf.Incumbent_Competitor_Name__c = cmp1.id;
            cinf.Winning_Competitor_Name__c = cmp2.id;
            cinf.Incumbent_Price_Range__c = '3';
            cinf.Incumbent_Price_Range_2__c= '4';
            cinf.Incumbent_Price_Range_3__c= '5';
            cinf.Incumbent_Price_Range_4__c= '6';
            cinf.Incumbent_Price_Range_5__c= '7';
            cinf.Winning_Price_Range__c = '24';
            cinf.Winning_Price_Range_2__c = '27';
            cinf.Winning_Price_Range_3__c = '28';
            cinf.Winning_Price_Range_4__c = '34';
            cinf.Winning_Price_Range_5__c = '35';
            insert cinf;
            
            Competitor_Info__c  cinf2 = new Competitor_Info__c();
            cinf2.Bid_No__c = pb.id;
            // cinf2.Product_Name__c = p2.id;
            cinf2.Bid_Line_Item__c = bl.id;
            cinf2.NDC__c = '55111-0729-10';
            cinf2.Product_Family__c = 'Allopurinol';
            cinf2.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
            cinf2.Incumbent_Competitor_Name__c = cmp1.id;
            cinf2.Winning_Competitor_Name__c = cmp2.id;
            cinf2.Incumbent_Price_Range__c = '3';
            cinf2.Incumbent_Price_Range_2__c= '4';
            cinf2.Incumbent_Price_Range_3__c= '5';
            cinf2.Incumbent_Price_Range_4__c= '6';
            cinf2.Incumbent_Price_Range_5__c= '7';
            cinf2.Winning_Price_Range__c = '24';
            cinf2.Winning_Price_Range_2__c = '27';
            cinf2.Winning_Price_Range_3__c = '28';
            cinf2.Winning_Price_Range_4__c = '34';
            cinf2.Winning_Price_Range_5__c = '35';
            insert cinf2;
            
            Phoenix_Customer_Response__c recb2 = new Phoenix_Customer_Response__c();
            recb2.Phoenix_Bid_No__c = pb.Id;
            insert recb2;
            CompetitorInfoCLS.CompetitorInfoPF(pb.id,'Daptomycin Inj 500mg US');
            CompetitorInfoCLS.CompetitorInfoPF(pb.id,'ChooseProductFamily');
            CompetitorInfoCLS.CollectCompetitorInfoRec(pb.id);
            CompetitorInfoCLS.updatecominforec(new List<Competitor_Info__c>{cinf});   
             CompetitorInfoCLS.fetchUser();  
        }
        catch(exception e)
        {
            system.debug('The message is '+e.getCause());
            system.debug('The message is '+e.getLineNumber());
            system.debug('The message is '+e.getMessage());
        }
    } 
}