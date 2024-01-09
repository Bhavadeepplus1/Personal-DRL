public class emailsforProductDisc_MasPrdctRemoval {
    public static void sendEmailToAllApproversforProductDiscontinuation(String bidId,List<Phoenix_Bid_Line_Item__c> lineitems,String approverName,List<String> toAddress,List<String> ccEmailIds){
        try{
            map<String,list<Phoenix_Bid_Line_Item__c>> maplist = new map<String,list<Phoenix_Bid_Line_Item__c>>();
            for(Phoenix_Bid_Line_Item__c item: lineitems){
                if(maplist.containskey(item.Phoenix_Product__r.Name)){
                    List<Phoenix_Bid_Line_Item__c> templist = maplist.get(item.Phoenix_Product__r.Name);
                    tempList.add(item);
                    maplist.put(item.Phoenix_Product__r.Name,tempList);
                } else{
                    maplist.put(item.Phoenix_Product__r.Name,new List<Phoenix_Bid_Line_Item__c> {item}); 
                }
            }
            Integer lineitemsize = maplist.keySet().size();
            Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
            
        /*    for (Phoenix_Bid_Process_Steps__c step: [SELECT Id,Phoenix_Approver_Team_Members__c,Phoenix_Approver_Team__c, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email
                                                     FROM Phoenix_Bid_Process_Steps__c
                                                     WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
                                                     AND Phoenix_Bid__c =: bidId 
                                                    ]) {
                                                        if (step.Phoenix_Approver__c != null) {
                                                            allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Email);
                                                            if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null){
                                                                allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);    
                                                                
                                                            }
                                                        }
                                                        Set < String > teamNames = new Set < String > ();
                                                        Set<String> emailList = new Set<String>();
                                                        if (step.Phoenix_Approver_Team_Members__c != null){
                                                            teamNames = new Set < String > (step.Phoenix_Approver_Team_Members__c.split(',')); 
                                                        }
                                                        List < User > usersList = [SELECT Id, Username, Name, Email FROM User where Name IN: teamNames];
                                                        for(User u : usersList){
                                                            emailList.add(u.Email);
                                                            allPeopleInvolvedEmailsSet.add(u.Email);
                                                         
                                                        }
                                                    }*/
            //List < String > toAddress = new List < String > ();
            //If(allPeopleInvolvedEmailsSet != null && allPeopleInvolvedEmailsSet.contains('mkalawadia@drreddys.com'))allPeopleInvolvedEmailsSet.remove('mkalawadia@drreddys.com');
           // toAddress.addAll(allPeopleInvolvedEmailsSet);
            
            List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                  Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_Bid__c =: bidId order by Phoenix_Approval_Sent_Time__c desc];
            List<String> approvernames= new List<String>();
            //String approverName ='';
            DateTime internalDueDateTime;String createdDate;
            for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                if(step.Phoenix_Status__c == 'In Process'){
                    approvernames.add(step.Phoenix_Approver__r.Name);
                    //approverName = step.Phoenix_Approver__r.Name;
                }
                
            }
          /*  System.debug('approvernames==>'+approvernames);
            if(approvernames != null){
                approverName = approvernames[0];
            }*/
            Phoenix_Bid__c bid = [select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:bidId];
            String bidNumber = bid.Name;
            String bidType = bid.Phoenix_Bid_Type__c;
            String bidName =bid.Phoenix_Bid_Name__c;
            if (bid.Phoenix_Internal_Target_Date__c != null) 
                internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));                        
            if (bid.CreatedDate != null) 
                createdDate = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
            //String bidComments = bid.Phoenix_Comments__c.replaceAll('<p>', '<span style = "font-size: 14px;font-family: Sans-Serif;">').replaceAll('</p>', '</span>');
           String bidComments = bid.Phoenix_Comments__c.replaceAll('<p>', '<p style="font-size:14px;font-family:Sans-Serif;>');

            String subject = '';  String title = '';
            
            if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){    
                subject = 'Product Discontinuation Approval Request Notification';	
                title = 'Product Discontinuation Approval Request';
            }
            if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){    
                subject = 'Product Removals Approval Request Notification';	
                title = 'Product Removal Approval Request';
            }
            String content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 26px;"></td><td style="padding: 12px 8px 0px 6px;">Dear '+approverName+',</td></tr></table>';
            //String content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;">Dear '+approverName+',</td></tr>';
            if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){
                content += '<table><tr><td style="width: 26px;"></td><td style="padding: 4px 8px 8px 6px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' is requesting your approval of deactivating '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
                //content += '<tr><td style="width: 24px;"></td><td style="padding: 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">'+bid.Owner.Name+' is requesting your approval of deactivating '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
            }
            if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                content += '<table><tr><td style="width: 26px;"></td><td style="padding: 4px 8px 8px 6px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' is requesting your approval of removing '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
                //content += '<tr><td style="width: 24px;"></td><td style="padding: 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">'+bid.Owner.Name+' is requesting your approval of removing '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
                
            }
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 26px;"></td><td style="padding: 0px 8px 8px 6px;"><b>Bid Details:</b></td></tr></table>';
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
            content += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead>';
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th>';
            content += '<th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bidId+'">'+bidNumber+'</a></th></tr>';
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bidName+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bidType+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
            if (internalDueDateTime != null) {
                content += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
            } else{
                content += '<td style="border: 1px solid black;"></td></tr>';
            }
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr></thead></table></td></tr></table>';
            String created_Date = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>Bid Comments:</b></td></tr></table>';
            if(bid.Phoenix_Comments__c != null)	content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'):</td><td style="padding: 0px 8px 0px 0px;font-size: 14px;font-family: Sans-Serif;">'+bidComments+'</td></tr></table>';
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>Product Details:</b></td></tr></table>';
            content += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Director</th>';
            content += '<tbody>';
            integer SNo = 0;
           
           /* Set<String >uniqueProducts = new Set<String>();
            for(Id forId : maplist.keySet()){
                  for(Phoenix_Bid_Line_Item__c item: maplist.get(forId)){
                      uniqueProducts.add(item.Phoenix_Product__r.Name);
                  }
            }*/
            for(String forId : maplist.keySet()){
                SNo++;
                for(Phoenix_Bid_Line_Item__c item: maplist.get(forId)){
                    content += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+SNo+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+item.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+item.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
               		break;
                }
            }
            content += '</tbody></table>';
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;">To approve, modify or reject the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bidId+'">'+bidNumber+'</a>.</b></td></tr></table>';
            //List<String> ccEmailIds = new List<String>();
            System.debug('sending email');
            Boolean isFooterTextAlterRequired = false;
            System.debug('toAddress for prod disc=='+toAddress);
             System.debug('ccEmailIds for prod disc=='+ccEmailIds);
            AllEmailNotificationsSenderCls.sendEmailAlert(bidId, content, toAddress, ccEmailIds, subject, title, isFooterTextAlterRequired);
            
        }
        Catch(Exception e) {
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            System.debug('msg in product discontinuation==>'+msg);
        } 
    }
     public static void sendEmailToAllApproversforProductDiscontinuationToMktLead(String bidId,List<Phoenix_Bid_Line_Item__c> lineitems){
        try{
            map<String,list<Phoenix_Bid_Line_Item__c>> maplist = new map<String,list<Phoenix_Bid_Line_Item__c>>();
            for(Phoenix_Bid_Line_Item__c item: lineitems){
                if(maplist.containskey(item.Phoenix_Product__r.Name)){
                    List<Phoenix_Bid_Line_Item__c> templist = maplist.get(item.Phoenix_Product__r.Name);
                    tempList.add(item);
                    maplist.put(item.Phoenix_Product__r.Name,tempList);
                } else{
                    maplist.put(item.Phoenix_Product__r.Name,new List<Phoenix_Bid_Line_Item__c> {item}); 
                }
            }
            Integer lineitemsize = maplist.keySet().size();
            Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
            List < String > toAddress = new List < String > ();
        /*    for (Phoenix_Bid_Process_Steps__c step: [SELECT Id,Phoenix_Approver_Team_Members__c,Phoenix_Approver_Team__c, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email
                                                     FROM Phoenix_Bid_Process_Steps__c
                                                     WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
                                                     AND Phoenix_Bid__c =: bidId 
                                                    ]) {
                                                        if (step.Phoenix_Approver__c != null) {
                                                            // allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                                                            allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Email);
                                                            if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null){
                                                                allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);    
                                                                
                                                            }
                                                        }
                                                        Set < String > teamNames = new Set < String > ();
                                                        Set<String> emailList = new Set<String>();
                                                        if (step.Phoenix_Approver_Team_Members__c != null){
                                                            teamNames = new Set < String > (step.Phoenix_Approver_Team_Members__c.split(',')); 
                                                        }
                                                        List < User > usersList = [SELECT Id, Username, Name, Email FROM User where Name IN: teamNames];
                                                        for(User u : usersList){
                                                            emailList.add(u.Email);
                                                            allPeopleInvolvedEmailsSet.add(u.Email);
                                                         
                                                        }
                                                    }
            List < String > toAddress = new List < String > ();
            If(allPeopleInvolvedEmailsSet != null && allPeopleInvolvedEmailsSet.contains('mkalawadia@drreddys.com'))allPeopleInvolvedEmailsSet.remove('mkalawadia@drreddys.com');
            toAddress.addAll(allPeopleInvolvedEmailsSet);*/
            
            List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                  Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_Bid__c =: bidId order by Phoenix_Approval_Sent_Time__c desc];
            List<String> approvernames= new List<String>();
            String approverName ='';DateTime internalDueDateTime;String createdDate;
            String approverEmailId = '';
            for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                if(step.Phoenix_Status__c == 'In Process'){
                 //pprovernames.add(step.Phoenix_Approver__r.Name);
                }
                if(step.Phoenix_Process_Step__r.Name =='Marketing Lead Rx Approval'){
                   approvernames.add(step.Phoenix_Approver__r.Name); 
                    approverEmailId = step.Phoenix_Approver__r.Email;
                }
                    
            }
            System.debug('approvernames==>'+approvernames);
            if(approvernames != null){
                approverName = approvernames[0];
            }
            Phoenix_Bid__c bid = [select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:bidId];
            String bidNumber = bid.Name;
            String bidType = bid.Phoenix_Bid_Type__c;
            String bidName =bid.Phoenix_Bid_Name__c;
            if (bid.Phoenix_Internal_Target_Date__c != null) 
                internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));                        
            if (bid.CreatedDate != null) 
                createdDate = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
            //String bidComments = bid.Phoenix_Comments__c.replaceAll('<p>', '').replaceAll('</p>', '');
            //String bidComments = 'satya==>'+bid.Phoenix_Comments__c.replaceAll('<p>', '').replaceAll('</p>', '');
            String bidComments = bid.Phoenix_Comments__c.replaceAll('<p>', '<p style="font-size:14px;font-family:Sans-Serif;>');
            String subject = '';  String title = '';
            
            if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){    
                subject = 'Product Discontinuation Approval Request Notification';	
                title = 'Product Discontinuation Approval Request';
            }
            if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){    
                subject = 'Product Removals Approval Request Notification';	
                title = 'Product Removal Approval Request';
            }
            String content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 26px;"></td><td style="padding: 12px 8px 0px 6px;">Dear '+approverName+',</td></tr></table>';
            //String content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;">Dear '+approverName+',</td></tr>';
            if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){
                content += '<table><tr><td style="width: 26px;"></td><td style="padding: 4px 8px 8px 6px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' is requesting your approval of deactivating '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
                //content += '<tr><td style="width: 24px;"></td><td style="padding: 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">'+bid.Owner.Name+' is requesting your approval of deactivating '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
            }
            if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                content += '<table><tr><td style="width: 26px;"></td><td style="padding: 4px 8px 8px 6px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' is requesting your approval of removing '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
                //content += '<tr><td style="width: 24px;"></td><td style="padding: 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">'+bid.Owner.Name+' is requesting your approval of removing '+lineitemsize+' product(s) on a newly submitted '+bidType+' Bid.</span> </td></tr></table>';
                
            }
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 26px;"></td><td style="padding: 0px 8px 8px 6px;"><b>Bid Details:</b></td></tr></table>';
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
            content += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead>';
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th>';
            content += '<th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bidId+'">'+bidNumber+'</a></th></tr>';
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bidName+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bidType+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
            if (internalDueDateTime != null) {
                content += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
            } else{
                content += '<td style="border: 1px solid black;"></td></tr>';
            }
            content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+'Marketing Lead'+'</td></tr></thead></table></td></tr></table>';
            String created_Date = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>Bid Comments:</b></td></tr></table>';
            if(bid.Phoenix_Comments__c != null)	content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'):</td><td style="padding: 0px 8px 0px 0px;font-family: Sans-Serif;font-size: 14px;">'+bidComments+'</td></tr></table>';
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>Product Details:</b></td></tr></table>';
            content += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding: 8px;text-align:left;background-color:#d4bdf8;">Product Director</th>';
            content += '<tbody>';
            integer SNo = 0;
            for(String forId : maplist.keySet()){
              
                SNo++;
                for(Phoenix_Bid_Line_Item__c item: maplist.get(forId)){
                    content += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+SNo+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+item.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+item.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
                	break;
                }
                
            }
             content += '</tbody></table>';
            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;">To approve, modify or reject the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bidId+'">'+bidNumber+'</a>.</b></td></tr></table>';
            List<String> ccEmailIds = new List<String>();
            System.debug('sending email');
            Boolean isFooterTextAlterRequired = false;
            if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
            System.debug('toAddress test==>'+approverEmailId);
            System.debug('ccEmailIds test==>'+ccEmailIds);
            AllEmailNotificationsSenderCls.sendEmailAlert(bidId, content, toAddress, ccEmailIds, subject, title, isFooterTextAlterRequired);
            
        }
        Catch(Exception e) {
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            System.debug('msg in product discontinuation==>'+msg);
        } 
    }
}