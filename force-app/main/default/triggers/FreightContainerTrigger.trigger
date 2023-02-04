trigger FreightContainerTrigger on Freight_Container__c (before insert, before update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{
            FreightContainerTriggerHandler.avoidDuplicatesBeforeInsert(Trigger.new);
        } 
        when BEFORE_UPDATE{
            FreightContainerTriggerHandler.avoidDuplicatesBeforeUpdate(Trigger.new, Trigger.old);
        }
    }

}