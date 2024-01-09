public with sharing class NumberToWord {  
    static String[] to_19 = new string[]{ 'zero', 'one',  'two', 'three', 'four',  'five',  'six',  
        'seven', 'eight', 'nine', 'ten',  'eleven', 'twelve', 'thirteen',  
        'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen' };  
            static String[] tens = new string[]{ 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};  
                // convert a value < 100 to English.    
                public static String convert_nn(integer val) {  
                    if (val < 20)  
                        return to_19[val];  
                    if(val == 100)  
                        return 'one hundred';  
                    for (integer v = 0; v < tens.size(); v++) {  
                        String dcap = tens[v];  
                        integer dval = 20 + 10 * v;  
                        if (dval + 10 > val) {  
                            if (Math.Mod(val,10) != 0)  
                                return dcap + ' ' + to_19[Math.Mod(val,10)];  
                            return dcap;  
                        }      
                    }  
                    return ' ';  
                }   
}