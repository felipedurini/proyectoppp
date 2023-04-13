trigger UnitResponse on User_Unidad__c (before update, after update) {
    
    if (trigger.isUpdate && trigger.isBefore){
        UnitResponseService.checkResponses(Trigger.new);
       
    } else if (trigger.isAfter && trigger.isUpdate){
         UnitResponseService.checkPoints(Trigger.new);
        
    }
    

}