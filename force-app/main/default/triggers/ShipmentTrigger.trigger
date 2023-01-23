trigger ShipmentTrigger on Shipment__c (before insert, before update, 
                                        after insert, after delete, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{
            ShipmentTriggerHandler.avoidDuplicatesBeforeInsert(Trigger.new);
        } 
        when BEFORE_UPDATE{
            ShipmentTriggerHandler.avoidDuplicatesBeforeUpdate(Trigger.new, Trigger.old);
        }
        when AFTER_INSERT{
            ShipmentTriggerHandler.createChecklistAfterInsert(Trigger.new);
        }  
        when AFTER_DELETE{
            ShipmentTriggerHandler.handleDelete(Trigger.old);
        } 
        when AFTER_UPDATE{
            ShipmentTriggerHandler.createChecklist(Trigger.new);
        }
    }

}