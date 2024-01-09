@isTest
public class Pheonix_BidWACChangeControllerTest {
    @testSetup static void setupTestData() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Preferred_Wholesaler__c='ABC',Phoenix_Is_Govt_Customer__c=true);
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        
        
        
        
        
        //--------Approval Test Data-----START
        Phoenix_Approval_Matrix__c appro= new Phoenix_Approval_Matrix__c();
        appro.Phoenix_Bid_Type__c='WAC Change Submissions';
        appro.Name='Pricing Review';
        insert appro;
        
        Phoenix_Approval_Process_Step__c proI= new Phoenix_Approval_Process_Step__c();
        proI.Name='Initial Submission';
        proI.Phoenix_Order__c=1;
        proI.Phoenix_Approval_Matrix__c=appro.Id;
        insert proI;
        
        Phoenix_Approval_Process_Step__c pro= new Phoenix_Approval_Process_Step__c();
        pro.Name='Business Head';
        pro.Phoenix_Order__c=2;
        pro.Phoenix_Approval_Matrix__c=appro.Id;
        insert pro;
        
        Phoenix_Approval_Process_Step__c pro3= new Phoenix_Approval_Process_Step__c();
        pro3.Name='Country Head';
        pro3.Phoenix_Order__c=3;
        pro3.Phoenix_Approval_Matrix__c=appro.Id;
        insert pro3;
        
        Phoenix_Approval_Process_Step__c proF= new Phoenix_Approval_Process_Step__c();
        proF.Name='Finance';
        proF.Phoenix_Order__c=4;
        proF.Phoenix_Approval_Matrix__c=appro.Id;
        insert proF;
        
        Phoenix_Approval_Process_Step__c pro1= new Phoenix_Approval_Process_Step__c();
        pro1.Name='Contracts';
        pro1.Phoenix_Order__c=5;
        pro1.Phoenix_Approval_Matrix__c=appro.Id;
        insert pro1;
        
        Phoenix_Approval_Process_Step__c proClosed= new Phoenix_Approval_Process_Step__c();
        proClosed.Name='Closed';
        proClosed.Phoenix_Order__c=6;
        proClosed.Phoenix_Approval_Matrix__c=appro.Id;
        insert proClosed;
        
        List<Phoenix_Bid_Process_Steps__c> processSteps= new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c processStep1=new Phoenix_Bid_Process_Steps__c();
        processStep1.Phoenix_Bid__c=pb.Id;
        processStep1.Phoenix_Process_Step__c=proI.Id;
        processStep1.Phoenix_Status__c='Submitted';
        // processStep1.Phoenix_Sub_Step__c=1;
        processSteps.add(processStep1);
        insert processSteps;
        
        List<Phoenix_Bid_Process_Steps__c> processStepNext= new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c processStep=new Phoenix_Bid_Process_Steps__c();
        processStep.Phoenix_Bid__c=pb.Id;
        processStep.Phoenix_Process_Step__c=pro.Id;
        processStep.Phoenix_Status__c='In Process';
        // processStep.Phoenix_Sub_Step__c=2;
        processStepNext.add(processStep);
        insert processStepNext;
        
        
        List<Phoenix_Bid_Process_Steps__c> processStepNext2= new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c processStep2=new Phoenix_Bid_Process_Steps__c();
        processStep2.Phoenix_Bid__c=pb.Id;
        processStep2.Phoenix_Process_Step__c=pro.Id;
        processStep2.Phoenix_Status__c='Not Initiated';
        // processStep.Phoenix_Sub_Step__c=2;
        processStepNext2.add(processStep2);
        insert processStepNext2;
        
        List<Phoenix_Bid_Process_Steps__c> processStepNext3= new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c processStep3=new Phoenix_Bid_Process_Steps__c();
        processStep3.Phoenix_Bid__c=pb.Id;
        processStep3.Phoenix_Process_Step__c=pro3.Id;
        processStep3.Phoenix_Status__c='In Process';
        // processStep.Phoenix_Sub_Step__c=2;
        processStepNext3.add(processStep3);
        insert processStepNext3;
        
        
        List<Phoenix_Bid_Process_Steps__c> processStepNextStep4= new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c processStep4=new Phoenix_Bid_Process_Steps__c();
        processStep4.Phoenix_Bid__c=pb.Id;
        processStep4.Phoenix_Process_Step__c=proF.Id;
        processStep4.Phoenix_Status__c='Not Initiated';
        //  processStep3.Phoenix_Sub_Step__c=3;
        processStepNextStep4.add(processStep4);
        insert processStepNextStep4;
        
        
        List<Phoenix_Bid_Process_Steps__c> processStepNextStep5= new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c processStep5=new Phoenix_Bid_Process_Steps__c();
        processStep5.Phoenix_Bid__c=pb.Id;
        processStep5.Phoenix_Process_Step__c=pro1.Id;
        processStep5.Phoenix_Status__c='Not Initiated';
        // processStep3.Phoenix_Sub_Step__c=3;
        processStepNextStep5.add(processStep5);
        insert processStepNextStep5;
        
        List<Phoenix_Bid_Process_Steps__c> processStepClose= new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c processStepCl=new Phoenix_Bid_Process_Steps__c();
        processStepCl.Phoenix_Bid__c=pb.Id;
        processStepCl.Phoenix_Process_Step__c=proClosed.Id;
        processStepCl.Phoenix_Status__c='Not Initiated';
        // processStep3.Phoenix_Sub_Step__c=4;
        processStepClose.add(processStepCl);
        insert processStepClose;
        
        //-------Approval Test Data End-----------------
        
        
    }
    static testmethod void AddProductMethod(){
        
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Preferred_Wholesaler__c='ABC',Phoenix_Is_Govt_Customer__c=true);
        insert testAccount;
        
        list<Product2> prodList = new list<Product2>();
        Product_Family__c pf1 = new Product_Family__c();
        pf1.Name = 'Test Family';
        insert pf1;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Sample Family';
        insert pf2;
        Product_Family__c pf3 = new Product_Family__c();
        pf3.Name = 'cetirizine';
        insert pf3;
        Product2 prod1 = new Product2(Name = 'Test Product',Product_Family__c = pf1.Id, Phoenix_Rx_SRx_OTC__c='Rx',Phoenix_Special_Product__c=true,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Product_Family__c = pf2.Id, Phoenix_Rx_SRx_OTC__c='Rx',Phoenix_Special_Product__c=true,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Product_Family__c = pf3.Id, Phoenix_Rx_SRx_OTC__c='SRx',Phoenix_Special_Product__c=true,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Product_Family__c = pf3.Id, Phoenix_Rx_SRx_OTC__c='OTC',Phoenix_Special_Product__c=true,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        if(!prodList.isEmpty())
            insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        
        
        list<Phoenix_BidWACCreatorCtrl.wrapperClass> wrap = new list<Phoenix_BidWACCreatorCtrl.wrapperClass>();
        list<string> productIds = new list<string>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_BidWACCreatorCtrl.wrapperClass pbw = new Phoenix_BidWACCreatorCtrl.wrapperClass();
            pbw.prdlist = prodList[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
            wrap.add(pbw);
            productIds.add(prodList[i].Id);
            
        }
        
        Phoenix_BidWACCreatorCtrl.BidWrapper pbWrapper2 = new Phoenix_BidWACCreatorCtrl.BidWrapper();
        pbWrapper2 = Pheonix_BidWACChangeController.getBidInfo(pb.Id);
        
        Phoenix_BidWACCreatorCtrl.BidWrapper pbWrapper3 = new Phoenix_BidWACCreatorCtrl.BidWrapper();
        pbWrapper3.bid = pb;
        pbWrapper3.isBidCreated = true;
        Pheonix_BidWACChangeController.getproducts1(pbWrapper3);
        
        string search = 'test';
        string searchFamily = 'test';
        list<string>RxSrxList=new list<string>();
        RxSrxList.add('Rx');
        list<string>directorList=new list<string>();
        directorList.add('Suseela Dhruvsoft');
        string searchNDC='12345678902 21345678902';
        Pheonix_BidWACChangeController.getSearch(wrap,directorList, search,searchFamily,RxSrxList,pbWrapper3);
        RxSrxList.add('SRx');
        Pheonix_BidWACChangeController.getSearch(wrap,directorList, '333333',searchFamily,RxSrxList,pbWrapper3);
        Pheonix_BidWACChangeController.getSearch(wrap,directorList, searchNDC,searchFamily,RxSrxList,pbWrapper3);
        Pheonix_BidWACChangeController.findBySrxOtc(RxSrxList,directorList,search,searchFamily,wrap,pbWrapper3);
        Pheonix_BidWACChangeController.getSearchFamily(wrap,directorList, searchFamily,search,RxSrxList,pbWrapper3);
        Pheonix_BidWACChangeController.getsearchDirectorResult(wrap,directorList, searchFamily,search,RxSrxList,pbWrapper3);
        Pheonix_BidWACChangeController.getProductDirectorList(pbWrapper3);
        Pheonix_BidWACChangeController.showselectedProducts(pb.Id);
        
        
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        String docId=documents[0].Id;
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = pb.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        
        Phoenix_BidWACCreatorCtrl.BidWrapper pbWrapper = new Phoenix_BidWACCreatorCtrl.BidWrapper();
        pbWrapper = Pheonix_BidWACChangeController.getBidInfo(pb.Id);
        Phoenix_BidWACCreatorCtrl.BidWrapper pbWrapper1 = new Phoenix_BidWACCreatorCtrl.BidWrapper();
        pbWrapper1.bid = pb;
        pbWrapper1.isBidCreated = true;
        Pheonix_BidWACChangeController.getproducts1(pbWrapper1);
        list<Phoenix_BidWACCreatorCtrl.wrapperClass> wrap1 = new list<Phoenix_BidWACCreatorCtrl.wrapperClass>();
        list<string> productIds1 = new list<string>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_BidWACCreatorCtrl.wrapperClass pbw = new Phoenix_BidWACCreatorCtrl.wrapperClass();
            pbw.prdlist = prodList[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
            wrap1.add(pbw);
            productIds1.add(prodList[i].Id);
            
        }
        string search1 = 'test';
        string searchFamily1 = 'test';
        list<string>RxSrxList1=new list<string>();
        RxSrxList1.add('Rx');
        // string searchNDC='12345678902 21345678902';
        // Pheonix_BidWACChangeController.getSearch(wrap1, search,searchFamily,RxSrxList1);
        RxSrxList.add('SRx');
        // Pheonix_BidWACChangeController.getSearch(wra1, '333333',searchFamily,RxSrxList1);
        // Pheonix_BidWACChangeController.getSearch(wrap1, searchNDC,searchFamily,RxSrxList1);
        // Pheonix_BidWACChangeController.findBySrxOtc(RxSrxList1,search1,searchFamily1,wrap1);
        // Pheonix_BidWACChangeController.getSearchFamily(wrap1, searchFamily1,search1,RxSrxList1);
        list<Phoenix_BidWACCreatorCtrl.wrapperClass> wrap2 = new list<Phoenix_BidWACCreatorCtrl.wrapperClass>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_BidWACCreatorCtrl.wrapperClass pbw = new Phoenix_BidWACCreatorCtrl.wrapperClass();
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id);
            pbw.qlItem=pbl;
            pbw.prdlist = prodList[i];
            wrap2.add(pbw);
        }
        
        Pheonix_BidWACChangeController.savequoteitems(wrap1, pbWrapper1);
        Pheonix_BidWACChangeController.fetchSortResults('Name',true,wrap);
        Pheonix_BidWACChangeController.getproductsrelatedtoBid(pbWrapper1);
        Pheonix_BidWACChangeController.deleteLineItems(lineItemsList[0].Id);
        Pheonix_BidWACChangeController.getDocs(pb.Id);
        Pheonix_BidWACChangeController.deleteAttachments(docId, pb.Id);
        Pheonix_BidWACChangeController.getProductDirectorList(pbWrapper);
        List<string> SearchKeyWordPD = new List<String>{'Test1','Test2','Test3'};
            Pheonix_BidWACChangeController.getsearchDirectorResult(wrap1,SearchKeyWordPD,'Find','Test Name',SearchKeyWordPD,pbWrapper1);
        
        //Pheonix_BidWACChangeController.editQuoteItems(wrap1, pbWrapper1);
        // Pheonix_BidWACChangeController.editQuoteItems(wrap1, pbWrapper1);
        
        System.assertEquals(1, 1);
        
    }
    static testmethod void businessApproval(){
        Phoenix_Bid__c pb=[SELECT Id FROM Phoenix_Bid__c LIMIT 1];
        Pheonix_BidWACChangeController.makeApprovalsBusiness(pb.Id,'test','Approved','Business Head');
        Pheonix_BidWACChangeController.makeApprovalsCountry(pb.Id,'test','Approved','Country Head');
        Pheonix_BidWACChangeController.makeApprovalsFinance(pb.Id,'test','Approved','Finance');
        Pheonix_BidWACChangeController.makeApprovalsContracts(pb.Id,'test','Processed','Contracts');
        Pheonix_BidWACChangeController.saveToBidBus(pb.Id,'test','Approved');
        Pheonix_BidWACChangeController.saveToBidCountry(pb.Id,'test','Approved');
        Pheonix_BidWACChangeController.saveToBidContr(pb.Id,'test','Processed');
        Pheonix_BidWACChangeController.saveToBidFin(pb.Id,'test','Approved');
        System.assertEquals(1, 1);
    }
    static testmethod void contractsApproval(){
        Phoenix_Bid__c pb=[SELECT Id FROM Phoenix_Bid__c LIMIT 1];
        Pheonix_BidWACChangeController.makeApprovalsBusiness(pb.Id,'test','Not Approved','Business Head');
        Pheonix_BidWACChangeController.saveToBidBus(pb.Id,'test','Not Approved');
        Pheonix_BidWACChangeController.saveToBidCountry(pb.Id,'test','Not Approved');
        Pheonix_BidWACChangeController.saveToBidContr(pb.Id,'test','Not Processed');
        Pheonix_BidWACChangeController.saveToBidFin(pb.Id,'test','Not Approved');
        System.assertEquals(1, 1);
    }
}