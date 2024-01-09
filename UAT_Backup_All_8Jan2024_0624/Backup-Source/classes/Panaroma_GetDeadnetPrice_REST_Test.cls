@isTest(SeeAllData=true)
public class Panaroma_GetDeadnetPrice_REST_Test {
@isTest
public static void TestHumana(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"146932","WAC":"25","ProposedDirectContractPrice":"20","proposedIndirectContractPrice":"22","productType":"Regular Product","bidTemplate":"Humana Indirect CII"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}    
    
@isTest
    public static void TestWalgreens(){
        Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();
        
        
            RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueOf('{"AccountNumber":"370741","WAC":"21","MarketingPrice":"15","productType":"Regular Product"}');
            RestContext.request = req;
        RestContext.response = res; 
        
        Test.startTest();
            Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
        Test.stopTest();  
    }   

 @isTest
    public static void TestABCProgen(){
        Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();
        
        
            RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueOf('{"AccountNumber":"370260","WAC":"85","MarketingPrice":"5.35","productType":"Regular Product"}');
            RestContext.request = req;
        RestContext.response = res; 
        
        Test.startTest();
            Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
        Test.stopTest();  

}
@isTest
public static void TestNetIndirectPricing(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"154328","WAC":"105.53","ProposedDirectContractPrice":"45","proposedIndirectContractPrice":"70","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}

@isTest
public static void TestABCPharmagen(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"370260","WAC":"101.64","proposedIndirectContractPrice":"22","productType":"Regular Product","bidTemplate":"ABC Pharmagen"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestCostco(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"118871","WAC":"15","MarketingPrice":"10","IndirectNet":"9","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}

@isTest
public static void TestSamsclub(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"147740","WAC":"176.07","ProposedDirectContractPrice":"50","proposedIndirectContractPrice":"70","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestGovernmentPricing(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"371075","WAC":"99.33","proposedIndirectContractPrice":"60","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestDirect(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"117571","ProposedDirectContractPrice":"80","proposedPUR":"0","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestIndirect(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"107257","WAC":"200","proposedPUR":"0","proposedIndirectContractPrice":"40","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}

@isTest
public static void TestClarusOne(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"153363","WAC":"43","ProposedNCPforMcKOSRAD":"5.53","ProposedNCPforWMTDirect":"4.13","ProposedNCPforWMTIndirect":"4.13","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestDSH (){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"151738","WAC":"2250"," ProposedBASEContractPrice":"2100","ProposedDSHContractPrice":"2037","ProposedAutoSubContractPrice":"2000","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}

@isTest
public static void TestHumanaIndirectretail(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"146932","WAC":"25","proposedPUR":"0","proposedIndirectContractPrice":"22","productType":"Regular Product","bidTemplate":"Humana Indirect retail"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestHumanaIndirectCII(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"146932","WAC":"25","ProposedDirectContractPrice":"20","proposedIndirectContractPrice":"22","productType":"Regular Product","bidTemplate":"Humana Indirect CII"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}

@isTest
public static void TestEcondisc(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"117866","WAC":"12.28","MarketingPrice":"9","WholesalerDiffPriceIndirect":"10","salesoutPromotionDays":"30","salesOutPromotionPercentage":"5","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestRXSS (){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"151515","WAC":"200","proposedPUR":"0","WholesalerDiffPriceIndirect":"100","proposedIndirectContractPrice":"40","productType":"Regular Product","MarketingPrice":"100"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
@isTest
public static void TestROS(){
    Panaroma_GetDeadnetPrice_REST rest = new Panaroma_GetDeadnetPrice_REST();

        RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/GetDeadnetPrice'; 
    req.httpMethod = 'Post';
    req.addHeader('Content-Type', 'application/json'); 
    req.requestBody = Blob.valueOf('{"AccountNumber":"115596","WAC":"15.77","MarketingPrice":"8","proposedIndirectContractPrice":"10","productType":"Regular Product"}');
        RestContext.request = req;
    RestContext.response = res; 
    
    Test.startTest();
        Panaroma_GetDeadnetPrice_REST.getDeadnetPrice();
    Test.stopTest();  
    
}
}