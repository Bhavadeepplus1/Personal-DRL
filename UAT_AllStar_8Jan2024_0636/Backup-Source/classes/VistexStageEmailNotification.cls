public class VistexStageEmailNotification {
    //This method is for gnerating email when a Srx IPA or RCA Member Addition Bid entered into Vistex Update stage
    public static void vistexEmailNotification(String bidId){
        
        Phoenix_Bid__c bid = [SELECT Id, Name, Owner.Name, Phoenix_Bid_Name__c, Phoenix_Comments__c, Phoenix_Approval_Status__c, Phoenix_Bid_Owner__r.Name, Phoenix_Customer__r.Name, Phoenix_Bid_Type__c,Phoenix_Internal_Target_Date__c, CreatedDate, Phoenix_RCA_Change_Date__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        List <Phoenix_RCA_IPA_LINE__c> ipaLineItems = [SELECT Id, Phoenix_Customer__r.Name FROM Phoenix_RCA_IPA_LINE__c Where Phoenix_Bid__c =: bid.Id];
        string content1 = ''; string dynamicSubject = ''; string dynamicTitle = ''; string customerString = ''; boolean alterRequired = false;
        String custName = bid.Phoenix_Customer__r.Name;

        DateTime createdDate; DateTime internalTarget; DateTime rcaChangeDate;
        if (bid.Phoenix_Internal_Target_Date__c != null) 
            internalTarget = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
        if (bid.CreatedDate != null) 
            createdDate = DateTime.newInstance(date.newinstance(bid.CreatedDate.year(), bid.CreatedDate.month(), bid.CreatedDate.day()), Time.newInstance(0, 0, 0, 0));
        if (bid.Phoenix_RCA_Change_Date__c != null) 
            rcaChangeDate = DateTime.newInstance(date.newinstance(bid.Phoenix_RCA_Change_Date__c.year(), bid.Phoenix_RCA_Change_Date__c.month(), bid.Phoenix_RCA_Change_Date__c.day()), Time.newInstance(0, 0, 0, 0));
        String bidComments = '';
        if(bid.Phoenix_Comments__c != null && bid.Phoenix_Comments__c != '') {
            bidComments = bid.Phoenix_Comments__c.replaceAll('<p>', '').replaceAll('</p>', '');
        }
        //subject
       // dynamicSubject = 'Your Update Required for SRx '+bid.Phoenix_Bid_Type__c+' - ' +bid.Name+ '-' +custName;
         dynamicSubject = 'Your Update Required for SRx '+bid.Phoenix_Bid_Type__c+' - ' +bid.Name;
        //title
        dynamicTitle = 'VISTEX Update Request';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;font-family: Sans-Serif;">Dear VISTEX Team,</td></tr></table>';
        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-size: 14px;font-family: Sans-Serif;">'+bid.Phoenix_Bid_Owner__r.Name+' submitted a SRx '+bid.Phoenix_Bid_Type__c+' Bid ('+bid.Name+') which has completed the bid approval workflow. Please make sure the customer details are updated in VISTEX.</td></tr> </table>';
        
        //Bid Details Side Heading
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>Bid Details:</b></td></tr></table>';
        //Bid Details Table, modify as you need
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">SRx '+bid.Phoenix_Bid_Type__c+'</td></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Change Date</th>';
        if(rcaChangeDate != null)	content1 += '<td style="border: 1px solid black;padding: 8px;">'+rcaChangeDate.format('MMM d yyyy')+'</td></tr>';
        else content1 += '<td style="border: 1px solid black;padding: 8px;"></td></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Target Date</th>';
        if(internalTarget != null)	content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalTarget.format('MMM d yyyy')+'</td></tr></thead></table>';
        else content1 += '<td style="border: 1px solid black;padding: 8px;"></td></tr></thead></table>';
        content1 += '</td></tr></table>';
        //Bid Details Table End
        
        //Bid Comments Side Heading
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>Bid Comments:</b></td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 4px 0px 4px 8px;">'+bid.Owner.Name+' ('+createdDate+') : ';
        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
        else content1 += '</td></tr></table>';
        
        //Customer Details Table Start
        customerString = '';
        customerString += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Customer</th>';
        customerString += '<tbody>';
        
        integer i = 1;
        for (Phoenix_RCA_IPA_LINE__c lineItem: ipaLineItems) {
            customerString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;padding:8px;">'+lineItem.Phoenix_Customer__r.Name+'</td></tr>';
            i++;
        }
        customerString += '</tbody></table>';
        //Customer Details Table End
        //Customer Details Side Heading
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>Customer Details:</b></td></tr></table>';
        content1 += customerString;
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To view the bid information,refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b><b>.</b></td></tr>';
        content1 += '</table>';
        alterRequired = false;
        AllEmailNotificationsSenderCls.sendEmailAlert(bid.Id, content1, new List<String> {'naseershaik@drreddys.com'}, new List<String> {'naseershaik@drreddys.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }    
   }