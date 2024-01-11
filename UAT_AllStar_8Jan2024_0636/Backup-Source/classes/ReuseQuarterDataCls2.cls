public class ReuseQuarterDataCls2 {
 public static List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
 public static List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
 
    public static String returnQuartData1(){
         
             String contentq1 = '';
            
            // Table container start
            
            contentq1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            contentq1 +=  '<tr><td style="width:42%;">';   //left table start                         
            
            contentq1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq1 +=  '<thead>';
         
            contentq1 +=  '<tr>';
            contentq1 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            contentq1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq1 += '</tr></thead>';
           
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {

                String colorStyle;
                Decimal quarter_one_Target = lineItem.quarter_one_Target;
                Decimal quarter_one_Achieved = lineItem.quarter_one_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_one_Achieved,quarter_one_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter1target;
                Decimal quart1tar;
                quart1tar = lineItem.quarter_one_Target;
                formattedQuarter1target =  HeadApprovalEmailNotification.conversion(quart1tar);
                
                String formattedQuarter1achieved;
                Decimal quart1ach;
                quart1ach = lineItem.quarter_one_Achieved;
                formattedQuarter1achieved =  HeadApprovalEmailNotification.conversion(quart1ach);
                
                
                
                contentq1 += '<tbody>';
                contentq1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1target+'</td>';
                contentq1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1achieved+'</td>';
                contentq1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
                
            }
              
            contentq1 += '</tbody></table>';
            contentq1 += '</td>'; // Close the left table cell      
            
            
            
            contentq1 += '<td style="width:42%;">';
            contentq1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq1 +=  '<thead>';
       
            contentq1 +=  '<tr>';
            contentq1 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            contentq1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq1 += '</tr></thead>';
          
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {

                 String colorStyle;
                Decimal quarter_one_Target = lineItem.quarter_one_Target;
                Decimal quarter_one_Achieved = lineItem.quarter_one_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_one_Achieved,quarter_one_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter1target;
                Decimal quart1tar;
                quart1tar = lineItem.quarter_one_Target;
                formattedQuarter1target =  HeadApprovalEmailNotification.conversion(quart1tar);
                
                String formattedQuarter1achieved;
                Decimal quart1ach;
                quart1ach = lineItem.quarter_one_Achieved;
                formattedQuarter1achieved =  HeadApprovalEmailNotification.conversion(quart1ach);
                
                
                contentq1 += '<tbody>';
                contentq1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1target+'</td>';
                contentq1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1achieved+'</td>';
                contentq1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
               
                
            }
            contentq1 += '</tbody></table>';
            contentq1 += '</td>'; // Close the left table cell      
            
            contentq1 += '<td style="width:16%;"></td>';
            contentq1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq1 += '</table>';
            contentq1 += '</tr></table>';
            System.debug('contentq1 ===>'+contentq1);
            return contentq1;
           
    }

    public static String returnQuartData2(){
         
             String contentq2 = '';
            
            // Table container start
            
            contentq2 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            contentq2 +=  '<tr><td style="width:42%;">';   //left table start                         
            
            contentq2 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq2 +=  '<thead>';
         
            contentq2 +=  '<tr>';
            contentq2 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq2 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            contentq2 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq2 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq2 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq2 += '</tr></thead>';
           
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {

                String colorStyle;
                Decimal quarter_Two_Target = lineItem.quarter_Two_Target;
                Decimal quarter_two_Achieved = lineItem.quarter_two_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_two_Achieved,quarter_Two_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter2target;
                Decimal quart2tar;
                quart2tar = lineItem.quarter_Two_Target;
                formattedQuarter2target =  HeadApprovalEmailNotification.conversion(quart2tar);
                
                String formattedQuarter2achieved;
                Decimal quart2ach;
                quart2ach = lineItem.quarter_two_Achieved;
                formattedQuarter2achieved =  HeadApprovalEmailNotification.conversion(quart2ach);
                
                
                
                contentq2 += '<tbody>';
                contentq2 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq2 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2target+'</td>';
                contentq2 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2achieved+'</td>';
                contentq2 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
                
            }
              
            contentq2 += '</tbody></table>';
            contentq2 += '</td>'; // Close the left table cell      
            
            
            
            contentq2 += '<td style="width:42%;">';
            contentq2 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq2 +=  '<thead>';
       
            contentq2 +=  '<tr>';
            contentq2 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq2 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            contentq2 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq2 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq2 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq2 += '</tr></thead>';
          
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {

                String colorStyle;
                Decimal quarter_Two_Target = lineItem.quarter_Two_Target;
                Decimal quarter_two_Achieved = lineItem.quarter_two_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_two_Achieved,quarter_Two_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter2target;
                Decimal quart2tar;
                quart2tar = lineItem.quarter_Two_Target;
                formattedQuarter2target =  HeadApprovalEmailNotification.conversion(quart2tar);
                
                String formattedQuarter2achieved;
                Decimal quart2ach;
                quart2ach = lineItem.quarter_two_Achieved;
                formattedQuarter2achieved =  HeadApprovalEmailNotification.conversion(quart2ach);
                
                
                contentq2 += '<tbody>';
                contentq2 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq2 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2target+'</td>';
                contentq2 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2achieved+'</td>';
                contentq2 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
               
                
            }
            contentq2 += '</tbody></table>';
            contentq2 += '</td>'; // Close the left table cell      
            
            contentq2 += '<td style="width:16%;"></td>';
            contentq2 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq2 += '</table>';
            contentq2 += '</tr></table>';
            System.debug('contentq2 ===>'+contentq2);
            return contentq2;
           
    }
    
    public static String returnQuartData3(){
         
             String contentq3 = '';
            
            // Table container start
            
            contentq3 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            contentq3 +=  '<tr><td style="width:42%;">';   //left table start                         
            
            contentq3 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq3 +=  '<thead>';
         
            contentq3 +=  '<tr>';
            contentq3 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq3 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            contentq3 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq3 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq3 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq3 += '</tr></thead>';
           
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {

                String colorStyle;
                Decimal quarter_Three_Target = lineItem.quarter_Three_Target;
                Decimal quarter_three_Achieved = lineItem.quarter_three_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_three_Achieved,quarter_Three_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter3target;
                Decimal quart3tar;
                quart3tar = lineItem.quarter_Three_Target;
                formattedQuarter3target =  HeadApprovalEmailNotification.conversion(quart3tar);
                
                String formattedQuarter3achieved;
                Decimal quart3ach;
                quart3ach = lineItem.quarter_three_Achieved;
                formattedQuarter3achieved =  HeadApprovalEmailNotification.conversion(quart3ach);
                
                
                
                contentq3 += '<tbody>';
                contentq3 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq3 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3target+'</td>';
                contentq3 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3achieved+'</td>';
                contentq3 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
                
            }
              
            contentq3 += '</tbody></table>';
            contentq3 += '</td>'; // Close the left table cell      
            
            
            
            contentq3 += '<td style="width:42%;">';
            contentq3 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq3 +=  '<thead>';
       
            contentq3 +=  '<tr>';
            contentq3 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq3 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            contentq3 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq3 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq3 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq3 += '</tr></thead>';
          
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {

              String colorStyle;
                Decimal quarter_Three_Target = lineItem.quarter_Three_Target;
                Decimal quarter_three_Achieved = lineItem.quarter_three_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_three_Achieved,quarter_Three_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter3target;
                Decimal quart3tar;
                quart3tar = lineItem.quarter_Three_Target;
                formattedQuarter3target =  HeadApprovalEmailNotification.conversion(quart3tar);
                
                String formattedQuarter3achieved;
                Decimal quart3ach;
                quart3ach = lineItem.quarter_three_Achieved;
                formattedQuarter3achieved =  HeadApprovalEmailNotification.conversion(quart3ach);
                
                
                contentq3 += '<tbody>';
                contentq3 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq3 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3target+'</td>';
                contentq3 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3achieved+'</td>';
                contentq3 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
               
                
            }
            contentq3 += '</tbody></table>';
            contentq3 += '</td>'; // Close the left table cell      
            
            contentq3 += '<td style="width:16%;"></td>';
            contentq3 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq3 += '</table>';
            contentq3 += '</tr></table>';
            System.debug('contentq3 ===>'+contentq3);
            return contentq3;
           
    }
    
     public static String returnQuartData4(){
         
             String contentq4 = '';
            
            // Table container start
            
            contentq4 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            contentq4 +=  '<tr><td style="width:42%;">';   //left table start                         
            
            contentq4 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq4 +=  '<thead>';
         
            contentq4 +=  '<tr>';
            contentq4 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq4 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            contentq4 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq4 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq4 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq4 += '</tr></thead>';
           
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {

                String colorStyle;
                Decimal quarter_Four_Target = lineItem.quarter_Four_Target;
                Decimal quarter_four_Achieved = lineItem.quarter_four_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_four_Achieved,quarter_Four_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter4target;
                Decimal quart4tar;
                quart4tar = lineItem.quarter_Four_Target;
                formattedQuarter4target =  HeadApprovalEmailNotification.conversion(quart4tar);
                
                String formattedQuarter4achieved;
                Decimal quart4ach;
                quart4ach = lineItem.quarter_three_Achieved;
                formattedQuarter4achieved =  HeadApprovalEmailNotification.conversion(quart4ach);
                
                
                
                contentq4 += '<tbody>';
                contentq4 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq4 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4target+'</td>';
                contentq4 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4achieved+'</td>';
                contentq4 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
                
            }
              
            contentq4 += '</tbody></table>';
            contentq4 += '</td>'; // Close the left table cell      
            
            
            
            contentq4 += '<td style="width:42%;">';
            contentq4 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq4 +=  '<thead>';
       
            contentq4 +=  '<tr>';
            contentq4 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            contentq4 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            contentq4 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            contentq4 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            contentq4 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            contentq4 += '</tr></thead>';
          
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {

            String colorStyle;
                Decimal quarter_Four_Target = lineItem.quarter_Four_Target;
                Decimal quarter_four_Achieved = lineItem.quarter_four_Achieved;
                Decimal percentData;
                percentData =  ReuseQuarterDataCls.percentCalculate(quarter_four_Achieved,quarter_Four_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter4target;
                Decimal quart4tar;
                quart4tar = lineItem.quarter_Four_Target;
                formattedQuarter4target =  HeadApprovalEmailNotification.conversion(quart4tar);
                
                String formattedQuarter4achieved;
                Decimal quart4ach;
                quart4ach = lineItem.quarter_three_Achieved;
                formattedQuarter4achieved =  HeadApprovalEmailNotification.conversion(quart4ach);
                
                
                
                contentq4 += '<tbody>';
                contentq4 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                contentq4 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4target+'</td>';
                contentq4 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4achieved+'</td>';
                contentq4 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
               
                
            }
            contentq4 += '</tbody></table>';
            contentq4 += '</td>'; // Close the left table cell      
            
            contentq4 += '<td style="width:16%;"></td>';
            contentq4 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            contentq4 += '</table>';
            contentq4 += '</tr></table>';
            System.debug('contentq4 ===>'+contentq4);
            return contentq4;
           
    }
    
}


/*

  // Table container start
            
            content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<tr><td style="width:42%;">';   //left table start                         
            
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
        
            String westCSV;
            String targetCSV;
            String achivedCSV;
            String percentCSV;
            westWrapList = new List<DataWrapper>();

            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
                  DataWrapper westWrap = new DataWrapper();

                  if(lineItem.salesRepName != null){
                    westCSV = (lineItem.salesRepName).replaceAll(',', '');
                }
                else{
                    westCSV = '';
                }
                
               
                
                String colorStyle;
                Decimal quarter_Three_Target = lineItem.quarter_Three_Target;
              
                Decimal quarter_three_Achieved = lineItem.quarter_three_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_three_Achieved,quarter_Three_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter3target;
                Decimal quart3tar;
                quart3tar = lineItem.quarter_Three_Target;
                formattedQuarter3target =  HeadApprovalEmailNotification.conversion(quart3tar);
                
                String formattedQuarter3achieved;
                Decimal quart3ach;
                quart3ach = lineItem.quarter_three_Achieved;
                formattedQuarter3achieved =  HeadApprovalEmailNotification.conversion(quart3ach);
           
                Integer quarterThreeTargetInteger = reduceDecimal(lineItem.quarter_Three_Target);
				String trimmedQuarter3target = '$' + quarterThreeTargetInteger;
                
                Integer quarterThreeAchievedInteger = reduceDecimal(lineItem.quarter_three_Achieved);
				String trimmedQuarter3achieved = '$' + quarterThreeAchievedInteger;
				
               String employeeeId = employeeDetails(lineItem.salesRepName);
                
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                 content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+trimmedQuarter3target+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+trimmedQuarter3achieved+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                westWrap.westName = lineItem.salesRepName;
                westWrap.westTarget = formattedQuarter3target;
                westWrap.westAchieve = formattedQuarter3achieved;
                westWrap.westPercentile = percentData;
                westWrap.westPerSymbol = String.valueOf(percentData)+'%';
                westWrap.westEmployeeId = lineItem.empId;
                westWrapList.add(westWrap);
                
                
                recordString = westCSV +','+employeeeId+','+trimmedQuarter3target+','+trimmedQuarter3achieved+','+percentData+'\n';
                finalstr += recordString;
               
                
                
            }
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            
            
            
            content1 += '<td style="width:42%;">';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
     
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            
      
            String eastCSV;
            String easttargetCSV;
            String eastachivedCSV;
            String eastpercentCSV;
            eastWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
                DataWrapper eastWrap = new DataWrapper();
                
                 String colorStyle;
                Decimal quarter_Three_Target = lineItem.quarter_Three_Target;
              
                Decimal quarter_three_Achieved = lineItem.quarter_three_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_three_Achieved,quarter_Three_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                
                String formattedQuarter3target;
                Decimal quart3tar;
                quart3tar = lineItem.quarter_Three_Target;
                formattedQuarter3target =  HeadApprovalEmailNotification.conversion(quart3tar);
                
                String formattedQuarter3achieved;
                Decimal quart3ach;
                quart3ach = lineItem.quarter_three_Achieved;
                formattedQuarter3achieved =  HeadApprovalEmailNotification.conversion(quart3ach);
           
                Integer quarterThreeTargetInteger = reduceDecimal(lineItem.quarter_Three_Target);
				String trimmedQuarter3target = '$' + quarterThreeTargetInteger;
                
                Integer quarterThreeAchievedInteger = reduceDecimal(lineItem.quarter_three_Achieved);
				String trimmedQuarter3achieved = '$' + quarterThreeAchievedInteger;
				
               String employeeeId = employeeDetails(lineItem.salesRepName);
                
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                 content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+trimmedQuarter3target+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+trimmedQuarter3achieved+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                
                eastWrap.eastName = lineItem.salesRepName;
                eastWrap.eastTarget = formattedQuarter2target;
                eastWrap.eastAchieve = formattedQuarter2achieved;
                eastWrap.eastPercentile = percentData;
                eastWrap.eastPerSymbol = String.valueOf(percentData)+'%';
                eastWrap.eastEmployeeId = lineItem.empId;
                eastWrapList.add(eastWrap);
                recordString2 = lineItem.salesRepName+','+employeeeId+','+trimmedQuarter3target+','+trimmedQuarter3achieved+','+percentData+'\n';
                finalstr2 += recordString2;
                
                
                
            }
               recordString3 = sno0 + ',' + 'Initial Submission' + ',' + recDetails2.Intial_Approver__c + ',' +
                recDetails2.Initiator_Approval_Sent_Time_String__c + ',' + recDetails2.Initiator_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.Initiator_Head_Comments__c) ? '' : recDetails2.Initiator_Head_Comments__c) + ',' + '\n' +
                sno1 + ',' + 'RSM Head' + ',' + recDetails2.RSM_Approver__c + ',' +
                recDetails2.RSM_Head_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_Head_Comments__c) ? '' : recDetails2.RSM_Head_Comments__c) + ',' + '\n' +
                sno2 + ',' + 'SRx Head' + ',' + 'Admin' + ',' +
                recDetails2.SRx_Head_Approval_Sent_Time_String__c + ',' + recDetails2.SRx_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.SRx_Head_Comments__c) ? '' : recDetails2.SRx_Head_Comments__c) + ',' + '\n' +
                sno3 + ',' + 'Marketing Head' + ',' + recDetails2.Marketing_Approver__c + ',' +
                recDetails2.Marketing_Head_Approval_Sent_Time_String__c + ',' + recDetails2.Marketing_Head_Approval_Completed_Str__c + ',' +
                (String.isBlank(recDetails2.SRx_Head_Comments__c) ? '' : recDetails2.SRx_Head_Comments__c) + ',' + '\n';
            
            
                finalstr1 += recordString3;
        
            recordStringmultiples = finalstr1+'\n'+ finalstr+'\n'+finalstr2;

        
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
           
            content1 += '<td style="width:16%;"></td>';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 += '</table>';
            content1 += '</tr></table>';
            
            
        }    */