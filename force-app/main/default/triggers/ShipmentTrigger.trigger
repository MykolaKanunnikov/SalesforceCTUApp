trigger ShipmentTrigger on Shipment__c (before insert, before update, 
                                        after insert, after delete, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{
        } 
        when BEFORE_UPDATE{

        }
        when AFTER_INSERT{
            ShipmentTriggerHandler.createChecklist(Trigger.new);
        }  
        when AFTER_DELETE{
            ShipmentTriggerHandler.handleDelete(Trigger.old);
        } 
        when AFTER_UPDATE{

        }
    }

}