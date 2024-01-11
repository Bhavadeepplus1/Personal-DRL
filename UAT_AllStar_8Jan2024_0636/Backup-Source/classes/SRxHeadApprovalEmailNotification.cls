public class SRxHeadApprovalEmailNotification {
    
   /*  public static void srxHeadApprovalEmailNotification(String parentRecId){
    //String parentRecId = 'a1FDL000007kJDI2A2';
    SRx_Target__c srxTargetparentRec = [SELECT Id,Name,Head_Target__c,Marketing_Head_Comments__c,SRx_Head_Comments__c,SRx_Head_Approval_Completed_Time__c,Marketing_Approver__c,SRx_Approver__c,Intial_Approver__c,CreatedBy.Name,Target_Number__c FROM SRx_Target__c WHERE Id =: parentRecId ];
   // SRx_Target__c srxTargetparentRec = [SELECT Id,Name,Head_Target__c,Marketing_Head_Comments__c,SRx_Head_Comments__c,Marketing_Approver__c,SRx_Approver__c,Intial_Approver__c,CreatedBy.Name FROM SRx_Target__c WHERE Id =: parentRecId ];
    List<Sales_Reps_Targets__c> salesRepTargetChildRecs = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE SRx_Target__c =: parentRecId];
    System.debug('salesRepTargetChildRecsSize ===>'+salesRepTargetChildRecs.Size());
    List<Sales_Reps_Targets__c> eastChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c,SRx_Target__r.Target_Number__c FROM Sales_Reps_Targets__c WHERE Region__c = 'East' AND SRx_Target__c =: parentRecId];
    List<Sales_Reps_Targets__c> westChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c,SRx_Target__r.Target_Number__c FROM Sales_Reps_Targets__c WHERE Region__c = 'West'AND  SRx_Target__c =: parentRecId];
  
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
       // String targetValue;
 		String srxTargetName = srxTargetparentRec.Name;
        String rejectionSentDateTime;
       String recName = srxTargetparentRec.Name;
        String markHead = '';
        if(srxTargetparentRec.Marketing_Approver__c != null){
           markHead = srxTargetparentRec.Marketing_Approver__c;  
        }
        else if (srxTargetparentRec.Marketing_Approver__c == null){
           markHead = '';  
 
        }
        else{
            System.debug('markHead');
        }
        
        String srxHead = srxTargetparentRec.SRx_Approver__c;
        string initialApprov;
        if(srxTargetparentRec.Intial_Approver__c != null){
           initialApprov = srxTargetparentRec.Intial_Approver__c;  
        }
        else if (srxTargetparentRec.Marketing_Approver__c == null){
           initialApprov = '';  
 
        }
        else{
            System.debug('initialApprov');
        }
        
        //subject
        dynamicSubject = 'Your Approval Required For '+srxTargetparentRec.Target_Number__c+' - '+srxTargetparentRec.Name+' ';
        //title
        dynamicTitle = 'Sales Team Target Achievement Approval Request';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   '<tr>';
        content1 +=  '<td style="width: 24px;">';
        content1 +=  '</td>';
        content1 += '<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear N/A,';
        content1 += '</td>';
        content1 += '</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;font-family: Sans-Serif;">'+srxTargetparentRec.CreatedBy.Name+' require your approval of the submitted annual target values for the entire Sales Team in '+srxTargetparentRec.Name+'<b>.</b> The values are listed below for your review<b>.</b> You\'ve been included in this process as the recognised SRx Head for the Sales Team<b>.</b></td></tr></table>';
       
            
        String targetValue;
        Decimal targetHead;
        targetHead = srxTargetparentRec.Head_Target__c ;
        targetValue = conversion(targetHead);
      
        //Annual Target Value Details Side Heading
       // content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>Annual Target Value Details:</b></td></tr></table>';
      //  content1 += '<table align="center" style="width: 15%;background-color:#d4bdf8;padding:0px;padding-bottom: 16px;"><tr><th style="font-size: 22px;font-family: Sans-Serif;padding:20px 0 0 0;">SRx Heads Target</b></th></tr><tr  style="font-size: 12px;font-family: Sans-Serif;padding:0px;"><td><center>(NAME)</center></td></tr></b><tr  style="font-size:25px;font-family: Sans-Serif;padding:20px 0 10px 0;"><td><center><b>'+targetValue+'</b></center></td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Annual Target Value Details:</td></tr></table>';
       // content1 += '<table align="center" style="width: 16%;background-color:#d4bdf8;padding:0px;padding-bottom: 16px;border-radius: 8px;"><tr><th style="font-size: 20px;font-weight:500;font-color:#2d2d2d;font-family: Sans-Serif;padding:20px 0 0 0;">SRx HEAD\'s TARGET</th></tr><tr  style="font-size: 12px;font-family: Sans-Serif;padding:0px;"><td><center>(NAME)</center></td></tr></b><tr  style="font-size:25px;font-family: Sans-Serif;padding:20px 0 10px 0;"><td><center><b>'+targetValue+'</b></center></td></tr></table>';
          content1 += '<table align="center" style="width: 16%;background-color:#d4bdf8;padding:0px;padding-bottom: 16px;border-radius: 8px;">';
        content1 +=  '<tr>';
        content1 +=			'<th style="font-size: 20px;font-weight:500;font-color:#2d2d2d;font-family: Sans-Serif;padding:20px 0 0 0;">SRx HEAD\'s TARGET</th>';
        content1 +=   '</tr>';
        content1 +=   '<tr  style="font-size: 12px;font-family: Sans-Serif;padding:0px;">';
       // content1 +=     	'<td><center>(NAME)</center></td>';
        content1 +=   '</tr>';
       // content1 +=    '</b>';
        content1 +=    '<tr  style="font-size:25px;font-family: Sans-Serif;padding:20px 0 10px 0;">';
        content1 +=        '<td>';
        content1 +=      	'<center>';
       // content1 +=    		'<b>';
        content1 +=    	 ' <b>'+targetValue+'</b>';
       // content1 += 	    '</b>';
        content1 +=  	    '</center>';
        content1 +=        '</td>';
        content1 +=   '</tr>';
        content1 +=  '</table>';
        
        
         // Table container start
         content1 += '<table style="width: 100%;font-size: 14px; font-family: Sans-Serif;">';
       content1 += '<tr>';
       content1 += '<td style="width: 48%; padding: 20px 0px 8px 38px;font-size:16px;font-weight:500; color:#000000;">';
       content1 += 'Eric Sutherland\'s East Target Values';
       content1 += '</td>';
       content1 += '<td style="width: 48%; padding: 20px 0px 8px 38px;font-size:16px;font-weight:500;color:#000000;">';
       content1 += 'Dave Smith\'s West Target Values';
       content1 += '</td>';
       content1 += '</tr>';
       content1 += '</table>';


       content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 50%;">';   //left table start                         
        content1 += '<table align="left" style="width: 90%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;height: 20px;"></th><th style="height: 20px;text-align:center;background-color:#d4bdf8;border-bottom:1px solid #ddd;border-top:0.1px solid;border-left:1px solid;padding-top: 5px;padding-bottom: 5px; border-right: 1px solid;border-color:#ddd;">S No.</th>';
        content1 += '<th style="height: 20px;text-align:left;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;padding-left:10px;background-color:#d4bdf8;border-color:#ddd;">Name</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 1</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 2</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 3</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 4</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right:1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Annual</th></tr></thead>';
        integer i = 1;
        for (Sales_Reps_Targets__c lineItem: eastChildRecords) {
            String formattedQuarter1;
            Decimal quart1;
            quart1 = lineItem.Quarter_1__c;
            formattedQuarter1 =  conversion(quart1);
          
            String formattedQuarter2;
            Decimal quart2;
            quart2 = lineItem.Quarter_2__c;
            formattedQuarter2 =  conversion(quart2);
           
            String formattedQuarter3;
            Decimal quart3;
            quart3 = lineItem.Quarter_3__c;
            formattedQuarter3 =  conversion(quart3);
           
            
            String formattedQuarter4;
            Decimal quart4;
            quart4 = lineItem.Quarter_4__c;
            formattedQuarter4 =  conversion(quart4);
           
                     
            String formattedAnnual;
            Decimal annual;
            annual = lineItem.Annual__c;
            formattedAnnual =  conversion(annual);
           
           
         content1 += '<tbody>';
            content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-bottom:1px solid;border-left:1px solid;border-color:#ddd;text-align:center; border-right: 1px solid #ddd;">'+i+' </td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:left;border-color:#ddd">'+lineItem.User_Name__c+'</td>';
            
            content1 += '<td style="height: 20px; padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter1+'</td>';   
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter2+'</td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter3+'</td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter4+'</td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right:1px solid;text-align:center;border-color:#ddd">'+formattedAnnual+'</td></tr>';
            i++;
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
        
        // Add space between tables
        content1 += '<td style="width:0%;"></td>';
        
        
        //content1 += '<table style="min-width: 50%;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 50%;">';   //right table start                         
        //content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:200px 10px 10px 10px;"><b>Dave Smith West Target Values</b></td></tr></table>';
        content1 += '<td style="width: 50%;height: 20px;">';
      //  content1 += '<table align="left" style="width: 90%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;height: 20px;"></th><th style="text-align:center;border-bottom:1px solid #4E19DE;border-top:0.1px solid;border-left:1px solid;padding-top: 5px;padding-bottom: 5px;height: 20px;background-color:#d4bdf8;">S No.</th>';
        //content1 += '<th style="width: 36px;height: 20px;"></th><th style="text-align:center;color:#BAB7C1;border-bottom:1px solid #4E19DE;border-top:1px solid;border-left:1px solid;padding-top: 5px;padding-bottom: 5px;height: 20px;">S No.</th>';
       content1 += '<table align="left" style="width: 90%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;height: 20px;"></th><th style="height: 20px;text-align:center;background-color:#d4bdf8;border-bottom:1px solid #ddd;border-top:0.1px solid;border-left:1px solid;padding-top: 5px;padding-bottom: 5px; border-right: 1px solid;border-color:#ddd;">S No.</th>';
        content1 += '<th style="height: 20px;text-align:left;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;padding-left:10px;background-color:#d4bdf8;border-color:#ddd;">Name</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 1</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 2</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 3</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right: 1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Quarter 4</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:0.1px solid;border-right:1px solid;padding-top: 5px;padding-bottom: 5px;background-color:#d4bdf8;border-color:#ddd;">Annual</th></tr></thead>';
        integer j = 1;
        for (Sales_Reps_Targets__c lineItem	: westChildRecords) {
            String formattedQuarter1;
            Decimal quart1;
            quart1 = lineItem.Quarter_1__c;
            formattedQuarter1 =  conversion(quart1);
          
            String formattedQuarter2;
            Decimal quart2;
            quart2 = lineItem.Quarter_2__c;
            formattedQuarter2 =  conversion(quart2);
           
            String formattedQuarter3;
            Decimal quart3;
            quart3 = lineItem.Quarter_3__c;
            formattedQuarter3 =  conversion(quart3);
           
            
            String formattedQuarter4;
            Decimal quart4;
            quart4 = lineItem.Quarter_4__c;
            formattedQuarter4 =  conversion(quart4);
           
                     
            String formattedAnnual;
            Decimal annual;
            annual = lineItem.Annual__c;
            formattedAnnual =  conversion(annual);
              
            content1 += '<tbody>';
              content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-bottom:1px solid;border-left:1px solid;border-color:#ddd;text-align:center; border-right: 1px solid #ddd;">'+j+' </td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:left;border-color:#ddd">'+lineItem.User_Name__c+'</td>';
            
            content1 += '<td style="height: 20px; padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter1+'</td>';   
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter2+'</td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter3+'</td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right: 1px solid;text-align:center;border-color:#ddd">'+formattedQuarter4+'</td>';
            content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid;border-right:1px solid;text-align:center;border-color:#ddd">'+formattedAnnual+'</td></tr>';
            j++;
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
        
    
        // Close the table container
        content1 += '</tr></table>';



      //  content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve or reject the Annual Target Values,refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+parentRecId+'">Target Achievement HyperLink</a></b>.</td></tr>';
	   //content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;font-family: Sans-Serif;">To approve or reject the Annual Target Values,refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+parentRecId+'">&nbsp;'+srxTargetparentRec.Name+'</a></b>. </td></tr></table>';
        
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;font-family: Sans-Serif;">To approve or reject the Annual Target Values, refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker'+'">&nbsp;'+srxTargetparentRec.Name+'</a></b><b>.</b> </td></tr></table>'; 
        
       List<String> l1 = new List<String>();
       List<String> l2 = new List<String>();
       testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);

    
        //AllEmailNotificationsSenderCls.sendEmailAlert(parentRecId, content1, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
        // AllEmailNotificationsSenderCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
/* public static void salesRepTargetData(String parentRecId){
    //String parentRecId = 'a1FDL000007kJBq2AM';
    List<SRx_Target__c> srxTargetparentRec = [SELECT Id,Name FROM SRx_Target__c];
    List<Sales_Reps_Targets__c> salesRepTargetChildRecs = [SELECT Id,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE SRx_Target__c =: parentRecId];
    System.debug('salesRepTargetChildRecsSize ===>'+salesRepTargetChildRecs.Size());
    List<Sales_Reps_Targets__c> eastChildRecords = [SELECT Id,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'East' AND SRx_Target__c =: parentRecId];
    List<Sales_Reps_Targets__c> westChildRecords = [SELECT Id,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'West'AND  SRx_Target__c =: parentRecId];
  
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
    
        //subject
        dynamicSubject = 'Test Your Approval Required for Sales Team Target Achievement Approval Request';
        //title
        dynamicTitle = 'Sales Team Target Achievement Approval Request';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">Dear <SRx Head Name>,</td></tr></table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;"><RSMs First and Lastnames> require your approval of the submitted annual target values for the entire Sales Team in <Target Value Name>.The values are listed below for your review.You have been included in this process as the recognised SRx Head for the Sales Team.</td></tr></table>';

        //Annual Target Value Details Side Heading
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>Annual Target Value Details:</b></td></tr></table>';
        content1 += '<table align="center" style="background-color:#d4bdf8;padding:20px;"><tr><th style="font-size: 18px;font-family: Sans-Serif;">SRX Heads Target</b></th></tr><tr  style="font-size: 12px;font-family: Sans-Serif;"><center>(NAME)</center></tr></table>';
     
        // Table container start
        content1 += '<br/><br/><br/><table style="width: 100%;"><tr>';
      //content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">East Target Values</td></tr></table>';
        // Left table (eastChildRecords)
      //content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">East Target Values</td></tr></table>';
        content1 += '<td style="width: 35%; padding-right: 5%;padding-left: 2.5%;"><table style="width: 100%;font-size: 14px;font-family: Sans-Serif;border-spacing:0;">';
        content1 += '<tr><td colspan="7" style="text-align:center;padding: 8px;font-weight:bold;">East Target Values</td></tr>'; // Statement added

        content1 += '<tr><th style="text-align:center;color:#BAB7C1;border-bottom:1px solid #4E19DE;border-top:1px solid;border-left:1px solid;padding-top: 5px;padding-bottom: 5px;">S No.</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Name</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 1</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 2</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 3</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 4</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;border-right:1px solid;padding-top: 5px;padding-bottom: 5px;">Annual</th></tr>';
        integer i = 1;
        for (Sales_Reps_Targets__c lineItem: eastChildRecords) {
        content1 += '<tr ><td style="padding: 8px;border-bottom:1px solid;border-left:1px solid;border-color:#512888;">'+i+' </td>';
        content1 += '<td style="padding: 8px;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem.Name+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem.Quarter_1__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem.Quarter_2__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem.Quarter_3__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem.Quarter_4__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-right:1px solid;border-color:#4E19DE;">'+lineItem.Annual__c+'</td></tr>';
      
            i++;
        }
        
         content1 += '</table></td>'; // Close the left table cell      
        
        // Add space between tables
        content1 += '<td style="width: 1%;"></td>';
        
        
        
        // Right table (westChildRecords)
        content1 += '<td style="width: 35%; padding-right: 5%;padding-left: 2.5%;"><table style="width: 100%;font-size: 14px;font-family: Sans-Serif;border-spacing:0;">';
        content1 += '<tr><td colspan="7" style="text-align:center;padding: 8px;font-weight:bold;">West Target Values</td></tr>'; // Statement added
        content1 += '<tr><th style="text-align:center;color:#BAB7C1;border-bottom:1px solid #4E19DE;border-top:1px solid;border-left:1px solid;padding-top: 5px;padding-bottom: 5px;">S No.</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Name</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 1</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 2</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 3</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;padding-top: 5px;padding-bottom: 5px;">Quarter 4</th>';
        content1 += '<th style="color:#BAB7C1;text-align:center;border-bottom:1px solid #4E19DE;border-top:1px solid;border-right:1px solid;padding-top: 5px;padding-bottom: 5px;">Annual</th></tr>';
        integer j = 1;
        for (Sales_Reps_Targets__c lineItem2: westChildRecords) {
        content1 += '<tr ><td style="padding: 8px;border-bottom:1px solid;border-left:1px solid;border-color:#512888;">'+j+' </td>';
        content1 += '<td style="padding: 8px;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem2.Name+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem2.Quarter_1__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem2.Quarter_2__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem2.Quarter_3__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-color:#4E19DE;">'+lineItem2.Quarter_4__c+'</td>';
        content1 += '<td style="padding: 8px;background-color:#D0C7E9;border-bottom:1px solid;border-right:1px solid;border-color:#4E19DE;">'+lineItem2.Annual__c+'</td></tr>';
      
            j++;
        }
        
         content1 += '</table></td>'; // Close the right table cell  
        
    
        // Close the table container
        content1 += '</tr></table>';

      //  content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve or reject the Annual Target Values,refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+parentRecId+'">Target Achievement HyperLink</a></b>.</td></tr>';
	   content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">To approve or reject the Annual Target Values,refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+parentRecId+'"> &nbsp;Target Achievement HyperLink</a></b>. </td></tr></table>';
        
        
        
        
    
        AllEmailNotificationsSenderCls.sendEmailAlert(parentRecId, content1, new List<String> {'naseershaik@drreddys.com'}, new List<String> {'naseershaik@drreddys.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }*/
}