@isTest
public class Phoenix_BidHistoryTest {
    @isTest
    public static void analyticsComp(){
        
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        insert acc;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        bid.Phoenix_Bid_Type__c='Product Addition';
        bid.Phoenix_Approval_Status__c='Draft';
        insert bid;
        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;
        bli.Phoenix_Product__c=pro.Id;
        insert bli;
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
        npr.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr;
        
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'Won');
        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'Contract Price');
        Phoenix_BidHistory.getIMSMarketShare(bli.Id, bid.Id);
        Phoenix_BidHistory.getHistoricalPricing(bli.Id, bid.Id,'12');
        
        Phoenix_BidHistory.Wrapper wrap = new Phoenix_BidHistory.Wrapper();
        wrap.bidRecord = new Phoenix_Bid__c();
        wrap.prdlist = new Product2();
        wrap.nprRec = new Phoenix_NPR_Data__c();
        wrap.custResponse = 'NA';
        wrap.bidIds = 'wrap';
        wrap.bidNames = 'wrap';
        wrap.bidType ='bidType';
        wrap.bidStatus='bidStatus';
        wrap.guidancePrice = 1;
        wrap.contrPrice = 10;
        wrap.internalDeadPrice = 10;
        wrap.qlItem = new Phoenix_Bid_Line_Item__c();
        wrap.nprHistory = new List<Phoenix_NPR_Data_History__c>();
        wrap.tptPercent = 1;
        wrap.netSales = 10;
        wrap.tptDollar = 1;
        wrap.volume = 10;
        wrap.twelveMtsSales = 10;
        
        
        
    }
    @isTest
    public static void analyticsComp1(){
        
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        insert acc;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        Product2 pro2= new Product2();
        pro2.Name='Test';
        pro2.Family='Test';
        pro2.ProductCode='30000001';
        pro2.Phoenix_Overall_market__c=70000;
        pro2.Phoenix_DRL_Market_Share__c=5;
        insert pro2;
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        bid.Phoenix_Bid_Type__c='';
        bid.Phoenix_Approval_Status__c='Closed';
        insert bid;
        
        Phoenix_Bid__c bid1 =new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c='Test';
        bid1.Phoenix_Customer__c=acc.Id;
        bid1.Phoenix_Bid_Type__c='';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Bid_Status__c='Awarded';
                bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        bli.Phoenix_Product__c=pro2.Id;
        insert bli;
        
        Phoenix_Bid_Line_Item__c bli1= new Phoenix_Bid_Line_Item__c();
        bli1.Phoenix_Bid__c=bid1.Id;
        bli1.Phoenix_Product__c=pro2.Id;
        insert bli1;
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
        npr.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr;
        
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'');
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'test');
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'Rejected by Customer');
        
        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'Contract Price');
        Phoenix_BidHistory.getIMSMarketShare(bli.Id, bid.Id);
        Phoenix_BidHistory.getHistoricalPricing(bli.Id, bid.Id,'12');
    }
    @isTest
    public static void analyticsComp2(){
        
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        insert acc;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        Product2 pro2= new Product2();
        pro2.Name='Test';
        pro2.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro2.ProductCode='30000001';
        pro2.Phoenix_Overall_market__c=70000;
        pro2.Phoenix_DRL_Market_Share__c=5;
        insert pro2;
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        bid.Phoenix_Bid_Type__c='Product Addition ';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        
        Phoenix_Bid__c bid1 =new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c='Test';
        bid1.Phoenix_Customer__c=acc.Id;
        
        bid1.Phoenix_Bid_Type__c='';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Product__c=pro2.Id;
        bli.Phoenix_Bid_Status__c='Pending';
                bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli;
        
        Phoenix_Bid_Line_Item__c bli1= new Phoenix_Bid_Line_Item__c();
        bli1.Phoenix_Bid__c=bid1.Id;
        bli1.Phoenix_Product__c=pro2.Id;
        bli1.Phoenix_Bid_Status__c='Declined by Customer';
                bli1.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli1;
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
        npr.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr;
        
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'Rejected by Customer');
        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'Contract Price');
        Phoenix_BidHistory.getIMSMarketShare(bli.Id, bid.Id);
        Phoenix_BidHistory.getHistoricalPricing(bli.Id, bid.Id,'12');
    }
    @isTest
    public static void analyticsComp4(){
        
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        acc.Phoenix_Customer_Bucket__c='Bucket1';
        insert acc;
        
        
        Account acc2=new Account();
        acc2.Name='Test';
        acc2.Phoenix_Customer_Bucket__c='Bucket1';
        acc2.AccountNumber='1234';
        insert acc2;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_Pkg_Size__c=5;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        Product2 pro2= new Product2();
        pro2.Name='Test';
        pro2.Family='Test';
        pro2.ProductCode='30000001';
        pro2.Phoenix_Overall_market__c=70000;
        pro2.Phoenix_DRL_Market_Share__c=5;
        insert pro2;
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        bid.Phoenix_Bid_Type__c='';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        
        Phoenix_Bid__c bid1 =new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c='Test';
        bid1.Phoenix_Customer__c=acc.Id;
        bid1.Phoenix_Bid_Type__c='';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Product__c=pro2.Id;
        bli.Phoenix_Bid_Status__c='Declined by Customer';
                bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli;
        
        Phoenix_Bid_Line_Item__c bli1= new Phoenix_Bid_Line_Item__c();
        bli1.Phoenix_Bid__c=bid1.Id;
        bli1.Phoenix_Product__c=pro2.Id;
        insert bli1;
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
        npr.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr;
        
        
        Phoenix_NPR_Data__c npr1= new Phoenix_NPR_Data__c();
        npr1.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c=cont.Id;
        npr1.Phoenix_Product__c=pro.Id;
        npr1.Phoenix_Add_ABS_Value__c=2.00;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr1;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr1;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=20;
        update npr1;
        
        
        Phoenix_NPR_Data__c npr2= new Phoenix_NPR_Data__c();
        npr2.Phoenix_Account__c=acc2.Id;
        npr2.Phoenix_Contract__c=cont.Id;
        npr2.Phoenix_Product__c=pro.Id;
        npr2.Phoenix_Add_ABS_Value__c=2.00;
        npr2.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr2;
        
        Phoenix_NPR_Snapshot__c snap= new Phoenix_NPR_Snapshot__c();
        snap.Phoenix_NPR_Data__c=npr.Id;
        snap.Phoenix_Dead_Net_Tracking_GR__c=20;
        snap.Phoenix_Date__c=system.today();
        insert snap;
        
        Phoenix_NPR_Snapshot__c snap2= new Phoenix_NPR_Snapshot__c();
        snap2.Phoenix_NPR_Data__c=npr2.Id;
        snap2.Phoenix_Dead_Net_Tracking_GR__c=20;
        snap2.Phoenix_Date__c=system.today();
        insert snap2;
        
        
        Phoenix_NPR_Volume__c snap1= new Phoenix_NPR_Volume__c();
        snap1.Phoenix_NPR_Data__c=npr.Id;
        snap1.Phoenix_Date__c=system.today();
        snap1.Phoenix_Volume__c=20;
        insert snap1;
        
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'');
        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'Contract Price');
        Phoenix_BidHistory.getIMSMarketShare(bli.Id, bid.Id);
        Phoenix_BidHistory.getHistoricalPricing(bli.Id, bid.Id,'12');
    }
    
    
    @isTest
    public static void analyticsComp6(){
        
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        acc.Phoenix_Customer_Bucket__c='Bucket1';
        insert acc;
        
        
        Account acc2=new Account();
        acc2.Name='Test';
        acc2.Phoenix_Customer_Bucket__c='Bucket1';
        acc2.AccountNumber='1234';
        insert acc2;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.ProductCode='30000001';
        pro.Phoenix_Pkg_Size__c=5;
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        Product2 pro2= new Product2();
        pro2.Name='Test';
        pro2.Family='Test';
        pro2.ProductCode='30000001';
        pro2.Phoenix_Overall_market__c=70000;
        pro2.Phoenix_DRL_Market_Share__c=5;
        insert pro2;
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        bid.Phoenix_Bid_Type__c='';
        bid.Phoenix_Approval_Status__c='Vistex Update';
        insert bid;
        
        Phoenix_Bid__c bid1 =new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c='Test';
        bid1.Phoenix_Customer__c=acc.Id;
        bid1.Phoenix_Bid_Type__c='';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Product__c=pro2.Id;
        bli.Phoenix_Bid_Status__c='';
                bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli;
        
        Phoenix_Bid_Line_Item__c bli1= new Phoenix_Bid_Line_Item__c();
        bli1.Phoenix_Bid__c=bid1.Id;
        bli1.Phoenix_Product__c=pro2.Id;
                bli1.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli1;
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
        npr.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr;
        
        
        Phoenix_NPR_Data__c npr1= new Phoenix_NPR_Data__c();
        npr1.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c=cont.Id;
        npr1.Phoenix_Product__c=pro.Id;
        npr1.Phoenix_Add_ABS_Value__c=2.00;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr1;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr1;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=20;
        update npr1;
        
        
        Phoenix_NPR_Data__c npr2= new Phoenix_NPR_Data__c();
        npr2.Phoenix_Account__c=acc2.Id;
        npr2.Phoenix_Contract__c=cont.Id;
        npr2.Phoenix_Product__c=pro.Id;
        npr2.Phoenix_Add_ABS_Value__c=2.00;
        npr2.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr2;
        
        Phoenix_NPR_Snapshot__c snap= new Phoenix_NPR_Snapshot__c();
        snap.Phoenix_NPR_Data__c=npr.Id;
        snap.Phoenix_Dead_Net_Tracking_GR__c=20;
        snap.Phoenix_Date__c=system.today();
        insert snap;
        
        Phoenix_NPR_Snapshot__c snap2= new Phoenix_NPR_Snapshot__c();
        snap2.Phoenix_NPR_Data__c=npr2.Id;
        snap2.Phoenix_Dead_Net_Tracking_GR__c=20;
        snap2.Phoenix_Date__c=system.today();
        insert snap2;
        
        
        Phoenix_NPR_Volume__c snap1= new Phoenix_NPR_Volume__c();
        snap1.Phoenix_NPR_Data__c=npr.Id;
        snap1.Phoenix_Date__c=system.today();
        snap1.Phoenix_Volume__c=20;
        insert snap1;
        
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'Pending');
        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'Contract Price');
        Phoenix_BidHistory.getIMSMarketShare(bli.Id, bid.Id);
        Phoenix_BidHistory.getHistoricalPricing(bli.Id, bid.Id,'24');
    }
    
    @isTest
    public static void analyticsComp5(){
        
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        acc.Phoenix_Customer_Bucket__c='Bucket1';
        insert acc;
        
        
        Account acc2=new Account();
        acc2.Name='Test';
        acc2.Phoenix_Customer_Bucket__c='Bucket1';
        acc2.AccountNumber='1234';
        insert acc2;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        Product2 pro2= new Product2();
        pro2.Name='Test';
        pro2.Family='Test';
        pro2.ProductCode='30000001';
        pro2.Phoenix_Overall_market__c=70000;
        pro2.Phoenix_DRL_Market_Share__c=5;
        insert pro2;
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        bid.Phoenix_Bid_Type__c='';
        bid.Phoenix_Approval_Status__c='Customer\'s Update';
        insert bid;
        
        Phoenix_Bid__c bid1 =new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c='Test';
        bid1.Phoenix_Customer__c=acc.Id;
        bid1.Phoenix_Bid_Type__c='';
        bid1.Phoenix_Approval_Status__c='';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Product__c=pro2.Id;
        bli.Phoenix_Bid_Status__c='';
        bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;
        
        insert bli;
        
        Phoenix_Bid_Line_Item__c bli1= new Phoenix_Bid_Line_Item__c();
        bli1.Phoenix_Bid__c=bid1.Id;
        bli1.Phoenix_Product__c=pro2.Id;
                bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli1;
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
        npr.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr;
        
        
        Phoenix_NPR_Data__c npr1= new Phoenix_NPR_Data__c();
        npr1.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c=cont.Id;
        npr1.Phoenix_Product__c=pro.Id;
        npr1.Phoenix_Add_ABS_Value__c=2.00;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr1;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=12;
        update npr1;
        npr1.Phoenix_Dead_Net_Tracking_GR__c=20;
        update npr1;
        
        
        Phoenix_NPR_Data__c npr2= new Phoenix_NPR_Data__c();
        npr2.Phoenix_Account__c=acc2.Id;
        npr2.Phoenix_Contract__c=cont.Id;
        npr2.Phoenix_Product__c=pro.Id;
        npr2.Phoenix_Add_ABS_Value__c=2.00;
        npr2.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr2;
        
        Phoenix_NPR_Snapshot__c snap= new Phoenix_NPR_Snapshot__c();
        snap.Phoenix_NPR_Data__c=npr.Id;
        snap.Phoenix_Dead_Net_Tracking_GR__c=20;
        snap.Phoenix_Date__c=system.today();
        insert snap;
        
        Phoenix_NPR_Snapshot__c snap2= new Phoenix_NPR_Snapshot__c();
        snap2.Phoenix_NPR_Data__c=npr2.Id;
        snap2.Phoenix_Dead_Net_Tracking_GR__c=20;
        snap2.Phoenix_Date__c=system.today();
        insert snap2;
        
        
        Phoenix_NPR_Volume__c snap1= new Phoenix_NPR_Volume__c();
        snap1.Phoenix_NPR_Data__c=npr.Id;
        snap1.Phoenix_Date__c=system.today();
        snap1.Phoenix_Volume__c=20;
        insert snap1;
        
        Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, bid.Phoenix_Bid_Type__c, bid.Phoenix_Approval_Status__c,'Pending');
                  Phoenix_BidHistory.getBidHistory(bli1.Id, bid1.Id, bid1.Phoenix_Bid_Type__c, bid1.Phoenix_Approval_Status__c,'Pending');

        //   Phoenix_BidHistory.getBidHistory(bli.Id, bid.Id, '', '','Pending');

        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'Contract Price');
        Phoenix_BidHistory.getIMSMarketShare(bli.Id, bid.Id);
        Phoenix_BidHistory.getHistoricalPricing(bli.Id, bid.Id,'24');
    }
     @isTest
    public static void analyticsComp7(){
        
        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        acc.Phoenix_Customer_Bucket__c='Bucket1';
        insert acc;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        //bid.Phoenix_Bid_Type__c='Customer Rebate Change';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        

        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Product__c=pro.Id;
        bli.Phoenix_Bid_Status__c='';
                bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli;
        
       
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
       
       
        list<Phoenix_NPR_Data_History__c> np = new list<Phoenix_NPR_Data_History__c>();
        for(integer i =  0; i < 3 ; i ++)
        {
          Phoenix_NPR_Data_History__c npr4 = new Phoenix_NPR_Data_History__c();
        
        npr4.Phoenix_Field_Name__c = 'Dead Net(Tracking GR)';
           
        npr4.Phoenix_New_Value__c = 'test 1';
        npr4.Phoenix_NPR_Data__c = npr.id;
        npr4.Phoenix_Previous_Value__c = 'npr';
            np.add(npr4);
          
        }
       insert np; 
  
        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'');
      
    }
    
    @isTest
    public static void analyticsComp8(){
        
        
                Map<String, List<Decimal>> nprVolMap= new  Map<String, List<Decimal>>();
        
        list<Phoenix_NPR_Volume__c> nr = new  list<Phoenix_NPR_Volume__c>();
        
            list<Phoenix_NPR_Snapshot__c> nrv = new  list<Phoenix_NPR_Snapshot__c>();

        Account acc=new Account();
        acc.Name='Test';
        acc.AccountNumber='1234';
        acc.Phoenix_Customer_Bucket__c='Bucket1';
        insert acc;
        
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        
        
        
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=acc.Id;
        //bid.Phoenix_Bid_Type__c='Customer Rebate Change';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        

        
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Product__c=pro.Id;
        bli.Phoenix_Bid_Status__c='';
                bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;

        insert bli;
        
        Phoenix_Contract__c cont= new Phoenix_Contract__c();
        cont.Name='Test';
        cont.Phoenix_Contract_Number__c='1234';
        cont.Phoenix_Customer__c=acc.Id;
        insert cont;
        
       
        
        Phoenix_NPR_Data__c npr= new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c=cont.Id;
        npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c=2.00;
        npr.Phoenix_Dead_Net_Tracking_GR__c=10;
        insert npr;
        
         for(integer i = 0 ; i < 3 ; i++)
        {
            
          Phoenix_NPR_Snapshot__c snap= new Phoenix_NPR_Snapshot__c();
        snap.Phoenix_NPR_Data__c=npr.Id;
        snap.Phoenix_Dead_Net_Tracking_GR__c=20;
        snap.Phoenix_Date__c=system.today();
      nrv.add(snap);
            
        }
        
        insert nrv;
       
        for(integer i = 0 ; i < 3 ; i++)
        {
 Phoenix_NPR_Volume__c snap1= new Phoenix_NPR_Volume__c();
        snap1.Phoenix_NPR_Data__c=npr.Id;
        snap1.Phoenix_Date__c=system.today();
        snap1.Phoenix_Volume__c=20;
            nr.add(snap1);
nprVolMap.put(snap1.Phoenix_Month__c,new List<Decimal> { snap1.Phoenix_Volume__c });
        }
        
      
        insert nr;
  
        Phoenix_BidHistory.getProdNPRHistory(bli.Id, bid.Id,'');
                Phoenix_BidHistory.getHistoricalPricing(bli.Id, bid.Id,'12');

      
    }
}