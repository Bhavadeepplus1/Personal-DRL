@isTest
public class Vision_IDNChargeBackClsTest {
    @isTest public static void testMethod1(){
         account acc1 = new account(name = 'acc1');
        List<IDN_Charge_Back_Hospital_Summary__c> chargebackrecList = new List<IDN_Charge_Back_Hospital_Summary__c>();
        IDN_Charge_Back_Hospital_Summary__c rec1 = new  IDN_Charge_Back_Hospital_Summary__c();
       rec1.Account__c = '0011K00002UrWG9QAN';
        rec1.Hospital_Name__c = 'University of Wisconsin Health (AKA UW Health)';
        rec1.Child1__c = 'University Hospital';
        rec1.Child_2__c = 'None';
       	rec1.Sales_Rep_Territory__c = 'Zack McClard';
        rec1.Region__c = 'West';
        rec1.Category__c = 'GPO';
        rec1.revised_product_family__c = 'Thiotepa';
        rec1.material_description__c = 'Thiotepa For Injection 100mg/Vial 1s USA';
        rec1.Contact_Description__c = 'RCA-N';
        chargebackrecList.add(rec1);
        
        User u = new User(Alias = 'satya', Email= 'satyakalyala@drreddys.com', 
          EmailEncodingKey='UTF-8', LastName='Satya', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US',  
          TimeZoneSidKey='America/New_York', UserName= 'satyakalyala@drreddys.com');      
        
        String salesTerritory = 'Zack McClard';
        String userRegion = 'West';
        List<String> userRegion1 = new List<String>();userRegion1.add('West');
        list<string> hospitalName = new list<string>() ;hospitalName.add('University of Wisconsin Health (AKA UW Health)');
        string hospitalName1= 'University of Wisconsin Health (AKA UW Health)';
        list<string>   userCategory = new list<string>() ;userCategory.add('GPO');
        string userCategory1='GPO';
        String child1Name = 'University Hospital';
       list<string> productFamily =new list<string>(); productFamily.add('Thiotepa');
          list<string> productDescription = new list<string>();productDescription.add('Thiotepa For Injection 100mg/Vial 1s USA');
        String accountId = '0011K00002RDkucQAD';
        List<String> contractDescription = new List<String>();
        contractDescription.add('RCA-N');
        contractDescription.add('MCKESSON (SSF) OS ACUTE/LTC');
        List<String> selectedMemberState = new List<String>();
        List<String> selectedMemberCity = new List<String>();
          List<String> submitterName = new list<string>();
        // Vision_IDNChargeBackCls.codeCoverageBlock();
        Vision_IDNChargeBackCls.getContrcts('RCN','005410000054MzeAAE');
        Vision_IDNChargeBackCls.getsubmitters('005410000054MzeAAE');
        Vision_IDNChargeBackCls.getmemberstate('005410000054MzeAAE');
        Vision_IDNChargeBackCls.getmembericty('005410000054MzeAAE');
        Vision_IDNChargeBackCls.getuser();
        Vision_IDNChargeBackCls.getRegion('005410000054MzeAAE');
        Vision_IDNChargeBackCls.getcategory('005410000054MzeAAE');
        Vision_IDNChargeBackCls.getHospitalNames('005410000054MzeAAE');
        Vision_IDNChargeBackCls.getProductNames('005410000054MzeAAE');
        Vision_IDNChargeBackCls.getProducts('005410000054MzeAAE');
       Vision_IDNChargeBackCls.getDataIndividual('005410000054MzeAAE',userRegion1,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
       Vision_IDNChargeBackCls.getDatafromLastLevBatch('005410000054MzeAAE',userRegion1,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackCls.getData('005410000054MzeAAE',userRegion,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackCls.gettwmonthsFullData('005410000054MzeAAE',userRegion,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackCls.getAllTotals('005410000054MzeAAE',userRegion1,userCategory,hospitalName1,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackCls.getAllTotalsforIndividual('005410000054MzeAAE',userRegion1,userCategory,hospitalName1,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
         Vision_IDNChargeBackCls.getAllTotalsforChilds('005410000054MzeAAE',userRegion,userCategory,hospitalName1,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);

        //Vision_IDNChargeBackCls.getprevsixMonthsData('005410000054MzeAAE',userRegion,userCategory1,hospitalName1,child1Name,'None',productFamily[0],productDescription[0],accountId,contractDescription);
       //Vision_IDNChargeBackCls.getAllTotalsMain('005410000054MzeAAE',userRegion,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
          //   Vision_IDNChargeBackCls.getAllTotalsMain('005410000054MzeAAE',userRegion,userCategory,hospitalName1,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        // Vision_IDNChargeBackCls.getAllTotalsMain('005410000054MzeAAE',userRegion,userCategory1,hospitalName1,child1Name,'None',productFamily[0],productDescription[0],accountId,contractDescription);
        Vision_IDNChargeBackHir3Cls.getRegion('005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getsubmitters('005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getmemberstate('005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getmembericty('005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getuser();
       
        Vision_IDNChargeBackHir3Cls.getcategory('005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getHospitalNames('005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getProductNames('005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getProducts('005410000054MzeAAE');
       Vision_IDNChargeBackHir3Cls.getContrcts('RCA-N','005410000054MzeAAE');
        Vision_IDNChargeBackHir3Cls.getDatafromLastLevBatch('005410000054MzeAAE',userRegion1,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackHir3Cls.gettwmonthsFullData('005410000054MzeAAE',userRegion,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackHir3Cls.getAllTotals('005410000054MzeAAE',userRegion1,userCategory,hospitalName1,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackHir3Cls.getAllTotalsforIndividual('005410000054MzeAAE',userRegion1,userCategory,'test1',hospitalName1,child1Name,'None',productFamily,productDescription,contractDescription,selectedMemberState,selectedMemberCity,submitterName);

        Vision_IDNChargeBackHir3Cls.getprevsixMonthsData('005410000054MzeAAE',userRegion,userCategory1,hospitalName1,child1Name,'None',productFamily[0],productDescription[0],accountId,contractDescription);
    
         /*for class 2*/
        Vision_IDNChargeBackClsHir2.getsubmitters('005410000054MzeAAE');
          Vision_IDNChargeBackClsHir2.getContrcts('RCA-N','005410000054MzeAAE');
        Vision_IDNChargeBackClsHir2.getmemberstate('005410000054MzeAAE');
        Vision_IDNChargeBackClsHir2.getmembericty('005410000054MzeAAE');
        Vision_IDNChargeBackClsHir2.getuser();
       Vision_IDNChargeBackClsHir2.getRegion('005410000054MzeAAE');
        Vision_IDNChargeBackClsHir2.getcategory('005410000054MzeAAE');
        Vision_IDNChargeBackClsHir2.getHospitalNames('005410000054MzeAAE');
        Vision_IDNChargeBackClsHir2.getProductNames('005410000054MzeAAE');
        Vision_IDNChargeBackClsHir2.getProducts('005410000054MzeAAE');
     //  Vision_IDNChargeBackClsHir2.getAllTotalsforIndividual('005410000054MzeAAE',userRegion,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
        Vision_IDNChargeBackClsHir2.getDatafromTab2SummaryBatch('005410000054MzeAAE',userRegion1,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
            Vision_IDNChargeBackClsHir2.gettwmonthsFullData('005410000054MzeAAE',userRegion,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
      //  Vision_IDNChargeBackClsHir2.gettwmonthsFullData
       // Vision_IDNChargeBackClsHir2.getHospitalNames();
    //    Vision_IDNChargeBackClsHir2.getData('005410000054MzeAAE',userRegion1,userCategory,hospitalName,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
       Vision_IDNChargeBackClsHir2.getAllTotals('005410000054MzeAAE',userRegion1,userCategory,hospitalName1,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);
       Vision_IDNChargeBackClsHir2.getAllTotalsforIndividual('005410000054MzeAAE',userRegion1,userCategory,hospitalName1,child1Name,'None',productFamily,productDescription,accountId,contractDescription,selectedMemberState,selectedMemberCity,submitterName);

        Vision_IDNChargeBackClsHir2.getprevsixMonthsData('005410000054MzeAAE',userRegion,userCategory1,hospitalName1,child1Name,'None',productFamily[0],productDescription[0],accountId,contractDescription);
    
    
    }

}