trigger Phoenix_NPRDataFieldHistory on Phoenix_NPR_Data__c (after update) {
  
    if((trigger.isAfter && trigger.isUpdate) && !Phoenix_Util.hasAlreadyDone())
        System.enqueueJob(new Phoenix_NPRDataFieldHistoryQueue(trigger.newMap,trigger.oldMap));
}