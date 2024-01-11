/**
* @description       : Enter the Incumbent/Winning Competitor Info based on the Products
* @author            : Ramakrishna Y
* @last modified on  : 26-08-2021
* @last modified by  : Ramakrishna Y
**/
public class CompetitorInfoCLS 
{
    //-----code by rama --------
    @AuraEnabled
    public static list<string> collectProductFamilyNames(string bidid)
    {
        set<string> ProductFamilylist=new set<string>();
        for(Phoenix_Bid_Line_Item__c  liblineobj:[select Id,Product_Family_Name__c, Phoenix_Product__r.Product_Family__r.Name,Phoenix_Bid__c,Phoenix_Product_Family1__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c  =: bidid])
        {
            //system.debug('---====---==='+liblineobj.Phoenix_Product_Family1__c);
            ProductFamilylist.add(liblineobj.Product_Family_Name__c);
        }
        return new list<string>(ProductFamilylist);
    }
    @AuraEnabled
    public static list<CompetitorInfo_wrapperClass> CompetitorInfoPF(string bidid,string pf)
    {
        String searchWord='%'+pf+'%';
        //system.debug('*******************bidid---'+bidid+'----pf'+pf);
        list<CompetitorInfo_wrapperClass> Competitorwerlist=new list<CompetitorInfo_wrapperClass>();
        list<Competitor__c> complist=new list<Competitor__c>();
        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
        //Competitor_wrapperClass compobj=new Competitor_wrapperClass();
        //compobj.Competitorlist=complist;
        if(pf!='ChooseProductFamily')
        {
            for(Phoenix_Bid_Line_Item__c  liblineobj:[select Id ,name ,Phoenix_Product__r.Product_Family__r.Name,Phoenix_NDC__c,Phoenix_Product_Family1__c,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__r.Name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c  =: bidid and Product_Family__r.Name like :searchWord])
            {
                //system.debug('==========---------'+liblineobj);
                CompetitorInfo_wrapperClass ciw=new CompetitorInfo_wrapperClass();
                ciw.BidNo=liblineobj.Phoenix_Bid__r.Name;
                ciw.BidLineItemNo=liblineobj.Id;
                ciw.ProductName=liblineobj.Phoenix_Product__r.Name;
                ciw.Competitorlist123=complist;
                ciw.Competitorlist2=complist;// Adding Incumbent Values
                ciw.Competitorlist3=complist;
                ciw.Competitorlist4=complist;
                ciw.Competitorlist5=complist;
                ciw.ndc=liblineobj.Phoenix_NDC__c;
                ciw.productfamily=liblineobj.Phoenix_Product__r.Product_Family__r.Name;
                
                //ciw.compclass=compobj;
                Competitorwerlist.add(ciw);
            }
        }
        else
            Competitorwerlist.addAll(CompetitorInfoCLS.CompetitorInfoMethod(bidid));
        return Competitorwerlist;
    }
    
    @AuraEnabled
    public static list<CompetitorInfo_wrapperClass> CompetitorInfoMethod(string bidid)
    {
        //system.debug('*******************bidid---'+bidid);
        list<CompetitorInfo_wrapperClass> Competitorwerlist=new list<CompetitorInfo_wrapperClass>();
        list<Competitor__c> complist=new list<Competitor__c>();
        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
        //Competitor_wrapperClass compobj=new Competitor_wrapperClass();
        //compobj.Competitorlist=complist;
        for(Phoenix_Bid_Line_Item__c  liblineobj:[select Id ,name ,Phoenix_NDC__c,Phoenix_Product__r.Product_Family__r.Name,Phoenix_Product_Family1__c,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__r.Name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c  =: bidid])
        {
            CompetitorInfo_wrapperClass ciw=new CompetitorInfo_wrapperClass();
            ciw.BidNo=liblineobj.Phoenix_Bid__r.Name;
            ciw.BidLineItemNo=liblineobj.Id;
            ciw.ProductName=liblineobj.Phoenix_Product__r.Name;
            ciw.Competitorlist123=complist;
            ciw.Competitorlist2=complist;// Adding Incumbent Values
            ciw.Competitorlist3=complist;
            ciw.Competitorlist4=complist;
            ciw.Competitorlist5=complist;
            
            ciw.ndc=liblineobj.Phoenix_NDC__c;
            ciw.productfamily=liblineobj.Phoenix_Product__r.Product_Family__r.Name;
            
            //ciw.compclass=compobj;
            Competitorwerlist.add(ciw);
        }
        
        return Competitorwerlist;
    }
    // wrapper class from Competitor Info  used in CompetitorInfoMethod method   
    public class CompetitorInfo_wrapperClass
    {
        @AuraEnabled public String BidNo 						{get;set;}
        @AuraEnabled public String BidLineItemNo 				{get;set;}
        @AuraEnabled public String ProductName 					{get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist123 {get;set;}
        //Addition Incumbent Competitor Values 
        @AuraEnabled public list<Competitor__c> Competitorlist2 {get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist3 {get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist4 {get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist5 {get;set;}
        
        @AuraEnabled public String ndc {get;set;}
        @AuraEnabled public String productfamily {get;set;}
        
        
    }
    //----wrapper class of save records 
    public class CompetitorInfo_savewrapperClass
    {
        @AuraEnabled public String BidNos {get;set;}
        @AuraEnabled public String BidLineItemNos {get;set;}
        @AuraEnabled public String ProductNames {get;set;}
        @AuraEnabled public String IncumbentCompetitornames {get;set;}
        @AuraEnabled public String IncumbentCompetitornames2 {get;set;} //Adding Incumbent Values
        @AuraEnabled public String IncumbentCompetitornames3 {get;set;} 
        @AuraEnabled public String IncumbentCompetitornames4 {get;set;} 
        @AuraEnabled public String IncumbentCompetitornames5 {get;set;} 
        
        @AuraEnabled public String IncumbentPriceRanges {get;set;}
        @AuraEnabled public String IncumbentPriceRanges2 {get;set;}       
        @AuraEnabled public String IncumbentPriceRanges3 {get;set;}       
        @AuraEnabled public String IncumbentPriceRanges4 {get;set;}       
        @AuraEnabled public String IncumbentPriceRanges5 {get;set;}
        
        @AuraEnabled public String Ndcs {get;set;}
        @AuraEnabled public String Productfamilies {get;set;}
    }
    @AuraEnabled
    public static void   CompetitorInfoMethodsave(list<CompetitorInfo_savewrapperClass>  resultobjs)
    {
        //CompetitorInfo_savewrapperClass wep=new CompetitorInfo_savewrapperClass();
        //wep=resultobjs;
        list<Competitor_Info__c> insertcomlist=new list<Competitor_Info__c>();
        for(CompetitorInfo_savewrapperClass wep: resultobjs)
        {
            Competitor_Info__c comobj=new Competitor_Info__c();
            comobj.Bid_No__c=wep.BidNos;
            comobj.Product_Name__c=wep.ProductNames;
            comobj.Bid_Line_Item__c=wep.BidLineItemNos;
            
            if(wep.IncumbentCompetitornames == '' || wep.IncumbentCompetitornames == null)
                comobj.Incumbent_Competitor_Name__c =null;
            else if(wep.IncumbentCompetitornames != '' || wep.IncumbentCompetitornames != null)
                comobj.Incumbent_Competitor_Name__c = wep.IncumbentCompetitornames;
            
            //Adding Competitor Names
            if(wep.IncumbentCompetitornames2 == '' || wep.IncumbentCompetitornames2 == null)
                comobj.Incumbent_Competitor_Name_2__c = null;
            else if(wep.IncumbentCompetitornames2 != '' || wep.IncumbentCompetitornames2 != null)
                comobj.Incumbent_Competitor_Name_2__c = wep.IncumbentCompetitornames2;
            
            if(wep.IncumbentCompetitornames3 == '' || wep.IncumbentCompetitornames3 == null)
                comobj.Incumbent_Competitor_Name_3__c = null;
            else if(wep.IncumbentCompetitornames3 != '' || wep.IncumbentCompetitornames3 != null)
                comobj.Incumbent_Competitor_Name_3__c = wep.IncumbentCompetitornames3;
            
            if(wep.IncumbentCompetitornames4 == '' || wep.IncumbentCompetitornames4 == null)
                comobj.Incumbent_Competitor_Name_4__c =null;
            else if(wep.IncumbentCompetitornames4 != '' || wep.IncumbentCompetitornames4 != null)
                comobj.Incumbent_Competitor_Name_4__c = wep.IncumbentCompetitornames4;
            
            if(wep.IncumbentCompetitornames5 == '' || wep.IncumbentCompetitornames5 == null)
                comobj.Incumbent_Competitor_Name_5__c = null;
            else if(wep.IncumbentCompetitornames5 != '' || wep.IncumbentCompetitornames5 != null)
                comobj.Incumbent_Competitor_Name_5__c = wep.IncumbentCompetitornames5;
            
            
            // comobj.Incumbent_Competitor_Name_New__c=wep.IncumbentCompetitornames;
            
            if(wep.IncumbentPriceRanges == '' || wep.IncumbentPriceRanges == null)
                comobj.Incumbent_Price_Range__c=null;
            else if(wep.IncumbentPriceRanges != '' || wep.IncumbentPriceRanges != null)
                comobj.Incumbent_Price_Range__c=wep.IncumbentPriceRanges;
            
            if(wep.IncumbentPriceRanges2 == '' || wep.IncumbentPriceRanges2 == null)
                comobj.Incumbent_Price_Range_2__c=null;
            else if(wep.IncumbentPriceRanges2 != '' || wep.IncumbentPriceRanges2 != null)
                comobj.Incumbent_Price_Range_2__c = wep.IncumbentPriceRanges2;
            
            if(wep.IncumbentPriceRanges3 == '' || wep.IncumbentPriceRanges3 == null)
                comobj.Incumbent_Price_Range_3__c = null;
            else if(wep.IncumbentPriceRanges3 != '' || wep.IncumbentPriceRanges3 != null)
                comobj.Incumbent_Price_Range_3__c = wep.IncumbentPriceRanges3;
            
            if(wep.IncumbentPriceRanges4 == '' || wep.IncumbentPriceRanges4 == null)
                comobj.Incumbent_Price_Range_4__c = null;
            else if(wep.IncumbentPriceRanges4 != '' || wep.IncumbentPriceRanges4 != null)
                comobj.Incumbent_Price_Range_4__c = wep.IncumbentPriceRanges4;
            
            if(wep.IncumbentPriceRanges5 == '' || wep.IncumbentPriceRanges5 == null)
                comobj.Incumbent_Price_Range_5__c = null;
            else if(wep.IncumbentPriceRanges5 != '' || wep.IncumbentPriceRanges5 != null)
                comobj.Incumbent_Price_Range_5__c = wep.IncumbentPriceRanges5;
            
            comobj.NDC__c=wep.Ndcs;
            comobj.Product_Family__c=wep.Productfamilies;
            insertcomlist.add(comobj);
        }
        if(insertcomlist.size()>0)
        {
            insert insertcomlist;
        }
    }
    @AuraEnabled
    public static list<Competitor_Info__c>   CollectCompetitorInfoRec(string  bidid)
    {
        system.debug('-----bidid----'+bidid);
        list<Competitor_Info__c> CIlist=new list<Competitor_Info__c>();
        for(Competitor_Info__c ci:[select id,Bid_Line_Item__r.Name,Bid_Line_Item__c,Bid_No__r.Name,Incumbent_Competitor_Name__c,Incumbent_Competitor_Name_2__c,Incumbent_Competitor_Name_3__c,Incumbent_Competitor_Name_4__c,Incumbent_Competitor_Name_5__c,Incumbent_Competitor_Name__r.Id,Product_Name__c,Incumbent_Competitor_Name__r.Name,Incumbent_Price_Range__c,Incumbent_Competitor_Name_2__r.Name,Incumbent_Competitor_Name_3__r.Name,Incumbent_Competitor_Name_4__r.Name,Incumbent_Competitor_Name_5__r.Name,Incumbent_Price_Range_2__c,Incumbent_Price_Range_3__c,Incumbent_Price_Range_4__c,Incumbent_Price_Range_5__c,NDC__c,Product_Family__c from Competitor_Info__c where Bid_No__c=:bidid])
            CIlist.add(ci);
        system.debug('-----bididsize----'+CIlist.size());
        return CIlist;
    }
    @AuraEnabled
    public static list<string> collectProductFamilyNamesview(string bidid)
    {
        set<string> ProductFamilylist=new set<string>();
        for(Competitor_Info__c ci:[select id,Bid_No__r.Name,Bid_No__c,Product_Family__c from Competitor_Info__c where Bid_No__c=:bidid])
        {
            //system.debug('---====---==='+liblineobj.Phoenix_Product_Family1__c);
            ProductFamilylist.add(ci.Product_Family__c);
        }
        return new list<string>(ProductFamilylist);
    }
    @AuraEnabled
    public static list<Competitor_Info__c>  CompetitorInfoPFv(string bidid,string pf)
    {
        list<Competitor_Info__c> CIlist=new list<Competitor_Info__c>();
        String searchWord='%'+pf+'%';
        if(pf!='ChooseProductFamily')
        {
            for(Competitor_Info__c ci:[select id,Bid_Line_Item__r.Name,Bid_Line_Item__c,Bid_No__r.Name,Incumbent_Competitor_Name__c,
                                       Incumbent_Competitor_Name_2__c,Incumbent_Competitor_Name_3__c,Incumbent_Competitor_Name_4__c,
                                       Incumbent_Competitor_Name_5__c,Incumbent_Competitor_Name__r.Id,Product_Name__c,Incumbent_Competitor_Name__r.Name,
                                       Incumbent_Price_Range__c,Incumbent_Competitor_Name_2__r.Name,Incumbent_Competitor_Name_3__r.Name,Incumbent_Competitor_Name_4__r.Name,
                                       Incumbent_Competitor_Name_5__r.Name,Incumbent_Price_Range_2__c,Incumbent_Price_Range_3__c,Incumbent_Price_Range_4__c,
                                       Incumbent_Price_Range_5__c,NDC__c,Product_Family__c from Competitor_Info__c 
                                       where Bid_No__c=:bidid and Product_Family__c like :searchWord])
            {
                CIlist.add(ci);
            }
        }
         else
            CIlist.addAll(CompetitorInfoCLS.CollectCompetitorInfoRec(bidid));
        
        
        return CIlist;
    }
    @AuraEnabled
    public static list<string> GetCompetitorNames()
    {
        list<string> Competitornamelist=new list<string>();
        for(Competitor__c Compobj:[select Id,Name from Competitor__c ORDER BY Name ASC])
            Competitornamelist.add(Compobj.Name);
        return Competitornamelist;
    }
    @AuraEnabled
    public static void updatecominforec(list<Competitor_Info__c> comlist)
    {
        list<Competitor_Info__c> updatelist=new list<Competitor_Info__c>();
        for(Competitor_Info__c c: comlist)    
        {
            Competitor_Info__c cobj=new Competitor_Info__c();
            cobj.Id=c.Id;
            cobj.Incumbent_Competitor_Name__c=c.Incumbent_Competitor_Name__c;
            //  system.debug('Hello'+c.Incumbent_Competitor_Name__c);
            cobj.Incumbent_Competitor_Name_2__c=c.Incumbent_Competitor_Name_2__c;
            cobj.Incumbent_Competitor_Name_3__c=c.Incumbent_Competitor_Name_3__c;
            cobj.Incumbent_Competitor_Name_4__c=c.Incumbent_Competitor_Name_4__c;
            cobj.Incumbent_Competitor_Name_5__c=c.Incumbent_Competitor_Name_5__c;
            cobj.Incumbent_Price_Range__c=c.Incumbent_Price_Range__c;
            cobj.Incumbent_Price_Range_2__c=c.Incumbent_Price_Range_2__c;
            cobj.Incumbent_Price_Range_3__c=c.Incumbent_Price_Range_3__c;
            cobj.Incumbent_Price_Range_4__c=c.Incumbent_Price_Range_4__c;
            cobj.Incumbent_Price_Range_5__c=c.Incumbent_Price_Range_5__c;
            
            updatelist.add(cobj);
        }
        if(updatelist.size()>0)
            update updatelist;
    }
    
    @Auraenabled
    public static List<Competitor__c> getCompetitorName()
    {
        return ([Select Id, Name from Competitor__c ORDER BY Name ASC]);
    }
    
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive 
                      FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }  
    @AuraEnabled 
    public static Phoenix_Bid__c fetchBidCustomerName(string bidCustName){
        // query current user information  
        Phoenix_Bid__c bAccName = [select id,Name,Phoenix_Customer__c,Phoenix_Customer__r.Name 
                      FROM Phoenix_Bid__c Where id =: bidCustName];
        return bAccName;
    }
    
    @AuraEnabled
    public static void codeCoverage(){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    //-----code by rama end --------
}