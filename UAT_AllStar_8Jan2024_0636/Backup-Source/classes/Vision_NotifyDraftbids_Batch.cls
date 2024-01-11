public class Vision_NotifyDraftbids_Batch implements Database.Batchable < Phoenix_Bid__c > ,Schedulable{
    
    String header;
    String templateBody;
    String strLogoUrl;
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new Vision_NotifyDraftbids_Batch());
    }
    public class wrapper{
        public string bidNumber;
        public Phoenix_Bid__c bidObj = new Phoenix_Bid__c();
        public List<Phoenix_Bid_Line_Item__c> bidLines = new List<Phoenix_Bid_Line_Item__c>();
    }
    
    public Vision_NotifyDraftbids_Batch(){
        List<Phoenix_Bid_Line_Item__c> bidLineItem = [SELECT Id FROM Phoenix_Bid_Line_Item__c LIMIT 1];
        System.debug('bidLineItem'+bidLineItem);
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Vision_NotifyOldDraftBidPDs', bidLineItem[0].Id);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        templateBody = emailWrapper.mailHtmlBody;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        list<Document> lstDocument = [SELECT Id FROM Document WHERE DeveloperName = 'Vision_Logo'];
        String strOrgId = UserInfo.getOrganizationId();
        if(!test.isRunningTest()){
            String strLogoUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + 
                '/servlet/servlet.ImageServer?id='+lstDocument[0].Id +'&oid='+ strOrgId;
            header= '<div style="width: 691px;max-width: 691px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;"><img src="'+strLogoUrl+'" width="55" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
        } 
    }
    
    public Iterable<Phoenix_Bid__c> start(Database.BatchableContext BC) {
        
        //List<Phoenix_Approval_Process_Step__c> processStep = [SELECT Id, Name FROM Phoenix_Approval_Process_Step__c WHERE Name = 'Customer\'s Update'];
        //system.debug('processStep.size() --> '+processStep.size());
        date d10 = system.today().addDays(-10);
        date d30 = system.today().addDays(-30);
        date d60 = system.today().addDays(-60);
        //date d31 = system.today().addDays(-28);
        //date d28 = system.today().addDays(-27);
        //date d29 = system.today().addDays(-29);
        //date d9 = system.today().addDays(-28);
        List<String> dateStringslist = new List<String>();
        dateStringslist.add(string.valueOf(d10).substringBefore(' '));
        dateStringslist.add(string.valueOf(d30).substringBefore(' '));
        dateStringslist.add(string.valueOf(d60).substringBefore(' '));
        //dateStringslist.add(string.valueOf(d28).substringBefore(' '));
        //dateStringslist.add(string.valueOf(d29).substringBefore(' '));
        //dateStringslist.add(string.valueOf(d31).substringBefore(' '));
        //dateStringslist.add(string.valueOf(d9).substringBefore(' '));
        List<Phoenix_Bid_Process_Steps__c> bidProcesStepList = [SELECT Phoenix_Bid__c, Phoenix_Approval_Sent_Time__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Approval_Sent_Time__c = LAST_N_DAYS:60 AND Phoenix_Status__c = 'In Process' AND Phoenix_Process_Step__r.Name = 'Customer\'s Update'];
        /*List<Phoenix_Bid_Process_Steps__c> bidProcesStep30List = [SELECT Phoenix_Bid__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Approval_Sent_Time__c =:d30 AND Phoenix_Status__c = 'In Process' AND Phoenix_Process_Step__c =: processStep];
List<Phoenix_Bid_Process_Steps__c> bidProcesStep10DaysList = [SELECT Phoenix_Bid__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Approval_Sent_Time__c =:d10 AND Phoenix_Status__c = 'In Process' AND Phoenix_Process_Step__c =: processStep];
List<Phoenix_Bid_Process_Steps__c> bidProcesStep60DaysList = [SELECT Phoenix_Bid__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Approval_Sent_Time__c =:d60 AND Phoenix_Status__c = 'In Process' AND Phoenix_Process_Step__c =: processStep];
List<Phoenix_Bid_Process_Steps__c> bidProcesStepList = new List<Phoenix_Bid_Process_Steps__c>();bidProcesStepList.addAll(bidProcesStep30List);
bidProcesStepList.addAll(bidProcesStep30List);
bidProcesStepList.addAll(bidProcesStep10DaysList);
bidProcesStepList.addAll(bidProcesStep60DaysList);*/
        
        system.debug('bidProcesStepList.size() --> '+bidProcesStepList.size());
        List<Id> bidIds = new List<Id>();
        for(Phoenix_Bid_Process_Steps__c obj : bidProcesStepList){
            if(!bidIds.contains(obj.Phoenix_Bid__c) && dateStringslist.contains(string.valueOf(obj.Phoenix_Approval_Sent_Time__c).subStringBefore(' ')))
                bidIds.add(obj.Phoenix_Bid__c);
        }
       //satya added Phoenix_Customer__r.Owner.Email in inner query
        List<Phoenix_Bid__c> bidList = [SELECT Id, Name, Phoenix_Approval_Status__c, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer__r.Owner.Name, Phoenix_Customer__r.Owner.Email,
                                        (SELECT Id, Phoenix_Product__r.name,Phoenix_Product__r.Phoenix_NDC_11__c, Phoenix_Product__r.Family,Phoenix_Product__r.Phoenix_Product_Director__r.Name, 
                                         Phoenix_Product__r.Phoenix_Product_Director__r.Email,Phoenix_Customer__r.Owner.Email FROM Bid_Line_Items__r), Phoenix_Bid_Name__c FROM Phoenix_Bid__c WHERE  Id IN: bidIds AND Phoenix_Approval_Status__c = 'Customer\'s Update'];//(Id = 'a0C1K00000XaxiPUAR' or Id = 'a0C1K00000Xaxl8' or Id= 'a0C1K00000XawxtUAB')];//
        return bidList;
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_Bid__c> bidItems) {
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            Map<String, List<Map<String,List<Phoenix_Bid_Line_Item__c>>>> itemsMap = new Map<String, List<Map<String,List<Phoenix_Bid_Line_Item__c>>>>();
            Map<String, List<Phoenix_Bid_Line_Item__c>> prodDirBidLineMap = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
            Map<String, List<wrapper>> wrapMap = new Map<String, list<wrapper>>();
            //List<map<String,List<Phoenix_Bid__c>>> kamList = new List<map<String,List<Phoenix_Bid__c>>>();
            Map<String,List<Phoenix_Bid__c>> kamMap = new Map<String,List<Phoenix_Bid__c>>();
            for(Phoenix_Bid__c item:bidItems){
                if(!kamMap.containsKey(item.Phoenix_Customer__r.Owner.Name))
                    kamMap.put(item.Phoenix_Customer__r.Owner.Name,new list<Phoenix_Bid__c>());
                kamMap.get(item.Phoenix_Customer__r.Owner.Name).add(item);
                
                wrapper wrapObj = new wrapper();
                wrapObj.bidObj = item;
                Map<String,List<Phoenix_Bid_Line_Item__c>> internalMap = new Map<String,List<Phoenix_Bid_Line_Item__c>>();
                for(Phoenix_Bid_Line_Item__c obj:item.Bid_Line_Items__r){
                    String prodDir = obj.Phoenix_Product__r.Phoenix_Product_Director__r.Name;
                    if(!internalMap.containsKey(prodDir))
                        internalMap.put(prodDir, new List<Phoenix_Bid_Line_Item__c>());
                    internalMap.get(prodDir).add(obj);
                }
                for(String dirName : internalMap.keySet()){
                    wrapObj.bidLines = internalMap.get(dirName);
                    if(!wrapMap.containsKey(dirName))
                        wrapMap.put(dirName, new List<wrapper>());
                    wrapMap.get(dirName).add(wrapObj);
                }
            }
            
            for(String prodDir : wrapMap.keySet()){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                List<wrapper> wrapList = wrapMap.get(prodDir);
                //String tableString = '<div> No# of responses waiting in total : '+wrapList.size()+' </div><div></div>';
                String tableString = '<div align="center" style="margin: auto; transform: initial;width:700px;border-radius: 10px;border: 1px solid black;"> <div style="background-color:#4902d2;border-radius: 10px;border: black;"> <div style="text-align: right; padding-top: 25px; padding-right: 10px; padding-bottom: 15px; padding-left: 10px;background-color:#4902d2;border-radius: 10px;border: black;"></div>'+
                    //+'<img src="'+strLogoUrl+'" width="55" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"/>'+
                    +'<div class="pad" style="text-align: center; padding-top: 20px; padding-right: 10px; padding-bottom: 25px; padding-left: 10px;background-color:#4902d2;"> <p style=" margin: 0; color: #ffffff; font-size: 14px; font-family: Arial; line-height: 24px; text-align: '+
                    +'left; direction: ltr; font-weight: 600; letter-spacing: 1px; margin-top: 0; margin-bottom: 15px; "> Hi '+
                    +prodDir+
                    +', </p>  <p style=" margin: 0; color: #ffffff; font-size: 14px; font-family: Arial; line-height: 24px; text-align: left; direction: ltr; font-weight: 600; letter-spacing: 1px; margin-top: 0; margin-bottom: 0; "> There are a few bids which have been open for more than 30 days. Below are the list of products and the bid information. </p> </div>'+
                    +'</div>  <div style="align-text:center;padding-left:100px;padding-right:100px;padding-top:10px;"> <div style="font-weight: 400; text-align: left; vertical-align: middle; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px; padding-bottom: 15px; padding-top: 15px; background-color: #f9e0e0;border-radius: 10px;border: black;">'+
                    +'<div> <p style=" font-family: Arial; font-style: normal; font-weight: 600; font-size: 24px; line-height: 40px; color: #3a0085; text-align: center; margin-block-start: 0; margin-block-end: 0; ">'+
                    +wrapList.size()+
                    +'</p> <p style=" font-family: Arial; font-style: normal; font-weight: 600; font-size: 14px; line-height: 25px; text-align: center; letter-spacing: 0.04em; color: #6900ef; margin-block-start: 0; margin-block-end: 0; "> No# of responses waiting </p> </div> '+
                    +'</div> </div> <div> <p style=" font-family: Arial; font-style: normal; font-weight: 600; font-size: 10px; line-height: 19px; letter-spacing: 1px; color: #ababab; text-align: right; margin-block-start: 0; margin-block-end: 0; " > Click on Account/Bid# to view on Bright. </p> </div>';
                for(wrapper obj:wrapList){
                    List<Phoenix_Bid_Line_Item__c> bidLines = obj.bidLines;
                    Phoenix_Bid__c bidObj = obj.bidObj;
                    tableString += '<div style="background-color:#dce1f6;margin-bottom:5px;"> <div style="font-weight: 400; text-align: left; vertical-align: center; padding-left: 16px; padding-top: 16px; padding-right: 16px; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px;">'+
                        +'<div align="left" class="alignment" style="font-family: Arial;"> <span style="font-size: 12px;">Bid Number#</span>'+
                        +'<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+bidObj.Id+'"style="text-decoration: none;display: inline-block;color: #240052;background-color: #ffe2e2;border-radius: 4px;width: auto;font-weight: 600;padding: 5px 8px;font-family: Arial;font-size: 10px;text-align: center;mso-border-alt: none;word-break: keep-all;"target="_blank"><span data-mce-style="font-size: 11px; line-height: 16px; letter-spacing:1px;" style="font-size: 11px; line-height: 13px; letter-spacing: 1px;">'+
                        +''+bidObj.Name+'</span></a></div> </div> <div class="column column-1" style="font-weight: 400; text-align: left; vertical-align: center; padding-left: 16px; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px; " >'+
                        +'<div align="left" class="alignment"> <p style="font-family: Arial; font-style: normal; font-weight: 400; font-size: 12px; line-height: 16px; letter-spacing: 0.02em; color: #676767;"> Bid Name: '+bidObj.Phoenix_Bid_Name__c+' </p> </div> </div>'+
                        +'<div class="column column-1" style="font-weight: 400; text-align: left; vertical-align: center; padding-left: 16px; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px; " >'+
                        +'<div align="left" class="alignment"> <p style="font-family: Arial; font-style: normal; font-weight: 400; font-size: 12px; line-height: 16px; letter-spacing: 0.02em; color: #676767;"> Customer Name: '+bidObj.Phoenix_Customer__r.Name+'<br/> </p> </div> </div>'+
                        +'<div> <table style="width:700px;border-collapse:collapse"> <thead> <tr> <th style="width:500px;padding:2px 8px;color:white;border:1px solid black;text-align:left;background-color:#257cff">Product Name</th>'+
                        +'<th style="width:200px;padding:2px 8px;color:white;background-color:#feb343;border:1px solid black;text-align:left">Product Family</th><th style="width:200px;padding:2px 8px;color:white;background-color:#feb343;border:1px solid black;text-align:left">NDC-11</th></tr></thead><tbody>';
                    Integer totalSize = 0;
                    for(Phoenix_Bid_Line_Item__c lineItem:bidLines){
                        if(totalSize < 11){
                            tableString += '<tr><td style="padding:2px 8px;border:1px solid black">'+lineItem.Phoenix_Product__r.name+'</td>'+
                                +'<td style="padding:2px 8px;border:1px solid black">'+lineItem.Phoenix_Product__r.Family+'</td>'+
                                +'<td style="padding:2px 8px;border:1px solid black">'+lineItem.Phoenix_Product__r.Phoenix_NDC_11__c+'</td></tr>';
                            totalSize++;
                        }
                    }
                    tableString += '</tbody></table></div></div>';
                    if(totalSize > 10)
                        tableString += '<div> Click on Bid# to view all the Products and details... </div></br></br>';
                }
                system.debug('tableString --> '+tableString);
                //String newBody = templateBody;
                //newBody = newBody.replace('HEADER',header)
                //    .replace('PROD_OWNER', prodDir)
                //    .replace('LINEITEM_TABLE', tableString);
                email.setHtmlBody(templateBody.replace('EMAIL_BODY',tableString));
                email.setSubject('Bids which are waiting for Customer response.');
                List<String> emailList = new List<String>{wrapList[0].bidLines[0].Phoenix_Customer__r.Owner.Email};//{'pradeep@dhruvsoft.com'};//
                    email.setToAddresses(emailList);//
                mails.add(email);
            }
            
            for(String kamName : kamMap.keySet()){
                List<Phoenix_Bid__c> kamBids = kamMap.get(kamName);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String tableString = '<div align="center" style="margin: auto; transform: initial;width:700px;border-radius: 10px;border: 1px solid black;"> <div style="background-color:#4902d2;border-radius: 10px;border: black;"> <div style="text-align: right; padding-top: 25px; padding-right: 10px; padding-bottom: 15px; padding-left: 10px;background-color:#4902d2;border-radius: 10px;border: black;">'+
                    //+'<img src="'+strLogoUrl+'" width="55" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"/></div>'+
                    +'</div><div class="pad" style="text-align: center; padding-top: 20px; padding-right: 10px; padding-bottom: 25px; padding-left: 10px;background-color:#4902d2;"> <p style=" margin: 0; color: #ffffff; font-size: 14px; font-family: Arial; line-height: 24px; text-align: '+
                    +'left; direction: ltr; font-weight: 600; letter-spacing: 1px; margin-top: 0; margin-bottom: 15px; "> Hi '+
                    +kamName+
                    +', </p>  <p style=" margin: 0; color: #ffffff; font-size: 14px; font-family: Arial; line-height: 24px; text-align: left; direction: ltr; font-weight: 600; letter-spacing: 1px; margin-top: 0; margin-bottom: 0; "> There are a few bids which have been open for more than 30 days. Below are the list of products and the bid information. </p> </div>'+
                    +'</div>  <div style="align-text:center;padding-left:100px;padding-right:100px;padding-top:10px;"> <div style="font-weight: 400; text-align: left; vertical-align: middle; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px; padding-bottom: 15px; padding-top: 15px; background-color: #f9e0e0;border-radius: 10px;border: black;">'+
                    +'<div> <p style=" font-family: Arial; font-style: normal; font-weight: 600; font-size: 24px; line-height: 40px; color: #3a0085; text-align: center; margin-block-start: 0; margin-block-end: 0; ">'+
                    +kamBids.size()+
                    +'</p> <p style=" font-family: Arial; font-style: normal; font-weight: 600; font-size: 14px; line-height: 25px; text-align: center; letter-spacing: 0.04em; color: #6900ef; margin-block-start: 0; margin-block-end: 0; "> No# of responses waiting </p> </div> '+
                    +'</div> </div> <div> <p style=" font-family: Arial; font-style: normal; font-weight: 600; font-size: 10px; line-height: 19px; letter-spacing: 1px; color: #ababab; text-align: right; margin-block-start: 0; margin-block-end: 0; " > Click on Account/Bid# to view on Bright. </p> </div>';
                for(Phoenix_Bid__c bidObj:kamBids){
                    tableString += '<div style="background-color:#dce1f6;margin-bottom:5px;"> <div style="font-weight: 400; text-align: left; vertical-align: center; padding-left: 16px; padding-top: 16px; padding-right: 16px; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px;">'+
                        +'<div align="left" class="alignment" style="font-family: Arial;"> <span style="font-size: 12px;">Bid Number#</span>'+
                        +'<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+bidObj.Id+'"style="text-decoration: none;display: inline-block;color: #240052;background-color: #ffe2e2;border-radius: 4px;width: auto;font-weight: 600;padding: 5px 8px;font-family: Arial;font-size: 10px;text-align: center;mso-border-alt: none;word-break: keep-all;"target="_blank"><span data-mce-style="font-size: 11px; line-height: 16px; letter-spacing:1px;" style="font-size: 11px; line-height: 13px; letter-spacing: 1px;">'+
                        +''+bidObj.Name+'</span></a></div> </div> <div class="column column-1" style="font-weight: 400; text-align: left; vertical-align: center; padding-left: 16px; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px; " >'+
                        +'<div align="left" class="alignment"> <p style="font-family: Arial; font-style: normal; font-weight: 400; font-size: 12px; line-height: 16px; letter-spacing: 0.02em; color: #676767;"> Bid Name: '+bidObj.Phoenix_Bid_Name__c+' </p> </div> </div>'+
                        +'<div class="column column-1" style="font-weight: 400; text-align: left; vertical-align: center; padding-left: 16px; border-top: 0px; border-right: 0px; border-bottom: 0px; border-left: 0px; " >'+
                        +'<div align="left" class="alignment"> <p style="font-family: Arial; font-style: normal; font-weight: 400; font-size: 12px; line-height: 16px; letter-spacing: 0.02em; color: #676767;"> Customer Name: '+bidObj.Phoenix_Customer__r.Name+'<br/> </p> </div> </div>';
                }
                tableString += '</div></div>';
                //String newBody = templateBody;
                //newBody = newBody.replace('HEADER',header)
                //    .replace('PROD_OWNER', kamName)
                //    .replace('LINEITEM_TABLE', tableString);
                //email.setHtmlBody(newBody);
                email.setHtmlBody(templateBody.replace('EMAIL_BODY',tableString));
                email.setSubject('Bids which are waiting for Customer response.');
                List<String> emailList = new List<String>{kamBids[0].Phoenix_Customer__r.Owner.Email};//{'pradeep@dhruvsoft.com'};//
                    email.setToAddresses(emailList);
                mails.add(email);
            }
            
            if(mails.size()>0)
                Messaging.sendEmail(mails);
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_NotifyDraftbids_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }    
    public void finish(Database.BatchableContext BC) {}
    /* public void codecoverageBlock(){
Integer i=0;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
         i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;

}*/
}