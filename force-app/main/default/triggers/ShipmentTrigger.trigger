trigger ShipmentTrigger on Shipment__c (before insert, before update, after insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{
            ShipmentTriggerHandler.avoidDuplicatesBeforeInsert(Trigger.new);
        } 
        when BEFORE_UPDATE{
            ShipmentTriggerHandler.avoidDuplicatesBeforeUpdate(Trigger.new, Trigger.old);
            ShipmentTriggerHandler.handleNotDangerousGoodsBeforeUpdate(Trigger.new, Trigger.old);
        }
        when AFTER_INSERT{
            ShipmentTriggerHandler.createChecklist(Trigger.new);
        }  
    }

}