public class loginDetailsUpdate {
    
	/*public loginDetailsUpdate() {
        User u = [SELECT Id,Login_and_Logout__c,Last_logout__c from User where id=:Userinfo.getUserId()];
System.debug('current user==>'+Userinfo.getUserId());
//User us = new User();
u.Last_logout__c = System.now();
u.Login_and_Logout__c = true;
update u;
        getLoginDetailsUpdate();
    }*/
    public PageReference getLoginDetailsUpdate(){
        pagereference pg=new pagereference('/home/home.jsp');
		return pg;
    }
}