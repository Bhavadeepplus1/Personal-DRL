@RestResource(urlMapping='/OrderJobRunningStatus/*')

global class PrismOrderJobRunningStatus_REST {

    @HttpPost
    global static string dopost(string status) {
        
        Order_Job_Status__c jobstatus = Order_Job_Status__c.getinstance('Data1');
        string state='';
        if(status=='Running'){
            jobstatus.Is_Job_Running__c=true;
            state='Job Status Updated as Running';
          }
        else if(status=='Completed'){
           jobstatus.Is_Job_Running__c=false; 
            state='Job Status Updated as Completed';
        }
        update jobstatus;
        return state;
       
        
        
    }
    
    
    
}