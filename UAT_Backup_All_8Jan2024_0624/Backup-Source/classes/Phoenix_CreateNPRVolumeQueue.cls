/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_CreateNPRVolumeQueue implements Queueable {
    public Map < String, Phoenix_NPR_Data__c > existingNPRMap;
    public List < Phoenix_SAP_NPR_Staging__c > nprStagingList;
    public Phoenix_CreateNPRVolumeQueue(List < Phoenix_SAP_NPR_Staging__c > nprStagingList, Map < String, Phoenix_NPR_Data__c > existingNPRMap) {
        this.existingNPRMap = existingNPRMap;
        this.nprStagingList = nprStagingList;
    }
    public void execute(QueueableContext context) {
        Set < Id > nprIdSet = new Set < Id > ();
        for (Phoenix_NPR_Data__c npr: existingNPRMap.values()) nprIdSet.add(npr.Id);
        List < Phoenix_NPR_Volume__c > nprVolumeUpdatedList = new List < Phoenix_NPR_Volume__c > ();
        Map < Id, List < Phoenix_NPR_Volume__c >> nprDataWithVolumeMap = new Map < Id, List < Phoenix_NPR_Volume__c >> ();
        Map < String, Phoenix_NPR_Volume__c > existingNPRVolumeMap = new Map < String, Phoenix_NPR_Volume__c > ();
        for (Phoenix_NPR_Volume__c nprVol: Database.query('SELECT' + Phoenix_Util.nprVolumeFields + 'FROM Phoenix_NPR_Volume__c where Phoenix_NPR_Data__c IN:nprIdSet ')) {
            existingNPRVolumeMap.put(nprVol.Name, nprVol); //Phoenix_Unique_Identifier_SF__c  
        }
        for (Phoenix_NPR_Volume__c npr: existingNPRVolumeMap.values()) {
            if (nprDataWithVolumeMap.containsKey(npr.Phoenix_NPR_Data__c)) {
                List < Phoenix_NPR_Volume__c > existingNpr = nprDataWithVolumeMap.get(npr.Phoenix_NPR_Data__c);
                existingNpr.add(npr);
                nprDataWithVolumeMap.put(npr.Phoenix_NPR_Data__c, existingNpr);
            } else {
                nprDataWithVolumeMap.put(npr.Phoenix_NPR_Data__c, new List < Phoenix_NPR_Volume__c > {
                    npr
                });
            }
        }
        for (Phoenix_SAP_NPR_Staging__c nprStaging: nprStagingList) {
            Phoenix_NPR_Data__c npr = existingNPRMap.get(nprStaging.Phoenix_NPR_Ref_SF__c);
            DateTime todayDateTime = Datetime.now();
            //  DateTime todayDateTime= DateTime.newInstanceGmt(2021, 02, 01);
            String month = todayDateTime.format('MMMM'); //get month
            Integer year = todayDateTime.Year(); //get year

            DateTime DT1 = todayDateTime.addMonths(-1); //DateTime.newInstance(yr, mo, d);
            String previousMonth1 = DT1.format('MMMM');
            Integer yearForPreviousMonth1 = DT1.year();

            DateTime DT2 = todayDateTime.addMonths(-2);
            String previousMonth2 = DT2.format('MMMM');
            Integer yearForPreviousMonth2 = DT2.year();

            DateTime DT3 = todayDateTime.addMonths(-3);
            String previousMonth3 = DT3.format('MMMM');
            Integer yearForPreviousMonth3 = DT3.year();

            DateTime DT4 = todayDateTime.addMonths(-4);
            String previousMonth4 = DT4.format('MMMM');
            Integer yearForPreviousMonth4 = DT4.year();

            DateTime DT5 = todayDateTime.addMonths(-5);
            String previousMonth5 = DT5.format('MMMM');
            Integer yearForPreviousMonth5 = DT5.year();

            DateTime DT6 = todayDateTime.addMonths(-6);
            String previousMonth6 = DT6.format('MMMM');
            Integer yearForPreviousMonth6 = DT6.year();

            DateTime DT7 = todayDateTime.addMonths(-7);
            String previousMonth7 = DT7.format('MMMM');
            Integer yearForPreviousMonth7 = DT7.year();

            DateTime DT8 = todayDateTime.addMonths(-8);
            String previousMonth8 = DT8.format('MMMM');
            Integer yearForPreviousMonth8 = DT8.year();

            DateTime DT9 = todayDateTime.addMonths(-9);
            String previousMonth9 = DT9.format('MMMM');
            Integer yearForPreviousMonth9 = DT9.year();

            DateTime DT10 = todayDateTime.addMonths(-10);
            String previousMonth10 = DT10.format('MMMM');
            Integer yearForPreviousMonth10 = DT10.year();

            DateTime DT11 = todayDateTime.addMonths(-11);
            String previousMonth11 = DT11.format('MMMM');
            Integer yearForPreviousMonth11 = DT11.year();

            DateTime DT12 = todayDateTime.addMonths(-12);
            String previousMonth12 = DT12.format('MMMM');
            Integer yearForPreviousMonth12 = DT12.year();

            String nprVolumeRecord = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + month + '_' + string.valueOf(year);
            if (existingNPRVolumeMap.containsKey((nprVolumeRecord))) { // existing volume
                Phoenix_NPR_Volume__c nprVol = existingNPRVolumeMap.get(nprVolumeRecord);
                nprVol.Phoenix_Volume__c = nprStaging.Phoenix_Current_Month_Till_Date__c;
                nprVolumeUpdatedList.add(nprVol);
            } else { //new volume
                Phoenix_NPR_Volume__c nprVol = new Phoenix_NPR_Volume__c();
                if (nprStaging.Phoenix_Material_Number__c != null) {
                    nprVol.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + month + '_' + string.valueOf(year);
                }
                nprVol.Phoenix_Volume__c = nprStaging.Phoenix_Current_Month_Till_Date__c;
                nprVol.Phoenix_NPR_Data__c = npr.Id;
                nprVol.Phoenix_Date__c = System.today();
                nprVolumeUpdatedList.add(nprVol);

                String lastMonthNPRVolumeRecordRef1 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth1 + '_' + string.valueOf(yearForPreviousMonth1);
                String lastMonthNPRVolumeRecordRef2 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth2 + '_' + string.valueOf(yearForPreviousMonth2);
                String lastMonthNPRVolumeRecordRef3 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth3 + '_' + string.valueOf(yearForPreviousMonth3);
                String lastMonthNPRVolumeRecordRef4 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth4 + '_' + string.valueOf(yearForPreviousMonth4);
                String lastMonthNPRVolumeRecordRef5 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth5 + '_' + string.valueOf(yearForPreviousMonth5);
                String lastMonthNPRVolumeRecordRef6 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth6 + '_' + string.valueOf(yearForPreviousMonth6);
                String lastMonthNPRVolumeRecordRef7 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth7 + '_' + string.valueOf(yearForPreviousMonth7);
                String lastMonthNPRVolumeRecordRef8 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth8 + '_' + string.valueOf(yearForPreviousMonth8);
                String lastMonthNPRVolumeRecordRef9 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth9 + '_' + string.valueOf(yearForPreviousMonth9);
                String lastMonthNPRVolumeRecordRef10 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth10 + '_' + string.valueOf(yearForPreviousMonth10);
                String lastMonthNPRVolumeRecordRef11 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth11 + '_' + string.valueOf(yearForPreviousMonth11);
                String lastMonthNPRVolumeRecordRef12 = npr.Phoenix_Contract_Number__c + '_' + npr.Phoenix_Material_Number__c + '_' + previousMonth12 + '_' + string.valueOf(yearForPreviousMonth12);

                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord1 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef1);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord2 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef2);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord3 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef3);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord4 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef4);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord5 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef5);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord6 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef6);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord7 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef7);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord8 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef8);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord9 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef9);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord10 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef10);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord11 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef11);
                Phoenix_NPR_Volume__c lastMonthNPRVolumeRecord12 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef12);

                /* ------------------------ creating last 12 months records----START----*/
                if (lastMonthNPRVolumeRecord1 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth1 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth1.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth1 + '_' + string.valueOf(yearForPreviousMonth1);
                    } else {
                        nprVolPrevMonth1.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth1 + '_' + string.valueOf(previousMonth1);
                    }
                    nprVolPrevMonth1.Phoenix_Volume__c = nprStaging.Phoenix_M1__c;
                    nprVolPrevMonth1.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth1.Phoenix_Date__c = System.today().addMonths(-1).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth1);
                }
                if (lastMonthNPRVolumeRecord2 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth2 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth2.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth2 + '_' + string.valueOf(yearForPreviousMonth2);
                    } else {
                        nprVolPrevMonth2.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth2 + '_' + string.valueOf(yearForPreviousMonth2);
                    }
                    nprVolPrevMonth2.Phoenix_Volume__c = nprStaging.Phoenix_M2__c;
                    nprVolPrevMonth2.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth2.Phoenix_Date__c = System.today().addMonths(-2).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth2);
                }
                if (lastMonthNPRVolumeRecord3 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth3 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth3.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth3 + '_' + string.valueOf(yearForPreviousMonth3);
                    } else {
                        nprVolPrevMonth3.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth3 + '_' + string.valueOf(yearForPreviousMonth3);
                    }
                    nprVolPrevMonth3.Phoenix_Volume__c = nprStaging.Phoenix_M3__c;
                    nprVolPrevMonth3.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth3.Phoenix_Date__c = System.today().addMonths(-3).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth3);
                }
                if (lastMonthNPRVolumeRecord4 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth4 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth4.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth4 + '_' + string.valueOf(yearForPreviousMonth4);
                    } else {
                        nprVolPrevMonth4.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth4 + '_' + string.valueOf(yearForPreviousMonth4);
                    }
                    nprVolPrevMonth4.Phoenix_Volume__c = nprStaging.Phoenix_M4__c;
                    nprVolPrevMonth4.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth4.Phoenix_Date__c = System.today().addMonths(-4).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth4);
                }
                if (lastMonthNPRVolumeRecord5 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth5 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth5.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth5 + '_' + string.valueOf(yearForPreviousMonth5);
                    } else {
                        nprVolPrevMonth5.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth5 + '_' + string.valueOf(yearForPreviousMonth5);
                    }
                    nprVolPrevMonth5.Phoenix_Volume__c = nprStaging.Phoenix_M5__c;
                    nprVolPrevMonth5.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth5.Phoenix_Date__c = System.today().addMonths(-5).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth5);
                }
                if (lastMonthNPRVolumeRecord6 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth6 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth6.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth6 + '_' + string.valueOf(yearForPreviousMonth6);
                    } else {
                        nprVolPrevMonth6.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth6 + '_' + string.valueOf(yearForPreviousMonth6);
                    }
                    nprVolPrevMonth6.Phoenix_Volume__c = nprStaging.Phoenix_M6__c;
                    nprVolPrevMonth6.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth6.Phoenix_Date__c = System.today().addMonths(-6).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth6);
                }
                if (lastMonthNPRVolumeRecord7 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth7 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth7.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth7 + '_' + string.valueOf(yearForPreviousMonth7);
                    } else {
                        nprVolPrevMonth7.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth7 + '_' + string.valueOf(yearForPreviousMonth7);
                    }
                    nprVolPrevMonth7.Phoenix_Volume__c = nprStaging.Phoenix_M7__c;
                    nprVolPrevMonth7.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth7.Phoenix_Date__c = System.today().addMonths(-7).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth7);
                }
                if (lastMonthNPRVolumeRecord8 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth8 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth8.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth8 + '_' + string.valueOf(yearForPreviousMonth8);
                    } else {
                        nprVolPrevMonth8.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth8 + '_' + string.valueOf(yearForPreviousMonth8);
                    }
                    nprVolPrevMonth8.Phoenix_Volume__c = nprStaging.Phoenix_M8__c;
                    nprVolPrevMonth8.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth8.Phoenix_Date__c = System.today().addMonths(-8).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth8);
                }
                if (lastMonthNPRVolumeRecord9 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth9 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth9.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth9 + '_' + string.valueOf(yearForPreviousMonth9);
                    } else {
                        nprVolPrevMonth9.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth9 + '_' + string.valueOf(yearForPreviousMonth9);
                    }
                    nprVolPrevMonth9.Phoenix_Volume__c = nprStaging.Phoenix_M9__c;
                    nprVolPrevMonth9.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth9.Phoenix_Date__c = System.today().addMonths(-9).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth9);
                }
                if (lastMonthNPRVolumeRecord10 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth10 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth10.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth10 + '_' + string.valueOf(yearForPreviousMonth10);
                    } else {
                        nprVolPrevMonth10.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth10 + '_' + string.valueOf(yearForPreviousMonth10);
                    }
                    nprVolPrevMonth10.Phoenix_Volume__c = nprStaging.Phoenix_M10__c;
                    nprVolPrevMonth10.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth10.Phoenix_Date__c = System.today().addMonths(-10).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth10);
                }
                if (lastMonthNPRVolumeRecord11 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth11 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth11.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth11 + '_' + string.valueOf(yearForPreviousMonth11);
                    } else {
                        nprVolPrevMonth11.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth11 + '_' + string.valueOf(yearForPreviousMonth11);
                    }
                    nprVolPrevMonth11.Phoenix_Volume__c = nprStaging.Phoenix_M11__c;
                    nprVolPrevMonth11.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth11.Phoenix_Date__c = System.today().addMonths(-11).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth11);
                }
                if (lastMonthNPRVolumeRecord12 == null) {
                    Phoenix_NPR_Volume__c nprVolPrevMonth12 = new Phoenix_NPR_Volume__c();
                    if (nprStaging.Phoenix_Material_Number__c != null) {
                        nprVolPrevMonth12.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Material_Number__c + '_' + previousMonth12 + '_' + string.valueOf(yearForPreviousMonth12);
                    } else {
                        nprVolPrevMonth12.Name = nprStaging.Phoenix_Contract_Number__c + '_' + previousMonth12 + '_' + string.valueOf(yearForPreviousMonth12);
                    }
                    nprVolPrevMonth12.Phoenix_Volume__c = nprStaging.Phoenix_M12__c;
                    nprVolPrevMonth12.Phoenix_NPR_Data__c = npr.Id;
                    nprVolPrevMonth12.Phoenix_Date__c = System.today().addMonths(-12).toStartOfMonth();
                    nprVolumeUpdatedList.add(nprVolPrevMonth12);
                }
                /* ------------------------ creating last 12 months records----END----*/

                /* ------------------------ updating last 12 months records----START----*/
                if (lastMonthNPRVolumeRecord1 != null) {
                    Phoenix_NPR_Volume__c nprVol1 = existingNPRVolumeMap.get(lastMonthNPRVolumeRecordRef1);
                    nprVol1.Phoenix_Volume__c = nprStaging.Phoenix_M1__c;
                    nprVolumeUpdatedList.add(nprVol1);
                }
                /* ------------------------ updating last 12 months records----END----*/
            }
        }
        if (!nprVolumeUpdatedList.isEmpty()) {
            upsert nprVolumeUpdatedList;
        }
    }
}