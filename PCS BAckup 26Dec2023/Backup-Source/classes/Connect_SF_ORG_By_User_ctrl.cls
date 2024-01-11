public class Connect_SF_ORG_By_User_ctrl {
    
/*
Consumer Key 3MVG9NYvTkhtdEI7bF7w6H22arwlKIo4osFHlV.Q.sQuLTQdLp2mgVfWZwBhnNewLUqO.ni_24ezX3eZP060y
Consumer Secret 8BE21B3AC51A220F6FDB44E68D16F9545C3579283E207BEFBC2BC8FC665DEDB6

https://drreddysnag--project2.my.salesforce.com/services/oauth2/token?username=integrationuser@phoenix.project2.com&password=Salesforce54321&grant_type=password&
client_id=3MVG9zJJ_hX_0bb83y_7Azu3LxmWsJktlZ82Ik_goxkBQ9sbLcSi57e.fF.owpVyJ_WFbj_x8X0Gdin42biDa&client_secret=2CDE5D65A9B3582658CF9D18EF514BBEC048C323FE3390CB7840762988F2E521

Scope given Full in target SF Org Connected App
*/
    public String consumerKey {set;get;}
    public String  consumerSecret {set;get;}  
    public String endpoint {set;get;}  
    public String tokenEndpoint {set;get;} 
    public String receivedAuthCode {set;get;}  
    public String accessToken {set;get;}  
    
    
    public Connect_SF_ORG_By_User_ctrl(){
        consumerKey  = '3MVG9NYvTkhtdEI7bF7w6H22arwlKIo4osFHlV.Q.sQuLTQdLp2mgVfWZwBhnNewLUqO.ni_24ezX3eZP060y';
        consumerSecret = '8BE21B3AC51A220F6FDB44E68D16F9545C3579283E207BEFBC2BC8FC665DEDB6';
        endpoint = 'https://drreddysnag--phoenixpcs.sandbox.my.salesforce.com/services/oauth2/authorize?grant_type=client_credentials&client_id='+ consumerKey +'&client_secret='+consumerSecret+'&response_type=code';
        endpoint += '&redirect_uri=https%3A%2F%2Fdrreddysnag--uat--c.sandbox.vf.force.com%2Fapex%2FConnect_SF_ORG_By_User';
        receivedAuthCode = ApexPages.CurrentPage().getParameters().get('code');
       if(receivedAuthCode != null) GenerateToken();
    }
    
    public PageReference GenerateToken() {
        tokenEndpoint = 'https://drreddysnag--phoenixpcs.sandbox.my.salesforce.com/services/oauth2/token?grant_type=authorization_code&client_id='+ consumerKey +'&client_secret='+consumerSecret;
        tokenEndpoint += '&redirect_uri=https%3A%2F%2Fdrreddysnag--uat--c.sandbox.vf.force.com%2Fapex%2FConnect_SF_ORG_By_User&code='+receivedAuthCode;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(tokenEndpoint);
        
        HttpResponse res = new http().send(req);
        
        //accessToken = res.getBody();
        //String sampleRes =  '{"access_token":"00D7c000008w4IJ!AQ0AQKKKG0.BEROJE.qUQAZnV3PkbZTyAMVeTeuOqLhkhsmkNG37Lx2NpQwEknhmQvlgMDbpuKswqdb.fdYwSsX52JKqAfxt","signature":"lE3HniZ2x0R2Vlp49DcUnfAM4FhLRhcz8dORSa3gLBs=","scope":"full","id_token":"eyJraWQiOiIyNDAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdF9oYXNoIjoiUmRYem5TVkI5WENYVk54RmR6VFZEZyIsInN1YiI6Imh0dHBzOi8vdGVzdC5zYWxlc2ZvcmNlLmNvbS9pZC8wMEQ3YzAwMDAwOHc0SUpFQVkvMDA1MUswMDAwMDlQaXdOUUFTIiwiYXVkIjoiM01WRzlOWXZUa2h0ZEVJN2JGN3c2SDIyYXJ3bEtJbzRvc0ZIbFYuUS5zUXVMVFFkTHAybWdWZldad0Jobk5ld0xVcU8ubmlfMjRlelgzZVpQMDYweSIsImlzcyI6Imh0dHBzOi8vZHJyZWRkeXNuYWctLXBob2VuaXhwY3Muc2FuZGJveC5teS5zYWxlc2ZvcmNlLmNvbSIsImV4cCI6MTY2NjkyNDM0MSwiaWF0IjoxNjY2OTI0MjIxfQ.cPFGh2UiSOMtJVIzgJoWx3YONDAIjQ4XqGztr0DCnbmJfbrFjPouVQRMt0yj3s7sB8UA6TwPbXhzeBz3sw4RDGFtBzrihd7goKJHswsOqW7j_0lPrshicn3VAr_M9iOyEYJrCnuZh6VLVU1v_Ee_R18UdlIRoQ8E6Eet_VDBwgbZOrp5rd7DuocaPZHrH6FEcGMY6QRKA3qdG2PQT4CDS0NioqcYz0fEbC8JJDPGPQhTqzlK5wGdOdymMFTKGMkPHIUZWD_DwDN2LcdzNTGktvYgZBHmZSjbDe7CRyB1i8ih7VWYYAd6ayzJDX2PJq3mWA_tbuvcK6R87LdS4LEgC7w0UVcK3EvJCy2A9s5VWqUJREHHH-hhhNfUsmFAS9IYKav8G5VngJVUu5kCvL6M5_rGLV5hjejkY7h4Dxcq9Ybb6wRoxA6H2z95hsdxcS4CHDo_IqI7Kwzwk3Z8B1lrUYMMgpIZmfB5dsd5ljQx-LPpGt6rwIuwPad9wCTLviCXaUhTL64Zm35MYpryKJ0PGZqsKGMsTRRlTz_jBVQMamtZO7umnmo5c2myZ2HJP1fcWdO8KWHJHaPnzAnNWkkA_o_YKakta4p9qjbH5BozsrGCEeDha4BjD9pM2HsDUV12Hk7sr6U7ShIoLsKpkeQVITbn54OlYqKxFNE0tbLRSSs","instance_url":"https://drreddysnag--phoenixpcs.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D7c000008w4IJEAY/0051K000009PiwNQAS","token_type":"Bearer","issued_at":"1666924221508"}';
        
        Map<String, Object> body =  (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        accessToken = body.get('access_token').toString(); 
        return null;
    }
}