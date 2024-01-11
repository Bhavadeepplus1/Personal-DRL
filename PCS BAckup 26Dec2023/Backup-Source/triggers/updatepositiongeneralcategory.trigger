trigger updatepositiongeneralcategory on Vision_Customer_Product_Tracker__c (before insert,before update) {
    //list<Vision_Customer_Product_Tracker__c> prodposition =trigger.new;
    map<string,string> prodpositionmap=new map<string,string>();
    for(Phoenix_Product_Position__c prodposition:[select Name,Phoenix_General_Category__c from Phoenix_Product_Position__c]){
        if(prodposition.Phoenix_General_Category__c!=null){
            //system.debug('prodposition...'+prodposition.name.tolowercase().trim());
        prodpositionmap.put(prodposition.name.tolowercase().trim(),prodposition.Phoenix_General_Category__c);
        }
    } 
    for(Vision_Customer_Product_Tracker__c cptrec:trigger.new){
        if(cptrec.Vision_Current_Product_Position__c!=null){
           // system.debug('cptposition.......'+cptrec.Vision_Current_Product_Position__c.tolowercase().trim());
        if(prodpositionmap.containskey(cptrec.Vision_Current_Product_Position__c.tolowercase().trim())){
            //system.debug('enteered...'+prodpositionmap.get(cptrec.Vision_Current_Product_Position__c.tolowercase().trim()));
            
            cptrec.General_Category__c=prodpositionmap.get(cptrec.Vision_Current_Product_Position__c.tolowercase().trim());
           
        }
            else if(cptrec.Vision_Current_Product_Position__c.tolowercase().trim().contains('secondary')){
                
               cptrec.General_Category__c=prodpositionmap.get('secondary');
                
            }
             else if(cptrec.Vision_Current_Product_Position__c.tolowercase().trim().contains('primary')){
                
               cptrec.General_Category__c=prodpositionmap.get('primary');
                
            }
             else if(cptrec.Vision_Current_Product_Position__c.tolowercase().trim().contains('multi')){
                
               cptrec.General_Category__c=prodpositionmap.get('secondary');
                
            }
          
        }
    }

}