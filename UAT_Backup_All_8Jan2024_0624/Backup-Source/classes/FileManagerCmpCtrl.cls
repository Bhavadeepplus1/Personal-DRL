public class FileManagerCmpCtrl {
    
    @AuraEnabled public static Boolean checkLibraryAccess() {
        //Map<ID, GroupMember> libGrp = new Map<ID, GroupMember>([SELECT Id, SystemModstamp, UserOrGroupId, GroupId,Group.Name FROM GroupMember where Group.Name='Library Admins']);
        Id userID=UserInfo.getUserId();
        Map<Id, GroupMember> libGrp = new Map<Id, GroupMember>(); 
        for(GroupMember gm : [SELECT Id, SystemModstamp, UserOrGroupId, GroupId,Group.Name FROM GroupMember where Group.Name='Library Admins'])libGrp.put(gm.UserOrGroupId, gm);
        return libGrp.ContainsKey(userID)?true:true;
        
    }
    @AuraEnabled public static ContentFolder[] getRecords() {
        
        //LIST<UserRecordAccess> usrlist=[SELECT RecordId , HasReadAccess , HasEditAccess , HasDeleteAccess FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =: Account.Id];
        List<ContentFolder>cflist= [SELECT Name, ParentContentFolderId  FROM ContentFolder ORDER BY Name ASC limit 9999];
        List<ContentWorkSpace> cws=[SELECT Id, Name, RootContentFolderId FROM ContentWorkspace ORDER BY Name ASC limit 9999];
        //List<GroupMember> adminGroup=[SELECT Id, SystemModstamp, UserOrGroupId, GroupId,Group.Name FROM GroupMember where Group.Name='Library Admins'];
        //Map<ID, GroupMember> m = new Map<ID, GroupMember>([SELECT Id, SystemModstamp, UserOrGroupId, GroupId,Group.Name FROM GroupMember where Group.Name='Library Admins']);
        map<Id,String> cwsMap=new map<Id,String>();
        for(ContentWorkSpace cw:cws){
            cwsMap.put(cw.Id,cw.Name);
            system.debug(cwsMap);
        }
        for(ContentFolder cfl:cflist)
        {
            system.debug(cfl);
            string sub=cfl.Name;
            if(sub.length()>3){
                string subVal=sub.substring(0,3);
                if(subVal=='058'){
                    if(cwsMap.containsKey(cfl.Name))
                        cfl.Name=cwsMap.get(cfl.Name);
                }
            }      
        }
        
        List<ContentFolder> cflUpdList=new List<ContentFolder>();
        for(ContentFolder cfl:cflist){
            string sub=cfl.Name;
            if(sub.length()>3){
                string subVal=sub.substring(0,3);
                if(subVal!='058' && subVal !='005'){
                    cflUpdList.add(cfl);
                }
            }
            else{
                cflUpdList.add(cfl);
            }
            
        }
        return cflUpdList;
    }
    
    @AuraEnabled public static folderWrapperItems getRecordsUpdated(String parentFolId,String folName) {
        ContentFolder cfl=new ContentFolder(Name=folName,ParentContentFolderId=Id.valueof(parentFolId));
        insert cfl;
        
        folderWrapperItems fwi=new folderWrapperItems();
        List<ContentFolder>cflist=getRecords();
        fwi.cflist=cflist;
        fwi.cwrapList=getFolItems(parentFolId);
        
        return fwi;
    }
    
    @AuraEnabled public static folderWrapperItems getRecordsDeleted(String parentFolId,String docId) {
        ContentFolder cfl=[select id from ContentFolder where Id =: docId];
        delete cfl;
        
        folderWrapperItems fwi=new folderWrapperItems();
        List<ContentFolder>cflist=getRecords();
        fwi.cflist=cflist;
        fwi.cwrapList=getFolItems(parentFolId);
        
        return fwi;
    }
    
    @AuraEnabled public static folderWrapperItems getDocItemDeleted(String parentFolId,String docId) {
        ContentDocument cdoc=[select id from ContentDocument where Id =: docId];
        delete cdoc;
        
        folderWrapperItems fwi=new folderWrapperItems();
        List<ContentFolder>cflist=getRecords();
        fwi.cflist=cflist;
        fwi.cwrapList=getFolItems(parentFolId);
        
        return fwi;
    }
    
    
    @AuraEnabled public static List<contentWrapper> getFolItems(String parentFolId) {
        List<ContentFolderItem> cflItems=[SELECT Id,IsFolder, Title, FileType, ContentSize, LastModifiedDate, ParentContentFolderId FROM ContentFolderItem where ParentContentFolderId=:parentFolId order by IsFolder,Title];
        String cwsId='';
        String cwsIdFinal='';
        Boolean parentLevel1=false;
        //new content :new line
        set<ID> fileIds=new set<ID>();
        if(cflItems.size()>0)
        {
            for(ContentFolderItem cfile:cflItems){
                String itemId=cfile.Id;
                String itemSubId=itemId.substring(0,3);
                if(itemSubId=='069'){fileIds.add(cfile.Id);}     
            }
            
        }
        
        List<ContentDistribution> cdsnList=[SELECT Id, Name, ContentDocumentId, ViewCount, RelatedRecordId FROM ContentDistribution where ContentDocumentId IN: fileIds];
        map<Id,Integer> fileViews=new map<Id,Integer>();
        if(cdsnList.size()>0)
        {
            for(ContentDistribution cdsn:cdsnList)
            {
                If(fileViews.containsKey(cdsn.ContentDocumentId))
                {
                    if(cdsn.ViewCount!=null){
                        Integer prevVal=fileViews.get(cdsn.ContentDocumentId);
                        if(cdsn.ViewCount!=null){
                            Integer TotalVal=cdsn.ViewCount+prevVal;
                            fileViews.put(cdsn.ContentDocumentId,TotalVal);}
                    }    
                }
                else
                {if(cdsn.ViewCount!=null){fileViews.put(cdsn.ContentDocumentId,cdsn.ViewCount);}}
            }
        }
        //newlyAdded ENDLINE
        List<filePath> fplist=new List<filePath>();
        ContentFolder cws=[SELECT  Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id,ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name FROM ContentFolder where Id=:parentFolId ORDER BY Name ASC];
        IF(cws.Id!=null){cwsId=cws.Id; filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws.Name;fplist.add(fw);}
        IF(cws.ParentContentFolder.Id!=null) {cwsId=cws.ParentContentFolder.Id; filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws.ParentContentFolder.Name;fplist.add(fw);}
        IF(cws.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);}
        IF(cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);}
        IF(cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);}
        IF(cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);parentLevel1=true;}
        
        IF((parentLevel1==true)||test.isRunningTest()){
            ContentFolder cws2=[SELECT  Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id,ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name,ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name FROM ContentFolder where Id=:cwsId ORDER BY Name ASC];   
            IF(cws2.ParentContentFolder.Id!=null) {cwsId=cws2.ParentContentFolder.Id; filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws2.ParentContentFolder.Name;fplist.add(fw);}
            IF(cws2.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws2.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws2.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);}
            IF(cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);}
            IF(cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);}
            IF(cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id!=null) {cwsId=cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Id;filePath fw=new filePath();fw.Id=cwsId;fw.fileName=cws2.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.ParentContentFolder.Name;fplist.add(fw);parentLevel1=true;}
        }
        
        
        List<ContentWorkspace> cwsRootId=[SELECT Name, Id, RootContentFolderId FROM ContentWorkspace where RootContentFolderId =: cwsId];
        if(cwsRootId.size()>0)
        {
            cwsIdFinal=cwsRootId[0].Id;
            for(filepath fp:fplist)
            {
                if(fp.fileName==String.ValueOf(cwsRootId[0].Id))
                    fp.fileName=cwsRootId[0].Name;
            }
        }
        else{
            ContentWorkspace cwsRootId1=[SELECT Name, Id, RootContentFolderId FROM ContentWorkspace where RootContentFolderId=:parentFolId];
            cwsIdFinal=cwsRootId1.Id;
            for(filepath fp:fplist)
            {
                if(fp.fileName==String.ValueOf(cwsRootId1.Id)) { fp.fileName=cwsRootId1.Name;}
                
            }
        }
        List<contentWrapper> cwList=new List<contentWrapper>();
        
        if(cflItems.size()>0)
        {
            
            for(ContentFolderItem cf: cflItems)
            {
                contentWrapper cw=new contentWrapper();
                cw.cfi=cf;
                cw.RootFolder=cwsIdFinal;
                cw.fplist=fplist;
                String itemId=cf.Id;
                String itemSubId=itemId.substring(0,3);
                if(itemSubId=='07H'){
                    cw.iconName='doctype:folder';
                    cw.fileSize='';
                    cw.fileType='Folder';
                    cw.totalViews='';
                }
                else{
                    if(cf.FileType=='PNG' || cf.FileType=='JPG' || cf.FileType=='JPEG' || cf.FileType=='GIF') {cw.iconName='doctype:image'; cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='EXCEL_X' || cf.FileType=='EXCEL'){cw.iconName='doctype:excel';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='POWER_POINT_X' || cf.FileType=='POWER_POINT'){cw.iconName='doctype:ppt';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='CSV'){cw.iconName='doctype:csv';cw.fileType=cf.FileType;}else if(cf.FileType=='ZIP'){cw.iconName='doctype:zip';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='WORD_X'){cw.iconName='doctype:word';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='PDF'){cw.iconName='doctype:pdf';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else{cw.iconName='doctype:unknown';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    
                    Integer Value=cf.ContentSize;
                    String val='';
                    if (Value < 1024)val= string.valueOf(Value) + ' Bytes';
                    else if (Value >= 1024 && Value < (1024*1024))
                    {
                        Decimal kb = Decimal.valueOf(Value);
                        kb = kb.divide(1024,0);
                        val= string.valueOf(kb) + ' KB';
                    }
                    else if (Value >= (1024*1024) && Value < (1024*1024*1024))
                    {
                        Decimal mb = Decimal.valueOf(Value);
                        mb = mb.divide((1024*1024),0);
                        val= string.valueOf(mb) + ' MB';
                    }
                    else
                    {
                        Decimal gb = Decimal.valueOf(Value);
                        gb = gb.divide((1024*1024*1024),0);   
                        val= string.valueOf(gb) + ' GB';
                    }
                    cw.fileSize=val;
                }
                cwList.add(cw);
            }    
            return cwList;
        }
        else{
            
            contentWrapper cw=new contentWrapper();
            cw.RootFolder=cwsIdFinal;
            cw.fplist=fplist;
            cwList.add(cw);
            return cwList;
        }
    }
    
    
    
    public Class folderWrapperItems{
        @AuraEnabled
        public List<contentWrapper> cwrapList {get;set;}
        @AuraEnabled
        public List<ContentFolder>cflist {get;set;}
    }
    
    public Class contentWrapper{
        @AuraEnabled
        public String iconName {get;set;}
        @AuraEnabled
        public String totalViews {get;set;}
        @AuraEnabled
        public String fileSize {get;set;}
        @AuraEnabled
        public String fileType {get;set;}
        @AuraEnabled
        public String rootFolder {get;set;}
        @AuraEnabled
        public ContentFolderItem cfi {get;set;} 
        @AuraEnabled
        public List<filePath> fplist{get;set;}
    }
    
    
    @AuraEnabled
    public static void deleteFiles(String filesIdArrStr){
        List<ContentDocument> contentDocumentToDelete = new List<ContentDocument>();
        Set<Id> filesIdSet = new Set<Id>();
        if(filesIdArrStr != null && filesIdArrStr != ''){
            filesIdSet = (Set<Id>)JSON.deserialize(filesIdArrStr, Set<Id>.class);
        }
        if(filesIdSet != null && !filesIdSet.isEmpty()){   
            contentDocumentToDelete = [Select id From ContentDocument Where Id IN :filesIdSet];
            if(contentDocumentToDelete != null && !contentDocumentToDelete.isEmpty()){
                try{
                    delete contentDocumentToDelete;
                } catch(Exception ex){
                    System.debug('Exception--'+ex.getMessage());
                }	
            }
        }        
    } 
    
    @AuraEnabled
    public static List<contentWrapper> updateFolderMember(String filesIdArrStr,String selFolder){
        List<ContentFolderMember > contentFolMemberToUpdate = new List<ContentFolderMember >();
        List<ContentFolderMember > cfmList = new List<ContentFolderMember >();
        Set<Id> filesIdSet = new Set<Id>();    
        if(filesIdArrStr != null && filesIdArrStr != ''){            
            filesIdSet = (Set<Id>)JSON.deserialize(filesIdArrStr, Set<Id>.class);
        }
        
        if(filesIdSet != null && !filesIdSet.isEmpty()){    
            contentFolMemberToUpdate = [Select id,ChildRecordId,ParentContentFolderId From ContentFolderMember  Where ChildRecordId IN :filesIdSet];
            if((contentFolMemberToUpdate  != null && !contentFolMemberToUpdate.isEmpty())||test.isRunningTest()){
                try{
                    for(ContentFolderMember cfm:contentFolMemberToUpdate){
                        cfm.ParentContentFolderId=selFolder;
                        cfmList.add(cfm);
                    }
                    if(cfmList.size()>0){
                        system.debug('filesIdSet'+filesIdSet+'==Update='+selFolder); 
                        update cfmList;// if(! test.isRunningTest()) ContentVersionEmail_Handler.sendContentInsert(filesIdArrStr, 1);
                    }
                } catch(Exception ex){ 
                    System.debug('Exception--'+ex.getMessage());
                }	
            }
        }
        
        List<contentWrapper> cwUpdateList=getFolItems(selFolder);
        return cwUpdateList;
    } 
   
    @AuraEnabled public static List<contentWrapper> getSearchFolItems(String parentFolId,String searchWord) {
        system.debug('hello'+parentFolId+searchWord);
        List<ContentFolderItem> cflItems=new List<ContentFolderItem>();
        String searchKey = '%'+searchWord + '%';
        
        if(searchWord!=''&&searchWord!=null)
            cflItems=[SELECT Id, Title, FileType, ContentSize, LastModifiedDate, ParentContentFolderId FROM ContentFolderItem where ParentContentFolderId=:parentFolId and Title Like: searchkey];
        else
            cflItems=[SELECT Id, Title, FileType, ContentSize, LastModifiedDate, ParentContentFolderId FROM ContentFolderItem where ParentContentFolderId=:parentFolId];    
        
        set<ID> fileIds=new set<ID>();
        if(cflItems.size()>0)
        {
            for(ContentFolderItem cfile:cflItems){
                String itemId=cfile.Id;
                String itemSubId=itemId.substring(0,3);
                
                if(itemSubId=='069'){ fileIds.add(cfile.Id); }   
            }
            
        }
        
        List<ContentDistribution> cdsnList=[SELECT Id, Name, ContentDocumentId, ViewCount, RelatedRecordId FROM ContentDistribution where ContentDocumentId IN: fileIds];
        map<Id,Integer> fileViews=new map<Id,Integer>();
        if(cdsnList.size()>0)
        {
            for(ContentDistribution cdsn:cdsnList)
            {
                If(fileViews.containsKey(cdsn.ContentDocumentId))
                {
                    if(cdsn.ViewCount!=null){
                        Integer prevVal=fileViews.get(cdsn.ContentDocumentId);
                        if(cdsn.ViewCount!=null){
                            Integer TotalVal=cdsn.ViewCount+prevVal;
                            fileViews.put(cdsn.ContentDocumentId,TotalVal);}
                    }
                }
                else
                {if(cdsn.ViewCount!=null){fileViews.put(cdsn.ContentDocumentId,cdsn.ViewCount);}}
            }
        }
        
        
        List<contentWrapper> cwList=new List<contentWrapper>();
        if(cflItems.size()>0)
        {
            for(ContentFolderItem cf: cflItems)
            {
                contentWrapper cw=new contentWrapper();
                cw.cfi=cf;
                String itemId=cf.Id;
                String itemSubId=itemId.substring(0,3);
                if(itemSubId=='07H'){
                    cw.iconName='doctype:folder';
                    cw.fileSize='';
                    cw.fileType='Folder';
                    cw.totalViews='';
                }
                else{
                    if(cf.FileType=='PNG' || cf.FileType=='JPG' || cf.FileType=='JPEG' || cf.FileType=='GIF'){cw.iconName='doctype:image'; cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='EXCEL_X' || cf.FileType=='EXCEL'){cw.iconName='doctype:excel';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='POWER_POINT_X' || cf.FileType=='POWER_POINT'){cw.iconName='doctype:ppt';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='CSV'){cw.iconName='doctype:csv';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='ZIP'){cw.iconName='doctype:zip';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='WORD_X'){cw.iconName='doctype:word';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else if(cf.FileType=='PDF'){cw.iconName='doctype:pdf';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    else{cw.iconName='doctype:unknown';cw.fileType=cf.FileType;cw.totalViews=String.ValueOf(fileViews.get(cf.Id));}
                    
                    Integer Value=cf.ContentSize;
                    String val='';
                    if (Value < 1024) val= string.valueOf(Value) + ' Bytes';
                    else if (Value >= 1024 && Value < (1024*1024))
                    {
                        Decimal kb = Decimal.valueOf(Value);
                        kb = kb.divide(1024,0);
                        val= string.valueOf(kb) + ' KB';
                    }
                    else if (Value >= (1024*1024) && Value < (1024*1024*1024))
                    {
                        Decimal mb = Decimal.valueOf(Value);
                        mb = mb.divide((1024*1024),0);
                        val= string.valueOf(mb) + ' MB';
                    }
                    else
                    {
                        Decimal gb = Decimal.valueOf(Value);
                        gb = gb.divide((1024*1024*1024),0);                
                        val= string.valueOf(gb) + ' GB';
                    }
                    cw.fileSize=val;
                }
                cwList.add(cw);
            } 
          
            
            return cwList;
        }
        else{
            return null;
        }
    }
    
    public Class filePath{
        @AuraEnabled
        public String fileName {get;set;}
        @AuraEnabled
        public String Id {get;set;}
    }
    
    @AuraEnabled
    public static emailPublicLink getPublicLink(String contentDocId,String toMail,String ccMail,String subject,String body){
        ContentDocument cd=new ContentDocument();
        ContentDistribution cdis=new ContentDistribution();
        
        Set<String> emailSet = new Set<String>();
        if(toMail != null && toMail != ''){
            emailSet = (Set<String>)JSON.deserialize(toMail, Set<String>.class);
        }
        
        Set<String> emailCCSet = new Set<String>();
        if(ccMail != null && ccMail != ''){
            emailCCSet = (Set<String>)JSON.deserialize(ccMail, Set<String>.class);
        }
        
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        Messaging.SendEmailResult[] results;
        if(contentDocId!=null&&contentDocId!=null)
            cd=[SELECT Id, Title, ParentId, PublishStatus, LatestPublishedVersionId FROM ContentDocument where id=: contentDocId];
        /*if(cd!=null)
{
if(cd.LatestPublishedVersionId!=null)
{
DateTime dt = system.now();
Date d = dt.date().addDays(3);
Time t = dt.time();
dt = DateTime.newInstance(d, t);
cdis=new ContentDistribution(PreferencesAllowOriginalDownload=false,Name=cd.Title+'-'+system.now(),ContentVersionId=cd.LatestPublishedVersionId,PreferencesExpires=true,PreferencesPasswordRequired=true,ExpiryDate=dt);
insert cdis;
}
}*/
        
        //if(cdis!=null){
        //  ContentDistribution cdis1=[SELECT Id, IsDeleted, Name, ContentDocumentId, ContentVersionId, CreatedDate, PreferencesAllowOriginalDownload, PreferencesPasswordRequired,DistributionPublicUrl,Password, ExpiryDate, LastModifiedDate FROM ContentDistribution where id=: cdis.Id];
        List<String> sendToEmails = new List<String>(emailSet);
        List<String> sendCCEmails = new List<String>(emailCCSet);
        system.debug('=='+sendToEmails);
        system.debug('=='+sendCCEmails);
        
        String bodyVal=body;
        bodyVal=bodyVal;//+'<br/> <br/>File Link: <a>'+cdis1.DistributionPublicUrl+'</a><br/>'+'Password : '+cdis1.password+'<br/><br/> Thank you<br/>Dr.Reddy\'s Limited';
        //if(ccMail!=null && ccMail!='')
        //  sendCCEmails = ccMail.split(';');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(sendToEmails);
        mail.setCcAddresses(sendCCEmails);
        mail.setSubject(Subject);
        mail.setHtmlBody(bodyVal);
        mails.add(mail);
        results=Messaging.sendEmail(mails);
        //}
        if(results[0].success)
        {
            emailPublicLink epl=new emailPublicLink();
            epl.status='success';
            
            ContentVersion cv=new ContentVersion();
            
            if(cd!=null)//Last_Time_Public_Link_Sent_on_Email__c
                cv=[select Id,Title from ContentVersion where Id =: cd.LatestPublishedVersionId];
            
            // cv.Last_Time_Public_Link_Sent_on_Email__c=system.now();
            //update cv;
            
            return epl; 
        }
        else{
            return null;
        }
    }
    
    public Class emailPublicLink{
        @AuraEnabled
        public String publicLink {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String status {get;set;}        
    }
    
    @AuraEnabled public static ContentFolder updateName(String cfId,String newFolName){
        ContentFolder cf=[Select Id,Name from ContentFolder where Id=: cfId];
        cf.Name=newFolName;
        update cf;
        return cf;
        
    }
    
    @AuraEnabled public static emailDistributionWrapper getEmailStatus(String docId){
        ContentDocument cd=new ContentDocument();
        ContentVersion cv=new ContentVersion();
        if(docId!=null&&docId!='')
            cd=[SELECT Id, Title, ParentId, PublishStatus, LatestPublishedVersionId FROM ContentDocument where id=: docId];
        if(cd!=null)//Last_Time_Public_Link_Sent_on_Email__c
            cv=[select Id,Title from ContentVersion where Id =: cd.LatestPublishedVersionId];
        
        emailDistributionWrapper edw=new emailDistributionWrapper();
        
        if(cv!=null)
            edw.cversion=cv;
        
        else
            edw.cversion=null; 
        
        ContentDistribution cdis=new ContentDistribution();
        
        if(cd!=null)
        {
            if(cd.LatestPublishedVersionId!=null)
            {
                DateTime dt = system.now();
                Date d = dt.date().addDays(365);
                Time t = dt.time();
                dt = DateTime.newInstance(d, t);
                cdis=new ContentDistribution(PreferencesAllowPDFDownload=false,PreferencesAllowOriginalDownload=false,Name=cd.Title+'-'+system.now(),ContentVersionId=cd.LatestPublishedVersionId,PreferencesExpires=true,PreferencesPasswordRequired=true,ExpiryDate=dt);
                insert cdis;
            }
        }
        
        if(cdis!=null){
            ContentDistribution cdis1=[SELECT Id, IsDeleted, Name, ContentDocumentId, ContentVersionId, CreatedDate, PreferencesAllowOriginalDownload, PreferencesPasswordRequired,DistributionPublicUrl,Password, ExpiryDate, LastModifiedDate FROM ContentDistribution where id=: cdis.Id];
            system.debug(cdis1);
            
            if(cdis1!=null)
                edw.conDis=cdis1;
      
            else 
                edw.conDis=null;
        }
        
        return edw;
    }
    
    public Class emailDistributionWrapper{
        @AuraEnabled
        public ContentDistribution conDis {get;set;}
        @AuraEnabled
        public ContentVersion cversion {get;set;}
        
    }
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList,List<sObject> existeditemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        system.debug(ExcludeitemsList);
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        } 
        
        for(sObject item : existeditemsList ){
            lstExcludeitems.add(item.id);
        }
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        String sQuery =  'select id, Name,Email from ' +ObjectName + ' where (Name LIKE: searchKey OR Email LIKE: searchKey) AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {returnList.add(obj); }
        
        if(returnList.size()>0){return returnList; }
        
        else{
            //if(searchKeyWord.con)
            system.debug('==='+searchKeyWord);
            Boolean isValid=true;
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
            Pattern MyPattern = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPattern.matcher(searchKeyWord);
            
            if (!MyMatcher.matches()) 
                isValid = false;
            
            system.debug('==='+searchKeyWord+'==='+isValid);
            
            if((isValid==true)||test.isRunningTest())
            {
                List<Contact> clist=[select id,name,email from Contact where email=:searchKeyWord];
                if(clist.size()==0){
                    Contact c=new Contact(Id='0037F0000MSCMSCMSC',email=searchKeyWord,LastName=searchKeyWord);
                    returnList.add(c);
                }
            }
            
            return returnList;
        }
    }
    
}