public class DepartmentWise_Custom_Report 
{
   /* @AuraEnabled
    public static list<wrapperTask> getSCM(date startdate,date enddate,String types){
        system.debug('startdate is  '+startdate+'endadate is '+enddate + 'type is '+types);
        Date enddates = enddate;
        Date endnewDate = enddates.addDays(1);
        decimal scmcount = 0;
        decimal scmcount2 = 0;
        decimal scmcount3 = 0;
        decimal scmtotalcount = 0;
        decimal bidsrcds = 0;
        decimal tme = 0 ;
        // decimal scmpercentage =0;
        list<decimal> exportbid = new list<decimal>();
        list<wrapperTask> wrapperlist=new list<wrapperTask>();   
        List<Phoenix_Bid__c> bid = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>twodaysscmbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>threetofivedaysscmbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>fivedaysscmbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c> bidtotals = new List<Phoenix_Bid__c>();
        set<String>remainingscmbidsids = new set<String>();
        set<String>scmbidsids = new set<String>();
        List<Phoenix_Bid__c>remainingscmbidslist = new List<Phoenix_Bid__c>();
        list<Phoenix_Bid_Process_Steps__c>steps = new List<Phoenix_Bid_Process_Steps__c>();
        list<Phoenix_Bid_Process_Steps__c>holdscmbids = new List<Phoenix_Bid_Process_Steps__c>();
        if(startdate != null && enddate != null && types == null) 
        {
            bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_SCM_Approved_Date__c != null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate  ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
            system.debug('bid if '+bid.size());
            steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and(Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' or phoenix_Bid__r.Phoenix_Approval_Status__c = 'Supply Chain') and Phoenix_Approver_Team__c = 'Supply Chain' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
            system.debug('List size is '+steps.size());
            //holdscmbids = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and(Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' or phoenix_Bid__r.Phoenix_Approval_Status__c = 'Supply Chain') and Phoenix_Approver_Team__c = 'Supply Chain' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
        }
        else if(startdate != null && enddate != null && types != null )
        {
            if(types == 'All')
            {
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_SCM_Approved_Date__c != null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate  ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                system.debug('bid if '+bid.size()); 
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and(Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' or phoenix_Bid__r.Phoenix_Approval_Status__c = 'Supply Chain') and Phoenix_Approver_Team__c = 'Supply Chain' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
                system.debug('List size is '+steps.size());  
            }
            else
            {
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_SCM_Approved_Date__c != null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate and Phoenix_Bid_Type__c =: types  ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                system.debug('bid else if'+bid.size());
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and (Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' or phoenix_Bid__r.Phoenix_Approval_Status__c = 'Supply Chain') and Phoenix_Bid__r.Phoenix_Bid_Type__c =: types and Phoenix_Approver_Team__c = 'Supply Chain' and Phoenix_Status__c = 'In Process'  ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
                system.debug('List size is '+steps.size());    
            }
        }
        else
        {
            bid =  new List<Phoenix_Bid__c>();
            steps = new List<Phoenix_Bid_Process_Steps__c>();
        }
        for(Phoenix_Bid_Process_Steps__c rem : steps)
        {
            remainingscmbidsids.add(rem.Phoenix_Bid__r.id);
        }
        remainingscmbidslist = [select id,name,Phoenix_Bid_Type__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Status__c,Phoenix_Approval_Status__c  from Phoenix_Bid__c where id =: remainingscmbidsids  ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
        try{
            for(Phoenix_Bid__c Bidrecords : [select id,name,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Bid_SCM_Approved_Date__c,(select id,name,Phoenix_Bid__c,Phoenix_Bid_Approval_Status__c,Phoenix_hold_time__c,Phoenix_release_time__c,Phoenix_hold_duration__c,Phoenix_SCM_Marketing__c,Phoenix_Bid__r.name,Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Marketing_Approved_Date__c from Bid_Hold_History__r where (Phoenix_SCM_Marketing__c ='SCM' and Phoenix_Bid_Approval_Status__c='SCM & Marketing')or(Phoenix_SCM_Marketing__c ='SCM&Marketing' and Phoenix_Bid_Approval_Status__c='SCM & Marketing')) from Phoenix_Bid__c where id =: Bid])
            {
                //system.debug('Bidrecords------'+Bidrecords.Phoenix_Bid_Submitted_Date__c+''+Bidrecords.Phoenix_Bid_SCM_Approved_Date__c);
                if(Bidrecords.Phoenix_Bid_Submitted_Date__c  != null && Bidrecords.Phoenix_Bid_SCM_Approved_Date__c !=null)
                {
                    system.debug('The bid name is before for loop '+Bidrecords.name);
                    for(Phoenix_Bid_Hold_History__c bidshld : Bidrecords.Bid_Hold_History__r)
                    {
                        system.debug('Marketing Bid hold are '+bidshld.phoenix_bid__r.name+'and record names are '+bidshld.name+'\n');
                        if(bidshld.Phoenix_hold_duration__c != null || bidshld.Phoenix_hold_duration__c >0)
                        {
                            tme = tme + bidshld.Phoenix_hold_duration__c;  
                            system.debug('The tme 1 is '+tme+'the iteration time for each record is '+bidshld.Phoenix_hold_duration__c);
                        }
                    }
                    tme = tme/24;//this is duration time
                    system.debug('The tme 2 is '+tme);
                    Date submitted = Bidrecords.Phoenix_Bid_Submitted_Date__c;
                    date scm = Bidrecords.Phoenix_Bid_SCM_Approved_Date__c;
                    bidsrcds = submitted.daysBetween(scm);
                    system.debug('Bid records days is '+bidsrcds);
                    system.debug('The submitted date is '+submitted+'The scm date is '+scm);
                    bidsrcds = bidsrcds-tme;//here we subtracting the duration time from actual days
                    system.debug('Bid records days is with hold'+bidsrcds);
                    if(bidsrcds < 0)
                    {
                        bidsrcds = 0;
                    }
                }
                else
                {
                    bidsrcds = null;  
                }
                if(bidsrcds >=0 && bidsrcds <=2)
                {
                    scmcount = scmcount + 1; 
                    system.debug(scmcount);
                    //system.debug('Bid records from child'+Bidholds.Phoenix_Bid__r);
                    bidtotals.add(Bidrecords);
                    twodaysscmbidslist.add(Bidrecords);
                }
                if(bidsrcds > 2 && bidsrcds <= 5)
                {
                    scmcount2 = scmcount2+1; 
                    bidtotals.add(Bidrecords);
                    threetofivedaysscmbidslist.add(Bidrecords);
                }
                if(bidsrcds  > 5)
                {
                    scmcount3 = scmcount3+1; 
                    bidtotals.add(Bidrecords);
                    fivedaysscmbidslist.add(Bidrecords);
                }
            }
        }
        catch(exception e){
            system.debug('The exception is e'+e.getMessage()+'The line number is '+e.getLineNumber()+'The cause is '+e.getCause());
        }
        scmtotalcount = scmcount+scmcount2+scmcount3;
        wrapperTask wr=new wrapperTask();
        wr.numbers = scmcount;
        wr.numbers = scmcount;
        wr.numbers2 = scmcount2;
        wr.numbers3 = scmcount3;
        wr.scmtotal = scmtotalcount;
        wr.scmBidsremaining = remainingscmbidsids.size();
        wr.scmpercentage2 = (scmcount/scmtotalcount*100).setScale(2);
        wr.scmpercentage3 = (scmcount2/scmtotalcount*100).setScale(2);
        wr.scmpercentage5 = (scmcount3/scmtotalcount*100).setScale(2);
        wr.scmpercentagetotal = (wr.scmpercentage2+ wr.scmpercentage3+wr.scmpercentage5).setScale(0);
        wr.totaldaysscmbidslistwrapper = bidtotals;
        wr.twodaysscmbidslistwrapper = twodaysscmbidslist;
        wr.threedaysscmbidslistwrapper = threetofivedaysscmbidslist;
        wr.fivedaysscmbidslistwrapper = fivedaysscmbidslist;
        wr.remainingdaysscmbidslistwrapper = remainingscmbidslist;
        wrapperlist.add(wr);
        system.debug('wrapperlist '+wrapperlist.size());
        return wrapperlist;
    }
    
    @AuraEnabled
    public static list<wrapperTask> getMarketing(date startdate,date enddate,String types){
        system.debug('startdate is  '+startdate+'endadate is '+enddate + 'type is '+types);
        Date enddates = enddate;
        Date endnewDate = enddates.addDays(1);
        list<wrapperTask> wrapperlist=new list<wrapperTask>();   
        decimal Marketingcount = 0;
        decimal Marketingcount2 = 0;
        decimal Marketingcount3 = 0;
        decimal Marketingtotalcount = 0;
        decimal Marketingbidsrcds = 0;
        decimal tme = 0 ;
        date managementmarketingdate; // for mangement approval dates
        date marketingnew;
        List<Phoenix_Bid__c> bid = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c> bid2 = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>twodaysMarketingbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>threetofivedaysMarketingbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>fivedaysMarketingbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c> bidtotals = new List<Phoenix_Bid__c>();
        set<String>remainingMarketingbidsids = new set<String>();
        List<Phoenix_Bid__c>remainingMarketingbidslist = new List<Phoenix_Bid__c>();
        list<Phoenix_Bid_Process_Steps__c>steps = new List<Phoenix_Bid_Process_Steps__c>();
        list<Phoenix_Bid_Hold_History__c>bidhistory=new list<Phoenix_Bid_Hold_History__c>();
        Map<Id, Phoenix_Bid_Process_Steps__c> bidstepsMap = new Map<Id, Phoenix_Bid_Process_Steps__c>();
        
        if(startdate != null && enddate != null && types == null) 
        {
            bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Marketing_Approved_Date__c != null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
            //system.debug('bid else '+bid.size());
            steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and (Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' or phoenix_Bid__r.Phoenix_Approval_Status__c = 'Marketing') and Phoenix_Approver_Team__c = 'Marketing' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
            //  system.debug('List size is '+steps.size());
        }
        else if(startdate != null && enddate != null && types != null )
        {
            if(types == 'All')
            {
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Marketing_Approved_Date__c != null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                //system.debug('bid else '+bid.size());
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and (Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' or phoenix_Bid__r.Phoenix_Approval_Status__c = 'Marketing') and Phoenix_Approver_Team__c = 'Marketing' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
                //   system.debug('All records List size is '+steps.size());   
            }
            else
            {
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Marketing_Approved_Date__c != null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate and Phoenix_Bid_Type__c =: types ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                // system.debug('bid else '+bid.size()); 
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and (Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' or phoenix_Bid__r.Phoenix_Approval_Status__c = 'Marketing') and Phoenix_Bid__r.Phoenix_Bid_Type__c =: types and Phoenix_Approver_Team__c = 'Marketing' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
                //   system.debug('Selected types List size is '+steps.size());   
            }
        }
        else
        {
            bid = new List<Phoenix_Bid__c>();
            steps = new List<Phoenix_Bid_Process_Steps__c>();
        }
        for(Phoenix_Bid_Process_Steps__c rem : steps)
        {
            remainingMarketingbidsids.add(rem.Phoenix_Bid__r.Name);
        }
        remainingMarketingbidslist = [select id,name,Phoenix_Bid_Type__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Status__c,Phoenix_Approval_Status__c  from Phoenix_Bid__c where name =: remainingMarketingbidsids  ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
        system.debug('Marketing Bid records size is '+bid.size());
        try{
            for(Phoenix_Bid__c Bidrecords : [select id, name, Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Bid_Marketing_Approved_Date__c, Bid_Marketing_Lead_OTC_Approved_Date__c,Bid_Marketing_Lead_RX_Approved_Date__c,Bid_Marketing_Lead_SRX_Approved_Date__c, Bid_Marketing_Head_Approved_Date__c,(select id,name,Phoenix_Bid__c,Phoenix_Bid_Approval_Status__c,Phoenix_hold_time__c,Phoenix_release_time__c,Phoenix_hold_duration__c,Phoenix_SCM_Marketing__c,Phoenix_Bid__r.name,Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Marketing_Approved_Date__c from Bid_Hold_History__r where (Phoenix_SCM_Marketing__c ='Marketing' and Phoenix_Bid_Approval_Status__c='SCM & Marketing')or(Phoenix_SCM_Marketing__c ='SCM&Marketing' and Phoenix_Bid_Approval_Status__c='SCM & Marketing') or Phoenix_Bid_Approval_Status__c='Marketing Lead' or Phoenix_Bid_Approval_Status__c = 'Marketing Head'),(select id,name,Phoenix_Bid__c,Phoenix_Approver_Team__c,Phoenix_Status__c, Phoenix_Bid__r.Phoenix_Bid_Marketing_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Lead_SRX_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Lead_RX_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Head_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Lead_OTC_Approved_Date__c,Phoenix_Bid__r.name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approval_Completed_Time__c, Phoenix_Approval_Sent_Time__c from Bid_Process_Steps__r where  Phoenix_Status__c = 'Completed' and (Phoenix_Approver_Team__c = 'Marketing Head' or Phoenix_Approver_Team__c = 'Marketing Lead OTC'  or Phoenix_Approver_Team__c  = 'Marketing Lead Rx' or Phoenix_Approver_Team__c  = 'Marketing Lead SRx' or Phoenix_Approver_Team__c = 'Marketing') order by Phoenix_Approval_Completed_Time__c desc limit 1) from Phoenix_Bid__c  where id =:bid]){
                {
                    system.debug('Marketing Bid records are '+Bidrecords.name);
                    if(Bidrecords.Phoenix_Bid_Submitted_Date__c !=null && (Bidrecords.Phoenix_Bid_Marketing_Approved_Date__c!=null || Bidrecords.Bid_Marketing_Lead_RX_Approved_Date__c!=null || Bidrecords.Bid_Marketing_Lead_SRX_Approved_Date__c != null || Bidrecords.Bid_Marketing_Lead_OTC_Approved_Date__c != null || Bidrecords.Bid_Marketing_Head_Approved_Date__c !=null))
                    {
                        for(Phoenix_Bid_Process_Steps__c datesvalue : Bidrecords.Bid_Process_Steps__r)
                        {
                            DateTime completeddate = datesvalue.Phoenix_Approval_Completed_Time__c ;
                            marketingnew = date.newinstance(completeddate.year(), completeddate.month(), completeddate.day()); 
                        }
                        system.debug('The Bid name is '+Bidrecords.name+'The date is '+marketingnew);
                        Date submitted = Bidrecords.Phoenix_Bid_Submitted_Date__c;
                        date marketing =marketingnew;
                        //for hold bid functionality
                        system.debug('The bid name is before for loop '+Bidrecords.name);
                        for(Phoenix_Bid_Hold_History__c bidshld : Bidrecords.Bid_Hold_History__r)
                        {
                            system.debug('Marketing Bid hold are '+bidshld.phoenix_bid__r.name+'and record names are '+bidshld.name+'\n');
                            if(bidshld.Phoenix_hold_duration__c != null || bidshld.Phoenix_hold_duration__c >0)
                            {
                                tme = tme + bidshld.Phoenix_hold_duration__c;  
                                system.debug('The tme 1 is '+tme+'the iteration time for each record is '+bidshld.Phoenix_hold_duration__c);
                            }
                        }
                        tme = tme/24;//this is duration time
                        system.debug('The tme 2 divided by 24 is'+tme);
                        Marketingbidsrcds = Marketingbidsrcds-tme;//here we subtracting the duration time from actual days
                        system.debug('Bid records days is with hold'+Marketingbidsrcds);
                        if(tme > 0 && tme !=null)
                        {
                            tme = tme/24;//this is duration time
                            system.debug('The tme 2 is '+tme);   
                        }
                        else
                        {
                            tme = 0;
                        }
                        if(marketing != null)
                        {
                            Marketingbidsrcds = submitted.daysBetween(marketing);
                            system.debug('Bid records days is '+Marketingbidsrcds);
                            system.debug('The submitted date is '+submitted+'The marketing date is '+marketing);
                        }
                        
                        if(Marketingbidsrcds <= 0)
                        {
                            Marketingbidsrcds = 0;
                        }
                    }
                    if(Marketingbidsrcds >= 0 && Marketingbidsrcds <=2)
                    {
                        Marketingcount = Marketingcount + 1; 
                        //system.debug(Marketingcount);
                        bidtotals.add(Bidrecords);
                        twodaysMarketingbidslist.add(Bidrecords);
                        // system.debug('twodaysmarketingbids list records is '+twodaysMarketingbidslist);
                    }
                    if(Marketingbidsrcds > 2 && Marketingbidsrcds <= 5)
                    {
                        Marketingcount2 = Marketingcount2+1;
                        bidtotals.add(Bidrecords);
                        threetofivedaysMarketingbidslist.add(Bidrecords);
                    }
                    if(Marketingbidsrcds  > 5)
                    {
                        Marketingcount3 = Marketingcount3+1;  
                        bidtotals.add(Bidrecords);
                        fivedaysMarketingbidslist.add(Bidrecords);
                    }
                }
            }
        }
        catch(exception e)
        {
            system.debug('The line number is '+e.getLineNumber()+'The message is '+e.getMessage()+'The reson is '+e.getCause());
        }
        // system.debug('twodaysMarketingbidslist size is '+twodaysMarketingbidslist.size());
        Marketingtotalcount = Marketingcount + Marketingcount2 + Marketingcount3;
        wrapperTask wr=new wrapperTask();
        wr.Marketingnumbers = Marketingcount;
        wr.Marketingnumbers2 = Marketingcount2;
        wr.Marketingnumbers3 = Marketingcount3;
        wr.Marketingtotal = Marketingtotalcount;
        wr.MarketingBidsremaining = remainingMarketingbidsids.size();
        wr.Marketingpercentage2 = (Marketingcount/Marketingtotalcount*100).setScale(2);
        wr.Marketingpercentage3 = (Marketingcount2/Marketingtotalcount*100).setScale(2);
        wr.Marketingpercentage5 = (Marketingcount3/Marketingtotalcount*100).setScale(2);
        wr.Marketingpercentagetotal = (wr.Marketingpercentage2+ wr.Marketingpercentage3+wr.Marketingpercentage5).setScale(0);
        wr.totaldaysmarketingbidslistwrapper = bidtotals;
        wr.twodaysmarketingbidslistwrapper = twodaysMarketingbidslist;
        wr.threedaysmarketingbidslistwrapper=threetofivedaysMarketingbidslist;
        wr.fivedaysmarketingbidslistwrapper = fivedaysMarketingbidslist;
        wr.remainingdaysmarketingbidslistwrapper = remainingMarketingbidslist; // we nedd to check
        wrapperlist.add(wr);
        return wrapperlist;
    }
    
      @AuraEnabled
    public static list<wrapperTask> getFinance(date startdate,date enddate,String types){
        //  system.debug('startdate is  '+startdate+'endadate is '+enddate + 'type is '+types);
        Date enddates = enddate;
        Date endnewDate = enddates.addDays(1);
        list<wrapperTask> wrapperlist=new list<wrapperTask>();   
        decimal Financecount = 0;
        decimal Financecount2 = 0;
        decimal Financecount3 = 0;
        decimal Financetotalcount = 0;
        decimal Financebidsrcds = 0;
        decimal tme = 0 ;
        date managementmarketingdate; // for mangement approval dates
        date marketingnew;
        List<Phoenix_Bid__c> bid = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>twodaysfinancebidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>threetofivedaysfinancebidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>fivedaysfinancebidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c> bidtotals = new List<Phoenix_Bid__c>();
        set<String>remainingfinancebidsids = new set<String>();
        List<Phoenix_Bid__c>remainingfinancebidslist = new List<Phoenix_Bid__c>();
        list<Phoenix_Bid_Process_Steps__c>steps = new List<Phoenix_Bid_Process_Steps__c>();
        
        if(startdate != null && enddate != null && types == null) 
        {
            bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Marketing_Approved_Date__c!=null and Phoenix_Bid_Finance_Approved_Date__c != null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
            system.debug('bid if '+bid.size());
            steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and phoenix_Bid__r.Phoenix_Approval_Status__c ='Finance' and Phoenix_Approver_Team__c = 'Finance' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
            system.debug('List size is '+steps.size());
        }
        else if(startdate != null && enddate != null && types != null )
        {
            if(types == 'All')
            {
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Marketing_Approved_Date__c!=null and Phoenix_Bid_Finance_Approved_Date__c!=null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                system.debug('bid if '+bid.size());
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and phoenix_Bid__r.Phoenix_Approval_Status__c ='Finance' and Phoenix_Approver_Team__c = 'Finance' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
                system.debug('List size is '+steps.size());
            }
            else
            {
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Marketing_Approved_Date__c!=null and Phoenix_Bid_Finance_Approved_Date__c!=null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate and Phoenix_Bid_Type__c =: types ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                system.debug('bid else '+bid.size());
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Finance' and Phoenix_Bid__r.Phoenix_Bid_Type__c =: types and Phoenix_Approver_Team__c = 'Finance' and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
                system.debug('List size is '+steps.size());  
            }
        }
        else
        {
            bid =    new List<Phoenix_Bid__c>();
            steps =    new List<Phoenix_Bid_Process_Steps__c>();
        }
        for(Phoenix_Bid_Process_Steps__c rem : steps)
        {
            remainingfinancebidsids.add(rem.Phoenix_Bid__r.Name);
        }
        remainingfinancebidslist = [select id,name,Phoenix_Bid_Type__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Status__c,Phoenix_Approval_Status__c  from Phoenix_Bid__c where name =: remainingfinancebidsids  ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
       // try{
            for(Phoenix_Bid__c Bidrecords : [select id, name, Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Bid_Marketing_Approved_Date__c, Bid_Marketing_Lead_OTC_Approved_Date__c,Bid_Marketing_Lead_RX_Approved_Date__c,Bid_Marketing_Lead_SRX_Approved_Date__c, Bid_Marketing_Head_Approved_Date__c,Phoenix_Bid_Finance_Approved_Date__c,(select id,name,Phoenix_Bid__c,Phoenix_Bid_Approval_Status__c,Phoenix_hold_time__c,Phoenix_release_time__c,Phoenix_hold_duration__c,Phoenix_SCM_Marketing__c,Phoenix_Bid__r.name,Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Marketing_Approved_Date__c from Bid_Hold_History__r where Phoenix_Bid_Approval_Status__c='Finance'),(select id,name,Phoenix_Bid__c,Phoenix_Approver_Team__c,Phoenix_Status__c,Phoenix_Approver_Team_Members__c, Phoenix_Bid__r.Phoenix_Bid_Marketing_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Lead_SRX_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Lead_RX_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Head_Approved_Date__c,Phoenix_Bid__r.Bid_Marketing_Lead_OTC_Approved_Date__c,Phoenix_Bid__r.name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approval_Completed_Time__c, Phoenix_Approval_Sent_Time__c from Bid_Process_Steps__r where Phoenix_Status__c = 'Completed' and Phoenix_Approver_Team__c = 'Finance'  order by Phoenix_Approval_Sent_Time__c desc limit 1) from Phoenix_Bid__c where id =: bid])
            {
                    system.debug('Bid records are in finance '+Bidrecords.name);
                    if(Bidrecords.Phoenix_Bid_Marketing_Approved_Date__c != null && Bidrecords.Phoenix_Bid_Finance_Approved_Date__c !=null)
                    {
                        //for management approvals 
                     
                         for(Phoenix_Bid_Process_Steps__c datesvalue : Bidrecords.Bid_Process_Steps__r)
                        {
                            DateTime completeddate = datesvalue.Phoenix_Approval_Sent_Time__c ;
                            marketingnew = date.newinstance(completeddate.year(), completeddate.month(), completeddate.day()); 
                        }
                        system.debug('marketing new in finance '+marketingnew);
                        date marketing = marketingnew;
                       for(Phoenix_Bid_Hold_History__c bidshld : Bidrecords.Bid_Hold_History__r)
                        {
                            if(bidshld.Phoenix_hold_duration__c != null || bidshld.Phoenix_hold_duration__c >0)
                            {
                                tme = tme + bidshld.Phoenix_hold_duration__c;  
                            }
                        }
                        if(tme > 0 && tme !=null)
                        {
                            tme = tme/24;//this is duration time
                        }
                        else
                        {
                            tme = 0;
                        }
                        if(marketing != null)
                        {
                            Financebidsrcds = marketing.daysBetween(Bidrecords.Phoenix_Bid_Finance_Approved_Date__c);
                             Financebidsrcds = Financebidsrcds-tme;//here we subtracting the duration time from actual days
                        }
                        
                        if(Financebidsrcds < 0)
                        {
                            Financebidsrcds = 0;
                        }
                    }
                    else
                    {
                        Financebidsrcds = null;   
                    }
                    if(Financebidsrcds >=0 && Financebidsrcds <=2)
                    {
                        Financecount = Financecount + 1; 
                        bidtotals.add(Bidrecords);
                        twodaysfinancebidslist.add(Bidrecords);
                      }
                    if(Financebidsrcds > 2 && Financebidsrcds <= 5)
                    {
                        Financecount2 = Financecount2+1;
                        bidtotals.add(Bidrecords);
                        threetofivedaysfinancebidslist.add(Bidrecords);
                    }
                    if(Financebidsrcds  > 5)
                    {
                        Financecount3 = Financecount3+1;  
                        bidtotals.add(Bidrecords);
                        fivedaysfinancebidslist.add(Bidrecords);
                        system.debug('with greater than  5 days');
                    }
                }
            
        Financetotalcount = Financecount + Financecount2 + Financecount3;
        wrapperTask wr=new wrapperTask();
        wr.Financenumbers = Financecount;
        wr.Financenumbers2 = Financecount2;
        wr.Financenumbers3 = Financecount3;
        wr.Financetotal = Financetotalcount;
        wr.FinanceBidsremaining = remainingfinancebidsids.size();
        wr.Financepercentage2 = (Financecount/Financetotalcount*100).setScale(2);
        wr.Financepercentage3 = (Financecount2/Financetotalcount*100).setScale(2);
        wr.Financepercentage5 = (Financecount3/Financetotalcount*100).setScale(2);
        wr.Financepercentagetotal = (wr.Financepercentage2+ wr.Financepercentage3+wr.Financepercentage5).setScale(0);
        wr.totaldaysfinancebidslistwrapper = bidtotals;
        wr.twodaysfinancebidslistwrapper = twodaysfinancebidslist;
        wr.threedaysfinancebidslistwrapper = threetofivedaysfinancebidslist;
        wr.fivedaysfinancebidslistwrapper = fivedaysfinancebidslist;
        wr.remainingdaysfinancebidslistwrapper = remainingfinancebidslist;
        wrapperlist.add(wr);
        return wrapperlist;
    }
  
    
    @AuraEnabled
    public static list<wrapperTask> getContract(date startdate,date enddate,String types){
        Date enddates = enddate;
        Date endnewDate = enddates.addDays(1);
        list<wrapperTask> wrapperlist=new list<wrapperTask>();   
        decimal Contractcount = 0;
        decimal Contractcount2 = 0;
        decimal Contractcount3 = 0;
        decimal Contracttotalcount = 0;
        decimal Contractbidsrcds = 0;
        decimal tme = 0 ;
        List<Phoenix_Bid__c> bid = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>twodayscontractbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>threetofivedayscontractbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c>fivedayscontractbidslist = new List<Phoenix_Bid__c>();
        List<Phoenix_Bid__c> bidtotals = new List<Phoenix_Bid__c>();
        set<String>remainingcontractbidsids = new set<String>();
        List<Phoenix_Bid__c>remainingcontractbidslist = new List<Phoenix_Bid__c>();
        list<Phoenix_Bid_Process_Steps__c>steps = new List<Phoenix_Bid_Process_Steps__c>();
        if(startdate != null && enddate != null && types == null) 
        {
            bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where  Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Finance_Approved_Date__c!=null and Phoenix_Bid_Contracts_Approved_Date__c!=null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
           steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and phoenix_Bid__r.Phoenix_Approval_Status__c ='Contracts' and(Phoenix_Approver_Team__c = 'Contracts' or Phoenix_Approver_Team__c= 'SRx IPA Contracts Approver') and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
          }
        else if(startdate != null && enddate != null && types != null )
        {
            if(types == 'All')
            {
                
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where  Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Finance_Approved_Date__c!=null and Phoenix_Bid_Contracts_Approved_Date__c!=null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and phoenix_Bid__r.Phoenix_Approval_Status__c ='Contracts' and(Phoenix_Approver_Team__c = 'Contracts' or Phoenix_Approver_Team__c= 'SRx IPA Contracts Approver') and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
             }
            else
            {
                bid = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where  Phoenix_Bid_Submitted_Date__c!=null and Phoenix_Bid_Finance_Approved_Date__c!=null and Phoenix_Bid_Contracts_Approved_Date__c!=null and Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid_Submitted_Date__c <=:endnewDate and Phoenix_Bid_Type__c =: types ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
                steps = [select id,name,Phoenix_Status__c,Phoenix_Bid__r.id,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team__c,phoenix_bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Type__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c != null and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c  >=:startdate and Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:endnewDate and Phoenix_Bid__r.Phoenix_Approval_Status__c ='Contracts' and Phoenix_Bid__r.Phoenix_Bid_Type__c =: types and(Phoenix_Approver_Team__c = 'Contracts' or Phoenix_Approver_Team__c= 'SRx IPA Contracts Approver') and Phoenix_Status__c = 'In Process' ORDER BY Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
            }
        }
        else
        {
            bid =    new List<Phoenix_Bid__c>();
            steps =    new List<Phoenix_Bid_Process_Steps__c>();
        }
        for(Phoenix_Bid_Process_Steps__c rem : steps)
        {
            remainingcontractbidsids.add(rem.Phoenix_Bid__r.Name);
        }
        remainingcontractbidslist = [select id,name,Phoenix_Bid_Type__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Status__c,Phoenix_Approval_Status__c  from Phoenix_Bid__c where name =: remainingcontractbidsids  ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000];
        try{
            for(Phoenix_Bid__c Bidrecords : [select id, name, Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,Phoenix_Bid_Submitted_Date__c,Phoenix_Bid_Marketing_Approved_Date__c, Bid_Marketing_Lead_OTC_Approved_Date__c,Bid_Marketing_Lead_RX_Approved_Date__c,Bid_Marketing_Lead_SRX_Approved_Date__c, Bid_Marketing_Head_Approved_Date__c,Phoenix_Bid_Finance_Approved_Date__c,Phoenix_Bid_Contracts_Approved_Date__c,(select id,name,Phoenix_Bid__c,Phoenix_Bid_Approval_Status__c,Phoenix_hold_time__c,Phoenix_release_time__c,Phoenix_hold_duration__c,Phoenix_SCM_Marketing__c,Phoenix_Bid__r.name,Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c,Phoenix_Bid__r.Phoenix_Bid_Marketing_Approved_Date__c from Bid_Hold_History__r where Phoenix_Bid_Approval_Status__c='Contracts') from Phoenix_Bid__c where id =: Bid]){
                {
                    // system.debug(Bidrecords);
                    if(Bidrecords.Phoenix_Bid_Finance_Approved_Date__c !=null && Bidrecords.Phoenix_Bid_Contracts_Approved_Date__c !=null)
                    {
                        for(Phoenix_Bid_Hold_History__c bidshld : Bidrecords.Bid_Hold_History__r)
                        {
                            system.debug('Finance Bid hold are '+bidshld.phoenix_bid__r.name+'and record names are '+bidshld.name+'\n');
                            if(bidshld.Phoenix_hold_duration__c != null || bidshld.Phoenix_hold_duration__c >0)
                            {
                                tme = tme + bidshld.Phoenix_hold_duration__c;  
                                system.debug('The tme 1 is '+tme+'the iteration time for each record is '+bidshld.Phoenix_hold_duration__c);
                            }
                        }
                        tme = tme/24;//this is duration time
                        system.debug('The tme 2 is '+tme);
                        Contractbidsrcds = Bidrecords.Phoenix_Bid_Finance_Approved_Date__c.daysBetween(Bidrecords.Phoenix_Bid_Contracts_Approved_Date__c);
                        system.debug(Contractbidsrcds); 
                        Contractbidsrcds = Contractbidsrcds-tme;//here we subtracting the duration time from actual days
                        system.debug('Bid records days is with hold'+Contractbidsrcds); 
                        if(Contractbidsrcds < 0)
                        {
                            Contractbidsrcds = 0;
                        }
                    }
                    else
                    {
                        Contractbidsrcds = null;    
                    }
                    
                    if(Contractbidsrcds >=0 && Contractbidsrcds <=2)
                    {
                        Contractcount = Contractcount + 1; 
                        bidtotals.add(Bidrecords);
                        twodayscontractbidslist.add(Bidrecords);
                    }
                    if(Contractbidsrcds > 2 && Contractbidsrcds <= 5)
                    {
                        Contractcount2 = Contractcount2+1;  
                        bidtotals.add(Bidrecords);
                        threetofivedayscontractbidslist.add(Bidrecords);
                    }
                    if(Contractbidsrcds  > 5)
                    {
                        Contractcount3 = Contractcount3+1; 
                        bidtotals.add(Bidrecords);
                        fivedayscontractbidslist.add(Bidrecords);
                    }
                }
            }
        }
        catch(exception e){
            system.debug('The exception is e'+e.getMessage()+'The line number is '+e.getLineNumber()+'The cause is '+e.getCause());
        }
        Contracttotalcount = Contractcount + Contractcount2 + Contractcount3;
        wrapperTask wr=new wrapperTask();
        wr.Contractnumbers = Contractcount;
        wr.Contractnumbers2 = Contractcount2;
        wr.Contractnumbers3 = Contractcount3;
        wr.Contracttotal = Contracttotalcount;
        wr.ContractBidsremaining = remainingcontractbidsids.size();
        wr.Contractpercentage2 = (Contractcount/Contracttotalcount*100).setScale(2);
        wr.Contractpercentage3 = (Contractcount2/Contracttotalcount*100).setScale(2);
        wr.Contractpercentage5 = (Contractcount3/Contracttotalcount*100).setScale(2);
        wr.Contractpercentagetotal = (wr.Contractpercentage2+ wr.Contractpercentage3+wr.Contractpercentage5).setScale(0);
        wr.totaldayscontractbidslistwrapper = bidtotals;
        wr.twodayscontractbidslistwrapper = twodayscontractbidslist;
        wr.threedayscontractbidslistwrapper = threetofivedayscontractbidslist;
        wr.fivedayscontractbidslistwrapper = fivedayscontractbidslist;
        wr.remainingdayscontractbidslistwrapper = remainingcontractbidslist;
        
        wrapperlist.add(wr);
        return wrapperlist;
    }
    public class wrapperTask 
    {
        @AuraEnabled public decimal numbers{get;set;}
        @AuraEnabled public decimal numbers2{get;set;}
        @AuraEnabled public decimal numbers3{get;set;}
        @AuraEnabled public decimal scmtotal{get;set;}
        @AuraEnabled public integer scmBidsremaining{get;set;}
        @AuraEnabled public decimal scmpercentage2{get;set;}
        @AuraEnabled public decimal scmpercentage3{get;set;}
        @AuraEnabled public decimal scmpercentage5{get;set;}
        @AuraEnabled public decimal scmpercentagetotal{get;set;}
        @AuraEnabled public List<Phoenix_Bid__c>totaldaysscmbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>twodaysscmbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>threedaysscmbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>fivedaysscmbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>remainingdaysscmbidslistwrapper{get;set;} 
        
        
        @AuraEnabled public decimal Marketingnumbers{get;set;}
        @AuraEnabled public decimal Marketingnumbers2{get;set;}
        @AuraEnabled public decimal Marketingnumbers3{get;set;}
        @AuraEnabled public decimal Marketingtotal{get;set;}
        @AuraEnabled public decimal MarketingBidsremaining{get;set;}
        @AuraEnabled public decimal Marketingpercentage2{get;set;}
        @AuraEnabled public decimal Marketingpercentage3{get;set;}
        @AuraEnabled public decimal Marketingpercentage5{get;set;}
        @AuraEnabled public decimal Marketingpercentagetotal{get;set;}
        @AuraEnabled public List<Phoenix_Bid__c>totaldaysmarketingbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>twodaysmarketingbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>threedaysmarketingbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>fivedaysmarketingbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>remainingdaysmarketingbidslistwrapper{get;set;} 
        
        
        @AuraEnabled public decimal Financenumbers{get;set;}
        @AuraEnabled public decimal Financenumbers2{get;set;}
        @AuraEnabled public decimal Financenumbers3{get;set;}
        @AuraEnabled public decimal Financetotal{get;set;}
        @AuraEnabled public decimal FinanceBidsremaining{get;set;}
        @AuraEnabled public decimal Financepercentage2{get;set;}
        @AuraEnabled public decimal Financepercentage3{get;set;}
        @AuraEnabled public decimal Financepercentage5{get;set;}
        @AuraEnabled public decimal Financepercentagetotal{get;set;}
        @AuraEnabled public List<Phoenix_Bid__c>totaldaysfinancebidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>twodaysfinancebidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>threedaysfinancebidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>fivedaysfinancebidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>remainingdaysfinancebidslistwrapper{get;set;} 
        
        @AuraEnabled public decimal Contractnumbers{get;set;}
        @AuraEnabled public decimal Contractnumbers2{get;set;}
        @AuraEnabled public decimal Contractnumbers3{get;set;}
        @AuraEnabled public decimal Contracttotal{get;set;}
        @AuraEnabled public decimal ContractBidsremaining{get;set;}
        @AuraEnabled public decimal Contractpercentage2{get;set;}
        @AuraEnabled public decimal Contractpercentage3{get;set;}
        @AuraEnabled public decimal Contractpercentage5{get;set;}
        @AuraEnabled public decimal Contractpercentagetotal{get;set;}
        @AuraEnabled public List<Phoenix_Bid__c>totaldayscontractbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>twodayscontractbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>threedayscontractbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>fivedayscontractbidslistwrapper{get;set;} 
        @AuraEnabled public List<Phoenix_Bid__c>remainingdayscontractbidslistwrapper{get;set;} 
        
    }  */
}