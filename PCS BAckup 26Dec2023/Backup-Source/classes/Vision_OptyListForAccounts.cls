///<!-- CREATED BY ASHOK DHRUV SOFT 16-06-2022 -->
public class Vision_OptyListForAccounts {
    @auraEnabled public static List<Opportunity> getOptyList(String accId){
        String query = 'SELECT CreatedBy.Name, '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE AccountId =: accId ORDER BY CreatedDate DESC';
        return Database.query(query);//optyList;List<Opportunity> optyList = Database.query(query);
    }
}