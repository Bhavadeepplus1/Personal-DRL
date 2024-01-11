public class RxComplainceUtility {
    public  decimal convStrtoDec(String value){
        if(value.contains(',')){
            value=value.replace(',','');
            return decimal.valueOf(value);
        }
        else{
            return decimal.valueof(value);
        }
        
    }
}