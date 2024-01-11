public class MarketingHeadAchieSalesRejectNotify {
    
  public static void captureWrapperData(){
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        //westwrapData.sort();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
         List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
       
    }
    
    public static Decimal percentCalculate(Decimal achieve,Decimal target){
      Decimal percentResult;
        if((achieve>0 && target>0)){
             percentResult = (achieve/target) * 100;
             System.debug('percentResult ===>'+percentResult);

        }
        else{
              percentResult = 0;

        }
               return percentResult;
    }
    
    
     public static void salesRepTargetData(){
         
        String parentRecId = 'a1FDL000007kKld2AE';
    
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Date currentDate = Date.today();

        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;

        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year();
        } else {
            fiscalYear = currentDate.year() - 1;
        }

        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
         // Calculate fiscal quarter
         Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
         
         // Adjust fiscal quarter for your custom quarters
         if (calendarQuarter == 1) {
             fiscalQuarter = 4;
         } else if (calendarQuarter == 2) {
             fiscalQuarter = 1;
         } else if (calendarQuarter == 3) {
             fiscalQuarter = 2;
         } else {
             fiscalQuarter = 3;
         }
 
         List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
         List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
       
      

        //subject
        dynamicSubject = 'Marketing Head Achieved Sales Summary Notification';
        //title
        dynamicTitle = 'SRx Sales Team FY '+fiscalYear+' '+fiscalQuarter+' Achieved Sales';
        //Salutation
      content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
      content1 +=   	'<tr>';
      content1 +=  			'<td style="width: 24px;">';
      content1 +=  			'</td>';
      content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear Milan Kalawadia,';
      content1 += 			'</td>';
      content1 += 		'</tr>';
      content1 += '</table>';
      content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
      content1 +=    	'<tr>';
      content1 +=    		'<td style="width: 24px;"></td>';
      content1 += '<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">We require your approval on the FY '+fiscalYear+' '+fiscalQuarter+' Achieved Sales Summary by each Sales Team member<b>.</b>';
      content1 +=    		' The Values are listed in tables below for your review<b>.</b>';
      content1 +=  			'</td>';
      content1 += 		'</tr>';
      content1 += '</table>';
        
        
        
        
  

      
         if(fiscalQuarter == 1){
             
       
      // Table container start
     
        content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<tr><td style="width:42%;">';   //left table start                         
 
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 1</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">West</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
        for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
       
            String colorStyle;
            Decimal quarter_one_Target = lineItem.quarter_one_Target;
            Decimal quarter_one_Achieved = lineItem.quarter_one_Achieved;
            Decimal percentData;
            percentData =  percentCalculate(quarter_one_Achieved,quarter_one_Target);
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
            formattedQuarter1target =  MarketingHeadApprovalEmailNotification.conversion(quart1tar);
           
            String formattedQuarter1achieved;
            Decimal quart1ach;
            quart1ach = lineItem.quarter_one_Achieved;
            formattedQuarter1achieved =  MarketingHeadApprovalEmailNotification.conversion(quart1ach);
           
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
      
            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
        
        
            
        content1 += '<td style="width:42%;">';
       content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 1</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">East</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
             for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
       
             String colorStyle;
            Decimal quarter_one_Target = lineItem.quarter_one_Target;
            Decimal quarter_one_Achieved = lineItem.quarter_one_Achieved;
            Decimal percentData;
            percentData =  percentCalculate(quarter_one_Achieved,quarter_one_Target);
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
            formattedQuarter1target =  MarketingHeadApprovalEmailNotification.conversion(quart1tar);
           
            String formattedQuarter1achieved;
            Decimal quart1ach;
            quart1ach = lineItem.quarter_one_Achieved;
            formattedQuarter1achieved =  MarketingHeadApprovalEmailNotification.conversion(quart1ach);
           
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
      

            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
          //content1 += '<td style="width: 33%;height: 20px;">';
             // content1 += '</td>';
        // Close the table container
        content1 += '<td style="width:16%;"></td>';
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 += '</table>';
        content1 += '</tr></table>';


     }    
   
            if(fiscalQuarter == 2){
             
       
      // Table container start
     
        content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<tr><td style="width:42%;">';   //left table start                         
 
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 2</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">West</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
        for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
       
            String colorStyle;
            Decimal quarter_Two_Target = lineItem.quarter_Two_Target;
            Decimal quarter_two_Achieved = lineItem.quarter_two_Achieved;
            Decimal percentData;
            percentData =  percentCalculate(quarter_two_Achieved,quarter_Two_Target);
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
            formattedQuarter2target =  MarketingHeadApprovalEmailNotification.conversion(quart2tar);
           
            String formattedQuarter2achieved;
            Decimal quart2ach;
            quart2ach = lineItem.quarter_two_Achieved;
            formattedQuarter2achieved =  MarketingHeadApprovalEmailNotification.conversion(quart2ach);
           
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
      
            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
        
        
            
        content1 += '<td style="width:42%;">';
       content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 2</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">East</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
             for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
       
           
            String colorStyle;
            Decimal quarter_Two_Target = lineItem.quarter_Two_Target;
            Decimal quarter_two_Achieved = lineItem.quarter_two_Achieved;
            Decimal percentData;
            percentData =  percentCalculate(quarter_two_Achieved,quarter_Two_Target);
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
            formattedQuarter2target =  MarketingHeadApprovalEmailNotification.conversion(quart2tar);
           
            String formattedQuarter2achieved;
            Decimal quart2ach;
            quart2ach = lineItem.quarter_two_Achieved;
            formattedQuarter2achieved =  MarketingHeadApprovalEmailNotification.conversion(quart2ach);
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
      

            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
          //content1 += '<td style="width: 33%;height: 20px;">';
             // content1 += '</td>';
        // Close the table container
        content1 += '<td style="width:16%;"></td>';
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 += '</table>';
        content1 += '</tr></table>';


     }    

         
         if(fiscalQuarter == 3){
             
       
      // Table container start
     
        content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<tr><td style="width:42%;">';   //left table start                         
 
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 3</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">West</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
        for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
       
            String colorStyle;
            Decimal quarter_three_Target = lineItem.quarter_Three_Target;
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
            quart3tar = lineItem.quarter_three_Target;
            formattedQuarter3target =  MarketingHeadApprovalEmailNotification.conversion(quart3tar);
           
            String formattedQuarter3achieved;
            Decimal quart3ach;
            quart3ach = lineItem.quarter_three_Achieved;
            formattedQuarter3achieved =  MarketingHeadApprovalEmailNotification.conversion(quart3ach);
           
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
      
            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
        
        
            
        content1 += '<td style="width:42%;">';
       content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 3</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">East</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
             for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
       
            String colorStyle;
            Decimal quarter_three_Target = lineItem.quarter_Three_Target;
            Decimal quarter_three_Achieved = lineItem.quarter_three_Achieved;
            Decimal percentData;
            percentData =  percentCalculate(quarter_three_Achieved,quarter_three_Target);
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
            quart3tar = lineItem.quarter_three_Target;
            formattedQuarter3target =  MarketingHeadApprovalEmailNotification.conversion(quart3tar);
           
            String formattedQuarter3achieved;
            Decimal quart3ach;
            quart3ach = lineItem.quarter_three_Achieved;
            formattedQuarter3achieved =  MarketingHeadApprovalEmailNotification.conversion(quart3ach);
                 
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
      
            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
          //content1 += '<td style="width: 33%;height: 20px;">';
             // content1 += '</td>';
        // Close the table container
        content1 += '<td style="width:16%;"></td>';
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 += '</table>';
        content1 += '</tr></table>';


     }    
         
         
          if(fiscalQuarter == 4){
             
       
      // Table container start
     
        content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<tr><td style="width:42%;">';   //left table start                         
 
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 4</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">West</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
        for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
       
            String colorStyle;
            Decimal quarter_Four_Target = lineItem.quarter_Four_Target;
            Decimal quarter_four_Achieved = lineItem.quarter_four_Achieved;
            Decimal percentData;
            percentData =  percentCalculate(quarter_four_Achieved,quarter_Four_Target);
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
            formattedQuarter4target =  MarketingHeadApprovalEmailNotification.conversion(quart4tar);
           
            String formattedQuarter4achieved;
            Decimal quart4ach;
            quart4ach = lineItem.quarter_four_Achieved;
            formattedQuarter4achieved =  MarketingHeadApprovalEmailNotification.conversion(quart4ach);
           
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
      
            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
        
        
            
        content1 += '<td style="width:42%;">';
       content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<thead>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
        content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 4</th>';
        content1 +=  '</tr>';
        content1 +=  '<tr>';
        content1 +=  '<th style="width: 36px;height: 20px;"></th>';
        
        content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">East</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Target</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">Achieved</th>';
        content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;">%</th>';
        content1 += '</tr></thead>';
        //integer i = 1;
             for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
       
            String colorStyle;
            Decimal quarter_Four_Target = lineItem.quarter_Four_Target;
            Decimal quarter_four_Achieved = lineItem.quarter_four_Achieved;
            Decimal percentData;
            percentData =  percentCalculate(quarter_four_Achieved,quarter_Four_Target);
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
            formattedQuarter4target =  MarketingHeadApprovalEmailNotification.conversion(quart4tar);
           
            String formattedQuarter4achieved;
            Decimal quart4ach;
            quart4ach = lineItem.quarter_four_Achieved;
            formattedQuarter4achieved =  MarketingHeadApprovalEmailNotification.conversion(quart4ach);
           
           
            
         content1 += '<tbody>';
        content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4target+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4achieved+'</td>';
        content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
        
            
        }
          content1 += '</tbody></table>';
         content1 += '</td>'; // Close the left table cell      
          //content1 += '<td style="width: 33%;height: 20px;">';
             // content1 += '</td>';
        // Close the table container
        content1 += '<td style="width:16%;"></td>';
        content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
        content1 += '</table>';
        content1 += '</tr></table>';


     }  
         
     
    
        AllEmailNotificationsSenderCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }  

    
}