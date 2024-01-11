public class Teams_Integration {
    public static Teams_Credentials__mdt cred;
    public static String access_token;
    static{
        //Get Teams_Credentials metadata
        cred = Teams_Credentials__mdt.getAll().get('Teams_Credentials');
        access_token = getAccessToken();
    }
    
    public static String getAccessToken(){
        String token;
 
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        String body = 'client_id='+EncodingUtil.urlEncode(cred.client_id__c ,'UTF-8')
            +'&client_secret='+EncodingUtil.urlEncode(cred.client_secret__c ,'UTF-8')
            +'&grant_type='+EncodingUtil.urlEncode(cred.grant_type__c ,'UTF-8')
            +'&resource='+EncodingUtil.urlEncode(cred.resource__c ,'UTF-8');
        
        req.setEndpoint(cred.Token_URL__c);
        req.setBody(body);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
         HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest())
        {
            res = new http().send(req);
        }else{
            res.setBody('{"token_type":"Bearer","expires_in":"86399","not_before":"1651218404","expires_on":"1651305104","resource":"00000003-0000-0ff1-ce00-000000000000/drlglobal.sharepoint.com@6d14682b-68a6-4a25-af3d-06615e146b1e","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvZHJsZ2xvYmFsLnNoYXJlcG9pbnQuY29tQDZkMTQ2ODJiLTY4YTYtNGEyNS1hZjNkLTA2NjE1ZTE0NmIxZSIsImlzcyI6IjAwMDAwMDAxLTAwMDAtMDAwMC1jMDAwLTAwMDAwMDAwMDAwMEA2ZDE0NjgyYi02OGE2LTRhMjUtYWYzZC0wNjYxNWUxNDZiMWUiLCJpYXQiOjE2NTEyMTg0MDQsIm5iZiI6MTY1MTIxODQwNCwiZXhwIjoxNjUxMzA1MTA0LCJpZGVudGl0eXByb3ZpZGVyIjoiMDAwMDAwMDEtMDAwMC0wMDAwLWMwMDAtMDAwMDAwMDAwMDAwQDZkMTQ2ODJiLTY4YTYtNGEyNS1hZjNkLTA2NjE1ZTE0NmIxZSIsIm5hbWVpZCI6ImI2MWJhOWRkLTc4Y2UtNDNjYS05M2I4LTY0NWUxNDE1NmRiNUA2ZDE0NjgyYi02OGE2LTRhMjUtYWYzZC0wNjYxNWUxNDZiMWUiLCJvaWQiOiI5YzVjOTc0Yi1lMzY5LTRhYjgtODVhMS0yY2Y1OWNjNGJlMmMiLCJzdWIiOiI5YzVjOTc0Yi1lMzY5LTRhYjgtODVhMS0yY2Y1OWNjNGJlMmMiLCJ0cnVzdGVkZm9yZGVsZWdhdGlvbiI6ImZhbHNlIn0.aoJr_oRZRgR04nZlbSsM0qOOgxfoA4P3y0BBdgJ4vWNYrQugnNVU9Coy4G9YoAZVq4ndCnhhxx-iuQd0Ztry3ulUBT5eSQpMDcZ2wwo9hBn1AkWcUmPT--l45Q6KnP8OSEZVixNatYKoMgslWVXEHQ5239WzjqH1pGShZM1lnNu3llbpfHVMACnC8phHbQSAk1QTRLAXxUXHEFXz67ixLu2jRkxlC-p_uSw2MzvXYuobcdyKGrIwkUqzehWNFsjiHMDy5pnWhNFPr8jMfXtlIpnO2kw5VyAXWMdUSRcYe4Wp--BSqzvD3NgDWxY8Ni6FfDhvGb-QYzXMdTZmqMhq-g"}');
        }
        
        Map<String,Object> result = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        token = String.valueOf(result.get('access_token'));
        
        return token;
    }
   // @future(callout=true)
    public static void batchsendMessage(String email,String body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(cred.Send_Notification_URL__c);
        String body_notification = cred.Notification_Body__c;
        
        body_notification = body_notification.replace('MESSAGE_BODY', body).replace('EMAIL',email);
        //String token = getAccessToken();
        
        req.setHeader('Authorization','Bearer '+access_token);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json;odata=verbose');
        
        req.setBody(body_notification);
        
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest())   res = new http().send(req);
        
        
    }
    @future(callout=true)
    public static void triggersendMessage(String email,String body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(cred.Send_Notification_URL__c);
        String body_notification = cred.Notification_Body__c;
        
        body_notification = body_notification.replace('MESSAGE_BODY', body).replace('EMAIL',email);
        //String token = getAccessToken();
        
        req.setHeader('Authorization','Bearer '+access_token);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json;odata=verbose');
        
        req.setBody(body_notification);
        
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest())   res = new http().send(req);
        
        
    }
    
    
}