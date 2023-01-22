trigger PackingChecklistTrigger on Packing_checklist__c (before insert, before update, 
                                                         after insert, after delete, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT{

        } 
        when BEFORE_UPDATE{
            PackingChecklistTriggerHandler.checkNo(Trigger.new);
        }
        when AFTER_INSERT{
            
        }  
        when AFTER_DELETE{
            
        } 
        when AFTER_UPDATE{

        }
    }
}