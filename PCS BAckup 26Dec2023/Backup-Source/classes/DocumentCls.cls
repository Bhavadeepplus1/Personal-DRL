public class DocumentCls {
    public List < Product_Pipeline__c > lineItemsRX {
        get;
        set;
    }
    public List < Product_Pipeline__c > lineItemsSRX {
        get;
        set;
    }
    public List < Product_Pipeline__c > lineItemsOTC {
        get;
        set;
    }
    public List < Product_Pipeline__c > lineItemsSpecialty {
        get;
        set;
    }
   public List < Product_Pipeline__c > pplist {
        get;
        set;
    }
    public string ids {
        get;
        set;
    }
    public  Map<string, List < Product_Pipeline__c >> itemsOTCMap {
        get;
        set;
    }
    public Integer SizeOfMap { get { return itemsOTCMap.size(); } } 
    
 /*   public List < Account > accList { get;set; }
   
    public String DosageColumn {
        get;
        set;
    }
    public String SegmentColumn {
        get;
        set;
    }
    public String StrengthColumn {
        get;
        set;
    }
    public String SizeColumn {
        get;
        set;
    }
    public String ReferenceBrandColumn {
        get;
        set;
    }
    public String LaunchMonthColumn {
        get;
        set;
    }
    public String LaunchQtrColumn {
        get;
        set;
    }
    public String LaunchTypeColumn {
        get;
        set;
    }
    public String APIVIColumn {
        get;
        set;
    }
    public String commentsColumn {
        get;
        set;
    }
    public String GPIColumn {
        get;
        set;
    }
    public String GCNColumn {
        get;
        set;
    }
     public Account acc {
        get;
        set;
    }*/
    public void DocumentCls(){
        
        //try {
      //  String currentUserId = userInfo.getUserId();
       // userList = [SELECT Name from User WHERE id =: currentUserId ];
             //String pipIdsStr = Apexpages.CurrentPage().getParameters().get(ppList); 
       
         ids = Apexpages.CurrentPage().getParameters().get('id');
        
        String pipIdsStr2 = Apexpages.CurrentPage().getParameters().get('pplist');
         
       // String pipIdsStr = VisionProductPipelineCls.generateDocument(pplist);
        //string fileName = 'Product Pipeline '+Datetime.now().format('MM.dd.yyyy hh:mm:ss a')+'.pdf';
         //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + fileName);

      /*  DosageColumn = Apexpages.CurrentPage().getParameters().get('Dosage');  
        StrengthColumn = Apexpages.CurrentPage().getParameters().get('strength');  
        SizeColumn = Apexpages.CurrentPage().getParameters().get('size');  
        ReferenceBrandColumn = Apexpages.CurrentPage().getParameters().get('referenceBrand');  
        LaunchQtrColumn = Apexpages.CurrentPage().getParameters().get('launchQtr');  
        LaunchTypeColumn = Apexpages.CurrentPage().getParameters().get('launchType');  
        APIVIColumn = Apexpages.CurrentPage().getParameters().get('APIVI');  
        commentsColumn = Apexpages.CurrentPage().getParameters().get('comments');  
         GPIColumn = Apexpages.CurrentPage().getParameters().get('GPI');  
        GCNColumn = Apexpages.CurrentPage().getParameters().get('GCN');  */
        //  Map<String,String> headersMap = Apexpages.CurrentPage().getHeaders();
       List<id> setIds = new List<id>();
        if(ids != null)         setIds=ids.split(',');
        
        lineItemsRX=[select Id,Vision_GCP_Product_Family__c,Vision_Generic_Name__c,Vision_Segment__c,Vision_Potential_Launch_date__c,GCP_Launch_Year__c,Vision_Strength__c,Vision_Size__c,Vision_Launch_Month__c,Vision_Launch_Year1__c,Vision_Dosage_Form__c,Vision_Reference_Brand__c,Vision_Launch_Qtr__c,Vision_Api_Vertically_Integrated__c,Vision_Comments__c,Vision_Launch_Type__c,Vision_GPI__c,Vision_GCN__c from Product_Pipeline__c where Id=:setIds AND  Vision_Segment__c ='RX'];
        lineItemsSRX=[select Id,Vision_GCP_Product_Family__c,Vision_Generic_Name__c,Vision_Segment__c,Vision_Potential_Launch_date__c,GCP_Launch_Year__c,Vision_Strength__c,Vision_Size__c,Vision_Launch_Month__c,Vision_Launch_Year1__c,Vision_Dosage_Form__c,Vision_Reference_Brand__c,Vision_Launch_Qtr__c,Vision_Api_Vertically_Integrated__c,Vision_Comments__c,Vision_Launch_Type__c,Vision_GPI__c,Vision_GCN__c from Product_Pipeline__c where Id=:setIds AND Vision_Segment__c ='SRX' ];
        lineItemsSpecialty=[select Id,Vision_GCP_Product_Family__c,Vision_Generic_Name__c,Vision_Segment__c,Vision_Potential_Launch_date__c,GCP_Launch_Year__c,Vision_Strength__c,Vision_Size__c,Vision_Launch_Month__c,Vision_Launch_Year1__c,Vision_Dosage_Form__c,Vision_Reference_Brand__c,Vision_Launch_Qtr__c,Vision_Api_Vertically_Integrated__c,Vision_Comments__c,Vision_Launch_Type__c,Vision_GPI__c,Vision_GCN__c from Product_Pipeline__c where Id=:setIds AND Vision_Segment__c ='Specialty'];
        itemsOTCMap = new Map<string,List < Product_Pipeline__c >>();
        lineItemsOTC=[select Id,Vision_Therapeutic_Area__c, Vision_GCP_Product_Family__c,Vision_Generic_Name__c,Vision_Segment__c,Vision_Potential_Launch_date__c,GCP_Launch_Year__c,Vision_Strength__c,Vision_Size__c,Vision_Launch_Month__c,Vision_Launch_Year1__c,Vision_Dosage_Form__c,Vision_Reference_Brand__c,Vision_Launch_Qtr__c,Vision_Api_Vertically_Integrated__c,Vision_Comments__c,Vision_Launch_Type__c,Vision_GPI__c,Vision_GCN__c from Product_Pipeline__c where Id=:setIds AND Vision_Segment__c ='OTC'];
        if(Test.isRunningTest()){
           itemsOTCMap.put('Vision_Therapeutic_Area__c', lineItemsOTC); 
        }
        for(Product_Pipeline__c item: lineItemsOTC){
        if(itemsOTCMap.containsKey(item.Vision_Therapeutic_Area__c)){                List<Product_Pipeline__c> sdList = itemsOTCMap.get(item.Vision_Therapeutic_Area__c);                sdList.add(item);                itemsOTCMap.put(item.Vision_Therapeutic_Area__c,sdList);
            }
            else{
                itemsOTCMap.put(item.Vision_Therapeutic_Area__c,new List<Product_Pipeline__c>{item});
            }
             
        }
       
          //if(accId != null)
        //acc=[select Id,Name,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet from Account where Id=:accId];
       
        //lineItems = (List<Product_Pipeline__c>)JSON.deserialize(pipIdsStr,List<Product_Pipeline__c>.class);
      
        //}
        //Catch(Exception e) {
        //   Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
        //   insert exp;
        //}
 
    }
  
}