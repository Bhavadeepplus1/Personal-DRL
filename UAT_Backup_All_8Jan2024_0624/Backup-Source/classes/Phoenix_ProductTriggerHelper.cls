public with sharing class Phoenix_ProductTriggerHelper {
    List<Product2> newproductList;
    
    public Phoenix_ProductTriggerHelper(List<Product2> productList){
        newproductList=productList;
    }        
    public void updateProdFamilyStatus(){
        set<Id>productFamilyIds=new set<Id>();
        for(Product2 prod:newproductList){
            productFamilyIds.add(prod.Product_Family__c);   
        }
        list<Product_Family__c>familyRefords=[select Id,Vision_IsActive__c ,(select Id,Product_Family__c,IsActive from Products__r where IsActive=true) from Product_Family__c where Id IN:productFamilyIds];
        for(Product_Family__c pf:familyRefords){
            if(pf.Products__r.size()>=1)
                pf.Vision_IsActive__c=true;  
            else
                pf.Vision_IsActive__c=false; 
        }
        if(familyRefords.size()>0)
            update familyRefords;
    }
    
}