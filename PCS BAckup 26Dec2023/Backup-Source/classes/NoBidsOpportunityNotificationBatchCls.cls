public class NoBidsOpportunityNotificationBatchCls implements Database.Batchable < sObject >,Database.Stateful,Schedulable    {
    list<Opportunity> NullBidsList=new  list<Opportunity>();
    map<Id, list<Opportunity>> mapofOwnerwithOpp=new map<Id, list<Opportunity>>();
    map<Id, list<Opportunity>> mapofOwnerwithOppBids=new map<Id, list<Opportunity>>();
    
    set<Id> BidsList=new  set<Id>();
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new NoBidsOpportunityNotificationBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        list<string> idd=new list<string>();
        idd.add('0062h00000WKPS0AAP');
        idd.add('0062h00000WKPT8AAP');
        idd.add('0062h00000WK9LCAA1');
        idd.add('0062h00000WK9LRAA1');
        
        
        
        
        // ('0062h00000WIWfWAAX','0062h00000WIXNmAAP');
       // return Database.getQueryLocator([Select Id,Name,CloseDate,Owner.Name,Owner.Email,OwnerId, (select Id from Bids__r) from Opportunity where CloseDate >= Today and Id=:idd]);
       // }
        return Database.getQueryLocator([Select Id,Name,CloseDate,Owner.Name,Owner.Email,OwnerId, (select Id from Bids__r) from Opportunity where CloseDate >= Today ]);}
    
    public void execute(Database.BatchableContext BC, List < Opportunity > oppList) {
        List<Messaging.SingleEmailMessage> NullBidmails = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        map<Id, list<Product_Opportunity__c>> oppwithProductsmap=new map<Id, list<Product_Opportunity__c>>();
        set<id> oppIds=new set<Id>();
        OPPORTUNITY oppRe=[SELECT Id FROM OPPORTUNITY LIMIT 1];
        String oppName;
        String opCloseDate;
        String remainingDays;
        String closedate;
        String  targetdate;
        String header1 = '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">Opportunities with No Bids</div>';
        //Phoenix_Util.EmailWrapper emailWrapper1 = Phoenix_Util.getTemplateBody('Opportunity_with_No_Bids', oppRe.Id);
        //String templateBody = emailWrapper1.mailHtmlBody;
        //String header2 = '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">DoH Report </div>';
       // Phoenix_Util.EmailWrapper emailWrapper2 = Phoenix_Util.getTemplateBody('Opportunity_Products_with_No_Bids', oppRe.Id);
        //String templateBody1 = emailWrapper2.mailHtmlBody;
        set<id> alreadyexistingIds=new set<id>();
        for(Opportunity oppRec:oppList){
            oppIds.add(oppRec.Id); 
        }
        list<Product_Opportunity__c> oppProducts= new  list<Product_Opportunity__c>();
        if(oppIds.size()>0){
            oppProducts=  [select Id,Name,Vision_Bid_Line_Item__c,Vision_Product_Target_Date__c,Opportunity__c,Product_Family__c,Product__r.Name from Product_Opportunity__c where Opportunity__c=:oppIds];
            if(oppProducts.size()>0){
                for(Product_Opportunity__c oppProductsList:oppProducts){
                    if(oppwithProductsmap.containsKey(oppProductsList.Opportunity__c)){
                        
                        oppwithProductsmap.get(oppProductsList.Opportunity__c).add(oppProductsList);
                        
                    }
                    else{
                        oppwithProductsmap.put(oppProductsList.Opportunity__c,new list<Product_Opportunity__c>{oppProductsList}); 
                    }  
                }
            }
        }
        for(Opportunity opportunityRec : oppList){
            
            try{
                if(mapofOwnerwithOpp.containsKey(opportunityRec.OwnerId)){
                    
                    mapofOwnerwithOpp.get(opportunityRec.OwnerId).add(opportunityRec);
                    
                }
                else{
                    
                    mapofOwnerwithOpp.put(opportunityRec.OwnerId,new list<Opportunity>{opportunityRec}); 
                }
                
                
            }
            Catch(Exception e) {
                system.debug('Exception: '+e);
            }
            
            //for sending email
        }
        List<messaging.CustomNotification> pushNotificationsList = new List<messaging.CustomNotification>();
        String ownerEmail;
        String ownerEmailOppwithBids;
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Alert_Notification'];
        map<string,string> daysCountforCloseDate=new map<string,string>();
        for(Id rec:mapofOwnerwithOpp.keySet()){
            list<Opportunity> ownerOppList=mapofOwnerwithOpp.get(rec);
            list<Opportunity> nulloppList=new list<Opportunity>();
            list<Opportunity> nullbidsoppList1=new list<Opportunity>();
            
            for(Opportunity recList:ownerOppList){
                if(recList.Bids__r.size()==0){
                    System.debug('ownerOppList>>'+ownerOppList);
                    System.debug('recList>>>'+recList);
                    
                    
                    if(system.today() + integer.valueOf(System.Label.OpportunityEmail5Days) == recList.CloseDate){
                        nulloppList.add(recList); 
                        daysCountforCloseDate.put(recList.Id,'(5 days from today)');
                    }   
                    if(system.today() + integer.valueOf(System.Label.OpportunityEmail10Days) == recList.CloseDate){
                        nulloppList.add(recList); 
                        daysCountforCloseDate.put(recList.Id,'(10 days from today)');
                    }
                    if(system.today() + integer.valueOf(System.Label.OpportunityEmail15Days) == recList.CloseDate){
                        nulloppList.add(recList); 
                        daysCountforCloseDate.put(recList.Id,'(15 days from today)');
                    }
                    if(system.today() == recList.CloseDate){
                        system.debug('today condition'); 
                        nulloppList.add(recList); 
                        daysCountforCloseDate.put(recList.Id,'(0 days from today)');
                    }   
                } 
                else{
                    list<Product_Opportunity__c> productsListWithBids= new list<Product_Opportunity__c>(); 
                    productsListWithBids=oppwithProductsmap.get(recList.Id);
                    System.debug('productsListWithBids>>'+productsListWithBids);
                    //if(mapofOwnerwithOppBids.containsKey(oppProductsList.Opportunity__c)){
                    
                    if(productsListWithBids.size()>0){
                        for(Product_Opportunity__c prod:productsListWithBids){
                            if(prod.Vision_Product_Target_Date__c != null && prod.Vision_Bid_Line_Item__c==null){
                                //if(prod.Vision_Product_Target_Date__c!=null ){//prod.Vision_Bid_Line_Item__c==null
                                if(system.today() + integer.valueOf(System.Label.OpportunityEmail5Days) == prod.Vision_Product_Target_Date__c){
                                    // nullbidsoppList.add(recList); 
                                    alreadyexistingIds.add(recList.Id);
                                    
                                }
                                if(system.today() + integer.valueOf(System.Label.OpportunityEmail10Days) == prod.Vision_Product_Target_Date__c){
                                    //nullbidsoppList.add(recList);
                                    alreadyexistingIds.add(recList.Id);
                                }
                                if(system.today() + integer.valueOf(System.Label.OpportunityEmail15Days) == prod.Vision_Product_Target_Date__c){
                                    //nullbidsoppList.add(recList);   
                                    alreadyexistingIds.add(recList.Id);
                                }
                                if(system.today() == prod.Vision_Product_Target_Date__c /*&& prod.Vision_Bid_Line_Item__c==null*/){
                                    alreadyexistingIds.add(recList.Id);
                                    System.debug('today');
                                    
                                    //nullbidsoppList.add(recList);   
                                    
                                }
                                //}
                                /*if(prod.Vision_Bid_Line_Item__c==null){


}
if(prod.Vision_Bid_Line_Item__c==null){


}*/
                                
                                
                            }
                            
                            
                        }
                        
                    } 
                    system.debug('alreadyexistingIds'+alreadyexistingIds);
                }
            }
            //1st scenario
            if(nulloppList.size()>0){
                System.debug('nulloppList>>>'+nulloppList.size());
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                String subject='Opportunities with No Bids';    
                
                
                String tableData = '';
                //String header = '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">Opportunity Report</div>';
                string body='';
                body += '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">Opportunities with No Bids<img src="https://drreddysnag--doh--c.documentforce.com/servlet/servlet.ImageServer?id=0152h000000FOOz&oid=00D2h0000000O9g&lastMod=1647864446000" width="60" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
                //body += '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">Opportunities with No Bids</div>';
                //body +='<img src="https:CS36.salesforce.com/servlet/servlet.ImageServer?id=0152h000000FOOz&oid=00D2h0000000O9g&lastMod=1647864446000" alt="logo"</img>';
                //body +='<p><img src="https://drreddysnag--doh--c.documentforce.com/servlet/servlet.ImageServer?id=0152h000000FOOz&oid=00D2h0000000O9g&lastMod=1647919087000" width="40" alt="logo"/></p>';       
                body+='<span>Dear '+nulloppList[0].Owner.Name+',<br/><br/>'; 
                body+='The close date is approaching for the following opportunities: <br/><br/>';
                for(Opportunity opp:nulloppList){
                     list<Product_Opportunity__c> productsList=new list<Product_Opportunity__c>();
                    if((oppwithProductsmap.get(opp.Id)).size()>0){
                         productsList=oppwithProductsmap.get(opp.Id);}
                    
                    /* boolean isNullbidScenario=true;
if(BidsList.contains(opp.Id)){
isNullbidScenario=false;  
}*/
                    String pgRef = '{ type: "standard__recordPage",attributes:{recordId:' +  opp.Id + ',objectApiName: "Opportunity",actionName: "view"} }';
                    String ownerId=opp.OwnerId;
                    
                    ownerEmail=opp.Owner.Email;
                    
                    set<string> recipientsIds =new set<string>{ownerId};//opp.Owner
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();string bodyContent = '';
                    notification.setTitle('There are no bids present for this Opportunity');
                    bodyContent = 'Opportunity Name: '+opp.Name;
                    
                    notification.setBody(bodyContent);
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetPageRef(pgRef);
                    try {
                        
                        notification.send(recipientsIds);
                    }
                    catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    } 
                    oppName=opp.Name;
                    
                    opCloseDate=String.valueOf(opp.CloseDate).removeEnd(' 00:00:00');
                    remainingDays=daysCountforCloseDate.get(opp.Id);
                    body +='<b>Opportunity Name: </b>'+opp.Name+'<br/>';
                    body +='<b>Opportunity Close Date: </b>'+String.valueOf(opp.CloseDate).removeEnd(' 00:00:00')+'</b>&nbsp;<br/>';
                    body+='<b>'+daysCountforCloseDate.get(opp.Id)+'</b><br/><br/>';
                    body += '<table style="width: 700px; border-collapse: collapse;"><thead><tr><th style="width: 500px; padding: 2px 8px; color:white;border: 1px solid black; text-align: left;background-color:#257CFF;">Product Name</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">Product Family</th></tr></thead>';
                    body += '<tbody>';
                    System.debug('productsList>>'+productsList);
                    if(productsList.size()>0 ){
                        
                        for(Product_Opportunity__c prod:productsList){
                            body += '<tr>';
                            body += '<td style="padding: 2px 8px;border: 1px solid black;">' + prod.Product__r.Name + '</td>';
                            body += '<td style="padding: 2px 8px;border: 1px solid black; text-align: left;">' + prod.Product_Family__c + '</td>';
                            body += '</tr>';
                            
                        }
                    }
                    else{
                        body += '<tr>';
                        body += '<td colspan="2" style="width:100%;border: 1px solid black;">No Products Exists for this Opportunity</td>';
                        body += '</tr>';  
                    }
                    body += '</tbody></table></br><div style="width: 700px;max-width: 700px;text-align: right;"><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.Id+'">More Details</a></div></br>';
                    
                    //body+='For detailed information please check <a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.Id+'">Opportunity</a>';
                    body+='</span>';
                    
                }
                
                //templateBody = templateBody.replace('CLOSEDATE', closedate).replace('OPPNAME', oppName).replace('OPPDATE', opCloseDate).replace('REMAIN DAYS', remainingDays).replace('OPPORTUNITY_TABLE', tableData).replace('OWNER', nulloppList[0].Owner.Name).replace('HEADER', header1);
                //email.setHtmlBody(templateBody);
                body+='</br></br></br>';
                body+='Regards</br>';
                body+='Bright Vision Support Team';
                email.setHtmlBody(body);
                email.setSubject(subject);
//email.setToAddresses(new List<String>{ownerEmail});//Owner.Email
    email.setToAddresses(new List<String>{'pradeep@dhruvsoft.com'});//Owner.Email
            
                //if(isNullbidScenario){
                NullBidmails.add(email);
                //}
                //else{
                //mails.add(email);
                //}
            }
            System.debug('nullbidsoppList size'+nullbidsoppList1.size());
            if(alreadyexistingIds.size()>0){
                
                list<Opportunity> nullbidsoppList =[Select Id,Name,CloseDate,Owner.Name,Owner.Email,OwnerId, (select Id from Bids__r) from Opportunity where CloseDate >= Today and Id=:alreadyexistingIds];
                set<Opportunity> prodSetTemp=new set<Opportunity>();    
                
                set<Opportunity> prodSet=new set<Opportunity>();    
                
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                String subject='Opportunities of Products with No Bids';    
                
                
                String tableData = '';
                String body='';
                //body += '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">Opportunity of Products with No Bids</div>';
                
                body += '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">Opportunities of Products with No Bids<img src="https://drreddysnag--doh--c.documentforce.com/servlet/servlet.ImageServer?id=0152h000000FOOz&oid=00D2h0000000O9g&lastMod=1647864446000" width="60" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
                //body += '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">Opportunities with No Bids</div>';
                
                //String header2 = '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">Opportunity Report</div>';
                //string tableData='';
                body+='<span>Dear '+nullbidsoppList[0].Owner.Name+',<br/><br/>';
                body+='The target date is approaching for the following opportunity products: <br/><br/>';
               String ownerId;
                for(Opportunity opp:nullbidsoppList){
                    ownerEmailOppwithBids=opp.Owner.Email;
                    oppName=opp.Name;
                    ownerId=opp.OwnerId;
                    
                    if(!prodSetTemp.add(opp)){
                        prodSet.add(opp);
                        System.debug('prodSet>>'+prodSet);
                        
                    }
                    list<Product_Opportunity__c> productsList=oppwithProductsmap.get(opp.Id);
                    list<Product_Opportunity__c> prodList= [Select Id,Product_Family__c,Vision_Product_Target_Date__c,Product_Opportunity__c.Product__r.Name From Product_Opportunity__c where Id=:productsList and Vision_Bid_Line_Item__c=null];
                    
                    String pgRef = '{ type: "standard__recordPage",attributes:{recordId:' +  opp.Id + ',objectApiName: "Opportunity",actionName: "view"} }';
                    set<string> recipientsIds =new set<string>{ownerId};//opp.Owner
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();string bodyContent = '';
                    notification.setTitle('There are no bids present for '+prodList.size()+' products for this opportunity');
                    bodyContent = 'Opportunity Name: '+opp.Name;
                    notification.setBody(bodyContent);
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetPageRef(pgRef);
                    try {
                        
                        notification.send(recipientsIds);
                    }
                    catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    } 
                    
                    body +='<b>Opportunity Name: </b>'+opp.Name+'<br/><br/><br/>';
                    //body +='<b>Opportunity Close Date: </b>'+String.valueOf(opp.CloseDate).removeEnd(' 00:00:00')+'</b><br/><br/>';
                    
                    if(prodList.size()>0 ){
                        body += '<table style="width: 700px; border-collapse: collapse;"><thead><tr><th style="width: 500px; padding: 2px 8px; color:white;border: 1px solid black; text-align: left;background-color:#257CFF;">Product Name</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">Product Family</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">Target Date</th></tr></thead>';
                        body += '<tbody>';
                        
                        for(Product_Opportunity__c prod:prodList){
                            body += '<tr>';
                            body += '<td style="padding: 2px 8px;border: 1px solid black;">' + prod.Product__r.Name + '</td>';
                            body += '<td style="padding: 2px 8px;border: 1px solid black; text-align: left;">' + prod.Product_Family__c + '</td>';
                            body += '<td style="padding: 2px 8px;border: 1px solid black; text-align: left;">' + String.valueOf(prod.Vision_Product_Target_Date__c).removeEnd(' 00:00:00') + '</td>';
                            body += '</tr>';
                            
                        }
                    }
                    else{
                        body += '<tr>';
                        body += '<td colspan="2" style="width:100%;border: 1px solid black;">No Products Exists for this Opportunity</td>';
                        body += '</tr>';  
                    }
                    body += '</tbody></table></br><div style="width: 700px;max-width: 700px;text-align: right;"><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.Id+'">More Details</a></div></br>';
                    
                    //body+='For detailed information please check <a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.Id+'">Opportunity</a>';
                    body+='</span>';
                    String homeUrl=URL.getSalesforceBaseUrl().toExternalForm();
                    System.debug('homeUrl>>'+homeUrl);
                    
                }
                body+='</br></br></br>';
                body+='Regards</br>';
                body+='Bright Vision Support Team';
                //templateBody1 = templateBody1.replace('OPPNAME', oppName).replace('TARGETDATE', targetdate).replace('OPPORTUNITY_TABLE', tableData).replace('OWNER', nullbidsoppList[0].Owner.Name).replace('HEADER', header2);
                //email.setHtmlBody(templateBody);
                email.setHtmlBody(body);
                email.setSubject(subject);
               // email.setToAddresses(new List<String>{ownerEmailOppwithBids});//Owner.Email
    email.setToAddresses(new List<String>{'pradeep@dhruvsoft.com'});//Owner.Email

                //if(isNullbidScenario){
                mails.add(email);
                //}
                //else{
                //mails.add(email);
                //}
            }
        }
        
        
        
        
        if(NullBidmails.size()>0){
            system.debug('Mails size is > 0');
            Messaging.sendEmail(NullBidmails);
        }
        if(mails.size()>0){
            system.debug('Mails size is > 0');
            Messaging.sendEmail(mails);
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
        
    }
}