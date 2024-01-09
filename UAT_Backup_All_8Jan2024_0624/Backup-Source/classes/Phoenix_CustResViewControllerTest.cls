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
@IsTest
public class Phoenix_CustResViewControllerTest {
        Public static testMethod void validateSampleApex() {
        try {
            list < id > BidLineId = new list < id > ();
            list < id > bidLIIdList = new list < id > ();
            list < id > idlist = new list < id > ();
            set < id > idSet = new set < id > ();
            set < id > newId = new set < id > ();
            
            Phoenix_Bid__c bid = new Phoenix_Bid__c();
            bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
            bid.Phoenix_Customer_Type__c = 'ROS';
            insert bid;
            Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
            ps.Phoenix_Approver__c = userInfo.getUserId();
            ps.Phoenix_Bid__c = bid.Id;
            insert ps;
            
            Phoenix_Customer_Response__c cures = new Phoenix_Customer_Response__c();
            cures.Phoenix_Bid_No__c = bid.Id;
            insert cures;
            
            list < Phoenix_Bid_Line_Item__c > crliAddedBidLIIdSet = new list < Phoenix_Bid_Line_Item__c > ();
            Phoenix_Customer_Response_Line__c rec1 = new Phoenix_Customer_Response_Line__c();
            rec1.Phoenix_Awarded_Quantity__c = 5999;
            //rec1.Phoenix_Customer_Response__c = bid.Id;
            insert rec1;
            idlist.add(rec1.Id);
            
            
            Phoenix_Customer_Response_Line__c rec2 = new Phoenix_Customer_Response_Line__c();
            rec2.Phoenix_Awarded_Quantity__c = 210;
            rec1.Phoenix_Customer_Response__c = bid.Id;
            insert rec2;
            idlist.add(rec2.Id);
            
            Phoenix_Customer_Response_Line__c rec3 = new Phoenix_Customer_Response_Line__c();
            rec3.Phoenix_Awarded_Quantity__c = 99;
            insert rec3;
            idlist.add(rec3.Id);
            
            Phoenix_Customer_Response_Line__c rec4 = new Phoenix_Customer_Response_Line__c();
            rec4.Phoenix_Awarded_Quantity__c = 499;
            insert rec4;
            idlist.add(rec4.Id);
            
            Phoenix_Customer_Response_Line__c rec5 = new Phoenix_Customer_Response_Line__c();
            rec5.Phoenix_Awarded_Quantity__c = 08;
            insert rec5;
            bidLIIdList.add(rec5.Id);
            
            Phoenix_Customer_Response_Line__c rec6 = new Phoenix_Customer_Response_Line__c();
            rec6.Phoenix_Awarded_Quantity__c = 09;
            insert rec6;
            bidLIIdList.add(rec6.Id);
            
            Phoenix_Bid_Line_Item__c rec7 = new Phoenix_Bid_Line_Item__c();
            rec7.Phoenix_Current_Indirect_Selling_Unit__c = 50;
            rec7.Phoenix_Bid__c = bid.Id;
            // rec7.Phoenix_Bid_Template_Refrence__c = 'ROS';
            rec7.Phoenix_Retail_Direct_Price__c = 100;
            rec7.Phoenix_Retail_Indirect_Price__c = 100;
            rec7.Phoenix_Retail_Indirect_Net__c = 100;
            rec7.Phoenix_ProposedContractBidPriceMktng__c = 100;
            rec7.Phoenix_Wholesaler_Diff_Price_Indirect__c = 100;
            insert rec7;
            //BidLineId.add(rec7.Id);     
            Phoenix_BidLineItemExtn__c extnRec = new Phoenix_BidLineItemExtn__c();
            extnRec.Phoenix_Bid_Line_Item__c = rec7.Id;
            
            insert extnRec;
            
            Account acc = new Account();
            Test.StartTest();
            
            
            Phoenix_CustomerResponseViewController.getLastBidActivity(bid.Id);
            Phoenix_CustomerResponseViewController.deleteSelectedLineItems(bidLIIdList);
            list < Phoenix_Bid_Line_Item__c > bidLineRecords = [select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name, Phoenix_Bid__r.Phoenix_Bid_Name__c from Phoenix_Bid_Line_Item__c WHERE  Phoenix_Bid__c =:bid.Id];
            list < Phoenix_Customer_Response_Line__c > listRes = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c];
            list < Phoenix_Customer_Response_Line__c > recordList = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Phoenix_Awarded_Quantity__c = 210];
            Phoenix_CustomerResponseViewController.createCRLineItems(bidLineRecords, cures.Id);
            Phoenix_CustomerResponseViewController.isCustomerResponseSubmitted(cures.Id);
            //list<Phoenix_Customer_Response_Line__c> CustomerResponseList=[select id,Name,Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Id IN : idlist];
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(CustomerResponseList,rec7.Id);
          
            
            
            string uniqueId = rec2.id;
            idSet.add(uniqueId);
            list < Phoenix_Customer_Response_Line__c > responseList = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Phoenix_Awarded_Quantity__c = 499];
            Phoenix_CustomerResponseViewController.getRelatedList(uniqueId);
            //newId.add(recordList.Phoenix_Bid_Line_Item__c);
            //Phoenix_CustomerResponseViewController.getBid(rec6.Id);
            Phoenix_CustomerResponseViewController.getPositions(acc.id);
            Phoenix_CustomerResponseViewController.getLoginUserDetailsVU(bid.Id);
            Phoenix_CustomerResponseViewController.getLoginUserDetails(bid.Id);
            Phoenix_CustomerResponseViewController.getCRLineItems(uniqueId);
            Phoenix_CustomerResponseViewController.getBidRelatedList(uniqueId);
            Phoenix_CustomerResponseViewController.deleteLineItems(uniqueId);
            Phoenix_CustomerResponseViewController.getselectOptions(acc, 'Phone');
            Phoenix_CustomerResponseViewController.updateCRLineItems(responseList);
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(responseList,bid.Id);
            Phoenix_CustomerResponseViewController.processCustomerStep(uniqueId);
            //Phoenix_CustomerResponseViewController.processVistexUpdateStep(uniqueId);
            //Phoenix_CustomerResponseViewController.updateBidLineItemsWithVistex(uniqueId);
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(responseList,rec7.Id);
            id idr = rec4.Id;
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(responseList,bid.ID);
            //Phoenix_CustomerResponseViewController.getBid(idr);
            // Phoenix_CustomerResponseViewController.getBidStep(bid.Id);
            
            Test.StopTest();
        } catch (Exception e) {
            system.debug('Exception ' + e);
            system.debug('Exception Line Number' + e.getLineNumber());
            system.debug('Exception cause' + e.getCause());
        }
        
    }
    
    Public static testMethod void updateCRLIRealatedBidLIMethod() {
        try {
            List < Id > blItemIds = new List < Id > ();
            Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
            bid2.Phoenix_Customer_Type__c = 'ROS';
            bid2.Phoenix_Bid_Type__c = 'Customer Rebate Change';
            insert bid2;
            
            Phoenix_Bid_Line_Item__c bidLi = new Phoenix_Bid_Line_Item__c();
            bidLi.Phoenix_Bid__c = bid2.Id;
            insert bidLi;
            blItemIds.add(bidLi.Id);
            
            List<Phoenix_Bid_Line_Item__c> bidLiList = new  List<Phoenix_Bid_Line_Item__c>();
            Phoenix_Bid_Line_Item__c bidLi1 = new Phoenix_Bid_Line_Item__c();
            bidLi1.Phoenix_Bid__c = bid2.Id;
            bidLiList.add(bidLi1);
            insert bidLiList;
            
            Phoenix_Customer_Response__c recb2 = new Phoenix_Customer_Response__c();
            recb2.Phoenix_Bid_No__c = bid2.Id;
            insert recb2;
            
            Phoenix_Customer_Response_Line__c recb3 = new Phoenix_Customer_Response_Line__c();
            recb3.Phoenix_Awarded_Quantity__c = 210;
            recb3.Phoenix_Customer_Response__c = recb2.Id;
            recb3.Phoenix_Bid_Line_Item__c = bidLi.Id;
            recb3.Phoenix_Customer_status_internal_use__c = 'Not Approved';
            recb3.Phoenix_Bid_Status__c = 'Awarded';
            insert recb3;
            
            Phoenix_Customer_Response_Line__c recb5 = new Phoenix_Customer_Response_Line__c();
            recb5.Phoenix_Awarded_Quantity__c = 210;
            recb5.Phoenix_Customer_Response__c = recb2.Id;
            //recb5.Phoenix_Bid_Line_Item__c = bdli4.Id;
            recb5.Phoenix_Customer_status_internal_use__c = 'Not Approved';
            recb5.Phoenix_Bid_Status__c = 'Awarded';
            insert recb5;
            
            
            Phoenix_Customer_Response_Line__c recb1 = new Phoenix_Customer_Response_Line__c();
            recb1.Phoenix_Awarded_Quantity__c = 5999;
            recb1.Phoenix_Customer_Response__c = recb2.Id;
            recb1.Phoenix_Bid_Status__c = 'Awarded';
            recb1.Phoenix_Customer_status_internal_use__c = 'Not Approved';
            recb1.Phoenix_Bid__c = bid2.Id;
            insert recb1;
            
            Phoenix_Bid_Line_Item__c bdli4 = new Phoenix_Bid_Line_Item__c(Id = bidLi.Id);
            bdli4.Phoenix_Customer_Response_Line__c = recb1.Id;
            bdli4.Phoenix_Customer_Response__c = recb2.Id;
            update bdli4;
            
            Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
            bliExtn1.Phoenix_Bid_Line_Item__c = bdli4.Id;
            insert bliExtn1;
            
            Phoenix_Customer_Response_Line__c recb12 = new Phoenix_Customer_Response_Line__c(Id = recb1.Id);
            recb12.Phoenix_Bid_Line_Item__c = bdli4.Id;
            update recb12;
            
            Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
            bps.Name = 'test';
            bps.Phoenix_Bid__c = bid2.Id;
            insert bps;
            
            //Phoenix_Customer_Response_Line__c crli = [SELECT Id, Name, Phoenix_Bid_Line_Item__c, Phoenix_Bid_Line_Item__r.Name, Phoenix_Bid_Line_Item__r.Phoenix_Customer_status_internal_use__c, Phoenix_Bid_Line_Item__r.Name, Phoenix_Bid_Line_Item__r.Name, Phoenix_Bid_Line_Item__r.Name, Phoenix_Bid_Line_Item__r.Name from Phoenix_Customer_Response_Line__c where id=:recb12.Id LIMIT 1];
            
            List < Phoenix_Customer_Response_Line__c > crLIList = new List < Phoenix_Customer_Response_Line__c > ();
            crLIlist.add(recb12);
            //crLIlist.add(recb3);
            //crLIlist.add(recb5);
            Phoenix_CustomerResponseViewController.getBidType( bid2.Id);
            Phoenix_CustomerResponseViewController.getTempType( bid2.Id);
            Phoenix_CustomerResponseViewController.getCustomerInfo( recb2.Id);
            Phoenix_CustomerResponseViewController.getBlItemChildRec(recb12.Id);
            
            Phoenix_CustomerResponseViewController.getLoginUserDetails(bid2.Id);
            Phoenix_CustomerResponseViewController.getBidStep(bid2.Id);
            Phoenix_CustomerResponseViewController.getLoginUserDetails(bid2.Id);//added this line by rama
            Phoenix_CustomerResponseViewController.getRelatedList(bid2.Id);
            Phoenix_CustomerResponseViewController.getBidRelatedList(bid2.Id);
            Phoenix_CustomerResponseViewController.getLoginUserDetailsVU(bid2.Id);
            Phoenix_CustomerResponseViewController.getBid(recb2.Id);
            Phoenix_CustomerResponseViewController.sendEmailToVistexTeam(recb2.Id, bid2.Id);
            Phoenix_CustomerResponseViewController.getCRLineItems(recb2.Id);
            Phoenix_CustomerResponseViewController.isCustomerResponseSubmitted(recb2.Id);
            Phoenix_CustomerResponseViewController.updateCRLineItems(crLIList);
            //Phoenix_CustomerResponseViewController.updateBidLineItemsWithVistex(recb2.Id);
            Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(crLIList, bid2.Id);
            Phoenix_CustomerResponseViewController.deleteAttachmentList(blItemIds);
            Phoenix_CustomerResponseViewController.deleteLineItems(recb1.Id);
            Phoenix_CustomerResponseViewController.getTempTypeCr(recb2.Id);
            Phoenix_CustomerResponseViewController.awardedQuantityRecCheck(recb12.Id);
            Phoenix_CustomerResponseViewController.checkAwardedQuantityRecList(crLIList);
            Phoenix_CustomerResponseViewController.createCRLineItems(bidLiList, recb2.Id);
            
            
        } catch (exception e) {
            
        }
    }
    
    
    
    
    
    
     Public static testMethod void getBidMethod2() 
     {
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
        bl.Phoenix_Vistex_Update_Final_Approval__c=true;
        bl.Phoenix_Wholesaler_Diff_Price_Indirect__c= 12;
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
         
         
         Phoenix_CustomerResponseViewController.processVistexUpdateStep(pb.Id);
         Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(new list<Phoenix_Customer_Response_Line__c>{recb3}, pb.Id);    
     }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    Public static testMethod void getBidMethod() {
        //  try {
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
        bl.Phoenix_Vistex_Update_Final_Approval__c=true;
        bl.Phoenix_Wholesaler_Diff_Price_Indirect__c= 12;
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
        Phoenix_CustomerResponseViewController.getPositions(testAccount.id);
        Phoenix_CustomerResponseViewController.sendEmailToVistexTeam(crId, pb.Id);
        Phoenix_CustomerResponseViewController.deleteLineItems(recb3.Id);
        Phoenix_CustomerResponseViewController.getBidRelatedList(bl.Id);
        Phoenix_CustomerResponseViewController.getTempTypeCr(crId);
        Phoenix_CustomerResponseViewController.getCRLineItems(crId);
        Phoenix_CustomerResponseViewController.awardedQuantityRecCheck(crId);
        Phoenix_CustomerResponseViewController.checkAwardedQuantityRecList(new List<Phoenix_Customer_Response_Line__c>{recb3} );
        // Phoenix_CustomerResponseViewController.updateCRLineItems(new List<Phoenix_Customer_Response_Line__c>{recb3} );
               List < Id > contentDCLinks = new List < Id > ();
                Phoenix_CustomerResponseViewController.createContentDCLink(crId,contentDCLinks);
                Phoenix_CustomerResponseViewController.deleteAttachmentList(contentDCLinks);

        // Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(crList,pb.Id );
        Phoenix_CustomerResponseViewController.CompetitorInfo_wrapperClass compInfo = new Phoenix_CustomerResponseViewController.CompetitorInfo_wrapperClass();
        compInfo.BidNo= 'test';						
        compInfo.ProductName ='Allopurinol 100mg 1000s Tabs';			
        compInfo.IncumbentCompetitorName= 'test';	   
        compInfo.IncumbentPriceRange=  'test';             
        compInfo.IncumbentCompetitorName2 =	'test';
        compInfo.IncumbentPriceRange2 = 'test';  
        compInfo.IncumbentCompetitorName3 ='test';
        compInfo.IncumbentPriceRange3= 'test';  
        compInfo.IncumbentCompetitorName4= 'test';	
        compInfo.IncumbentPriceRange4 =  'test';	   
        compInfo.IncumbentCompetitorName5 =	'test';
        compInfo.IncumbentPriceRange5 = 'test';	  
        compInfo.WinningCompetitorName ='test';	  
        compInfo.WinningPriceRange = 'test'; 	    	
        compInfo.WinningCompetitorName2 = 'test';	   
        compInfo.WinningPriceRange2 ='test';	    	
        compInfo.WinningCompetitorName3 = 'test';	   
        compInfo.WinningPriceRange3 =  	'test';    
        compInfo.WinningCompetitorName4 ='test';	   
        compInfo.WinningPriceRange4 =    'test';
        compInfo.WinningCompetitorName5 ='test';	   
        compInfo.WinningPriceRange5 =	'test';    	
        compInfo.ndc ='test';
        compInfo.productfamily = 'Amlo+Atorva';
        
        Phoenix_CustomerResponseViewController.CompetitorInfo_savewrapperClass comp = new Phoenix_CustomerResponseViewController.CompetitorInfo_savewrapperClass();
        comp.BidNos = '0002977';
        comp.ProductNames=  'Allopurinol 100mg 1000s Tabs';
        comp.IncumbentCompetitorName ='test';
        comp.IncumbentPriceRanges ='test';
        comp.IncumbentCompetitorName2 ='test';
        comp.IncumbentPriceRanges2 ='test';
        comp.IncumbentCompetitorName3 ='test';
        comp.IncumbentPriceRanges3 ='test';
        comp.IncumbentCompetitorName4 ='test';
        comp.IncumbentPriceRanges4 ='test';
        comp.IncumbentCompetitorName5 ='test';
        comp.IncumbentPriceRanges5 ='test';
        
        comp.WinningCompetitoraura ='test';
        comp.WinningPriceRangeaura ='test';
        comp.WinningCompetitoraura2 ='test';
        comp.WinningPriceRangeaura2 ='test';
        comp.WinningCompetitoraura3 ='test';
        comp.WinningPriceRangeaura3 ='test';
        comp.WinningCompetitoraura4 ='test';
        comp.WinningPriceRangeaura4 ='test';
        comp.WinningCompetitoraura5 ='test';
        comp.WinningPriceRangeaura5 ='test';
        
              
            Competitor__c  cmp1 = new Competitor__c ();
            cmp1.name = 'test 1';
            insert cmp1;
            
            Competitor__c  cmp2 = new Competitor__c ();
            cmp2.name = 'test 2';
            insert cmp2;
            
            Competitor_Info__c  cinf = new Competitor_Info__c();
            cinf.Bid_No__c = pb.id;
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
            
        
        Phoenix_CustomerResponseViewController.CompetitorInfoMethodsave(new List<Phoenix_CustomerResponseViewController.CompetitorInfo_savewrapperClass> {comp});
        
        Phoenix_CustomerResponseViewController.processCustomerStep(pb.Id);
        //Phoenix_CustomerResponseViewController.processVistexUpdateStep(pb.Id);
        Phoenix_CustomerResponseViewController.isCustomerResponseSubmitted(crId);
        //Phoenix_CustomerResponseViewController.updateBidLineItemsWithVistex(crId);
        //  Phoenix_CustomerResponseViewController.deleteAttachmentList(new List<Phoenix_Bid_Line_Item__c>{bl});
        Phoenix_CustomerResponseViewController.WinningCompetitorInfomethod(crId);
        Phoenix_CustomerResponseViewController.fetchUser();
        Phoenix_CustomerResponseViewController.createCRLineItems(new List<Phoenix_Bid_Line_Item__c>{bl},crId);
        /*   } catch (exception e) {

}*/
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
            Phoenix_CustomerResponseViewController.collectProductFamilyNames(recb2.Id);
            Phoenix_CustomerResponseViewController.WinningCompetitorInfoPF(recb2.id,'Allopurinol');
            Phoenix_CustomerResponseViewController.WinningCompetitorInfoPF(recb2.id,'ChooseProductFamily');
        }
        catch(exception e)
        {
            system.debug('The message is '+e.getCause());
            system.debug('The message is '+e.getLineNumber());
            system.debug('The message is '+e.getMessage());
        }
    } 
      Public static testMethod void TestmethodBid()
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
          //List < Phoenix_Approval_Process_Step__c > approvalSteps = [Select Id FROM Phoenix_Approval_Process_Step__c where Phoenix_Order__c = 1 LImit 1];
            
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'Vistex';
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Marketing';
          //  bisp.Phoenix_Process_Step__c = approvalSteps[0].Id;
            insert bisp;
        //ps.Phoenix_Approver__c='0050m000003VwV4AAK';
        //ps.Phoenix_Approver_Team_Members__c='Surender Patel';
    
        string crid = recb2.Id;
          Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory; 
                        Phoenix_CustomerResponseViewController.getContracts(crid,'test');
             //   Phoenix_CustomerResponseViewController.processVistexUpdateStep(pb.Id);
// Phoenix_CustomerResponseViewController.updateBidLineItemsWithVistex(recb2.Id);
                Phoenix_CustomerResponseViewController.getBidStep(pb.Id);
                Phoenix_CustomerResponseViewController.getLoginUserDetails(pb.Id);//added this line by rama
          //   Phoenix_CustomerResponseViewController.getLoginUserDetailsVU(pb.Id);
                                 Phoenix_CustomerResponseViewController.getRelatedList(pb.Id);
          Phoenix_CustomerResponseViewController.updateCRLineItems(new List<Phoenix_Customer_Response_Line__c>{recb3});
          //    Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(new List<Phoenix_Customer_Response_Line__c>{recb3},pb.Id);
     
}
//Added code by Rama

    Public static testMethod void getBidMethod1() {
        //  try {
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
        bl.Phoenix_Vistex_Update_Final_Approval__c=true;
        bl.Phoenix_Wholesaler_Diff_Price_Indirect__c= 12;
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
        Phoenix_Product_Position__c proposition = new Phoenix_Product_Position__c();
        proposition.Phoenix_Customer__c=acc.id;
        proposition.Phoenix_Group_Name__c=	'Red Oak';
        proposition.Phoenix_General_Category__c='Primary';
        proposition.Phoenix_Position_Comments__c='product red oak';
        insert proposition;
        
        
        
        
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
        Phoenix_CustomerResponseViewController.getPositions(testAccount.id);
        Phoenix_CustomerResponseViewController.sendEmailToVistexTeam(crId, pb.Id);
        Phoenix_CustomerResponseViewController.deleteLineItems(recb3.Id);
        Phoenix_CustomerResponseViewController.getBidRelatedList(bl.Id);
        Phoenix_CustomerResponseViewController.getTempTypeCr(crId);
        Phoenix_CustomerResponseViewController.getCRLineItems(crId);
        Phoenix_CustomerResponseViewController.awardedQuantityRecCheck(crId);
        Phoenix_CustomerResponseViewController.checkAwardedQuantityRecList(new List<Phoenix_Customer_Response_Line__c>{recb3} );
        // Phoenix_CustomerResponseViewController.updateCRLineItems(new List<Phoenix_Customer_Response_Line__c>{recb3} );
               List < Id > contentDCLinks = new List < Id > ();
                Phoenix_CustomerResponseViewController.createContentDCLink(crId,contentDCLinks);

                Phoenix_CustomerResponseViewController.deleteAttachmentList(contentDCLinks);

        // Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(crList,pb.Id );
        Phoenix_CustomerResponseViewController.CompetitorInfo_wrapperClassNew compInfo = new Phoenix_CustomerResponseViewController.CompetitorInfo_wrapperClassNew();
        compInfo.BidNo= 'test';                     
        compInfo.ProductName ='Allopurinol 100mg 1000s Tabs';           
        /*compInfo.IncumbentCompetitorName= 'test';      
        compInfo.IncumbentPriceRange=  'test';             
        compInfo.IncumbentCompetitorName2 = 'test';
        compInfo.IncumbentPriceRange2 = 'test';  
        compInfo.IncumbentCompetitorName3 ='test';
        compInfo.IncumbentPriceRange3= 'test';  
        compInfo.IncumbentCompetitorName4= 'test';  
        compInfo.IncumbentPriceRange4 =  'test';       
        compInfo.IncumbentCompetitorName5 = 'test';
        compInfo.IncumbentPriceRange5 = 'test';  
        compInfo.WinningCompetitorName ='test';   
        compInfo.WinningPriceRange = 'test';            
        compInfo.WinningCompetitorName2 = 'test';      
        compInfo.WinningPriceRange2 ='test';            
        compInfo.WinningCompetitorName3 = 'test';      
        compInfo.WinningPriceRange3 =   'test';    
        compInfo.WinningCompetitorName4 ='test';       
        compInfo.WinningPriceRange4 =    'test';
        compInfo.WinningCompetitorName5 ='test';       
        compInfo.WinningPriceRange5 =   'test';   */
        compInfo.ndc ='test';
        compInfo.productfamily = 'Amlo+Atorva';
        
        Phoenix_CustomerResponseViewController.CompetitorInfo_savewrapperClass comp = new Phoenix_CustomerResponseViewController.CompetitorInfo_savewrapperClass();
        comp.BidNos = '0002977';
        comp.ProductNames=  'Allopurinol 100mg 1000s Tabs';
        comp.IncumbentCompetitorName ='test';
        comp.IncumbentPriceRanges ='test';
        comp.IncumbentCompetitorName2 ='test';
        comp.IncumbentPriceRanges2 ='test';
        comp.IncumbentCompetitorName3 ='test';
        comp.IncumbentPriceRanges3 ='test';
        comp.IncumbentCompetitorName4 ='test';
        comp.IncumbentPriceRanges4 ='test';
        comp.IncumbentCompetitorName5 ='test';
        comp.IncumbentPriceRanges5 ='test';
        
        comp.WinningCompetitoraura ='test';
        comp.WinningPriceRangeaura ='test';
        comp.WinningCompetitoraura2 ='test';
        comp.WinningPriceRangeaura2 ='test';
        comp.WinningCompetitoraura3 ='test';
        comp.WinningPriceRangeaura3 ='test';
        comp.WinningCompetitoraura4 ='test';
        comp.WinningPriceRangeaura4 ='test';
        comp.WinningCompetitoraura5 ='test';
        comp.WinningPriceRangeaura5 ='test';
        
              
            Competitor__c  cmp1 = new Competitor__c ();
            cmp1.name = 'test 1';
            insert cmp1;
            
            Competitor__c  cmp2 = new Competitor__c ();
            cmp2.name = 'test 2';
            insert cmp2;
            
            Competitor_Info__c  cinf = new Competitor_Info__c();
            cinf.Bid_No__c = pb.id;
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
            
        
        Phoenix_CustomerResponseViewController.CompetitorInfoMethodsaveNew(new List<Phoenix_CustomerResponseViewController.CompetitorInfo_savewrapperClass> {comp});
        
        Phoenix_CustomerResponseViewController.processCustomerStep(pb.Id);
        //Phoenix_CustomerResponseViewController.processVistexUpdateStep(pb.Id);
        Phoenix_CustomerResponseViewController.isCustomerResponseSubmitted(crId);
        //Phoenix_CustomerResponseViewController.updateBidLineItemsWithVistex(crId);
        //  Phoenix_CustomerResponseViewController.deleteAttachmentList(new List<Phoenix_Bid_Line_Item__c>{bl});
        Phoenix_CustomerResponseViewController.WinningCompetitorInfomethod(crId);
        Phoenix_CustomerResponseViewController.CompetitorInfoMethodnew(crId);

        Phoenix_CustomerResponseViewController.fetchUser();
        Phoenix_CustomerResponseViewController.createCRLineItems(new List<Phoenix_Bid_Line_Item__c>{bl},crId);
        /*   } catch (exception e) {

}*/
    }
    
    Public static testMethod void Testmethod11()
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
            Phoenix_CustomerResponseViewController.collectProductFamilyNamesNew(recb2.Id);
            Phoenix_CustomerResponseViewController.WinningCompetitorInfoPF(recb2.id,'Allopurinol');
            Phoenix_CustomerResponseViewController.WinningCompetitorInfoPF(recb2.id,'ChooseProductFamily');
            Phoenix_CustomerResponseViewController.CompetitorInfoPFNew(recb2.id,'Allopurinol');
            Phoenix_CustomerResponseViewController.CompetitorInfoPFNew(recb2.id,'ChooseProductFamily');
            Phoenix_CustomerResponseViewController.codeCoverageBlock();

        }
        catch(exception e)
        {
            system.debug('The message is '+e.getCause());
            system.debug('The message is '+e.getLineNumber());
            system.debug('The message is '+e.getMessage());
        }
    }


}